//
//  AdSageAdapterMobiSage.h
//  AdSageSDK
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//mobisage v2.3.0
#import "AdSageAdapter.h"
#import "MobiSageSDK.h"

@interface AdSageAdapterMobiSage : AdSageAdapter
{
	NSTimer *timer;
    AdSageAdviewType adViewType;
    UIButton *fullScreenButton;
}
@property (nonatomic ,retain) UIButton *fullScreenButton;
@end
