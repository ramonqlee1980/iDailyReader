//
//  MobiSageRecommendSDK.h
//  MobiSageRecommand
//
//  Created by SDK Team on 12-8-14.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/*系统事件*/
/*typedef enum SYSTEM_EVENT_ENUM
{
    CustomerEvent         = 0,      //    0 非系统事件，即用户事件
    AppLaunchingEvent     = 1,      //    1 程序启动事件
    AppTerminatingEvent   = 2      //    2 程序退出事件
    
}SystemEventEnum;
*/
#ifndef SYSTEM_EVENT_ENUM
#define SYSTEM_EVENT_ENUM
typedef enum SYSTEM_EVENT_ENUM
{
    CustomerEvent         = 0,      //    0 非系统事件，即用户事件
    AppLaunchingEvent     = 1,      //    1 程序启动事件
    AppTerminatingEvent   = 2      //    2 程序退出事件
    
}SystemEventEnum;

#endif

#ifndef _MobiSageManager_
#define _MobiSageManager_
@interface MobiSageManager : NSObject {
    
}

/**
 *  获得MobiSage平台管理单例
 */
+(MobiSageManager*)getInstance;


/**
 *  设置publisherID
 *  @param publisherID	AC平台分配给应用的id
 */
-(void)setPublisherID:(NSString *)publisherID;

/**
 *  设置应用分发渠道
 *  @param deployChannel	分发渠道名称
 */
-(void)setDeployChannel:(NSString *)deployChannel;

/**
 *  反馈应用系统事件，
 *  @param event	事件类型
 *  @note    例如应用进入后台或退出或重新回到前台等事件
 */
-(void)trackSystemEvent:(SystemEventEnum)event;

/**
 *  反馈应用系统事件，
 *  @param event	事件类型
 *  @param object	开发者自定义的附加反馈信息
 *  @note    例如应用进入后台或退出或重新回到前台等事件
 */
-(void)trackSystemEvent:(SystemEventEnum)event WithObject:(NSString *)object;

/**
 *  返回开发者自定义事件
 *  @param event	事件类型
 *  @param object	开发者自定义的附加反馈信息
 */
-(void)trackCustomerEvent:(NSString *)event WithObject:(NSString *)object;




@end
#endif


@protocol MobiSageRecommendDelegate <NSObject>

@required
/**
 *  嵌入应用推荐界面对象中实现Delegate
 */
- (UIViewController *)viewControllerForPresentingModalView;


@optional
/**
 *  应用推荐界面打开时调用
 */
- (void)MobiSageWillOpenRecommendModalView;
/**
 *  应用推荐界面打开失败时调用
 */
- (void)MobiSageFailToOpenRecommendModalView;
/**
 *  应用推荐界面关闭时调用
 */
- (void)MobiSageDidCloseRecommendModalView;

@end


@interface MobiSageRecommendView : UIControl
{

}

/**
 *  初始化应用推荐功能
 *  @param delegate	设置委托
 */
-(id)initWithDelegate:(id<MobiSageRecommendDelegate>)delegate;


/**
 *  初始化应用推荐功能
 *  @param delegate	设置委托
 *  @param image	设置点击图片
 */
-(id)initWithDelegate:(id<MobiSageRecommendDelegate>)delegate andImg:(UIImage*)image;


/**
 *  弹出应用推荐页面
 */
- (void)OpenAdSageRecmdModalView;

@end
