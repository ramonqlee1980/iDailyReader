//
//  AdSageDelegate.h
//  AdSageSDK
//
//  Created by sdk team on 2013/03/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//  SDK Aggregation Version 2.1.7
//

#import <Foundation/Foundation.h>

@class AdSageView;

@protocol AdSageDelegate <NSObject>

@required
/**
 * The view controller with which the ad network will display a modal view
 * (web view, canvas), such as when the user clicks on the ad. You must
 * supply a view controller. You should return the root view controller
 * of your application, such as the root UINavigationController, or
 * any controllers that are pushed/added directly to the root view controller.
 * For example, if your app delegate has a pointer to the root view controller:
 *
 * return [(MyAppDelegate *)[[UIApplication sharedApplication] delegate] rootViewController]
 *
 * will suffice.
 */
- (UIViewController *)viewControllerForPresentingModalView;

@optional

- (void)adSageDidReceiveBannerAd:(AdSageView *)adSageView;

- (void)adSageDidFailToReceiveBannerAd:(AdSageView *)adSageView;

- (void)adSageDidReceiveFullScreenAd:(AdSageView *)adSageView;

- (void)adSageDidFailToReceiveFullScreenAd:(AdSageView *)adSageView;

- (void)adSageDidCloseFullScreenAd:(AdSageView *)adSageView;

- (void)adSageWillPresentFullScreenModal;

- (void)adSageDidDismissFullScreenModal;

- (void)adSageViewPointInside:(AdSageView *)adsageView;

@end
