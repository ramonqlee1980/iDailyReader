//
//  UIView+Screenshot.m
//  FlipViewTest
//
//  Created by Mac Pro on 6/6/12.
//  Copyright (c) 2012 Dawn(use for learn,base on CAShowcase demo). All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView(screenshot)
//获取nav的截屏以供动画使用
- (UIImage *)screenshot
{
	UIGraphicsBeginImageContext(self.bounds.size);
    //注释之后无变化
	[[UIColor clearColor] setFill];
	[[UIBezierPath bezierPathWithRect:self.bounds] fill];
    //end
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[self.layer renderInContext:ctx];
	UIImage *anImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();	
	return anImage;
}


@end