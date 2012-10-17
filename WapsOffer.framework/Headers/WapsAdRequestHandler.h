#import <Foundation/Foundation.h>
#import "WapsCoreFetcherHandler.h"

extern NSString *kWapsAdClickURLStr;
extern NSString *kWapsAdImageDataStr;


@interface WapsAdRequestHandler : WapsCoreFetcherHandler <WapsWebFetcherDelegate> {
    BOOL accumulatingClickURL;
    NSMutableString *clickURL_;
    BOOL accumulatingImageDataStr;
    NSMutableString *imageDataStr_;
    BOOL isDataFetchSuccessful_;
    BOOL isFetchingData_;
}

- (id)initRequestWithDelegate:(id <WapsFetchResponseDelegate>)aDelegate andRequestTag:(int)aTag;

- (void)requestAdWithSize:(NSString *)adSize;

- (BOOL)isDataFetchSuccessful;

@end
