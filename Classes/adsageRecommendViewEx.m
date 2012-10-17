//
//  HypnosisView.m
//  Hypnosister
//
//  Created by skylin zhu on 11-7-27.
//  Copyright 2011年 mysoft. All rights reserved.
//

#import "adsageRecommendViewEx.h"

NSString* mTitle;
NSString* mSubtitle;  
BOOL mBanner;

#define kRecommendViewHeight 50
@interface AdSageRecommendView() 

-(void)loadBannerView;
@end

@implementation  AdSageRecommendView(HypnosisView)
-(void)setTitle:(NSString*)title
{
    mTitle = [[NSString alloc]initWithString:title];    
}
-(void)setSubtitle:(NSString*)subtitle
{
    mSubtitle = [[NSString alloc]initWithString:subtitle];
}
-(void)setBanner:(BOOL)banner
{
    mBanner = banner;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadBannerView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self loadBannerView];
    }
    return self;
}
-(id)init
{
    if (self = [super init]) {
        [self loadBannerView];
    }
    return self;
}
-(void)dealloc
{
    [super dealloc];
    [mTitle release];
    [mSubtitle release];
}
-(void)loadBannerView
{
    const NSUInteger kTitleLabelTag = 0x10000;
    //already loaded?
    for (UIView* child in  [self subviews]) {
        if(child && child.tag == kTitleLabelTag)
        {
            return;
        }
    }
    [self setBackgroundColor:[UIColor orangeColor]];
    
    const float kTitleHeight = 20;
    NSString* title = (mTitle!=nil&&mTitle.length>0)?mTitle:@"免费应用推荐";
    const float kSubtitleHeight = 18;
    NSString* subtitle = (mSubtitle!=nil&&mSubtitle.length>0)?mSubtitle:@"一网打尽国内的免费应用";
    
    CGRect bounds = [[UIScreen mainScreen]bounds];
    CGRect rc = self.frame;
    rc.origin.x = 0;
    rc.size = bounds.size;
    rc.size.height = self.frame.size.height;//kRecommendViewHeight;
    self.frame = rc;
    CGRect titleRc = bounds;
    titleRc.size.height = kTitleHeight;
    
    titleRc.origin.x = 50;
    UILabel* label = [[UILabel alloc]initWithFrame:titleRc];
    [label setBackgroundColor:[UIColor clearColor]];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor blueColor];
    label.text = title;
    label.tag = kTitleLabelTag;
    [self addSubview:label];
    [label release];
    
    titleRc.origin.y += kTitleHeight;
    titleRc.size.height = kSubtitleHeight;
    label = [[UILabel alloc]initWithFrame:titleRc];
    [label setBackgroundColor:[UIColor clearColor]];
    label.text = subtitle;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.lineBreakMode = UILineBreakModeTailTruncation;
    label.numberOfLines = 2;
    [self addSubview:label];
    
    [label release];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if(mBanner)
        [self loadBannerView];
}

@end
