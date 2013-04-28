//
//  YouMiWallDelegateProtocol.h
//  YouMiSDK
//
//  Created by Layne on 12-01-05.
//  Copyright (c) 2012年 YouMi Mobile Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YouMiWallAppModel.h"


// 后面 Notification 中的 userInfo 可能用到的key
extern NSString *const kYouMiFeatureAppKey;
extern NSString *const kYouMiOffersAppKey;
extern NSString *const kYouMiEarnedPointsKey;
extern NSString *const kYouMiErrorKey;

// Notifications
// Offers
extern NSString *const kYouMiOffersAppDataResponseNotification;         // 请求应用列表开源数据成功
extern NSString *const kYouMiOffersAppDataMoreResponseNotification;     // 请求应用列表更多开源数据成功
extern NSString *const kYouMiOffersResponseNotification;                // 请求应用列表成功
// Offers error
extern NSString *const kYouMiFeaturedAppResponseErrorNotification;          // 请求应用列表开源数据失败
extern NSString *const kYouMiOffersAppDataMoreResponseErrorNotification;    // 请求应用列表更多开源数据失败
extern NSString *const kYouMiOffersResponseErrorNotification;               // 请求应用列表失败
// Points
extern NSString *const kYouMiEarnedPointsResponseNotification;      //查询积分请求成功
extern NSString *const kYouMiEarnedPointsResponseErrorNotification; //查询积分请求失败
// View
extern NSString *const kYouMiWallViewOpenedNotification;        // 显示全屏页面
extern NSString *const kYouMiWallViewClosedNotification;        // 隐藏全屏页面
// Featured app
extern NSString *const kYouMiFeaturedAppDataResponseNotification;   // 请求推荐应用开源数据成功
extern NSString *const kYouMiFeaturedAppResponseNotification;       // 请求推荐应用成功
// Featured app error
extern NSString *const kYouMiFeaturedAppDataResponseErrorNotification;  // 请求推荐应用开源数据失败
extern NSString *const kYouMiFeaturedAppResponseErrorNotification;      // 请求推荐应用失败



@class YouMiWall;

@protocol YouMiWallDelegate <NSObject>
@optional

#pragma mark 应用列表回调方法

// 请求应用列表成功
//
// 说明:
//      应用列表请求成功后回调该方法
//
- (void)didReceiveOffers:(YouMiWall *)adWall;

// 请求应用列表失败
//
// 说明:
//      应用列表请求失败后回调该方法
//
- (void)didFailToReceiveOffers:(YouMiWall *)adWall error:(NSError *)error;

#pragma mark 积分查询情况

// 积分记录
extern NSString *const kYouMiEarnedPointsOrderIDOpenKey;     // 订单号
extern NSString *const kYouMiEarnedPointsUserIDOpenKey;      // 用户标示符，查看YouMiWall的 @property userID;
extern NSString *const kYouMiEarnedPointsStoreIDOpenKey;     // 广告标示符
extern NSString *const kYouMiEarnedPointsNameOpenKey;        // 安装的应用名称
extern NSString *const kYouMiEarnedPointsPoinstsOpenKey;     // 获得的积分[NSNumber]
extern NSString *const kYouMiEarnedPointsChannelOpenKey;     // 渠道号，查看YouMiWall的 @property channelID;
extern NSString *const kYouMiEarnedPointsTimeStampOpenKey;   // 安装记录GMT时间[NSString]

// 查询积分情况成功
// @info 里面包含 [积分记录] 的 NSDictionary
//
// 说明:
//      积分查询请求成功后回调该方法
- (void)didReceiveEarnedPoints:(YouMiWall *)adWall info:(NSArray *)info;

// 查询积分情况失败
//
// 说明:
//      积分查询请求失败后回调该方法
- (void)didFailToReceiveEarnedPoints:(YouMiWall *)adWall error:(NSError *)error;


#pragma mark 推荐应用回调方法

// 请求推荐应用成功
//
// 说明:
//      推荐应用请求成功后回调该方法
//
- (void)didReceiveFeaturedApp:(YouMiWall *)adWall;

// 请求推荐应用失败
//
// 说明:
//      推荐应用请求失败后回调该方法
//
- (void)didFailToReceiveFeaturedApp:(YouMiWall *)adWall error:(NSError *)error;

#pragma mark 全屏页面显示隐藏通知

//
// 说明:
//      全屏页面显示完成后回调该方法
//
- (void)didShowWallView:(YouMiWall *)adWall;

//
// 说明:
//      全屏页面隐藏完成后回调该方法
//
- (void)didDismissWallView:(YouMiWall *)adWall;


#pragma mark Request Featured App Notification Methods
 
// 请求推荐应用开源数据成功
// 
// 说明:
//      推荐应用开源数据请求成功后回调该方法
//
- (void)didReceiveFeaturedAppData:(YouMiWall *)adWall appModel:(YouMiWallAppModel *)appModel;

