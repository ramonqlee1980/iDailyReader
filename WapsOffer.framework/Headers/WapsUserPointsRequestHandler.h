#import <Foundation/Foundation.h>
#import "WapsCoreFetcherHandler.h"


@class WapsUserPoints;

@interface WapsUserPointsRequestHandler : WapsCoreFetcherHandler <WapsWebFetcherDelegate> {

}

- (id)initRequestWithDelegate:(id <WapsFetchResponseDelegate>)aDelegate andRequestTag:(int)aTag;

- (void)requestPoints;

- (void)subtractPoints:(int)points;

- (void)addPoints:(int)points;

@end
