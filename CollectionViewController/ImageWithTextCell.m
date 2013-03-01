//
//  ImageWithTextCell.m
//  com.idreems.mrh
//
//  Created by ramonqlee on 2/3/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import "ImageWithTextCell.h"
#import "ResponseJson.h"
#import "ImageBrowser.h"
#import "CommonHelper.h"
#import <QuartzCore/QuartzCore.h>
#import <ShareSDK/ShareSDK.h>

#define FONT_SIZE 14.0f
#define kHorizontalMargin 3.0f
#define kShareButtonSize 25
#define kShareButtonZoneSize 40
#define kFooterViewHeight 15
#define CELL_CONTENT_MARGIN 10.0f
#define kCellTextMaxLength 50

@implementation ImageWithTextCell
@synthesize response;
@synthesize label;
@synthesize imageView;
@synthesize centerimageView;
@synthesize footerView;
@synthesize shareButton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setResponse:(ResponseJson *)status
{
    if(response)
    {
        [response release];
    }
    response = [status retain];
    BOOL viewWithImage = ((nil!=status.thumbnailUrl)&&(0!=status.thumbnailUrl.length));
    BOOL nullText = ((nil==status.description)|(0==status.description.length));
    UIView* cell = self;
    UIImage* placeholderImage = [UIImage imageNamed:kPlaceholderImage];
    CGRect placeholderImageRect = CGRectMake(0, 0, placeholderImage.size.width, placeholderImage.size.height);
    
    CGRect backgroundRect = CGRectZero;
    if(!centerimageView)
    {    
        UIImage *centerimage = [UIImage imageNamed:@"block_center_background.png"];
        centerimageView = [[UIImageView alloc]initWithImage:centerimage];
        [centerimageView setFrame:backgroundRect];
        [self addSubview:centerimageView];
    }
    if(nil==label)
    {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:UILineBreakModeWordWrap];
        [label setMinimumFontSize:FONT_SIZE];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [label setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:label];
    }       
    
    if(nil==imageView)
    {
        imageView = [[[UIImageView alloc]initWithFrame:placeholderImageRect]autorelease];
        imageView.userInteractionEnabled = YES;
        if([imageView respondsToSelector:@selector(setImageWithURL:placeholderImage:)])
        {
            [imageView performSelector:@selector(setImageWithURL:placeholderImage:) withObject:[NSURL URLWithString:status.thumbnailUrl] withObject:placeholderImage];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.bounds = placeholderImageRect;
        [imageView setClipsToBounds:YES];
        
        //tap
        UITapGestureRecognizer* tap = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImageBtnClicked:)]autorelease];
        [imageView addGestureRecognizer:tap];
        
        [cell addSubview:imageView];
    }    
    
    CGRect footerViewRect = CGRectZero;
    if(!footerView)
    {
    UIImage *footimage = [UIImage imageNamed:@"block_foot_background.png"];
    footerView = [[UIImageView alloc]initWithImage:footimage];
    [footerView setFrame:footerViewRect];
    [self addSubview:footerView];
    }
    
    CGRect shareButtonRect = CGRectZero;
    if(!self.shareButton)
    {
//        shareButton = [[UIButton buttonWithType:UIButtonTypeContactAdd]retain];
        shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
        [shareButton setBackgroundImage:[UIImage imageNamed:@"micro_messenger"]forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:shareButton];
    }
   
    CGFloat CELL_CONTENT_WIDTH = self.frame.size.width;
    NSString *text = [ImageWithTextCell trimText:status.description trimToLength:kCellTextMaxLength];
    CGSize size = CGSizeZero;
    CGFloat width = CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN * 2;
    if(!nullText)
    {
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    }
    CGFloat textHeight = nullText?0:size.height;
    
    if(!nullText)
    {
        label.hidden = NO;
        CGRect rc = CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, width, textHeight);
        [label setFrame:rc];
        [label setText:text];        
        backgroundRect.size.height = rc.size.height;
        footerViewRect = rc;
    }
    else
    {
        [label setFrame:CGRectZero];
        label.hidden = YES;
    }
    
    if(viewWithImage && [imageView respondsToSelector:@selector(setImageWithURL:placeholderImage:)])
    {
        imageView.hidden = NO;
        placeholderImageRect.origin.x += (CELL_CONTENT_WIDTH-placeholderImage.size.width)/2;
        //without text
        if(!nullText)
        {
            [imageView performSelector:@selector(setImageWithURL:placeholderImage:) withObject:[NSURL URLWithString:status.thumbnailUrl] withObject:placeholderImage];
//            [imageView setImageWithURL:[NSURL URLWithString:status.thumbnailUrl] placeholderImage:placeholderImage];
            
            placeholderImageRect.origin.y += (CELL_CONTENT_MARGIN+textHeight+CELL_CONTENT_MARGIN);
        }
        else
        {
            placeholderImageRect.origin.y += CELL_CONTENT_MARGIN;
        }
        [imageView setFrame:placeholderImageRect];
        footerViewRect = placeholderImageRect;
        backgroundRect.size.height = placeholderImageRect.size.height;
    }else{
        [imageView setFrame:CGRectZero];
        imageView.hidden = YES;
    }

    
    footerViewRect.origin.x = 0;
    footerViewRect.origin.y = footerViewRect.size.height+footerViewRect.origin.y+kShareButtonZoneSize;
    footerViewRect.size.height = kFooterViewHeight;
    footerViewRect.size.width = kDeviceWidth - 2*kHorizontalMargin;
    [footerView setFrame:footerViewRect];
    
    shareButtonRect=footerViewRect;
    shareButtonRect.size.width = kShareButtonSize;
    shareButtonRect.size.height = kShareButtonSize;
    shareButtonRect.origin.y -= shareButtonRect.size.height;
    shareButtonRect.origin.x = kDeviceWidth-shareButtonRect.size.width-2*CELL_CONTENT_MARGIN;
    shareButton.frame = shareButtonRect;
    
    backgroundRect.size.width = footerViewRect.size.width;
    backgroundRect.size.height = footerViewRect.origin.y;
    [centerimageView setFrame:backgroundRect];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)dealloc
{
    self.response = nil;
    self.imageView = nil;
    self.label = nil;
    self.centerimageView = nil;
    self.footerView = nil;
    self.shareButton = nil;
    [super dealloc];
}
#pragma mark util
-(void)share:(id)sender
{
#define kWeiboTxtMaxLength 140
    UIImage* image = [UIImage imageNamed:@"icon-57"];
    NSString* title = NSLocalizedString(@"Title", @"");
    NSString* description = response.description;
    NSString* url = [CommonHelper appStoreUrl];
    NSString* content = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>\r\n\n\n%@",url,title,description];
    
    //txt
    id<ISSPublishContent> publishContent = [ShareSDK publishContent:(description&&description.length>kWeiboTxtMaxLength)?[description substringToIndex:kWeiboTxtMaxLength]:description
                                                     defaultContent:@""
                                                              image:image
                                                       imageQuality:0.8
                                                          mediaType:SSPublishContentMediaTypeNews
                                                              title:title
                                                                url:url
                                                       musicFileUrl:nil
                                                            extInfo:nil
                                                           fileData:nil];
    //定制微信好友内容
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:content
                                           title:title
                                             url:url
                                           image:image                                    imageQuality:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil];
    
    //定制微信朋友圈内容
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
                                          content:@"Hello 微信朋友圈!"
                                            title:title
                                              url:url
                                            image:image
                                     imageQuality:INHERIT_VALUE
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil];
    
    //定制QQ分享内容
    [publishContent addQQUnitWithType:INHERIT_VALUE
                              content:content
                                title:title
                                  url:url
                                image:image
                         imageQuality:INHERIT_VALUE];
    
    //定制邮件分享内容
    [publishContent addMailUnitWithSubject:title
                                   content:content
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:nil];
    
    //定制短信分享内容
    [publishContent addSMSUnitWithContent:content];
    
    //定制有道云笔记分享内容
    [publishContent addYouDaoNoteUnitWithContent:INHERIT_VALUE
                                           title:title
                                          author:title
                                          source:content
                                     attachments:nil];
    
    [ShareSDK showShareActionSheet:[self viewController]
                     iPadContainer:[ShareSDK iPadShareContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp]
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                        convertUrl:YES      //委托转换链接标识，YES：对分享链接进行转换，NO：对分享链接不进行转换，为此值时不进行回流统计。
                       authOptions:nil
                  shareViewOptions:[ShareSDK defaultShareViewOptionsWithTitle:@"内容分享"
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:NO
                                                        wxSessionButtonHidden:NO
                                                       wxTimelineButtonHidden:NO
                                                         showKeyboardOnAppear:YES]
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];

}
-(void) ImageBtnClicked:(id)sender
{
    UIApplication *app = [UIApplication sharedApplication];
    ImageBrowser* browserView = [[[ImageBrowser alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)] autorelease];
    [browserView setUp];
    
    browserView.image = imageView.image;
    browserView.bigImageURL = response.largeUrl;
    [browserView loadImage];
    
    app.statusBarHidden = YES;
    [[app keyWindow]addSubview:browserView];
}

