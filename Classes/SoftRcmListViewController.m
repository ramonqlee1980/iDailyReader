//
//  SoftRcmListViewController.m
//  Sample
//
//  Created by xiaolin liu on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SoftRcmListViewController.h"
#import "SoftRcmList.h"
#import "SoftInfo.h"
#import "Flurry.h"
#import "AdsConfig.h"
#import "AppDelegate.h"
#import "AdsViewManager.h"
#import "RMIndexedArray.h"
#import "AdsConfiguration.h"

#define kRecommendList @"kRecommendList"
#define TOOLBARTAG		200
#define TABLEVIEWTAG	300


#define BEGIN_FLAG @"[/"
#define END_FLAG @"]"

@interface SoftRcmListViewController ()
@property(nonatomic,assign)UIView* fullscreenView;
- (UIView *)bubbleView:(NSString *)text icon:(NSString*)icon from:(BOOL)fromSelf;
@end

@implementation SoftRcmListViewController
@synthesize fullscreenView;

#pragma mark AdSageRecommendDelegate
- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(kRecommendList, "");
        self.tabBarItem.image = [UIImage imageNamed:@"ICN_more_ON"];
        _softRcmList = [[SoftRcmList alloc] init];
        NSString *xmlPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SoftList.xml"];
        [_softRcmList loadData:xmlPath];
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self addFullscreenView];
}
-(void)addFullscreenView
{
    if(self.fullscreenView)
    {
        return;
    }
    AdsViewManager* adViewManager = [AdsViewManager sharedInstance];
    RMIndexedArray* list = (RMIndexedArray*)[adViewManager.configDict objectForKey:kFullScreenAd];
    if (list && [list count]) {
        
        list.taggedIndex = (list.taggedIndex>=0&&list.taggedIndex<[list count])?list.taggedIndex:0;
        NSLog(@"list.taggedIndex:%d",list.taggedIndex);
        //get index
        NSDictionary* item = [list objectAtIndex:list.taggedIndex++];
        
        fullscreenView = [adViewManager getFullscreenView:item inViewController:self];
        if (fullscreenView) {
            [self.view addSubview:fullscreenView];

            CGRect rc = self.tableView.frame;
            rc.origin.y += fullscreenView.frame.size.height;
            self.tableView.frame=rc;
        }
    }
}
-(void)willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if([fullscreenView respondsToSelector:@selector(rotateToOrientation:)])
    {
        [fullscreenView performSelector:@selector(rotateToOrientation:) withObject:toInterfaceOrientation];
    }
}
-(void) dealloc
{
    [_softRcmList release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_softRcmList)
    {
        NSInteger count = [_softRcmList.softList count];
        return  count;
    }
    return 0;
}

#define CELL_TAG 0x10
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIView* bubbleView = nil;
    NSInteger row = [indexPath row];
    SoftInfo* info = [_softRcmList.softList objectAtIndex:row];
    // Configure the cell...
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        
    }
    else {
        bubbleView = [cell.contentView viewWithTag:CELL_TAG];
        [bubbleView removeFromSuperview];        
    }
    
    bubbleView = [self bubbleView:[NSString stringWithFormat:@"%@:%@",info.name,info.detail] icon:info.icon from:(row%2==0)];
    bubbleView.tag = CELL_TAG;    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //remove cell's background
    [cell setBackgroundColor:[UIColor clearColor]];
    UIView* b = [[UIView alloc]init];
    [cell setBackgroundView:b];
    [b release];   
    
    [cell.contentView addSubview:bubbleView];       
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    SoftInfo* info = [_softRcmList.softList objectAtIndex:row];
    if (info) 
    {
        //youmi apps?
        
            NSURL *url = [[NSURL alloc] initWithString:info.url];
            UIApplication *myApp = [UIApplication sharedApplication];
            [myApp openURL:url];
            [url release];
    }
    
    [Flurry logEvent:[NSString stringWithFormat:@"didSelectRowAtIndexPath:%@",info.icon]];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger kMargin = 0;
    SoftInfo* info = [_softRcmList.softList objectAtIndex:[indexPath row]];
    
    UIView* bubbleView = [self bubbleView:[NSString stringWithFormat:@"%@:%@",info.name,info.detail] icon:info.icon from:([indexPath row]%2==0)];
    return bubbleView.frame.size.height+kMargin;
}



