//
//  MainViewController.h
//  NetDemo
//
//  Created by 海锋 周  on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@interface PullRefreshBaseController : UIViewController
{
    ContentViewController *m_contentViewController;  //内容页面    
}
@property (nonatomic,retain) ContentViewController *m_contentViewController;

@end
