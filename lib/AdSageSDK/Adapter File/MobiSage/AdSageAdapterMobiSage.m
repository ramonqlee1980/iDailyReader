//
//  AdSageAdapterMobiSage.m
//  AdSageSDK
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdSageAdapterMobiSage.h"
#import "AdSageView.h"
#import "AdSageManager.h"

static NSInteger adSizeList(AdSageBannerAdViewSizeType bannerAdViewSize)
{
    switch (bannerAdViewSize) {
        case AdSageBannerAdViewSize_320X50:
            return Ad_320X40;
            break;
        case AdSageBannerAdViewSize_320X270:
            return Ad_320X270;
            break;
        case AdSageBannerAdViewSize_488X80:
            return Ad_480X40;
            break;
        case AdSageBannerAdViewSize_748X110:
            return Ad_748X110;
            break;
        case AdSageBannerAdViewSize_48X48:
            return Ad_48X48;
            break;
        case AdSageBannerAdViewSize_748X60:
            return Ad_748X60;
            break;
        case AdSageBannerAdViewSize_210X177:
            return Ad_210X177;
            break;
        case AdSageBannerAdViewSize_120X480:
            return Ad_120X480;
            break;
        case AdSageBannerAdViewSize_256X192:
            return Ad_256X192;
            break;
        default:
            return 0;
            break;
    }
}

@implementation AdSageAdapterMobiSage
@synthesize fullScreenButton;
+ (void)load {
    [[AdSageManager getInstance] registerClass:self];
}

+ (AdSageAdapterType)adapterType {
  return AdSageAdapterTypeMobiSage;
}

+ (BOOL)hasBannerSize:(AdSageBannerAdViewSizeType)bannerAdViewSize
{
    if (adSizeList(bannerAdViewSize) > 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)hasFullScreen
{
    return YES;
}

- (void)getBannerAd:(AdSageBannerAdViewSizeType)bannerAdViewSize
{
    if (![[self class] hasBannerSize:bannerAdViewSize]) {
        return;
    }
    adViewType = AdSageBannerAdView;
    timer = [[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    MobiSageAdBanner *adView = [[MobiSageAdBanner alloc] initWithAdSize:adSizeList(bannerAdViewSize) PublisherID:[self getPublisherId]];
    [adView setInterval:Ad_NO_Refresh];
    self.adNetworkView = adView;
    [adView release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adStartShow:) 
                                                 name:MobiSageAdView_Start_Show_AD 
                                               object:self.adNetworkView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adPauseShow:) 
                                                 name:MobiSageAdView_Pause_Show_AD
                                               object:self.adNetworkView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adPop:) 
                                                 name:MobiSageAdView_Pop_AD_Window
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adHide:) 
                                                 name:MobiSageAdView_Hide_AD_Window
                                               object:nil];
}

- (void)getFullScreenAd
{
    if (![[self class] hasFullScreen]) {
        return;
    }
    
    adViewType = AdSageFullScreenAdView;
    
    timer = [[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    MobiSageAdPoster *adView = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        adView = [[MobiSageAdPoster alloc] initWithAdSize:Poster_320X460 PublisherID:[self getPublisherId]];
    }
    else
    {
        adView = [[MobiSageAdPoster alloc] initWithAdSize:Poster_1024X748 PublisherID:[self getPublisherId]];
    }
    [adView startRequestAD];
    
    self.adNetworkView = adView;
    [adView release];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adStartShow:) 
                                                 name:MobiSageAdView_Start_Show_AD 
                                               object:adView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adRefresh:) 
                                                 name:MobiSageAdView_Refresh_AD 
                                               object:adView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adPauseShow:) 
                                                 name:MobiSageAdView_Pause_Show_AD
                                               object:adView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adPop:) 
                                                 name:MobiSageAdView_Pop_AD_Window
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adHide:) 
                                                 name:MobiSageAdView_Hide_AD_Window
                                               object:nil];
}

- (void)stopBeingDelegate {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)dealloc {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    self.fullScreenButton = nil;
	[super dealloc];
}

- (void)adStartShow:(id)sender {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    if (adViewType == AdSageFullScreenAdView) {
        fullScreenButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 12, 32, 32)];
        fullScreenButton.backgroundColor = [UIColor clearColor];
        [fullScreenButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"adCloseNormal" ofType:@"png"]] forState:UIControlStateNormal];
        [fullScreenButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"adCloseHighlight" ofType:@"png"]] forState:UIControlStateHighlighted];
        [fullScreenButton addTarget:self action:@selector(fullScreenClose) forControlEvents:UIControlEventTouchUpInside];
        [self.adNetworkView addSubview:fullScreenButton];
    }
    [_adSageView adapter:self didReceiveAdView:self.adNetworkView];
}

- (void)adRefresh:(id)sender {
    [_adSageView adapter:self didReceiveAdView:self.adNetworkView];
}

- (void)adPauseShow:(id)sender {
    
}

- (void)fullScreenClose
{
    [self.fullScreenButton removeFromSuperview];
    self.fullScreenButton = nil;
    [self.adNetworkView removeFromSuperview];
	[_adSageView adapter:self didCloseAdView:self.adNetworkView];
}

- (void)adPop:(id)sender {
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)adHide:(id)sender {
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [_adSageView adapter:self didFailAd:self.adNetworkView];
}

#pragma mark Ad Request Lifecycle Notifications

// Sent when an ad request loaded an ad.  This is a good opportunity to add
// this view to the hierarchy if it has not yet been added.
//- (void)adViewDidReceiveAd:(GADBannerView *)adView {
//  [adSageView adapter:self didReceiveAdView:adView];
//}

// Sent when an ad request failed.  Normally this is because no network
// connection was available or no ads were available (i.e. no fill).
//- (void)adView:(GADBannerView *)adView
//    didFailToReceiveAdWithError:(GADRequestError *)error {
//  [adSageView adapter:self didFailAd:error];
//}

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
//- (void)adViewWillPresentScreen:(GADBannerView *)adView {
//  [self helperNotifyDelegateOfFullScreenModal];
//}

// Sent just after dismissing a full screen view.  Use this opportunity to
// restart anything you may have stopped as part of adViewWillPresentScreen:.
//- (void)adViewDidDismissScreen:(GADBannerView *)adView {
//  [self helperNotifyDelegateOfFullScreenModalDismissal];
//}

@end