+(NSString*)trimText:(const NSString*const)txt trimToLength:(NSUInteger)len
{
    NSString* text = [txt copy];
    if (text && text.length>len) {
        text = [text substringToIndex:len];
    }
    return text;
}
+(CGSize)measureCell:(ResponseJson*)status width:(CGFloat)width
{
    BOOL nullText = ((nil==status.description)|(0==status.description.length));
    NSString *text = [ImageWithTextCell trimText:status.description trimToLength:kCellTextMaxLength];
    
    CGFloat CELL_CONTENT_WIDTH = width;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = nullText?0:size.height;
    
    BOOL viewWithImage = ((nil!=status.thumbnailUrl)&&(0!=status.thumbnailUrl.length));
    if(viewWithImage)
    {
        UIImage* placeholderImage = [UIImage imageNamed:kPlaceholderImage];
        //WITH TEXT
        if(!nullText)
        {
            constraint.height = CELL_CONTENT_MARGIN+height+CELL_CONTENT_MARGIN+placeholderImage.size.height+CELL_CONTENT_MARGIN;
        }
        else//WITHOUT TEXT
        {
            constraint.height = 2*CELL_CONTENT_MARGIN+placeholderImage.size.height;
        }
        
    }
    else
    {
        //ONLY WITH TEXT
        constraint.height = 2*CELL_CONTENT_MARGIN+height;
    }
    //footerview(shareButton in it)
    constraint.height += kShareButtonZoneSize;
    return constraint;
}
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
