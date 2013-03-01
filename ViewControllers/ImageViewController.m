//  ImageViewController.m
//
//  Copyright (c) 2012 modocache
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "ImageViewController.h"
#import "MDCParallaxView.h"
#import "SDWebImageManager.h"

#define kPlaceholderImage @"placeholder.png"
#define kTextFontSize 18.0f

@interface ImageViewController () <UIScrollViewDelegate>
{
    NSUInteger imageWidth;
    NSUInteger imageHeight;
}
@end


@implementation ImageViewController
@synthesize text,imageUrl,placeholderImageUrl;

#pragma mark - UIViewController Overrides
-(NSString*)removeHtmlTags:(NSString*)txt
{
    if(txt)
    {
        NSString* pattern = @"&[a-zA-Z]*;";
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSMutableString *ret = [[NSMutableString alloc]initWithString:txt];
        [regex replaceMatchesInString:ret options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, txt.length) withTemplate:@""];
        return ret;
    }
    return txt;
}
-(void)initWithData:(NSString*)txt imageUrl:(NSString*)url placeHolderImageUrl:(NSString*)ph imageWidth:(NSUInteger)width imageHeight:(NSUInteger)height
{
    self.text = [self removeHtmlTags:txt];
    self.imageUrl = url;
    self.placeholderImageUrl = ph;
    imageHeight = height;
    imageWidth = width;
}

-(void)viewWillDisappear:(BOOL)animated
{
    //self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = nil;
    if(self.imageUrl && self.imageUrl.length>0)
    {
        //self.tabBarController.tabBar.hidden = YES;
        NSData* imageData = [[SDWebImageManager sharedManager]imageWithURL:[NSURL URLWithString:self.placeholderImageUrl]];
        
        UIImage* placeHolderImage = [UIImage imageWithData:imageData];
        
        UIImage *backgroundImage = placeHolderImage?placeHolderImage:[UIImage imageNamed:kPlaceholderImage];
        
        //adjust width
        CGFloat scale = (CGFloat)kDeviceWidth/imageWidth;
        CGRect backgroundRect = CGRectMake(0, 0,imageWidth*scale, imageHeight*scale);
        //height still exceed
        if(backgroundRect.size.height>KDeviceHeight/2)
        {
            scale = (CGFloat)KDeviceHeight/(backgroundRect.size.height*2);
            backgroundRect.size.height *= scale;
            backgroundRect.size.width  *= scale;
        }
        
        backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundRect];
        //    backgroundImageView.image = backgroundImage;
        if([backgroundImageView respondsToSelector:@selector(setImageWithURL:placeholderImage:)])
        {
            [backgroundImageView performSelector:@selector(setImageWithURL:placeholderImage:) withObject:[NSURL URLWithString:self.imageUrl] withObject:backgroundImage];            
        }
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    CGRect textRect = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
    UITextView *textView = [[UITextView alloc] initWithFrame:textRect];
    textView.text = self.text;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.font = [UIFont systemFontOfSize:kTextFontSize];
    textView.textColor = [UIColor darkTextColor];
    textView.editable = NO;
    
    MDCParallaxView *parallaxView = [[MDCParallaxView alloc] initWithBackgroundView:backgroundImageView
                                                                     foregroundView:textView];
    parallaxView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    parallaxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    parallaxView.backgroundHeight = backgroundImageView?250.0f:0.0f;
    parallaxView.scrollViewDelegate = self;
    [self.view addSubview:parallaxView];
}


#pragma mark - UIScrollViewDelegate Protocol Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

@end
