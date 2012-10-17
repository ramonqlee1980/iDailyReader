//
//  AdSageRecommendDelegate.h
//  adsage_test
//
//  Created by 苹果 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AdSageRecommendDelegate <NSObject>
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

- (void)adSageWillOpenRecommendModalView;
- (void)adSageFailToOpenRecommendModalView;
- (void)adSageDidCloseRecommendModalView;

@end
