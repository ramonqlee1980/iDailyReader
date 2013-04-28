//
//  YouMiWallBanner.h
//  YouMiSDK
//
//  Created by ENZO YANG on 13-1-29.
//  Copyright (c) 2013年 YouMi Mobile Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

//
// 默认大小 320X50
// 默认背景透明，可以像普通的UIView那样设置背景颜色
//
@interface YouMiWallBanner : UIView

// 创建YouMiWallBanner
//
// 输入:
//    rewarded: 是否是有积分模式
//    unit: 积分单位[比如:"元宝"，"金币" 等等], 默认"奖励", 如果是无积分模式则可只传nil
// 
// 例子:
//  YouMiWallBanner *wallBanner = [[[YouMiWallBanner alloc] initRewarded:YES unit:@"刀"] autorelease];
//  wallBanner.backgroundColor = [UIColor greenColor];
//  [aSuperview addSubview:wallBanner];
//
- (id)initRewarded:(BOOL)isRewarded unit:(NSString *)unit;

@end
