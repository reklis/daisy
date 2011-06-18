#!/opt/local/bin/python

import os, argparse, time
from urllib import urlopen
import urlparse
from xml.dom import minidom

method_parameter_template = """{param_label}: ({param_type}*) {param_name} """

property_template = """@property (readwrite,nonatomic,retain) IBOutlet {property_type}* {property_name};
"""

readonly_property_template = """@property (readonly) {property_type}* {property_name};
"""

result_property_template = """- ({property_type}*) {property_name} {{
    return [self.responseData objectForKey:@"{property_name}"];
}}
"""

synthesize_property_template = """@synthesize {property_name};
"""

uilabel_populator_template = """    [[self {property_name}] setText:[m valueForKey:@"{property_name}"]];
"""

command_populator_template = """    _command.{property_name} = {param_name};
"""

nsdictionary_entry_template = """    [{dictionary_name} setValue:{value} forKey:@"{key}"];
"""

singular_command_h_template = """
// {auto_gen_comment}

@interface {command_class_name} : XmlHttpRequestCommand
{{
}}

{property_declarations}

@property (readwrite, nonatomic, copy) NSDictionary* command_result;

@end

@interface {command_class_name}Result : AsyncCommandResponse
{{
}}

{result_property_declarations}

@end
"""

singular_command_m_template = """
// {auto_gen_comment}

#import "{command_class_name}.h"

@implementation {command_class_name}

{property_implementations}

@synthesize command_result;

- (NSDictionary*) parameters
{{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
{dictionary_population}
    return params;
}}

- (NSString*) baseURL
{{
    static NSString* baseURL = @"{resource_url}";
    return baseURL;
}}

- (void) parseResult:(id)result
{{
    self.command_result = [[[result objectForKey:@"{parent_element_name}"] objectForKey:@"{child_element_name}"] objectForKey:@"attributes"];
}}

@end

@implementation {command_class_name}Result

{result_property_implementations}

@end
"""

multi_command_h_template = """
// {auto_gen_comment}

@class {command_class_name}Result;

@interface {command_class_name} : XmlHttpRequestCommand
{{
}}

{property_declarations}

@property (readwrite, nonatomic, copy) NSArray* command_result;

- ({command_class_name}Result*) resultAtIndex:(NSInteger)index;

@end

@interface {command_class_name}Result : AsyncCommandResponse
{{
}}

{result_property_declarations}

@end
"""

multi_command_m_template = """
// {auto_gen_comment}

#import "{command_class_name}.h"
#import "NSObject+NSArray.h"

@implementation {command_class_name}

{property_implementations}

@synthesize command_result;

- (NSDictionary*) parameters
{{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
{dictionary_population}
    
    return params;
}}

- (NSString*) baseURL
{{
    static NSString* baseURL = @"{resource_url}";
    return baseURL;
}}

- (void) parseResult:(id)result
{{
    NSArray* resultArray = [[[result objectForKey:@"{parent_element_name}"] objectForKey:@"{child_element_name}"] toArray];
    NSMutableArray* parsedResult = [NSMutableArray arrayWithCapacity:[resultArray count]];
    for (NSDictionary* r in resultArray) {{
        [parsedResult addObject:[r objectForKey:@"attributes"]];
    }}
    
    self.command_result = parsedResult;
}}

- ({command_class_name}Result*) resultAtIndex:(NSInteger)index
{{
    return [{command_class_name}Result resultFromData:[self.command_result objectAtIndex:index]];
}}

@end

@implementation {command_class_name}Result

{result_property_implementations}

@end
"""

singular_view_h_template = """
// {auto_gen_comment}

#import <UIKit/UIKit.h>

@interface {view_class_name} : UIView <Bindable>
{{
}}

{property_declarations}

- (void) bindModel:(NSDictionary*)m;

@end

"""

singular_view_m_template = """
// {auto_gen_comment}

#import "{view_class_name}.h"

@implementation {view_class_name}

{property_implementations}

- (void) bindModel:(NSDictionary*)m
{{
{label_value_population}
}}

@end
"""

multi_view_h_template = singular_view_h_template
multi_view_m_template = singular_view_m_template

