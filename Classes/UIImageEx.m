//
//  UIImageEx.m
//  AdvancedTableViewCells
//
//  Created by ramonqlee on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImageEx.h"


@implementation UIImage (UIImageEx)
/*
 
 * 缩放图片限制横宽区域内
 
 */

- (UIImage*)scaleWithSize:(CGSize)size
{
    UIImage* scaleImaged = self;    
    BOOL needRedraw = YES;    
    NSLog(@"w = %f, h = %f", size.width, size.height);
    if (needRedraw) {
        
        UIGraphicsBeginImageContext(size);
        
        [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
        
        scaleImaged = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }  
    return scaleImaged;
    
}

@end
