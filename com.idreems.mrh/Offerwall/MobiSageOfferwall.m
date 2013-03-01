//
//  MobiSageOfferwall.m
//  com.idreems.mrh
//
//  Created by ramonqlee on 2/24/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import "MobiSageOfferwall.h"
#import "MobiSageRecommendDelegateImp.h"
#import "AdsConfig.h"
#import "CommonHelper.h"


#define kLoadMobisageRecommendViewDelayTime 10//10s
#define kLoadMobisageRecommendViewInactiveDelayTime 2//10s

@interface MobiSageOfferwall()
{
    UIViewController* _viewController;
    MobiSageRecommendView* _recmdView;
    MobiSageRecommendDelegateImp* _delegate;
}
@property(nonatomic,assign)MobiSageRecommendView* recmdView;
@property(nonatomic,assign)MobiSageRecommendDelegateImp* delegate;

@end

@implementation MobiSageOfferwall
@synthesize recmdView=_recmdView;
@synthesize delegate = _delegate;

#pragma instance life cycle
-(void)dealloc
{
    self.recmdView = nil;
    self.delegate = nil;
    [super dealloc];
}
#pragma mark init
+ (MobiSageOfferwall *)sharedInstance
{
    static MobiSageOfferwall *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [[MobiSageOfferwall alloc] init];
    }
    return sharedInstance;
}

#pragma iOfferwallDelegate
-(void)setViewController:(UIViewController*)controller
{
    _viewController = controller;
}

-(UIViewController*)viewController
{
    return _viewController;
}

-(void)open
{
    [self loadAdsageRecommendView:YES];
    
    [self performSelector:@selector(popupAdsageRecommendView:) withObject:self afterDelay:kLoadMobisageRecommendViewDelayTime];
}
#pragma util methods
-(void)loadAdsageRecommendView:(BOOL)visible
{
    [[MobiSageManager getInstance]setPublisherID:kMobiSageID_iPhone];
    if (self.recmdView == nil)
    {
        const NSUInteger size = 24;//mobisage recommend default view size
        if(!_delegate)
        {
            _delegate = [[MobiSageRecommendDelegateImp alloc]init];
            _delegate.viewControllerForPresentingModalView = _viewController;
        }
        _recmdView = [[MobiSageRecommendView alloc]initWithDelegate:_delegate andImg:nil];
        self.recmdView.frame = CGRectMake(kDeviceWidth-2*size, size/2, size, size);
        [_viewController.view addSubview:self.recmdView];
    }
    if(!visible)
    {
        [self.recmdView removeFromSuperview];
    }
}
-(void)popupAdsageRecommendView:(NSObject*)object
{
    //current view is active?
    UIViewController* ctrl = [CommonHelper getCurrentRootViewController];
    UIViewController* rootViewController = [[[UIApplication sharedApplication]delegate]window].rootViewController;
    if (![ctrl isKindOfClass:[rootViewController class]]) {
        [self performSelector:@selector(popupAdsageRecommendView:) withObject:self afterDelay:kLoadMobisageRecommendViewInactiveDelayTime];
        return;
    }
    [self.recmdView OpenAdSageRecmdModalView];
}
@end