multi_controller_h_template = """
// {auto_gen_comment}

#import <UIKit/UIKit.h>

#import "{view_class_name}.h"
#import "{command_class_name}.h"

@interface {controller_class_name} : UITableViewController <AsyncCommandDelegate>
{{
    @private
    LoadingDataSource* _loadingDataSource;
    EmptyDataSource* _emptyDataSource;
    
    {command_class_name}* _command;
}}

{property_declarations}

@property (readonly) LoadingDataSource* loadingDataSource;
@property (readonly) EmptyDataSource* emptyDataSource;

- (IBAction) loadData;

@end
"""

multi_controller_m_template = """
// {auto_gen_comment}

#import "{controller_class_name}.h"

typedef enum kTableSectionsEnum {{
    kTableSectionData = 0,
    kTableSectionsCount
}} kTableSections;

@implementation {controller_class_name}

{property_implementations}

- (void) viewWillAppear:(BOOL)animated
{{
    [super viewWillAppear:animated];
    
    [self loadData];
}}

- (LoadingDataSource*) loadingDataSource {{
    if (nil == _loadingDataSource) {{
        _loadingDataSource = [[LoadingDataSource loadingDataSource] retain];
    }}
    return _loadingDataSource;
}}

- (EmptyDataSource*) emptyDataSource {{
    if (nil == _emptyDataSource) {{
        _emptyDataSource = [[EmptyDataSource emptyDataSource] retain];
    }}
    return _emptyDataSource;
}}

- (void) dealloc
{{
    RELEASE(_loadingDataSource);
    RELEASE(_emptyDataSource);
    RELEASE(_command);

    [super dealloc];
}}

- (IBAction) loadData
{{
    if (nil == _command) {{
        _command = [[{command_class_name} alloc] init];
        _command.delegate = self;
    }}
    
{command_populator}
    
    [_command load];
}}

#pragma mark AsyncCommandDelegate

- (void)commandDidStart:(AsyncCommand*)command
{{
    [self changeDataSource:self.loadingDataSource];
}}

- (void)commandDidFinishLoad:(AsyncCommand*)command
{{
    if (0 == _command.command_result.count) {{
        [self changeDataSource:self.emptyDataSource];
    }} else {{
        [self changeDataSource:self];
    }}
}}

- (void)command:(AsyncCommand*)command didFailLoadWithError:(NSError*)error
{{
    [self changeDataSource:self.emptyDataSource];
    
    [UIApplication displayError:error];
}}

- (void)commandDidCancelLoad:(AsyncCommand*)command
{{
    if (nil == _command.command_result) {{
        [self changeDataSource:self.emptyDataSource];
    }}
}}

#pragma mark UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{{
//    return 100.0;
//}}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{{
    return nil;
}}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{{
    return kTableSectionsCount;
}}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{{
    switch (section) {{
        case kTableSectionData:
            return [_command.command_result count];
            
        default:
            return 0;
    }}
}}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{{
    switch (section) {{
        case kTableSectionData:
            return @"Data";
            
        default:
            return @"";
    }}
}}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{{
    UITableViewCell* cell = nil;
    
    if (indexPath.section == kTableSectionData) {{
        NSDictionary* m = [_command.command_result objectAtIndex:indexPath.row];
        cell = [tableView dequeueCellForView:@"{view_class_name}" withData:m];
    }}
    
    return cell;
}}

@end
"""

singular_controller_h_template = """
// {auto_gen_comment}

#import <UIKit/UIKit.h>

#import "{view_class_name}.h"
#import "{command_class_name}.h"

@interface {controller_class_name} : UIViewController <AsyncCommandDelegate>
{{
    @private
    OverlayView* _loadingView;
    
    {command_class_name}* _command;
    {view_class_name}* _modelview;
}}

{property_declarations}

- (AsyncCommand*) command;

@end

"""

singular_controller_m_template = """
// {auto_gen_comment}

#import "{controller_class_name}.h"

@implementation {controller_class_name}

{property_implementations}

#pragma mark UIViewController

- (void) viewWillAppear:(BOOL)animated
{{
    [super viewWillAppear:animated];
    
    _modelview = [[NSBundle loadNibView:@"{view_class_name}"] retain];
    self.view = _modelview;
    
    [[self command] load];
}}

- (void)dealloc
{{
    RELEASE(_modelview);
    RELEASE(_command);
    [super dealloc];
}}

- (AsyncCommand*) command
{{
    if (nil == _command) {{
        _command = [[{command_class_name} alloc] init];
{command_populator}
        _command.delegate = self;
    }}
    return _command;
}}

#pragma mark AsyncCommandDelegate

- (void)commandDidStart:(AsyncCommand*)command
{{
    _loadingView = [OverlayView overlayWithText:LS_NEWLOADING overView:self.view];
}}

- (void)commandDidFinishLoad:(AsyncCommand*)command
{{
    [_modelview bindModel:_command.command_result];
    
    [_loadingView dismiss];
}}

- (void)command:(AsyncCommand*)command didFailLoadWithError:(NSError*)error
{{
    [_loadingView dismiss];
    
    [UIApplication displayError:error];
}}

- (void)commandDidCancelLoad:(AsyncCommand*)command
{{
    [_loadingView dismiss];
}}

@end
"""


