//
//  AdSageView.h
//  AdSageSDK
//
//  Created by sdk team on 2013/03/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//  SDK Aggregation Version 2.1.7
//

#import <UIKit/UIKit.h>
#import "AdSageDelegate.h"

typedef enum {
    AdSageBannerAdView                                  = 1,
    AdSageFullScreenAdView                              = 2,
} AdSageAdviewType;

typedef enum {
    AdSageBannerAdViewSize_320X50                       = 1,
    AdSageBannerAdViewSize_300X250                      = 2,
    AdSageBannerAdViewSize_468X60                       = 3,
//  AdSageBannerAdViewSize_640X100                      = 4,   Note:由于各广告平台不支持该尺寸的广告，故取消该尺寸广告的支持。
    AdSageBannerAdViewSize_728X90                       = 5,
    
} AdSageBannerAdViewSizeType;

@class AdSageAdapter;

@interface AdSageView : UIView
{
}
//获取banner广告
+ (AdSageView *)requestAdSageBannerAdView:(id<AdSageDelegate>)delegate sizeType:(AdSageBannerAdViewSizeType)sizeType;
//获取全屏广告
+ (AdSageView *)requestAdSageFullScreenAdView:(id<AdSageDelegate>)delegate;

//暂停广告平台切换
- (void)pauseAdRequest;
//继续广告平台切换
- (void)continueAdRequest;
//实际广告尺寸
- (CGSize)actualAdSize;

//当显示全屏广告时，转屏需要调用此接口
- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;

#pragma mark For adapters use only
/**
 * Called by Adapters when there's a new ad view.
 */
- (void)adapter:(AdSageAdapter *)adapter didReceiveAdView:(UIView *)view;
/**
 * Called by Adapters when ad view failed.
 */
- (void)adapter:(AdSageAdapter *)adapter didFailAd:(UIView *)view;
/**
 * Called by Adapters when ad view click.
 */
- (void)adapter:(AdSageAdapter *)adapter didClickAd:(UIView *)view;
/**
 * Called by Adapters when ad view closed.
 */
- (void)adapter:(AdSageAdapter *)adapter didCloseAdView:(UIView *)view;
/**
 * Called by Adapters when the ad request is finished, but the ad view is
 * furnished elsewhere. e.g. Generic Notification
 */
- (void)adapterDidFinishAdRequest:(AdSageAdapter *)adapter;

@end
