#import <Foundation/Foundation.h>
#import "WapsCoreFetcherHandler.h"


@interface WapsService :WapsCoreFetcherHandler <WapsWebFetcherDelegate> {

}

- (id)initRequestWithDelegate:(id <WapsFetchResponseDelegate>)aDelegate andRequestTag:(int)aTag;

+ (WapsService *)sharedWapsService;

+ (void)saveAppScheme:(NSString *)appScheme appID:(NSString *)id appName:(NSString *)name;

- (void)schemeScan;

@end
