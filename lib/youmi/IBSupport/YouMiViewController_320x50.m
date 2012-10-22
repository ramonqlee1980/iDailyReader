//
//  YouMiViewController.m
//  YouMiSDK_iPhone_Sample
//
//  Created by Layne on 10-11-29.
//  Copyright 2010 www.youmi.net. All rights reserved.
//

#import "YouMiViewController_320x50.h"
#import "Constants.h"


@implementation YouMiViewController_320x50
@synthesize adView;

- (void)awakeFromNib {
	adView = [[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:nil];
    
    ////////////////[必填]///////////////////
    // 设置APP ID 和 APP Secret
#warning 修改为你自己的AppID和AppSecret
    adView.appID = kGlobalYouMiAdAppID;  // 该地方请填写您直接的APP ID
    adView.appSecret = kGlobalYouMiAdAppSecret; // 该地方请填写您直接的APP Secret
    
    ////////////////[可选]///////////////////
    // 设置您应用的版本信息
    adView.appVersion = @"1.0";
    
    // 设置您应用的推开渠道号
    // adView.channelID = 1;
    
    // 设置您应用的广告请求模式
    // adView.testing = NO;
    
    // 可以设置委托
    // adView.delegate = self;
    
    // 设置文字广告的属性
    // adView.indicateBorder = NO;
    // adView.indicateTranslucency = YES;
    // adView.indicateRounded = NO;
    
    // adView.indicateBackgroundColor = [UIColor purpleColor];
    // adView.textColor = [UIColor whiteColor];
    // adView.subTextColor = [UIColor yellowColor];
    
    // 添加对应的关键词
    // [adView addKeyword:@"女性"];
    // [adView addKeyword:@"19岁"];

    // 开始请求广告
	[adView start];
    
	[self.view addSubview:adView];

}

- (void)dealloc {
	[adView release];
    [super dealloc];
}

@end
