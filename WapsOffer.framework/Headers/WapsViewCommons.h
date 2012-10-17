#import <UIKit/UIKit.h>
#import "AppConnect.h"


typedef enum WapsTransitionEnum {
    WapsTransitionBottomToTop = 0,
    WapsTransitionTopToBottom,
    WapsTransitionLeftToRight,
    WapsTransitionRightToLeft,
    WapsTransitionFadeEffect,
    WapsTransitionNormalToBottom,
    WapsTransitionNormalToTop,
    WapsTransitionNormalToLeft,
    WapsTransitionNormalToRight,
    WapsTransitionFadeEffectReverse,
    WapsTransitionExpand,
    WapsTransitionShrink,
    WapsTransitionFlip,
    WapsTransitionFlipReverse,
    WapsTransitionPageCurl,
    WapsTransitionPageCurlReverse,
    WapsTransitionNoEffect = -1
} WapsTransitionEnum;

typedef enum WapsViewsIntegrationType {
    viewsIntegrationTypePlain = 0,
    viewsIntegrationTypeLibraryHandledVisibility = 1
} WapsViewsIntegrationType;


@interface WapsViewCommons : NSObject {
    WapsTransitionEnum currentTransitionEffect_;
    WapsTransitionEnum reverseTransitionEffect_;
    WapsViewsIntegrationType viewsIntegrationType_;
    int primaryColorCode_;
    UIColor *userDefinedColor_;
    float transitionDelay_;
}


+ (WapsViewCommons *)sharedWapsViewCommons;

+ (void)animateWapsView:(UIView *)viewRef withWapsTransition:(WapsTransitionEnum)transEffect withDelay:(float)delay;

- (void)runExpandTransition:(NSTimer *)timer;

- (int)getUserDefinedColorCode;

- (UIColor *)getUserDefinedColor;

- (WapsTransitionEnum)getCurrentTransitionEffect;

- (void)setTransitionEffect:(WapsTransitionEnum)transitionEffect;

- (float)getTransitionDelay;

- (WapsTransitionEnum)getReverseTransitionEffect;

- (void)removeTempView:(id)object;

@end


@interface AppConnect (WapsViewCommons)

+ (void)setTransitionEffect:(WapsTransitionEnum)transitionEffect;

+ (void)updateViewsWithOrientation:(UIInterfaceOrientation)interfaceOrientation;

+ (void)animateWapsView:(UIView *)viewRef withWapsTransition:(WapsTransitionEnum)transEffect withDelay:(float)delay;

+ (float)getTransitionDelay;

+ (WapsTransitionEnum)getCurrentTransitionEffect;

+ (WapsTransitionEnum)getReverseTransitionEffect;

@end