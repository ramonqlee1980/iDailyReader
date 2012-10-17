//
//  AdSageAdapterDoMob.h
//  AdSageSDK
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//Domob v3.0.3

#import "AdSageAdapter.h"
#import "DMAdView.h"
@interface AdSageAdapterDoMob : AdSageAdapter <DMAdViewDelegate>
{
    NSTimer *timer;
}
@end
