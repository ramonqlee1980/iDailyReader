#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "WapsFetchResponseProtocol.h"
#import "AppConnect.h"

#define AD_SIZE_320X50        @"320x50"
#define AD_SIZE_640X100    @"640x100"
#define AD_SIZE_768X90        @"768x90"
#define AD_SIZE_768X100        @"768x100"


#define WAPS_AD_REFRESH_DELAY        (15.0)

extern NSString *kWapsAdFailStr;

@class WapsAdRequestHandler;

@interface WapsAdView : UIView <WapsFetchResponseDelegate> {
@private
    NSURL *redirectURL_;
    NSString *clickURL_;
    NSString *imageDataStr_;
    UIImageView *imageView_;
    UIImageView *previousImageView_;
    NSString *contentSizeStr_;
    UIView *adViewOverlay_;

    WapsAdRequestHandler *adHandlerObj_;
}

@property(copy) NSURL *redirectURL;
@property(copy) NSString *clickURL;
@property(copy) NSString *imageDataStr;
@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) UIImageView *previousImageView;
@property(copy) NSString *contentSizeStr;
@property(nonatomic, retain) UIView *adViewOverlay;

@property(nonatomic, retain) WapsAdRequestHandler *adHandlerObj;

+ (WapsAdView *)sharedWapsAdView;

- (id)getAdWithDelegate:(UIViewController *)vController adSize:(NSString *)aSize showX:(CGFloat)x showY:(CGFloat)y;

- (void)fetchResponseSuccessWithData:(void *)dataObj withRequestTag:(int)aTag;

- (void)fetchResponseError:(WapsResponseError)errorType errorDescription:(id)errorDescObj requestTag:(int)aTag;

- (void)refreshAd:(NSTimer *)timer;

- (BOOL)isAdLoaded;

@end


@interface AppConnect (WapsAdView)

+ (id)displayAd:(UIViewController *)vController;

+ (id)displayAd:(UIViewController *)vController showX:(CGFloat)x showY:(CGFloat)y;

+ (id)displayAd:(UIViewController *)vController adSize:(NSString *)aSize showX:(CGFloat)x showY:(CGFloat)y;

+ (BOOL)isDisplayAdLoaded;

+ (WapsAdView *)getDisplayAdView;

@end

