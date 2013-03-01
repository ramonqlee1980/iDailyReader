//
//  MobiSageRecommendDelegateImp.m
//  com.idreems.mrh
//
//  Created by ramonqlee on 2/24/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import "MobiSageRecommendDelegateImp.h"
#import "Flurry.h"

@implementation MobiSageRecommendDelegateImp
@synthesize viewControllerForPresentingModalView=_viewControllerForPresentingModalView;
//@required
/**
 *  嵌入应用推荐界面对象中实现Delegate
 */
- (UIViewController *)viewControllerForPresentingModalView
{
    return _viewControllerForPresentingModalView;
}


//@optional
/**
 *  应用推荐界面打开时调用
 */
- (void)MobiSageWillOpenRecommendModalView
{
    [Flurry logEvent:@"MobiSageWillOpenRecommendModalView"];
}
/**
 *  应用推荐界面打开失败时调用
 */
- (void)MobiSageFailToOpenRecommendModalView
{
    [Flurry logEvent:@"MobiSageFailToOpenRecommendModalView"];
}
/**
 *  应用推荐界面关闭时调用
 */
- (void)MobiSageDidCloseRecommendModalView
{
    [Flurry logEvent:@"MobiSageDidCloseRecommendModalView"];
}
@end
