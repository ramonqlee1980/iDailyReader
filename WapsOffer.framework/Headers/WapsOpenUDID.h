#import <Foundation/Foundation.h>

// Usage:
//    #include "OpenUDID.h"
//    NSString* openUDID = [OpenUDID value];



@interface WapsOpenUDID : NSObject {
}
+ (NSString *)value;

+ (NSString *)valueWithError:(NSError **)error;

+ (void)setOptOut:(BOOL)optOutValue;

+ (int)getOpenUDIDSlotCount;

@end
