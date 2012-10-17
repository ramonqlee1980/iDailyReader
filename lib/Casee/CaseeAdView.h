//
//  CaseeAdView.h
//  CaseeAdLib
//
//  Copyright 2009 CASEE. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CaseeAdDelegate;

typedef enum {
    caseeAdSizeIdentifier_320x48  = 0,
    caseeAdSizeIdentifier_48x256  = 1,
    caseeAdSizeIdentifier_300x250 = 2,
    caseeAdSizeIdentifier_728x90  = 3,
    caseeAdSizeIdentifier_364x60  = 4,
    caseeAdSizeIdentifier_90x708  = 5,
    caseeAdSizeIdentifier_60x354  = 6,
} CaseeAdSizeIdentifier;

@interface CaseeAdView : UIView {

}

+(CaseeAdView *)adViewWithDelegate:(id <CaseeAdDelegate>)delegate caseeRectStyle:(CaseeAdSizeIdentifier) adSize;

- (void)refreshAd;

/**
 * start rotation timer.
 */
-(void)startAdRotation;

/**
 * Start rotation with a delay.
 */
-(void)startAdRotationWithDelay;

/**
 * If display mode is rotation, stop the timer.
 */
- (void)stopAdRotation;
/**
 * get param assigned by developer.
 * this methods is to request, you should to implement the method "didReceiveParam" define in CaseeAdDelegate get response
 */
- (void)getParam:(NSString*) param;

@end
