//
//  FlipScrollView.m
//  FlipViewTest
//
//  Created by Mac Pro on 6/6/12.
//  Copyright (c) 2012 Dawn(use for learn,base on CAShowcase demo). All rights reserved.
//

#import "FlipScrollView.h"
#import "InScrollViewLayer.h"
#import "UIView+Screenshot.h"
#import "AdsConfig.h"
#import "AdsConfiguration.h"

@implementation FlipScrollView
@synthesize delegateForFlip;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        selectIndex = NSNotFound;

        layersArray = [[NSMutableArray alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectALayerToShow:)];
        [self addGestureRecognizer:tap];
        [tap release];
        [self loadDataForView];
    }
    return self;
}
-(void)selectALayerToShow:(UITapGestureRecognizer *)recognizer{
    //判断点击的点是否在某一个layer里面
//    if (selectIndex != NSNotFound) {
//		return;
//	}
    CGPoint location = [recognizer locationInView:self];
    NSInteger index = 0;
    for (CALayer *layer in layersArray) {
        if (CGRectContainsPoint(layer.frame, location)) {
            //如果在，则执行动画效果显示FlipDetailViewController，由于FlipDetailViewController在FlipViewController中定义，则利用代理传递参数
            selectIndex = index;
            for (CATextLayer *textLayer in layer.sublayers) {
                if ([textLayer isKindOfClass:[CATextLayer class]]) {
                    textLayer.hidden = YES;
                }
            }
            [delegateForFlip flipScrollView:self didSelectAtIndex:index withLayer:layer];
            break;
        }
        index++;
    }
}
-(void)loadDataForView{ 
    selectIndex = NSNotFound;
    [self loadViewData];
}
-(void)loadViewData{
    for (CALayer *aLayer in layersArray) {
		if (aLayer.superlayer) {
			[aLayer removeFromSuperlayer];
		}
	}
	[layersArray removeAllObjects];
    
    NSMutableArray *dataMutableArray = [[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:kAppIdOnAppstore];
    NSInteger numberOfItems = dataMutableArray.count;//这里可以设置layer的数量，数量的大小可以通过代理从controller的layerarray里面获得
    NSLog(@"Note count:%d",numberOfItems);
    for (int i = 0; i < numberOfItems; i++) {
        InScrollViewLayer *layer = [InScrollViewLayer layer];
        layer.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"notepad" ofType:@"png"]];//这里设置layer的图片，可以用代理获取controller里面的截图
        layer.bounds = CGRectMake(0, 0, 80, 80);//80，80是layer可以设置layer的大小bound，大小最好设置成全局静态变量，方便修改和使用，修改时注意跟layer每行的数量相配合
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = [[dataMutableArray objectAtIndex:i] objectForKey:@"text"];
        textLayer.fontSize = 15.f;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.frame = CGRectMake(10, 20, 60, 50);
        textLayer.foregroundColor = [[UIColor purpleColor] CGColor];
        textLayer.wrapped = YES;
        [layer addSublayer:textLayer];
        [layersArray addObject:layer];
    }
    [self setNeedsLayout];

}
//每次刷新页面的时候都将非选择layer加到scrollview中去
- (void)layoutSubviews
{
    NSInteger index = 0;
    float border = 60;
    NSUInteger rows = (NSUInteger)ceilf((float)[layersArray count] / (float)3);

    self.contentSize = CGSizeMake(self.bounds.size.width, rows * (80 + 20.0) + 80.0);
    [CATransaction begin];//显示事物
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    for (InScrollViewLayer *aLayer in layersArray) {
        if (index != selectIndex) 
        {
            NSInteger indexInRow = index % 3;//layer在这一行中的列坐标
            NSInteger row = index / 3;//layer的行坐标
            //这里的3是每行layer的数量，可以设置成全局变量方便修改和使用
            aLayer.bounds = CGRectMake(0, 0, 80.0, 80.0);//
            aLayer.position = CGPointMake(border + (indexInRow) * ((self.bounds.size.width - border * 2) / (3 - 1)) , ((row + 0.5) * (80 + 20.0)) + 10.0);
            aLayer.backgroundColor = [UIColor clearColor].CGColor;
			if ([aLayer superlayer] != self.layer) {
				[self.layer addSublayer:aLayer];
			}
        }
        index++;
    }
    [CATransaction commit];
}
-(void)resetSelection{
    if (layersArray.count > selectIndex) {
        InScrollViewLayer *aLayer = [layersArray objectAtIndex:selectIndex];
        NSUInteger k = 3;
        for (CATextLayer *textLayer in aLayer.sublayers) {
            if ([textLayer isKindOfClass:[CATextLayer class]]) {
                textLayer.hidden = NO;
            }
        }

        NSUInteger indexInRow = selectIndex % k;//选中layer的纵坐标
        NSUInteger row = selectIndex / k;//选中layer的横坐标
        CGPoint position = CGPointMake(60 + (indexInRow) * ((self.bounds.size.width - 60 * 2) / (k - 1)) , ((row + 0.5) * (80 + 20.0)) + 10.0);
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:aLayer.position];
        positionAnimation.toValue = [NSValue valueWithCGPoint:[aLayer.superlayer convertPoint:position fromLayer:self.layer]];
        
        CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        boundsAnimation.fromValue = [NSValue valueWithCGRect:aLayer.bounds];
        boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 80, 80)];
        
        CATransition *t = [CATransition animation];
        t.type = @"flip";
        t.subtype = kCATransitionFromLeft;
        t.duration = 0.25;
        t.removedOnCompletion = YES;
        
        aLayer.contents = nil;
        //	aLayer.image = [dataSource imageForItemInGridControl:self atIndex:selectedIndex];
        aLayer.image = [UIImage imageNamed:@"notepad.png"];
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = 0.5;
        group.animations = [NSArray arrayWithObjects:positionAnimation, boundsAnimation, nil];
        group.delegate = self;
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        
        [aLayer addAnimation:group forKey:@"zoomOut"];		
        [aLayer addAnimation:t forKey:@"flip"];		

    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //关闭动画执行后
    if (layersArray.count > selectIndex) {
        InScrollViewLayer *aLayer = [layersArray objectAtIndex:selectIndex];
        [aLayer removeAllAnimations];
        [aLayer setNeedsDisplay];
        [self.layer addSublayer:aLayer];
        
        selectIndex = NSNotFound;
        [self setNeedsLayout];

    }
}
//-(void)setDelegateForFlip:(id<FlipScrollViewDelegate>)newDelegateForFlip{
//    delegateForFlip = newDelegateForFlip;
//    [self loadDataForView];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
