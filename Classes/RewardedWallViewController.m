//
//  RewardedWallViewController.m
//  YouMiSDK_Sample_Wall
//
//  Created by  on 12-1-5.
//  Copyright (c) 2012年 YouMi Mobile Co. Ltd. All rights reserved.
//

#import "RewardedWallViewController.h"
#import "YouMiWall.h"
#import "YouMiWallDelegateProtocol.h"
#import "AdsConfig.h"
#import "NetworkManager.h"
#import "AppDelegate.h"
#import "Flurry.h"
@interface RewardedWallViewController()
-(void)loadNeededView;
@end

@implementation RewardedWallViewController
-(id)init:(BOOL)adsClosedSupport
{
    mAdsClosedSupport = adsClosedSupport;
    id inst = [self init];    
    return  inst;
}
- (id)init {
    if (self=[super init]) {        
        mRequestOffersFail = NO;
        // 假设你用户账户的积分默认是100
        point = 0;
        openApps = [[NSMutableArray alloc] init];
        
        //
        //wall = [[YouMiWall alloc] initWithAppID:kDefaultAppID_iOS withAppSecret:kDefaultAppSecret_iOS];
        // or
        wall = [[YouMiWall alloc] init];
               
        // set delegate
        //        wall.delegate = self;
        
        //#warning 设置相应用户的账户名称，只能是邮件格式的字符串
        NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
        NSString* kUserIdKey = @"UserID";
        NSString* uid = [defaultSetting stringForKey:kUserIdKey];
        
        if([uid length]==0)
        {
            NetworkManager* nm = [NetworkManager sharedInstance]; 
            
            [defaultSetting setValue:[NSString stringWithFormat:@"%@%@",[nm uuid],@"@gmail.com"] forKey:kUserIdKey];
            uid = [defaultSetting stringForKey:kUserIdKey];
        }
        NSLog(@"uid:%@",uid);
        //wall.userID = uid;//[NSString stringWithFormat:@"User_%d", arc4random()%100];                // 设置你用户的账户名称
        
        // 添加应用列表开放源观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestOffersOpenDataSuccess:) name:YOUMI_OFFERS_APP_DATA_RESPONSE_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestOffersOpenDataFail:) name:YOUMI_OFFERS_APP_DATA_RESPONSE_NOTIFICATION_ERROR object:nil];
        
        // 添加请求Web应用列表观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestOffersSuccess:) name:YOUMI_OFFERS_RESPONSE_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestOffersFail:) name:YOUMI_OFFERS_RESPONSE_NOTIFICATION_ERROR object:nil];
        
        
        // 关于积分查询观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissFullScreen:) name:YOUMI_WALL_VIEW_CLOSED_NOTIFICATION object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestPointSuccess:) name:YOUMI_EARNED_POINTS_RESPONSE_NOTIFICATION object:nil];
    }
    [self loadNeededView];
    return self;
}

-(void)loadNeededView
{
    //add tip view
    CGRect rc = [[UIScreen mainScreen]applicationFrame];
    rc.origin.y = 0;
    
    if(mAdsClosedSupport)
    {
//        UIFont* font = [UIFont boldSystemFontOfSize:12];
//        AdsConfig* config = [AdsConfig sharedAdsConfig];  
//        CGSize labelSize=[[config wallShowString] sizeWithFont:font
//                          constrainedToSize:CGSizeMake(kDeviceWidth,KDeviceHeight)
//                              lineBreakMode:UILineBreakModeWordWrap];
//        //
//        UITextView* tipView = [[UITextView alloc]initWithFrame:rc];        
//        tipView.contentSize = labelSize;
//        rc.size.height = labelSize.height*1.5;
//              
//        tipView.text = [config wallShowString];
//        tipView.textColor = [UIColor redColor];
//        tipView.font = font;
//        [self.view addSubview:tipView];
//        [tipView release];
    }
    else
    {
        rc.size.height = 0;
    }
    
    if(!_tableView)
    {
        CGRect frame = [[UIScreen mainScreen]applicationFrame];
        frame.origin.y = 0;
        frame.origin.y += rc.size.height;
        frame.size.height = [[UIScreen mainScreen]applicationFrame].size.height-rc.size.height;
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YOUMI_OFFERS_APP_DATA_RESPONSE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YOUMI_OFFERS_APP_DATA_RESPONSE_NOTIFICATION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YOUMI_OFFERS_RESPONSE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YOUMI_OFFERS_RESPONSE_NOTIFICATION_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YOUMI_WALL_VIEW_CLOSED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YOUMI_EARNED_POINTS_RESPONSE_NOTIFICATION object:nil];
    
    [wall release];
    [openApps release];
    [_tableView release];
    
    [super dealloc];
}

#pragma mark - Actions

- (void)queryPoints {
    if(mAdsClosedSupport)
    {
        [wall requestEarnedPointsWithTimeInterval:10.0 repeatCount:10];
    }
}