// 请求推荐应用开源数据失败
// 
// 说明:
//      推荐应用开源数据请求失败后回调该方法
//
- (void)didFailToReceiveFeaturedAppData:(YouMiWall *)adWall error:(NSError *)error;



#pragma mark Request Offers Notification Methods

// 请求应用列表开源数据成功
// 
// 说明:
//      应用列表开源数据请求成功后回调该方法
//
- (void)didReceiveOffersAppData:(YouMiWall *)adWall offersApp:(NSArray *)apps;

// 请求应用列表更多开源数据成功
// 
// 说明:
//      应用列表更多开源数据请求成功后回调该方法
//
- (void)didReceiveMoreOffersAppData:(YouMiWall *)adWall offersApp:(NSArray *)apps;

// 请求应用列表开源数据失败
// 
// 说明:
//      应用列表开始数据请求失败后回调该方法
//
- (void)didFailToReceiveOffersAppData:(YouMiWall *)adWall error:(NSError *)error;

// 请求应用列表更多开源数据失败
// 
// 说明:
//      应用列表更多开源数据请求失败后回调该方法
//
- (void)didFailToReceiveMoreOffersAppData:(YouMiWall *)adWall error:(NSError *)error;


@end


///////////为了兼容以前的常量///////////
// 积分记录
#define kOneAccountRecordOrderIDOpenKey     kYouMiEarnedPointsOrderIDOpenKey    // 订单号
#define kOneAccountRecordUserIDOpenKey      kYouMiEarnedPointsUserIDOpenKey     // 用户标示符，查看YouMiWall的 @property userID;
#define kOneAccountRecordStoreIDOpenKey     kYouMiEarnedPointsStoreIDOpenKey    // 广告标示符
#define kOneAccountRecordNameOpenKey        kYouMiEarnedPointsNameOpenKey       // 安装的应用名称
#define kOneAccountRecordPoinstsOpenKey     kYouMiEarnedPointsPoinstsOpenKey    // 获得的积分[NSNumber]
#define kOneAccountRecordChannelOpenKey     kYouMiEarnedPointsChannelOpenKey    // 渠道号，查看YouMiWall的 @property channelID;
#define kOneAccountRecordTimeStampOpenKey   kYouMiEarnedPointsTimeStampOpenKey  // 安装记录GMT时间[NSString]


#define YOUMI_WALL_NOTIFICATION_USER_INFO_FEATURED_APP_KEY      kYouMiFeatureAppKey
#define YOUMI_WALL_NOTIFICATION_USER_INFO_OFFERS_APP_KEY        kYouMiOffersAppKey
#define YOUMI_WALL_NOTIFICATION_USER_INFO_EARNED_POINTS_KEY     kYouMiEarnedPointsKey
#define YOUMI_WALL_NOTIFICATION_USER_INFO_ERROR_KEY             kYouMiErrorKey


// offers
#define YOUMI_OFFERS_APP_DATA_RESPONSE_NOTIFICATION         kYouMiFeaturedAppResponseNotification
#define YOUMI_OFFERS_APP_DATA_MORE_RESPONSE_NOTIFICATION    kYouMiOffersAppDataMoreResponseNotification
#define YOUMI_OFFERS_RESPONSE_NOTIFICATION                  kYouMiOffersResponseNotification

// offers error
#define YOUMI_OFFERS_APP_DATA_RESPONSE_NOTIFICATION_ERROR       kYouMiFeaturedAppResponseErrorNotification
#define YOUMI_OFFERS_APP_DATA_MORE_RESPONSE_NOTIFICATION_ERROR  kYouMiOffersAppDataMoreResponseErrorNotification
#define YOUMI_OFFERS_RESPONSE_NOTIFICATION_ERROR                kYouMiOffersResponseErrorNotification

// points
#define YOUMI_EARNED_POINTS_RESPONSE_NOTIFICATION       kYouMiEarnedPointsResponseNotification
#define YOUMI_EARNED_POINTS_RESPONSE_NOTIFICATION_ERROR kYouMiEarnedPointsResponseErrorNotification

// view
#define YOUMI_WALL_VIEW_OPENED_NOTIFICATION     kYouMiWallViewOpenedNotification
#define YOUMI_WALL_VIEW_CLOSED_NOTIFICATION     kYouMiWallViewClosedNotification

// feature app
#define YOUMI_FEATURED_APP_DATA_RESPONSE_NOTIFICATION   kYouMiFeaturedAppDataResponseNotification
#define YOUMI_FEATURED_APP_RESPONSE_NOTIFICATION        kYouMiFeaturedAppResponseErrorNotification

// feature app error
#define YOUMI_FEATURED_APP_DATA_RESPONSE_NOTIFICATION_ERROR kYouMiFeaturedAppDataResponseErrorNotification
#define YOUMI_FEATURED_APP_RESPONSE_NOTIFICATION_ERROR      kYouMiFeaturedAppResponseErrorNotification



    