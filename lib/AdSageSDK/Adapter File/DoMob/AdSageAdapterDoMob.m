//
//  AdSageAdapterDoMob.m
//  AdSageSDK
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdSageAdapterDoMob.h"
#import "AdSageView.h"
#import "AdSageManager.h"

static CGSize adSizeList(AdSageBannerAdViewSizeType bannerAdViewSize)
{
    switch (bannerAdViewSize) {
        case AdSageBannerAdViewSize_320X50:
            return DOMOB_AD_SIZE_320x50;
            break;
        case AdSageBannerAdViewSize_320X270:
            return DOMOB_AD_SIZE_300x250;
            break;
        case AdSageBannerAdViewSize_488X80:
            return DOMOB_AD_SIZE_488x80;
            break;
        case AdSageBannerAdViewSize_748X110:
            return DOMOB_AD_SIZE_728x90;
            break;
        default:
            return CGSizeZero;
    }
}

@implementation AdSageAdapterDoMob

+ (AdSageAdapterType)adapterType{
    return AdSageAdapterTypeDoMob;
}

+ (void)load{
    [[AdSageManager getInstance] registerClass:self];
}

+ (BOOL)hasFullScreen
{
    return NO;
}

+ (BOOL)hasBannerSize:(AdSageBannerAdViewSizeType)bannerAdViewSize
{
    if (CGSizeEqualToSize(adSizeList(bannerAdViewSize), CGSizeZero)) {
        return NO;
    }
    return YES;
}

- (void)getBannerAd:(AdSageBannerAdViewSizeType)bannerAdViewSize
{
    if (![[self class] hasBannerSize:bannerAdViewSize]) {
        return;
    }
    timer = [[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];

    DMAdView *adView = [[DMAdView alloc] initWithPublisherId:[self getPublisherId] size:adSizeList(bannerAdViewSize) autorefresh:NO];
    adView.delegate = self;
    adView.rootViewController = [_adSageDelegate viewControllerForPresentingModalView];
    [adView loadAd];
    self.adNetworkView = adView;
    [adView release];
}
- (void)stopBeingDelegate{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    DMAdView *doMobView = (DMAdView *)self.adNetworkView;
	if (doMobView != nil) {
        doMobView.delegate = nil;
        doMobView.rootViewController = nil;
	}
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
	[super dealloc];
}

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation{
    
}

#pragma mark DoMob Delegate
// 成功加载广告后，回调该方法
- (void)dmAdViewSuccessToLoadAd:(DMAdView *)adView
{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [_adSageView adapter:self didReceiveAdView:adView];
}
// 加载广告失败后，回调该方法
- (void)dmAdViewFailToLoadAd:(DMAdView *)adView withError:(NSError *)error
{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [_adSageView adapter:self didFailAd:adView];
}

// 当将要呈现出 Modal View 时，回调该方法。如打开内置浏览器。
- (void)dmWillPresentModalViewFromAd:(DMAdView *)adView
{
    [self helperNotifyDelegateOfFullScreenModal];
}
// 当呈现的 Modal View 被关闭后，回调该方法。如内置浏览器被关闭。
- (void)dmDidDismissModalViewFromAd:(DMAdView *)adView
{
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

#pragma mark -
#pragma mark optional control ad request interval methods
//超时处理
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [_adSageView adapter:self didFailAd:nil];
}
@end