- (void)showOffersAction:(id)sender {
    [wall showOffers:YouMiWallAnimationTransitionPushFromBottom];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (point>0) {
        self.title = [NSString stringWithFormat:@"积分:%d", point];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self queryPoints];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 请求开源数据
    [openApps removeAllObjects];
    [_tableView reloadData];
    
    [wall requestOffersAppData:YES pageCount:15];
    
    
    // 请求Web源
    self.navigationItem.rightBarButtonItem = nil;
    
    [wall requestOffers:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [openApps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Rewarded Cell Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (indexPath.row >= [openApps count]) return cell;
    
    YouMiWallAppModel *model = [openApps objectAtIndex:indexPath.row];
	//NSString* text = [NSString stringWithFormat:@"%@\t积%d分",model.name,model.points];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.desc;
    
    //save under document directory
    AppDelegate* delegate= (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString* docDir= [delegate applicationDocumentsDirectory];
    NSString* smallIconUrl = model.smallIconURL;
    NSLog(@"smallIcon:%@",smallIconUrl) ;
     NSString* smallIconFileName = [NSString stringWithFormat:@"%@%@",model.name,model.storeID];
    NSString* localIconFileName = [NSString stringWithFormat:@"%@%@%@",docDir,@"/",smallIconFileName];
    NSData* localData = [NSData dataWithContentsOfFile:localIconFileName];
    if (localData==nil || localData.length==0) {
        localData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", smallIconUrl]]];
        [localData writeToFile:localIconFileName atomically:YES];        
    } 
    
    cell.imageView.image = [UIImage imageWithData:localData]; 
    
    //cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.smallIconURL]]];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // deselect cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 
    if (indexPath.row >= [openApps count]) return;
    
    YouMiWallAppModel *model = [openApps objectAtIndex:indexPath.row];
    [wall userInstallOffersApp:model];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:model.price forKey:model.name];
    [Flurry logEvent:kFlurryDidSelectApp2RemoveAds withParameters:dict];
    // 查询积分
    //[self queryPoints];
}

#pragma mark - YouMiWall delegate

- (void)requestOffersOpenDataSuccess:(NSNotification *)note {
    NSLog(@"--*-1--[Rewarded]requestOffersOpenDataSuccess:-*--");
    
    NSDictionary *info = [note userInfo];
    NSArray *apps = [info valueForKey:YOUMI_WALL_NOTIFICATION_USER_INFO_OFFERS_APP_KEY];
    [openApps addObjectsFromArray:apps];
    [_tableView reloadData];
}

- (void)requestOffersOpenDataFail:(NSNotification *)note {
    NSLog(@"--*-2--[Rewarded]requestOffersOpenDataFail:-*--");
    // do nothing
}

- (void)requestOffersSuccess:(NSNotification *)note {
    NSLog(@"--*-3--[Rewarded]requestOffersSuccess:-*--");
    
    //UIBarButtonItem *showOffersItem = [[UIBarButtonItem alloc] initWithTitle:@"显示Web列表" style:UIBarButtonItemStyleBordered target:self action:@selector(showOffersAction:)];
    //self.navigationItem.rightBarButtonItem = showOffersItem;
    //[showOffersItem release];
}

- (void)requestOffersFail:(NSNotification *)note {
    NSLog(@"--*-4--[Rewarded]requestOffersFail:-*--");
    if (!mRequestOffersFail) {
        // do nothing
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"获取积分应用列表貌似出了点小问题，请稍后重试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
        mRequestOffersFail = YES;
    }
}

- (void)dismissFullScreen:(NSNotification *)note {
    NSLog(@"--*-5--[Rewarded]dismissFullScreen:-*--");
    
    // 查询积分
    [self queryPoints];
}

- (void)requestPointSuccess:(NSNotification *)note {
//    NSLog(@"--*-6--[Rewarded]requestPointSuccess:-*--");
//    
//    if ([AdsConfig isAdsOff]) {
//        return;
//    }
//    
//    NSDictionary *info = [note userInfo];
//    NSArray *records = [info valueForKey:YOUMI_WALL_NOTIFICATION_USER_INFO_EARNED_POINTS_KEY];    
//    for (NSDictionary *oneRecord in records) {
//        [AdsConfig setAdsOn:NO type:kPermanent];
//        //NSString *userID = (NSString *)[oneRecord objectForKey:kOneAccountRecordUserIDOpenKey];
//        NSString *name = (NSString *)[oneRecord objectForKey:kOneAccountRecordNameOpenKey];
//        NSInteger earnedPoint = [(NSNumber *)[oneRecord objectForKey:kOneAccountRecordPoinstsOpenKey] integerValue];
//        
//        point += earnedPoint;
//        
//        if(mAdsClosedSupport)
//        {
//            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"新增积分:%d", earnedPoint] message:[NSString stringWithFormat:@"来源于安装了应用[%@]。\n恭喜广告将被关闭。", name] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil]autorelease];
//            [alert show];
//            
//            [Flurry logEvent:kFlurryRemoveAdsSuccessfully];
//        }
//    }
//    
//    
//    if(point>0)
//        self.title = [NSString stringWithFormat:@"积分:%d分", point];
    
}

@end
