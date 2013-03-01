//
//  ContentCell.m
//  NetDemo
//
//  Created by 海锋 周 on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentCell.h"
#import "AdsConfig.h"
#import "AddNewNoteViewController.h"
#import "Flurry.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "ImageBrowser.h"
#define FGOOD       101
#define FBAD        102
#define FCOMMITE    103


#define  kThumbImage @"thumb_pic.png"
@interface ContentCell()
-(void) BtnClicked:(id)sender;
-(void) ImageBtnClicked:(id)sender;
@end;

@implementation ContentCell
@synthesize txtContent,txtAnchor,headPhoto,footView,centerimageView,TagPhoto;
@synthesize commentsbtn,badbtn,goodbtn,imgUrl,txtTag;
@synthesize imgPhoto,imgMidUrl;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        UIImage *centerimage = [UIImage imageNamed:@"block_center_background.png"];
        centerimageView = [[UIImageView alloc]initWithImage:centerimage];
        
        NSInteger deviceWidth = [[UIScreen mainScreen]applicationFrame].size.width;
        //        [centerimageView setFrame:CGRectMake(0, 0, 320, 220)];
        [centerimageView setFrame:CGRectMake(0, 0, deviceWidth, 220)];
        [self addSubview:centerimageView];
        
        
        txtContent = [[UILabel alloc]init];
        [txtContent setBackgroundColor:[UIColor clearColor]];
        [txtContent setFrame:CGRectMake(20, 28, deviceWidth-40, 220)];
        [txtContent setFont:[UIFont fontWithName:@"Arial" size:14]];
        [txtContent setLineBreakMode:UILineBreakModeTailTruncation];
        [self addSubview:txtContent];

        imgPhoto = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kThumbImage]];
        imgPhoto.contentMode = UIViewContentModeScaleAspectFit;
        //[imgPhoto setFrame:CGRectMake(0, 0, 0, 0)];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(ImageBtnClicked:)];
        [tapRecognizer setNumberOfTouchesRequired:1];
        [tapRecognizer setDelegate:self];
        //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
        imgPhoto.userInteractionEnabled = YES;
        [imgPhoto addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
        
        [self addSubview:imgPhoto];
        
        headPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 24, 24)];
        [headPhoto setImage:[UIImage imageNamed:@"thumb_avatar.png"]];
        [self addSubview:headPhoto];
        
        txtAnchor = [[UILabel alloc]initWithFrame:CGRectMake(45,5, deviceWidth-120/*200*/, 30)];
        [txtAnchor setText:@"匿名"];
        [txtAnchor setFont:[UIFont fontWithName:@"Arial" size:14]];
        [txtAnchor setBackgroundColor:[UIColor clearColor]];
        [txtAnchor setTextColor:[UIColor brownColor]];
        [self addSubview:txtAnchor];
        
        txtTag = [[UILabel alloc]initWithFrame:CGRectMake(45,200, deviceWidth-120/*200*/, 30)];
        [txtTag setText:@""];
        [txtTag setFont:[UIFont fontWithName:@"Arial" size:14]];
        [txtTag setBackgroundColor:[UIColor clearColor]];
        [txtTag setTextColor:[UIColor brownColor]];
        [self addSubview:txtTag];
        
        TagPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(15, 200, 24, 24)];
        [TagPhoto setImage:[UIImage imageNamed:@"icon_tag.png"]];
        [self addSubview:TagPhoto];
        TagPhoto.hidden = YES;
        
        
        UIImage *footimage = [UIImage imageNamed:@"block_foot_background.png"];
        footView = [[UIImageView alloc]initWithImage:footimage];
        [footView setFrame:CGRectMake(0, txtContent.frame.size.height, deviceWidth, 15)];
        [self addSubview:footView];
        
        //添加Button，顶，踩，评论
        CGFloat fontSize = 10;
        goodbtn = [[UIButton buttonWithType:UIButtonTypeCustom]retain];
        [goodbtn setFrame:CGRectMake(10,txtContent.frame.size.height-30,70,32)];
        [goodbtn setBackgroundImage:[UIImage imageNamed:@"button_vote.png"] forState:UIControlStateNormal];
        [goodbtn setBackgroundImage:[UIImage imageNamed:@"button_vote_active.png"] forState:UIControlStateHighlighted];
        [goodbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
        [goodbtn setImage:[UIImage imageNamed:@"icon_for_good.png"] forState:UIControlStateNormal];
        [goodbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
        [goodbtn setTitle:@"0" forState:UIControlStateNormal];
        [goodbtn.titleLabel setFont:[UIFont fontWithName:@"Arial" size:fontSize]];
        [goodbtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        goodbtn.tag = FGOOD;
        [goodbtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:goodbtn];
        //goodbtn.hidden = YES;
        
        
        badbtn = [[UIButton buttonWithType:UIButtonTypeCustom]retain];
        [badbtn setFrame:CGRectMake(100,txtContent.frame.size.height-30,100,32)];
        [badbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
        [badbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
        [badbtn setBackgroundImage:[UIImage imageNamed:@"button_vote.png"] forState:UIControlStateNormal];
        [badbtn setBackgroundImage:[UIImage imageNamed:@"button_vote_active.png"] forState:UIControlStateHighlighted];
        [badbtn setImage:[UIImage imageNamed:@"micro_messenger.png"] forState:UIControlStateNormal];
        [badbtn setTitle:@"0" forState:UIControlStateNormal];
        [badbtn.titleLabel setFont:[UIFont fontWithName:@"Arial" size:fontSize]];
        [badbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        badbtn.tag = FBAD;
        [badbtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:badbtn];
        //badbtn.hidden = YES;
        
        commentsbtn = [[UIButton buttonWithType:UIButtonTypeCustom]retain];
        [commentsbtn setFrame:CGRectMake(200,txtContent.frame.size.height-30,70,32)];
        [commentsbtn setBackgroundImage:[UIImage imageNamed:@"button_vote.png"] forState:UIControlStateNormal];
        [commentsbtn setBackgroundImage:[UIImage imageNamed:@"button_vote_active.png"] forState:UIControlStateHighlighted];
        [commentsbtn setImage:[UIImage imageNamed:@"micro_messenger.png"] forState:UIControlStateNormal];
        [commentsbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
        [commentsbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
        [commentsbtn.titleLabel setFont:[UIFont fontWithName:@"Arial" size:fontSize]];
        [commentsbtn setTitle:@"0" forState:UIControlStateNormal];
        [commentsbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [commentsbtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [commentsbtn setTag:FCOMMITE];
        [self addSubview:commentsbtn];
        commentsbtn.hidden = YES;
        
    }
    return self;
}


-(void) resizeTheHeight
{
    CGFloat contentWidth = kDeviceWidth-40;//280;
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    
    CGSize size = [txtContent.text sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:UILineBreakModeTailTruncation];
    
    [txtContent setFrame:CGRectMake(20, 28, kDeviceWidth-40, size.height+60)];
    
    if (imgUrl!=nil&&![imgUrl isEqualToString:@""]) {
        [imgPhoto setFrame:CGRectMake(30, size.height+70, 72, 72)];
        [centerimageView setFrame:CGRectMake(0, 0, kDeviceWidth, size.height+200)];
        [imgPhoto setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:kThumbImage]];
    }
    else
    {
        [imgPhoto cancelCurrentImageLoad];
        [imgPhoto setFrame:CGRectMake(120, size.height, 0, 0)];
        [centerimageView setFrame:CGRectMake(0, 0, kDeviceWidth, size.height+120)];
    }
    
    [footView setFrame:CGRectMake(0, centerimageView.frame.size.height, kDeviceWidth, 15)];
    [goodbtn setFrame:CGRectMake(10,centerimageView.frame.size.height-28,70,32)];
    [badbtn setFrame:CGRectMake(90,centerimageView.frame.size.height-28,105,32)];
    [commentsbtn setFrame:CGRectMake(200,centerimageView.frame.size.height-28,115,32)];
    [txtTag setFrame:CGRectMake(40,centerimageView.frame.size.height-50,200, 30)];
    [TagPhoto setFrame:CGRectMake(15,centerimageView.frame.size.height-50,24, 24)];
    
}

-(void) ImageBtnClicked:(id)sender
{
    /*
    PhotoViewer *photoview = [[PhotoViewer alloc]initWithNibName:@"PhotoViewer" bundle:nil];
    photoview.imgUrl = self.imgMidUrl;
    photoview.imgPlaceholderUrl = self.imgUrl;
    [photoview.view setFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    
    [[[UIApplication sharedApplication]keyWindow] addSubview:photoview.view];    
    [photoview fadeIn];
     */
    UIApplication *app = [UIApplication sharedApplication];
    ImageBrowser* browserView = [[[ImageBrowser alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)] autorelease];
    [browserView setUp];
    
    browserView.image = imgPhoto.image;
    browserView.bigImageURL = self.imgMidUrl;
    [browserView loadImage];
    
    app.statusBarHidden = YES;
    [[app keyWindow]addSubview:browserView];
}

-(void) BtnClicked:(id)sender
{
    UIButton *btn =(UIButton *) sender;
    NSString* title = txtAnchor.text;
    NSString* content = txtContent.text;
    NSString* kWixinTitle = @"糗事一箩筐";
    switch (btn.tag) {
        case FGOOD:    //顶
        {
            NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:content,@"text",title,@"date", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:kAdd2Favorite object:nil userInfo:dict];
            
        }
            break;
        case FBAD:     //share to wixin chat
        {
            AppDelegate* delegate = SharedDelegate;
            NSString* description = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>\r\n\n\n%@",delegate.mTrackViewUrl,delegate.mTrackName,content];
//            [delegate shareByShareKit:kWixinTitle description:description image:[UIImage imageWithData: [[SDWebImageManager sharedManager]imageWithURL:[NSURL URLWithString:imgUrl]]]];
            [delegate sendAppContent:kWixinTitle description:content image:imgUrl scene:WXSceneSession];
        }
            break;
        case FCOMMITE: //评论
        {
            AppDelegate* delegate = SharedDelegate;
            [delegate sendAppContent:kWixinTitle description:content image:imgUrl scene:WXSceneTimeline];
        }
            break;
        default:
            break;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) dealloc
{
    [txtContent release];
    [txtAnchor release];
    [centerimageView release];
    [imgPhoto release];
    [TagPhoto release];
    [footView release];
    [goodbtn release];
    [badbtn release];
    [commentsbtn release];
    [txtTag release];
    [super dealloc];
}


@end