#pragma mark bubble support

//图文混排

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}

#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH 150
-(UIView *)assembleMessageAtIndex : (NSString *) message from:(BOOL)fromself
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = [UIFont systemFontOfSize:13.0f];
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    if (data) {
        for (int i=0;i < [data count];i++) {
            NSString *str=[data objectAtIndex:i];
            NSLog(@"str--->%@",str);
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = 150;
                    Y = upY;
                }
                NSLog(@"str(image)---->%@",str);
                NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                [img release];
                upX=KFacialSizeWidth+upX;
                if (X<150) X = upX;
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = 150;
                        Y =upY;
                    }
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    [la release];
                    upX=upX+size.width;
                    if (X<150) {
                        X = upX;
                    }
                }
            }
        }
    }
    returnView.frame = CGRectMake(15.0f,1.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    NSLog(@"%.1f %.1f", X, Y);
    return returnView;
}

/*
 生成泡泡UIView
 */
#pragma mark -
#pragma mark Table view methods
- (UIView *)bubbleView:(NSString *)text icon:(NSString*)icon from:(BOOL)fromSelf {
	// build single chat bubble cell with given text
    UIView *returnView =  [self assembleMessageAtIndex:text from:fromSelf];
    returnView.backgroundColor = [UIColor clearColor];
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectZero];
    cellView.backgroundColor = [UIColor clearColor];
    
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"bubbleSelf":@"bubble" ofType:@"png"]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:20 topCapHeight:14]];
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    UIImage* headImage = [UIImage imageNamed:icon];
    if (nil==headImage){
        headImage = [UIImage imageWithContentsOfFile:icon];
    }
    [headImageView setImage:headImage];
    if(fromSelf){    
        CGRect rc = [[UIScreen mainScreen]bounds];
        NSUInteger offset = UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM()?15:80;
        
        returnView.frame= CGRectMake(9.0f, 15.0f, returnView.frame.size.width, returnView.frame.size.height);
        bubbleImageView.frame = CGRectMake(0.0f, 14.0f, returnView.frame.size.width+24.0f, returnView.frame.size.height+24.0f );
        cellView.frame = CGRectMake(rc.size.width-bubbleImageView.frame.size.width-headImage.size.width-offset, 0.0f,bubbleImageView.frame.size.width+50.0f, bubbleImageView.frame.size.height+30.0f);
        headImageView.frame = CGRectMake(bubbleImageView.frame.size.width, cellView.frame.size.height-50.0f, 50.0f, 50.0f);
    }
	else{
        //[headImageView setImage:[UIImage imageNamed:@"default_head_online.png"]];
        returnView.frame= CGRectMake(65.0f, 15.0f, returnView.frame.size.width, returnView.frame.size.height);
        bubbleImageView.frame = CGRectMake(50.0f, 14.0f, returnView.frame.size.width+24.0f, returnView.frame.size.height+24.0f);
		cellView.frame = CGRectMake(0.0f, 0.0f, bubbleImageView.frame.size.width+30.0f,bubbleImageView.frame.size.height+30.0f);
        headImageView.frame = CGRectMake(0.0f, cellView.frame.size.height-50.0f, 50.0f, 50.0f);
    }   
    
    
    [cellView addSubview:bubbleImageView];
    [cellView addSubview:headImageView];
    [cellView addSubview:returnView];
    [bubbleImageView release];
    [returnView release];
    [headImageView release];
	return [cellView autorelease];
    
}

@end
