//
//  ImageBrowser.m
//  HHuan
//
//  Created by jtone on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageBrowser.h"
#import "GifView.h"
#import "SHKActivityIndicator.h"
#import "ZJTHelpler.h"

@implementation ImageBrowser
@synthesize image;
@synthesize imageView;
@synthesize aScrollView;
@synthesize bigImageURL;
@synthesize viewTitle;
@synthesize theDelegate;


- (void)dealloc
{
    self.imageView = nil;
    self.image = nil;
    self.aScrollView = nil;
    self.viewTitle = nil;
    
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        aScrollView = [[CustomScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        aScrollView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [imageView addGestureRecognizer:tap];
        [tap release];
        imageView.userInteractionEnabled = YES;
        
        [self           addSubview:aScrollView];
        [aScrollView    addSubview:imageView];
        
        UIButton *savebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [savebtn setFrame:CGRectMake(kDeviceWidth-80,KDeviceHeight-30,80,30)];
        [savebtn setImageEdgeInsets:UIEdgeInsetsMake(0,2,0,0)];
        [savebtn setTitleEdgeInsets:UIEdgeInsetsMake(2,-2,0,0)];
        [savebtn setImage:[UIImage imageNamed:@"imageviewer_save.png"] forState:UIControlStateNormal];
        [savebtn setTitle:@"保存" forState:UIControlStateNormal];
        [savebtn setBackgroundImage:[[UIImage imageNamed:@"imageviewer_toolbar_background.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [savebtn setTag:5];
        [savebtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        [aScrollView addSubview:savebtn];
        
    }
    return self;
}

-(void)dismiss
{
    NSLog(@"dismiss");
    for (UIView *view in self.subviews) 
    {
        if (view.tag == GIF_VIEW_TAG) {
            [view removeFromSuperview];
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self       name:@"tapClicked"              object:nil];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self removeFromSuperview];
}

-(void)saveImage
{
    if (!imageView.image) 
    {
        return;
    }
    UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
}


#pragma mark - View lifecycle
-(void)loadImage
{
    [[NSNotificationCenter defaultCenter] addObserver:self      selector:@selector(dismiss)         name:@"tapClicked"              object:nil];
    aScrollView.zoomScale = 1.0;
    [imageView setImage:image];
    if (bigImageURL!=nil) 
    {       
        if([imageView respondsToSelector:@selector(setImageWithURL:placeholderImage:)])
        {
            [imageView performSelector:@selector(setImageWithURL:placeholderImage:) withObject:[NSURL URLWithString:bigImageURL] withObject:image];
        }
        
    }
}

-(void)setUp
{
    aScrollView.minimumZoomScale = 1.0; //最小到1.0倍
    aScrollView.maximumZoomScale = 50.0; //最大到50倍
    aScrollView.delegate = self;
    aScrollView.backgroundColor = [UIColor blackColor];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
}

-(void)doubelClicked{
    if (aScrollView.zoomScale == 1.0) {
        [UIView beginAnimations:nil context:nil];		
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [aScrollView zoomToRect:CGRectMake(aScrollView.touchedPoint.x-50, aScrollView.touchedPoint.y-50, 100, 100) animated:YES];
        [UIView commitAnimations]; 
    }
    else{
        [UIView beginAnimations:nil context:nil];		
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationBeginsFromCurrentState:YES];
        aScrollView.zoomScale = 1.0;
        [UIView commitAnimations]; 
    }    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

-(void)getOriginImage:(NSNotification*)sender
{
    NSDictionary *dic = sender.object;
    if (theDelegate && [theDelegate respondsToSelector:@selector(browserDidGetOriginImage:)]) {
        [theDelegate browserDidGetOriginImage:dic];
    }
}


@end
