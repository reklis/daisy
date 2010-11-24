usage: xml2objc.py [-h] [-const CONST_QUERYSTRING_PARAMS] [-v VIEW]
                   [-c CONTROLLER] [-cmd COMMAND]
                   url

Generates Objective-C from a RESTful XML resources

positional arguments:
  url                   URL of the RESTful resource

optional arguments:
  -h, --help            show this help message and exit
  -const CONST_QUERYSTRING_PARAMS, --const-querystring-params CONST_QUERYSTRING_PARAMS
                        command delimited list of names of query string
                        parameters that will be passed through as constants
  -v VIEW, --view VIEW  class name of the View generated
  -c CONTROLLER, --controller CONTROLLER
                        class name of the Controller generated
  -cmd COMMAND, --command COMMAND
                        class name of the Command object generated



Example:
-------

A resource generated like this:

$ ./xml2objc.py -const method -m -v -cmd http://myservice/operation?method=getPayload\&foo=bar


Which returns this:

<payload>
  <result col1="value1" col2="value2" />
  <result col1="value3" col2="value4" />
</payload>

Will be represented as an NSArray of 'result'
Each 'result' class will have properties 'col1' and 'col2'
A table view controller will be built to hold a collection of 'result'

'getPayload' will always be passed as a constant in the query string for 'method'
however, a value for 'foo' will always need to be provided to the datasource


TODO:
----

Methods besides GET (POST, PUT, DELETE)
Post body instead of just query string
JSON support
Sub-element parsing, currently only attributes are used
Better security handling
Add a View .xib template so that no exceptions occur at runtime from the ViewCell loadNib
