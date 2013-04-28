//
//  BaseViewController.h
//  SkinnedUI
//
//  Created by QFish on 12/2/12.
//  Copyright (c) 2012 http://QFish.Net All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoHideMenuView.h"

@interface BaseViewController : UIViewController<MenuDelegate>
{
    //AutoHideMenuView *youkuMenuView;
}
//@property (nonatomic, retain) AutoHideMenuView *youkuMenuView;
- (void)initViews;
- (void)configureViews;

@end
