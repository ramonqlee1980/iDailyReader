//
//  ETMobAdWall.h
//  ETMobAdWall_Test2
//
//  Created by Qi on 12-7-26.
//  Copyright (c) 2012年 Qi. All rights reserved.
//

#import <UIKit/UIKit.h>

// Error code
enum 
{
    ETMobErrorUnknown = 0,
    ETMobErrorSDKUsingError = 1,      // SDK 使用错误. 比如 delegate 方法实现错误等.
    ETMobErrorServerNotReturnApps = 2 // 服务器返回的App列表是空的.
};

#pragma mark - ETMobAdWallDelegate

@class ETMobAdWall;

@protocol ETMobAdWallDelegate <NSObject>

@required
// 
// 设置服务器 URL。
// 
- (NSURL *)apiURLForETMobAdWall:(ETMobAdWall *)adWall;
// 
// 设置 App Token，该字符串是在网站注册后获得的。
// 
- (NSString *)appTokenForETMobAdWall:(ETMobAdWall *)adWall;

@optional
// 
// 设置 passcode，该字符串是在网站注册后获得的。
// 说明：passcode 目前是保留字段，可设置为任何值。
// 
- (NSString *)passcodeForETMobAdWall:(ETMobAdWall *)adWall; 
// 
// 请按与 AdWall 呈现方式相对应的方式解除之。
// 
- (void)dismissAdWall:(ETMobAdWall *)adWall;
// 
// 当应用墙数据成功加载后调用此方法。
// 
- (void)ETMobAdWallDidLoad:(ETMobAdWall *)adWall; 
// 
// 当应用墙数据加载失败时调用此方法。
// 
- (void)ETMobAdWall:(ETMobAdWall *)adWall didFailToLoadWithError:(NSError *)error; 

@end // @protocol


#pragma mark - ETMobAdWall

@interface ETMobAdWall : UIViewController
@property (assign, nonatomic) IBOutlet id<ETMobAdWallDelegate> delegate;

// 
// 获得应用墙的单例对象. 
// 
+ (ETMobAdWall *)sharedAdWall;

@end // @interface