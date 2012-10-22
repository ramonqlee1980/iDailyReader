//
//  YouMiViewController.h
//  YouMiSDK_iPhone_Sample
//
//  Created by Layne on 10-11-29.
//  Copyright 2010 www.youmi.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YouMiView.h"
#import "YouMiDelegateProtocol.h"


@interface YouMiViewController_320x50 : UIViewController<YouMiDelegate> {
	YouMiView *adView;
}

@property (nonatomic, retain)YouMiView *adView;

@end
