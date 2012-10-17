//
//  FlipScrollView.h
//  FlipViewTest
//
//  Created by Mac Pro on 6/6/12.
//  Copyright (c) Dawn(use for learn,base on CAShowcase demo). All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlipScrollView;
//定义scrollview的代理
@protocol FlipScrollViewDelegate <NSObject>
@required
//-(UIImage *)imageForDetailShowed:(FlipScrollView *)flipScroll atIndex:(NSInteger)index;
-(void)flipScrollView:(FlipScrollView *)flipScroll didSelectAtIndex:(NSInteger)index withLayer:(CALayer *)layer;

@end
@interface FlipScrollView : UIScrollView
{
    NSMutableArray *layersArray;
    //layer的数组，用来存放在scrollview中的layer，这里layer是自定义的
    NSInteger selectIndex;
    //确定所选定的layer是第几号，然后在关闭动画中确定动画layer的最终位置
}
@property (nonatomic,assign) id<FlipScrollViewDelegate>delegateForFlip;
-(void)loadDataForView;
-(void)resetSelection;
-(void)loadViewData;

@end
