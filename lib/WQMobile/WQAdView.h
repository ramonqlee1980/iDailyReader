//
//  WQAdView.h
//  WQMobile
//
//  Created by Yuehui Zhang on 1/5/11.
//  Copyright 2011 WQ Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 传统的广告大小, 320x48.
 */
#define WQMOB_SIZE_320x48     CGSizeMake(320,48)


@protocol WQAdProtocol;

/**
 * 广告控件所处的屏幕位置
 */
typedef enum WQ_ADVIEW_LOCATION{
	WQ_LOCATION_TOP,/**< 最顶部 */  
	WQ_LOCATION_BOTTOM,/**< 最底部 */  
	WQ_LOCATION_OTHERS/**< 其他位置 */  
} WQViewLocation;

/**
 * control for WQMobile
 */
@interface WQAdView : UIView 

/**
 * 构造一个广告控件.
 * @param location 控件所处的屏幕位置
 * @param size 广告控件的位置
 * @param delegate 处理该控件的委托对象
 **/
+(WQAdView *) requestAdByLocation:(WQViewLocation) location withSize:(CGSize)size withDelegate:(id<WQAdProtocol>)delegate;

/**
 * 构造一个广告控件.
 * @param rect 广告控件的rect属性
 * @param delegate 处理该控件的委托对象
 **/
+(WQAdView *) requestAdOfRect:(CGRect)rect withDelegate:(id<WQAdProtocol>)delegate;

/**
 * 相当于执行 [WQAdView requestAdByLocation:WQ_LOCATION_BOTTOM withSize:WQMOB_SIZE_320x48 withDelegate:delegate];
 * @param delegate 处理该控件的委托对象
 **/
+(WQAdView *) requestAdWithDelegate:(id<WQAdProtocol>)delegate;

/**
 * 设定一张默认图片
 * @param img 显示的图片对象
 **/
-(void) setDefaultImage:(UIImage*) img;

/**
 * 设置广告控件的位置大小信息
 * @param rect 要切换的信息
 **/
-(void) setAdRect:(CGRect) rect;

/**
 * 触发广告提取.
 **/
-(void) startRequestAd;

@end
