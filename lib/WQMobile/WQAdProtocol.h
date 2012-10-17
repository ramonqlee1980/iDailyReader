//
//  WQViewProtocol.h
//  WQMobile
//
//  Created by Yuehui Zhang on 1/4/11.
//  Copyright 2011 WQ Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQAdView;

/**
 * WQAdView的委托
 */
@protocol WQAdProtocol

@optional
/**
 * 当接收到广告的时候调用
 * 当收到此消息时，请将广告显示
 * @param adView 收到广告的控件
 */
-(void) didReceivedAd:(WQAdView*) adView;

/**
 * 当不能接收广告的时候调用
 * 请移除该广告控件，或者设置一个默认图片
 * @param adView 不能接收广告的控件
 */ 
-(void) didFailToReceiveAd:(WQAdView*) adView;

/**
 * 当需要跳出该您的应用程序，实现其他系统功能时调用，例如
 * 使用系统地图，或打电话。
 * 请保持您当前的应用程序数据以便退出
 * @param adView 触发该调用的广告控件
 */ 
-(void) applicationWillTerminated:(WQAdView *)adView;

/** 
 * 当需要使用全屏的时候调用，例如使用嵌入式浏览器
 * 请暂停您当前的应用程序
 * @param adView 触发该操作的广告控件
 */ 
-(void) applicationWillPaused:(WQAdView *)adView;

/**
 * 当全屏操作完成，把屏幕交回您的应用程序的时候调用
 * @param adView 触发该操作的广告控件
 */
-(void) applicationResumed:(WQAdView*) adView;

@end
