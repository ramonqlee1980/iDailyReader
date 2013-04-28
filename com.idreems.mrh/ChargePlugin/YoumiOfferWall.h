//
//  YoumiWall.h
//  HappyLife
//
//  Created by ramonqlee on 3/31/13.
//
//

#import <Foundation/Foundation.h>
#import "YoumiWall.h"

@protocol YouMiOfferWallDelegate <NSObject>
@optional

#pragma mark 应用列表回调方法

// 请求应用列表成功
//
// 说明:
//      应用列表请求成功后回调该方法
//
- (void)didReceiveOffers:(NSInteger)points;

// 请求应用列表失败
//
// 说明:
//      应用列表请求失败后回调该方法
//
- (void)didFailToReceiveOffers:(NSInteger)points error:(NSError *)error;
@end



@interface YoumiOfferWall : NSObject<YouMiWallDelegate>

+(YoumiOfferWall*)shareInstance:(NSString*)appId appKey:(NSString*)appKey reward:(BOOL)credit;

-(BOOL)showOffer:(BOOL)credit;

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
- (void)requestEarnedPoints:(id<YouMiOfferWallDelegate>)delegate;

-(BOOL)spendPoints:(NSInteger)points;
@end
