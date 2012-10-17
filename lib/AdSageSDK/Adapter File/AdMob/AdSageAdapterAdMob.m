//
//  AdSageAdapterAdMob.m
//  AdSageSDK
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdSageAdapterAdMob.h"
#import "AdSageView.h"
#import "AdSageManager.h"
#import "GADAdSize.h"
#import "GADBannerView.h"
#import "GADInterstitial.h"

static GADAdSize adSizeList(AdSageBannerAdViewSizeType bannerAdViewSize)
{
    switch (bannerAdViewSize) {
        case AdSageBannerAdViewSize_320X50:
            return kGADAdSizeBanner;
            break;
        case AdSageBannerAdViewSize_320X270:
            return kGADAdSizeMediumRectangle;
            break;
        case AdSageBannerAdViewSize_488X80:
            return kGADAdSizeFullBanner;
            break;
        case AdSageBannerAdViewSize_748X110:
            return kGADAdSizeLeaderboard;
            break;
        default:
            return kGADAdSizeInvalid;
            break;
    }
}

@implementation AdSageAdapterAdMob

+ (void)load {
    [[AdSageManager getInstance] registerClass:self];
}

+ (AdSageAdapterType)adapterType {
    return AdSageAdapterTypeAdMob;
}

+ (BOOL)hasBannerSize:(AdSageBannerAdViewSizeType)bannerAdViewSize
{
    return IsGADAdSizeValid(adSizeList(bannerAdViewSize));
}

+ (BOOL)hasFullScreen
{
    return NO;
}

+ (BOOL)hasClickMessage
{
    return YES;
}

// converts UIColor to hex string, ignoring alpha.
- (NSString *)hexStringFromUIColor:(UIColor *)color {
    CGColorSpaceModel colorSpaceModel =
    CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
    if (colorSpaceModel == kCGColorSpaceModelRGB
        || colorSpaceModel == kCGColorSpaceModelMonochrome) {
        const CGFloat *colors = CGColorGetComponents(color.CGColor);
        CGFloat red = 0.0, green = 0.0, blue = 0.0;
        if (colorSpaceModel == kCGColorSpaceModelRGB) {
            red = colors[0];
            green = colors[1];
            blue = colors[2];
            // we ignore alpha here.
        } else if (colorSpaceModel == kCGColorSpaceModelMonochrome) {
            red = green = blue = colors[0];
        }
        return [NSString stringWithFormat:@"%02X%02X%02X",
                (int)(red * 255), (int)(green * 255), (int)(blue * 255)];
    }
    return nil;
}

- (void)getBannerAd:(AdSageBannerAdViewSizeType)bannerAdViewSize
{
    
    if (![[self class] hasBannerSize:bannerAdViewSize]) {
        return;
    }
    
    timer = [[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad.
    request.testing = [self isTestMode];
    
    // Set the frame for this view to match the bounds of the parent adWhirlView.
    CGPoint origin = CGPointMake(0.0, 0.0);
    GADBannerView *view = [[[GADBannerView alloc] initWithAdSize:adSizeList(bannerAdViewSize) origin:origin] autorelease];
    view.adUnitID = [self getPublisherId];
    view.delegate = self;
    [view setRootViewController:[_adSageDelegate viewControllerForPresentingModalView] ];
    self.adNetworkView = view;
    
    [view loadRequest:request];
}

- (void)getFullScreenAd
{
    if (![[self class] hasFullScreen]) {
        return;
    }
    
    timer = [[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    
    GADRequest *request = [GADRequest request];
    
    GADInterstitial *interstitialAD = [GADInterstitial new];
    interstitialAD.adUnitID = [self getPublisherId];
    interstitialAD.delegate = self;
    [interstitialAD presentFromRootViewController:[_adSageDelegate viewControllerForPresentingModalView]];
    [interstitialAD loadRequest:request];
}

- (void)stopBeingDelegate {
    if (self.adNetworkView != nil) {
        GADBannerView *view = (GADBannerView *)self.adNetworkView;
        view.delegate = nil;
        self.adNetworkView =nil;
    }
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [_adSageView adapter:self didFailAd:nil];
}

- (void)dealloc {
    [super dealloc];
}
#pragma mark Ad Request Lifecycle Notifications

// Sent when an ad request loaded an ad.  This is a good opportunity to add
// this view to the hierarchy if it has not yet been added.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [_adSageView adapter:self didReceiveAdView:self.adNetworkView];
}

// Sent when an ad request failed.  Normally this is because no network
// connection was available or no ads were available (i.e. no fill).
- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [_adSageView adapter:self didFailAd:self.adNetworkView];
}

#pragma mark Click-Time Lifecycle Notifications

// Sent just before presenting the user a full screen view, such as a browser,
// in response to clicking on an ad.  Use this opportunity to stop animations,
// time sensitive interactions, etc.
//
// Normally the user looks at the ad, dismisses it, and control returns to your
// application by calling adViewDidDismissScreen:.  However if the user hits
// the Home button or clicks on an App Store link your application will end.
// On iOS 4.0+ the next method called will be applicationWillResignActive: of
// your UIViewController (UIApplicationWillResignActiveNotification).
// Immediately after that adViewWillLeaveApplication: is called.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    [self.adSageView adapter:self didClickAd:adView];
    [self helperNotifyDelegateOfFullScreenModal];
}

// Sent just after dismissing a full screen view.  Use this opportunity to
// restart anything you may have stopped as part of adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).  The normal UIApplicationDelegate methods, like
// applicationDidEnterBackground:, will be called immediately before this.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    [self.adSageView adapter:self didClickAd:adView];
}

#pragma mark parameter gathering methods

//- (SEL)delegatePublisherIdSelector {
//  return @selector(admobPublisherID);
//}

#pragma mark Ad Request Lifecycle Notifications
// Sent when an interstitial ad request succeeded.  Show it at the next
// transition point in your application such as when transitioning between view
// controllers.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    
}

// Sent when an interstitial ad request completed without an interstitial to
// show.  This is common since interstitials are shown sparingly to users.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    
}

#pragma mark Display-Time Lifecycle Notifications

// Sent just before presenting an interstitial.  After this method finishes the
// interstitial will animate onto the screen.  Use this opportunity to stop
// animations and save the state of your application in case the user leaves
// while the interstitial is on screen (e.g. to visit the App Store from a link
// on the interstitial).
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    
}

// Sent before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
    
}

// Sent just after dismissing an interstitial and it has animated off the
// screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    
}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).  The normal UIApplicationDelegate methods, like
// applicationDidEnterBackground:, will be called immediately before this.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    
}

@end