class ObjcCodeGenerator:
  def setComment(self, comment):
    self.autoGenComment = comment
  
  
  def setClassNames(self, v, c, cmd):
    self.viewClassName = v
    self.controllerClassName = c
    self.commandClassName = cmd
  
  
  def setFlags(self, flags):
    self.flags = flags;
    
    if (flags['singular']):
      self.commandHeader = singular_command_h_template
      self.commandBody = singular_command_m_template
      self.viewHeader = singular_view_h_template
      self.viewBody = singular_view_m_template
      self.controllerHeader = singular_controller_h_template
      self.controllerBody = singular_controller_m_template
    else:
      self.commandHeader = multi_command_h_template
      self.commandBody = multi_command_m_template
      self.viewHeader = multi_view_h_template
      self.viewBody = multi_view_m_template
      self.controllerHeader = multi_controller_h_template
      self.controllerBody = multi_controller_m_template
    
  
  
  def setUrl(self, u, constParamNames):
    self.url = urlparse.urlparse(u)
    
    # queryParts = self.url.query.split("&")
    # paramNames = [nvp.split("=") for nvp in queryParts]
    paramNames = urlparse.parse_qsl(self.url.query)
    
    self.commandParameterConstants = [p for p in paramNames if p[0] in constParamNames]
    self.commandParameterDynamics = [p[0] for p in paramNames if p[0] not in constParamNames]
  
  
  def parseXml(self, xmlfile):
    dom = minidom.parse(xmlfile)
    
    try:
      self.rootNodeName = dom.documentElement.tagName
      #print self.rootNodeName
      
      node = dom.documentElement.firstChild
      while (node and (node.nodeType != 1)):
        node = node.nextSibling
      
      if node:
        self.parseNode(node)
      
    except Exception, ex:
      print str(ex)
      return
      
    finally:
      dom.unlink()
    
  
  
  def parseNode(self, node):
    self.nodeName = node.tagName
    #print node.tagName
    
    details = {
      'sources' : "",
      'labels' : "",
      'synths' : "",
      'label_populators' : "",
      'result_property_decls' : "",
      'result_property_impls' : ""
    }
    
    if (node.hasAttributes()):
      
      attr = node.attributes
      for i in range(attr.length):
        a = attr.item(i)
        prop_name = str(a.name)
        #prop_value = str(a.value)
        
        details['sources'] += property_template.format(property_type="NSString",property_name=prop_name)
        details['labels'] += property_template.format(property_type="UILabel",property_name=prop_name)
        details['synths'] += synthesize_property_template.format(property_name=prop_name)
        details['label_populators'] += uilabel_populator_template.format(property_name=prop_name)
        details['result_property_decls'] += readonly_property_template.format(property_type="NSString",property_name=prop_name)
        details['result_property_impls'] += result_property_template.format(property_type="NSString",property_name=prop_name)
      
    
    else:
      raise NotImplementedError
    
    #print bag
    
    if (self.flags['command']):
      self.printCommand(details)
    
    if (self.flags['view']):
      self.printView(details)
    
    if (self.flags['controller']):
      self.printController(details)
    
  
  
  def printCommand(self, details):
    synths = ""
    params = ""
    
    for i in self.commandParameterDynamics:
      params += property_template.format(property_type="NSString",property_name=i)
      synths += synthesize_property_template.format(property_name=i)
    
    with open(self.commandClassName + ".h", "w+") as f:
      f.write(self.commandHeader.format(
        auto_gen_comment=self.autoGenComment,
        property_declarations=params,
        command_class_name=self.commandClassName,
        result_property_declarations=details['result_property_decls']
      ))
    
    params = ""
    for i in self.commandParameterConstants:
      params += nsdictionary_entry_template.format(dictionary_name="params", key=i[0], value="@\"" + i[1] + "\"")
    for i in self.commandParameterDynamics:
      params += nsdictionary_entry_template.format(dictionary_name="params", key=i, value="self."+i)
    
    with open(self.commandClassName + ".m", "w+") as f:
      f.write(self.commandBody.format(
        auto_gen_comment=self.autoGenComment,
        command_class_name=self.commandClassName,
        property_implementations=synths,
        resource_url=self.url.scheme + "://" + self.url.netloc + self.url.path,
        parent_element_name=self.rootNodeName,
        child_element_name=self.nodeName,
        dictionary_population=params,
        result_property_implementations=details['result_property_impls']
      ))
    
  
  
  def printView(self, details):
    with open(self.viewClassName + ".h", "w+") as f:
      f.write(self.viewHeader.format(
        auto_gen_comment=self.autoGenComment,
        view_class_name=self.viewClassName,
        property_declarations=details['labels']
      ))
    
    with open(self.viewClassName + ".m", "w+") as f:
      f.write(self.viewBody.format(
        auto_gen_comment=self.autoGenComment,
        view_class_name=self.viewClassName,
        property_implementations=details['synths'],
        label_value_population=details['label_populators']
      ))
    
  
  
  def printController(self, details):
    synths = ""
    params = ""
    populators = ""
    
    for i in self.commandParameterDynamics:
      params += property_template.format(property_type="NSString",property_name=i)
      synths += synthesize_property_template.format(property_name=i)
      populators += command_populator_template.format(property_name=i, param_name=i)
    
    with open(self.controllerClassName + ".h", "w+") as f:
      f.write(self.controllerHeader.format(
        auto_gen_comment=self.autoGenComment,
        view_class_name=self.viewClassName,
        controller_class_name=self.controllerClassName,
        command_class_name=self.commandClassName,
        property_declarations=params
      ))
    
    with open(self.controllerClassName + ".m", "w+") as f:
      f.write(self.controllerBody.format(
        auto_gen_comment=self.autoGenComment,
        controller_class_name=self.controllerClassName,
        view_class_name=self.viewClassName,
        command_class_name=self.commandClassName,
        property_implementations=synths,
        command_populator=populators
      ))
    
  


