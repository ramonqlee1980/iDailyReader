//
//  YouMiWall.h
//  YouMiSDK
//
//  Created by Layne on 12-01-05.
//  Copyright (c) 2012年 YouMi Mobile Co. Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "YouMiConfig.h"
#import "YouMiWallDelegateProtocol.h"
#import "YouMiWallAppModel.h"


typedef enum {
    YouMiWallAnimationTransitionNone,  // no animation
    YouMiWallAnimationTransitionZoomIn,
    YouMiWallAnimationTransitionZoomOut,
    YouMiWallAnimationTransitionFade,
    YouMiWallAnimationTransitionPushFromBottom,
    YouMiWallAnimationTransitionPushFromTop
} YouMiWallAnimationTransition;


@interface YouMiWall : NSObject

// 委托
// 
// 详解:
//      用于跟踪回调方法
// 
@property(nonatomic, assign)                                id<YouMiWallDelegate> delegate;


#pragma mark -
#pragma mark 请求和显示应用列表
// 请求应用列表
// 参数->rewarded @YES 有积分模式  @NO 无积分模式
//
// 详解:
//      使用该方法请求的应用列表为默认的Web页面，你需要通过使用showOffers或showOffers:来显示界面
// 补充:
//      1.有积分模式: 应用本身采用积分激励下载模式
//      2.无积分模式: 应用本身无积分激励模式，适应于应用交叉推广
//
// 回调:
//      1.成功->didReceiveOffers: 或 kYouMiOffersResponseNotification
//      2.失败->didFailToReceiveOffers:error: 或 kYouMiOffersResponseErrorNotification
//
- (void)requestOffers:(BOOL)rewarded;

// 显示应用列表
//
// 详解:
//      调用该方法之前确认requestOffers:请求应用列表成功
//
// 回调:
//      1.成功->didShowWallView: 或 kYouMiWallViewOpenedNotification
//      2.失败->didDismissWallView:error: 或 kYouMiWallViewClosedNotification
//
- (BOOL)showOffers;

// 显示应用列表
//
// 详解:
//      该方法和showOffers作用相同，只是该方法可以控制显示全屏页面的动画效果
//
// 回调:
//      同上
//
- (BOOL)showOffers:(YouMiWallAnimationTransition)transition;

#pragma mark -
#pragma mark 获取积分
// 查询用户安装获取积分情况
//
// 详解:
//      当用户安装完成应用并执行了相关操作后，后台将会保存相应的安装记录和所获得的积分情况。
//      通过该接口，你可以获取用户所赚取的积分
// 补充:
//      该方法适应于之前任何请求使用@rewarded为YES的安装记录
//
// 回调:
//      1.成功->didReceiveEarnedPoints:info: 或 kYouMiEarnedPointsResponseNotification
//      2.失败->didFailToReceiveEarnedPoints:error: 或 kYouMiEarnedPointsResponseErrorNotification
//
- (void)requestEarnedPoints;

// 查询用户安装获取积分情况
//
// 详解:
//      该方法和requestEarnedPoints方法作用相同，都是查询用户获取的积分情况。
//      区别在于使用该方法可以在后台生成一个Timer来控制重复查询及重复的次数。
//
// 回调:
//      同上
//
- (void)requestEarnedPointsWithTimeInterval:(NSTimeInterval)seconds repeatCount:(NSUInteger)count;  // |count| assigned to 0 indicate infinity

// 查询用户安装获取积分情况
//
// 详解:
//      该方法和requestEarnedPoints方法作用一样，只是可以通过block的方法来处理请求结果
//
// 回调:
//      同上
//
- (void)requestEarnedPoints:(void (^)(NSError *error, NSArray *info))notification;

// 查询用户安装获取积分情况
//
// 详解:
//      该方法和requestEarnedPoints:作用一样，同样和requestEarnedPointsWithTimeInterval:repeatCount:类似，
//      它采用重复请求模式来查询积分情况
//
// 回调:
//      同上
//
- (void)requestEarnedPointsWithTimeInterval:(NSTimeInterval)seconds
                                repeatCount:(NSUInteger)count
                                 usingBlock:(void (^)(NSError *error, NSArray *info))notification;  // |count| assigned to 0 indicate infinity



#pragma mark -
#pragma mark 请求和显示推荐应用
// 请求推荐应用
// 参数->rewarded @YES 有积分模式  @NO 无积分模式
//
// 详解:
//      使用该方法请求的推荐应用为默认的Web页面，你需要通过使用showFeaturedApp或showFeaturedApp:来显示界面
// 补充:
//      1.有积分模式: 应用本身采用积分激励下载模式
//      2.无积分模式: 应用本身无积分激励模式，适应于应用交叉推广
//
// 回调:
//      1.成功->didReceiveFeaturedApp: 或 kYouMiFeaturedAppResponseErrorNotification
//      2.失败->didFailToReceiveFeaturedApp:error: 或 kYouMiFeaturedAppResponseErrorNotification
//
- (void)requestFeaturedApp:(BOOL)rewarded;

