

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedInstance;

- (NSURL *)smartURLForString:(NSString *)str;

- (NSString *)pathForTestImage:(NSUInteger)imageNumber;
- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix;
- (NSString*) uuid;

@property (nonatomic, assign, readonly ) NSUInteger     networkOperationCount;  // observable

- (void)didStartNetworkOperation;
- (void)didStopNetworkOperation;

@end
