#import <UIKit/UIKit.h>

#define LOG_SILENT 0
#define LOG_FATAL 1
#define LOG_EXCEPTION 2
#define LOG_NONFATAL_ERROR 3
#define LOG_DEBUG 4
#define LOG_VERBOSE 5
#define LOG_ALL 6

@interface WapsLog : NSObject {

}

+ (void)setLogThreshold:(int)myThreshhold;

+ (void)logWithLevel:(int)myLevel format:(NSString *)myFormat, ...;
@end
