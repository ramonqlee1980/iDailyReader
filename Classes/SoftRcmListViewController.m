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
#import "YouMiWall.h"
#import "YouMiWallDelegateProtocol.h"
#import "AdsConfig.h"
#import "AppDelegate.h"

#define kRecommendList @"kRecommendList"
#define TOOLBARTAG		200
#define TABLEVIEWTAG	300


#define BEGIN_FLAG @"[/"
#define END_FLAG @"]"

@interface SoftRcmListViewController ()
- (UIView *)bubbleView:(NSString *)text icon:(NSString*)icon from:(BOOL)fromSelf;
@end

@implementation SoftRcmListViewController
@synthesize recmdView = _recmdView;
-(void)loadAdsageRecommendView
{
    [[MobiSageManager getInstance]setPublisherID:kMobiSageID_iPhone];
    if (self.recmdView == nil)
    {
        _recmdView = [[MobiSageRecommendView alloc]initWithDelegate:self];
        self.recmdView.frame = CGRectZero;
    }
}
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
        
#if 0
        [self loadAdsageRecommendView];
#ifndef k91Appstore
        //AdsConfig* config = [AdsConfig sharedAdsConfig];
        //show close ads 
        //if([config wallShouldShow])
        {
            //load youmi wall
            wall = [[YouMiWall alloc] init];
            wall.appID = kDefaultAppID_iOS;
            wall.appSecret = kDefaultAppSecret_iOS;
            
            // 添加应用列表开放源观察者
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestOffersOpenDataSuccess:) name:YOUMI_OFFERS_APP_DATA_RESPONSE_NOTIFICATION object:nil];
            [wall requestOffersAppData:YES pageCount:15];
        }
#endif
#endif
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AdsConfig* config = [AdsConfig sharedAdsConfig];    
    if([config wallShouldShow])
    {
        [self.recmdView OpenAdSageRecmdModalView];
    }
}
-(void) dealloc
{
    [_softRcmList release];
    [openApps release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YOUMI_OFFERS_APP_DATA_RESPONSE_NOTIFICATION object:nil];
    [wall release];
    self.recmdView = nil;
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


#pragma mark - Table view delegate
-(YouMiWallAppModel *)youmiApp:(NSString*)appName andUrl:(NSString*)linkUrl
{
    if(openApps == nil || [openApps count] == 0 || appName == nil || linkUrl == nil)
    {
        return nil;
    }
    for (YouMiWallAppModel* m in openApps) {
        if([appName isEqualToString:m.name] && [linkUrl isEqualToString:m.linkURL])
        {
            return m;
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    SoftInfo* info = [_softRcmList.softList objectAtIndex:row];
    if (info) 
    {
        //youmi apps?
        YouMiWallAppModel *model  = [self youmiApp:info.name andUrl:info.url];
        if(model)
        {
            [wall userInstallOffersApp:model];            
            NSDictionary *dict = [NSDictionary dictionaryWithObject:model.price forKey:model.name];
            [Flurry logEvent:kFlurryDidSelectAppFromRecommend withParameters:dict];
            
        }
        else
        {
            NSURL *url = [[NSURL alloc] initWithString:info.url];
            UIApplication *myApp = [UIApplication sharedApplication];
            [myApp openURL:url];
            [url release];
        }
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
#pragma mark - YouMiWall delegate

- (void)requestOffersOpenDataSuccess:(NSNotification *)note {
    NSLog(@"--*-1--[Rewarded]requestOffersOpenDataSuccess:-*--");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YOUMI_OFFERS_APP_DATA_RESPONSE_NOTIFICATION object:nil];
    
    AppDelegate* delegate= (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSDictionary *info = [note userInfo];
    NSArray *apps = [info valueForKey:YOUMI_WALL_NOTIFICATION_USER_INFO_OFFERS_APP_KEY];
    NSString* docDir= [delegate applicationDocumentsDirectory];
    if(openApps==nil)
    {
        openApps = [[NSMutableArray alloc] init];
        [openApps addObjectsFromArray:apps];
    }
    
    for (NSUInteger i = 0; i<[apps count]; ++i) {
        SoftInfo* t = [[SoftInfo alloc]init];
        YouMiWallAppModel *model = [apps objectAtIndex:i];
        //NSLog(@"model:%@",model) ;
        t.name = model.name;
        t.url = model.linkURL;
        t.detail = model.desc;
        
        NSString* smallIconUrl = model.smallIconURL;
        
        NSString* smallIconFileName = [NSString stringWithFormat:@"%@%@",model.name,model.storeID];
        NSString* localIconFileName = [NSString stringWithFormat:@"%@%@%@",docDir,@"/",smallIconFileName];
        NSData* localData = [NSData dataWithContentsOfFile:localIconFileName];
        if (localData==nil || localData.length==0) {
            localData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", smallIconUrl]]];
            [localData writeToFile:localIconFileName atomically:YES];        
        } 
        t.icon = localIconFileName;
        
        
        [_softRcmList.softList insertObject:t atIndex:0];
    }
    [self.tableView reloadData];
}
@end
