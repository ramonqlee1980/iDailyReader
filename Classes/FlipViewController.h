//
//  FlipViewController.h
//  FlipViewTest
//
//  Created by Mac Pro on 6/6/12.
//  Copyright (c) Dawn(use for learn,base on CAShowcase demo). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipScrollView.h"
#import "FlipDetailViewController.h"
#import "InScrollViewLayer.h"
#import "AddNewNoteViewController.h"
#import "BaseViewController.h"


@interface FlipViewController : BaseViewController<FlipScrollViewDelegate,FlipDetailViewControllerDelegate>
@property (nonatomic,strong) FlipScrollView *backScrollView;
@property (nonatomic,strong) FlipDetailViewController *flipDetailViewController;
@property (nonatomic,strong) InScrollViewLayer *inScrollViewLayer;
@property (nonatomic,strong) UINavigationController *subNav;
@end
