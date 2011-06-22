#import <Foundation/Foundation.h>


@interface AsyncCommandResponse : NSObject {

}

+ (id) resultFromData:(NSDictionary*)data;

@property (readwrite,nonatomic,retain) NSDictionary* responseData;

@end
