//
//  AdSageAdapterAdMob.h
//  AdSageSDK
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
// admob v6.1.5
#import "AdSageAdapter.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitialDelegate.h"

@interface AdSageAdapterAdMob : AdSageAdapter <GADBannerViewDelegate,GADInterstitialDelegate>
{
    NSTimer *timer;
}
- (NSString *)hexStringFromUIColor:(UIColor *)color;

@end