def main():
  parser = argparse.ArgumentParser(description='Generates Objective-C from a RESTful XML resources')
  parser.add_argument('-const', '--const-querystring-params', default="", metavar="foo,bar,baz", type=str, help='comma delimited list of names of query string parameters that will be passed through as constants in the url request command generated')
  parser.add_argument('-p', '--prefix', default='REST', type=str, help='The prefix for all classes generated')
  parser.add_argument('-s', '--singular', action='store_const', const=True, default=False, help='Flag indicating weather or not the results return a single value or not.  By default, resulsts are assumed to be collections and represented as tables.');
  
  output_parser = parser.add_argument_group('output')
  output_parser.add_argument('-cmd', '--command', action='store_const', const=True, default=False, help='Flag indicating Command class should be created')
  output_parser.add_argument('-v', '--view', action='store_const', const=True, default=False, help='Flag indicating View class should be created')
  #output_parser.add_argument('-x', '--xib', action='store_const', const=True, default=False, help='Flag indicating XIB resource should be generated')
  output_parser.add_argument('-c', '--controller', action='store_const', const=True, default=False, help='Flag indicating Controller class should be generated')
  
  parser.add_argument('url', type=str, help="URL of the RESTful resource")
  
  args = parser.parse_args()
  #print args
  #return
  
  #if args.xib:
  #  raise NotImplementedError
  
  g = ObjcCodeGenerator()
  g.setUrl(args.url, args.const_querystring_params.split(','))
  g.setClassNames(
    args.prefix + 'View',
    args.prefix + 'Controller',
    args.prefix + 'Command'
  )
  g.setFlags({
    'singular': args.singular,
    'view': args.view,
    'controller': args.controller,
    'command': args.command
  })
  g.setComment('auto-generated by {} at {}'.format(
    parser.prog,
    time.strftime("%a, %d %b %Y %H:%M:%S +0000", time.gmtime())
  ))
  
  x = urlopen(args.url)
  try:
    g.parseXml(x)
  finally:
    x.close()
  


if __name__ ==  '__main__':
  main()