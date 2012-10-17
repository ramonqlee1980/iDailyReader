//
//  FlipDetailViewController.h
//  FlipViewTest
//
//  Created by Mac Pro on 6/6/12.
//  Copyright (c) Dawn(use for learn,base on CAShowcase demo). All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlipDetailViewController;
@protocol FlipDetailViewControllerDelegate <NSObject>
//这里是关闭的代理，貌似也可以用通知来实现代理方法
-(void)FlipDetailViewControllerClose:(FlipDetailViewController *)flipViewController;
-(void)refreshFlipViewForDelete;

@end
#define kRefreshFlipViewAfterDelete @"kRefreshFlipViewAfterDelete"

@interface FlipDetailViewController : UIViewController<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    UITextView *textView;
    UILabel *dateLabel;
    
}
@property (nonatomic,assign) id<FlipDetailViewControllerDelegate>delegate;
@property (nonatomic) NSInteger indexNumber;
@end
