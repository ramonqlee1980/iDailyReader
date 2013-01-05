//
//  PhotoViewer.h
//  NetDemo
//
//  Created by 海锋 周 on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewer : UIViewController<UIGestureRecognizerDelegate>
{
    NSString *imgPlaceholderUrl;
    NSString *imgUrl;
    UIImageView *imageView;
    CGFloat roation;
    CGFloat scale;
}

@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) NSString *imgPlaceholderUrl;
@property (nonatomic,retain) NSString *imgUrl;
-(void) fadeOut;
-(void) fadeIn;

@end