// 显示推荐应用
//
// 详解:
//      调用该方法之前确认requestFeaturedApp:请求推荐应用成功
//
// 回调:
//      1.成功->didShowWallView: 或 kYouMiWallViewOpenedNotification
//      2.失败->didDismissWallView: 或 kYouMiWallViewClosedNotification
//
- (BOOL)showFeaturedApp;

// 显示推荐应用
//
// 详解:
//      该方法和showFeaturedApp作用相同，只是该方法可以控制显示全屏页面的动画效果
//
// 回调:
//      同上
//
- (BOOL)showFeaturedApp:(YouMiWallAnimationTransition)transition;


#pragma mark -
#pragma mark 请求应用列表开源数据
// 请求应用列表开源数据
// 参数->rewarded @YES 有积分模式  @NO 无积分模式
//
// 详解:
//      使用该方法请求的是应用列表的开始数据，可以使用这些开源数据来组织界面。记住配合userInstallOffersApp:使用

// 补充:
//      1.有积分模式: 应用本身采用积分激励下载模式
//      2.无积分模式: 应用本身无积分激励模式，适应于应用交叉推广
//
// 回调:
//      1.成功->didReceiveOffersAppData:offersApp: 或 kYouMiFeaturedAppResponseNotification
//      2.失败->didFailToReceiveOffersAppData:error: 或 kYouMiFeaturedAppResponseErrorNotification
//
- (void)requestOffersAppData:(BOOL)rewarded;    // default offers app count @10

// 请求应用列表开源数据
// 参数->rewarded @YES 有积分模式  @NO 无积分模式
//
// 详解:
//      该方法和requestOffersAppData:作用相同，都是请求应用列表开源数据，只是该方法多了|pageCount|参数，用于指定请求的页面的应用个数
// 补充:
//      1.有积分模式: 应用本身采用积分激励下载模式
//      2.无积分模式: 应用本身无积分激励模式，适应于应用交叉推广
//
// 回调:
//      同上
//
- (void)requestOffersAppData:(BOOL)rewarded pageCount:(NSUInteger)count;

// 请求更多应用列表的开源数据
//
// 详解:
//      该方法和requestOffersAppData:或requestOffersAppData:pageCount:配合使用，用于请求下一页的的源数据
// 补充:
//      1.该方法主要是用于请求非重复的数据，如果你多次使用requestOffersAppData:或requestOffersAppData:pageCount:方法得到的开源应用数据
//        有可能是重复的。
//      2.配合userInstallOffersApp:方法使用
//
// 回调:
//      1.成功->didReceiveMoreOffersAppData:offersApp: 或 kYouMiOffersAppDataMoreResponseNotification
//      2.失败->didFailToReceiveMoreOffersAppData:error: 或 kYouMiOffersAppDataMoreResponseErrorNotification
//
- (void)requestMoreOffersAppData;  // next page wiht |pageCount| app

// 应用列表开源数据点击回调方法
//
// 详解:
//      当用户点击了你使用requestOffersAppData:,requestOffersAppData:pageCount或requestMoreOffersAppData请求的开源数据后，
//      回调该方法，可以告知后台记录点击事件并打开跳转链接
//
- (void)userInstallOffersApp:(YouMiWallAppModel *)appModel;


#pragma mark -
#pragma mark 请求推荐应用开源数据
// 请求推荐应用的开源数据
// 参数->rewarded @YES 有积分模式  @NO 无积分模式
//
// 详解:
//      通过获取推荐应用的开源数据，你可以组织推荐显示界面。记住配合userInstallFeaturedApp:使用
// 补充:
//      1.有积分模式: 应用本身采用积分激励下载模式
//      2.无积分模式: 应用本身无积分激励模式，适应于应用交叉推广
// 
// 回调:
//      1.成功->didReceiveFeaturedAppData:appModel: 或 kYouMiFeaturedAppDataResponseNotification
//      2.失败->didFailToReceiveFeaturedAppData:error: 或 kYouMiFeaturedAppDataResponseErrorNotification
// 
- (void)requestFeaturedAppData:(BOOL)rewarded;

// 请求推荐应用的开源数据
//
// 详解:
//      当你使用requestFeaturedAppData:请求推荐应用开源数据后，如果用户单击对应的应用，你需要回调该方法
//      后台在接收到该回调信息后，会记录该点击情况，并打开相应的应用下载页面（比如跳转到App Store）
// 
- (void)userInstallFeaturedApp:(YouMiWallAppModel *)appModel;



@end


