//
//  CaseeAdDelegate.h
//  CaseeAdLib
//
//  Copyright 2009 CASEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class CaseeAdView;

@protocol CaseeAdDelegate<NSObject>

#pragma mark - required
@required

/**
 * app id assigned in casee.cn. This will be used in an ad request to identify this app.
 */
- (NSString *)appId;


#pragma mark - optional
@optional

/**
 * If your users are willing to share location information and your app have the location information,
 * you may want CASEE SDK to get the location info.  Default is NO.
 */
- (BOOL)allowShareLocation;

/**
 * Location information for the user while you make an ad request.  If this method is implemented,
 * CASEE will use the location information you provide.  Otherwise, the SDK will get the location
 * information from the app, which may consume more battery power.
 * It is highly recommended to implement this method for better user experience.
 *
 * If allowShareLocation returns NO, the SDK will not ask for it or get from OS.
 */
- (CLLocation *)location;

// Other information may send with an ad request
- (NSString *)keywords;	    // current context related keywords, such as @"sichuan food"

/**
 * An ad view did recieve an ad. This is called from a background thread.
 */
- (void)didReceiveAdIn:(CaseeAdView *)adView;

/**
 * An ad view failed to get ad.  This is called from a background thread.
 */
- (void)adView:(CaseeAdView *)adView failedWithError:(NSError *)error;

/**
 * Will show landing page.  Normally it's a full screen view or a modal view.
 * It's time to stop animations or other time sensitive interactions.
 */
- (void)willShowFullScreenAd;

/**
 * Close the landing page.  It's time to resume anything you stopped in -willShowLandingPage.
 */
- (void)didCloseFullScreenAd;

//
// test settings
//

/**
 * Specify whether this is in test(development) mode or production mode. Default is NO.
 */ 
- (BOOL)isTestMode;

#pragma mark - UI settings.

/**
 * ad rotation interval. default is 30 seconds.
 * return 0 means never rotate. minimal is 12 seconds.
 */
- (NSTimeInterval)adInterval;

/**
 * get prama assign by developer own
 * it would be take a few seconds
 */

- (void)didReceiveParam:(NSString*)param;

@end