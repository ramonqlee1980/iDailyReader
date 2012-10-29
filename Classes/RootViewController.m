
#import "RootViewController.h"
#import "CompositeSubviewBasedApplicationCell.h"
#import "HybridSubviewBasedApplicationCell.h"
#import "AppDelegate.h"
#import "UIImageEx.h"
#import "RewardedWallViewController.h"

#import "TextViewController.h"
#import "Constants.h"
#import "AdsConfig.h"
#import "Flurry.h"
#import "WapsOffer/AppConnect.h"
//#import "MiidiAdWall.h"

#define kTextLabeFontSize 25
#define kDetailTextLableFontSize 20
#define kToday @"kToday"
#define kTitle @"Title"
#define kLoadMobisageRecommendViewDelayTime 10//10s



@interface RootViewController()
{
    BOOL mYoumiFeaturedWallShown;
    BOOL mYoumiFeaturedWallClosed;
    BOOL mYoumiFeaturedWallLoadSuccess;
    BOOL mYoumiFeaturedWallShouldShow;//time's up for the next youmi wall show
    BOOL mYoumiFeatureWallShowCount;
}

-(void)closeAds:(BOOL)popClosingTip;
-(void)loadNeededView;
-(void)loadYoumiWall:(BOOL)credit;
-(void)loadAdsageRecommendView:(BOOL)visible;
-(void)loadRecommendAdsWall:(NSString*)wallName;
@end


@implementation RootViewController
@synthesize data;
@synthesize tableView;
@synthesize recmdView = _recmdView;


#pragma mark -
#pragma mark View controller methods
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = NSLocalizedString(kToday, "");
        self.tabBarItem.image = [UIImage imageNamed:@"ICN_account_ON"];
        self.navigationItem.title = NSLocalizedString(kTitle, "");
    }
    return self;
}
-(void)loadNeededView
{    
    //add tip view
    CGRect rc = [[UIScreen mainScreen]applicationFrame];   
    rc.size.height = 0;
#ifndef kSingleFile 
    rc.origin.y = 0;
    rc.size.height = 0;//35; 
#if 0
    UITextView* tipView = [[UITextView alloc]initWithFrame:rc];
    
    tipView.text = NSLocalizedString(@"appFriendlyTip", "");
    tipView.textColor = [UIColor redColor];
    tipView.textAlignment = UITextAlignmentCenter;
    tipView.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:tipView];
    [tipView release];
#endif
#endif    
    
    CGRect frame = [[UIScreen mainScreen]applicationFrame];
    frame.origin.y = 0;
    frame.origin.y += rc.size.height;
    frame.size.height -= rc.size.height;
    tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}
-(void)loadYoumiWall:(BOOL)credit
{   
    //    AdsConfig* config = [AdsConfig sharedAdsConfig];
    //    if(![config wallShouldShow])
    //    {
    //       return;
    //    }
    
    //load youmi wall
    if(!wall)
    {
        wall = [[YouMiWall alloc] init];
        wall.delegate = self;
        wall.appID = kDefaultAppID_iOS;
        wall.appSecret = kDefaultAppSecret_iOS;
    }
    if(credit)
    {  
        // 添加应用列表开放源观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestOffersOpenDataSuccess:) name:YOUMI_OFFERS_APP_DATA_RESPONSE_NOTIFICATION object:nil];
        
        [wall requestOffersAppData:credit pageCount:15];
    }
    else
    {      
        // 添加应用列表开放源观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFeaturedOffersSuccess) name:YOUMI_FEATURED_APP_RESPONSE_NOTIFICATION object:nil];
        
        [wall requestFeaturedApp:credit];
    }
}
-(void)loadAdsageRecommendView:(BOOL)visible
{
    [[MobiSageManager getInstance]setPublisherID:kMobiSageID_iPhone];
    if (self.recmdView == nil) 
    {
        const NSUInteger size = 24;//mobisage recommend default view size
        _recmdView = [[MobiSageRecommendView alloc]initWithDelegate:self andImg:nil];
        //CGFloat height = self.navigationController.navigationBar.frame.size.height;
        self.recmdView.frame = CGRectMake(0, size/2, size, size);
    }    
    if(visible)
    {
        //add to navigation
        UIBarButtonItem *naviLeftItem = [[UIBarButtonItem alloc] initWithCustomView:self.recmdView];    
        self.navigationItem.leftBarButtonItem = naviLeftItem;
        [naviLeftItem release];
    }
}
-(void)loadFeaturedYoumiWall
{    
    if(!mYoumiFeaturedWallShown)
    {
        [self loadYoumiWall:NO];
    }
}
-(void)shouldShowYoumiWall
{
    mYoumiFeaturedWallShouldShow = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //AdsConfig* config = [AdsConfig sharedAdsConfig];
    //self.navigationController.navigationBarHidden = YES;
    //if(![config wallShouldShow])
    //{
     //   return;
    //}
    AppDelegate* delegate = SharedDelegate;
    if([delegate shouldShowAdsWall])
    {
        [Flurry logEvent:kLoadRecommendAdsWall];
        [self  loadRecommendAdsWall:[delegate currentAdsWall]];
    }
}

- (void)viewDidLoad
{
    [self loadNeededView];    
    [super viewDidLoad];
    [self loadAdsageRecommendView:NO];
    
    mYoumiFeatureWallShowCount = 0;
    mYoumiFeaturedWallShown = NO;  
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeAds:) name:kAdsUpdateDidFinishLoading object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTableView:) name:kUpdateTableView object:nil];
    
	self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.data = delegate.data;
	
	// create our UINib instance which will later help us load and instanciate the
	// UITableViewCells's UI via a xib file.
	//
	// Note:
	// The UINib classe provides better performance in situations where you want to create multiple
	// copies of a nib file’s contents. The normal nib-loading process involves reading the nib file
	// from disk and then instantiating the objects it contains. However, with the UINib class, the
	// nib file is read from disk once and the contents are stored in memory.
	// Because they are in memory, creating successive sets of objects takes less time because it
	// does not require accessing the disk.
	//
	//self.cellNib = [UINib nibWithNibName:@"IndividualSubviewsBasedApplicationCell" bundle:nil];
    
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Back",@"") style: UIBarButtonItemStyleBordered target: nil action: nil];  
    [[self navigationItem] setBackBarButtonItem: newBackButton];  
    [newBackButton release]; 
    
    
    // Create a final modal view controller
	UIButton* modalViewButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[modalViewButton addTarget:self action:@selector(modalViewAction:) forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *donateButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Donate",@"") style: UIBarButtonItemStyleBordered target: self action:@selector(donateViewAction:)];  
    UIBarButtonItem* inforItem = [[UIBarButtonItem alloc ]initWithCustomView:modalViewButton];
	self.navigationItem.rightBarButtonItem = inforItem;
	[inforItem release];  
    
    if(openApps==nil)
    {
        openApps = [[NSMutableArray alloc] init];
    }
    
    //[Flurry logEvent:kEnterMainViewList];
}

-(void)updateTableView:(id)sender
{
    [tableView reloadData];
}

- (void)viewDidUnload
{
	[super viewDidLoad];
    [[NSNotificationCenter defaultCenter]removeObserver:self];	
	self.data = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark alertView delegate
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{   
#define kOkIndex 0    
    if(buttonIndex == kOkIndex)
    {
        NSDate* now = [AdsConfig currentLocalDate];        
        NSDate* validDate = [now dateByAddingTimeInterval:kOneDay*kTrialDays];
        NSDateFormatter* formatedDate = [[[NSDateFormatter alloc]init]autorelease];
        [formatedDate setDateFormat:kDateFormatter];
        NSString* validDateString = [formatedDate stringFromDate:validDate];
        NSLog(@"valid date:%@",validDateString);
        [AdsConfig setAdsOn:NO type:validDateString];  
        
        [Flurry logEvent:kFlurryRemoveTempConfirm];
    }
    else
    {
        [Flurry logEvent:kFlurryRemoveTempCancel];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}


#pragma mark -
#pragma mark Table view methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [data count]/kItemPerSection+[openApps count];
    NSLog(@"contentCount:%d",count);
    return count;//one for title,one for content
}
- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString* cellIdentifier = @"kContentCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier]autorelease];        
        //Add layout code here
        
    }
    
    //    if(indexPath.row<[SharedDelegate newContentCount] && [SharedDelegate showNewContent])
    if(indexPath.row<[openApps count])
    {
        AppDelegate* delegate= (AppDelegate*)[UIApplication sharedApplication].delegate;       
        NSString* docDir= [delegate applicationDocumentsDirectory];
        YouMiWallAppModel* model = [openApps objectAtIndex:indexPath.row];
        
        NSString* smallIconFileName = [NSString stringWithFormat:@"%@%@",model.name,model.storeID];
        NSString* localIconFileName = [NSString stringWithFormat:@"%@%@%@",docDir,@"/",smallIconFileName];
        
        UIImage* image = [UIImage imageWithContentsOfFile:localIconFileName];
        UIImageView* newContentImageView = [[[UIImageView alloc]initWithImage:image]autorelease];        //accessoryLabel.tag = SECONDLABEL_TAG;           
        cell.accessoryView = newContentImageView;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (免费，推荐下载)",model.name];
        cell.detailTextLabel.text = model.desc;
    }    
    else
    {
        NSUInteger index = indexPath.row-[openApps count];
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [SharedDelegate getTitle:index];
        cell.detailTextLabel.text = [SharedDelegate getContent:index];
    }
    
    
    cell.textLabel.textColor = [UIColor purpleColor];
    //NSLog(@"fontSize:%f",cell.textLabel.font.pointSize);
    
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.textColor = [UIColor blueColor];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath:%d",indexPath.row);
    
    if(indexPath.row<[openApps count])
    {
        YouMiWallAppModel *model  = [openApps objectAtIndex:indexPath.row];
        if(model)
        {
            [wall userInstallOffersApp:model];            
            NSDictionary *dict = [NSDictionary dictionaryWithObject:model.price forKey:model.name];
            [Flurry logEvent:kFlurryDidSelectAppFromMainList withParameters:dict];
            
        }
    }
    else
    {
        NSUInteger row = indexPath.row-[openApps count];
        NSIndexPath* reIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
        TextViewController *detail = (TextViewController*)[[TextViewController alloc] initWithIndexPath:reIndexPath];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
        
        //flurry
        AppDelegate* delegate = SharedDelegate;
        NSString* title = [delegate getTitle:row];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:NSStringFromCGPoint(CGPointMake(0, row)) forKey:title];
        [Flurry logEvent:kFlurryDidReviewContentFromMainList withParameters:dict];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YOUMI_OFFERS_APP_DATA_RESPONSE_NOTIFICATION object:nil];
    wall.delegate = nil;
    [wall release];
    [tableView release];
    [data release];
    [openApps release];
    self.recmdView = nil;
    [super dealloc];
}

-(IBAction)donateViewAction:(id)sender
{
    /*UIAlertView* alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Donate", @"") message:NSLocalizedString(@"DonateBody", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
     [alert show];
     [alert release];*/
    
    UIViewController *detailViewController;
    //if (indexPath.row == 0) {
    detailViewController = [[RewardedWallViewController alloc] init];
    ////} else if (indexPath.row == 1) {
    //   detailViewController = [[NoneRewardedWallViewController alloc] init];
    //}
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}
#pragma mark - YouMiWall delegate
-(void)requestFeaturedOffersSuccess
{
    mYoumiFeaturedWallLoadSuccess = YES;
    mYoumiFeaturedWallShown = YES;
    mYoumiFeaturedWallClosed = NO;
    if(!self.view.isHidden)
    {
        [wall showFeaturedApp:YouMiWallAnimationTransitionPushFromBottom];
        [Flurry logEvent:kDidShowFeaturedAppNoCredit];        
    }
}
// 隐藏全屏页面
// 
// 详解:
//      全屏页面隐藏完成后回调该方法
// 补充:
//      查看YOUMI_WALL_VIEW_CLOSED_NOTIFICATION
//
- (void)didDismissWallView:(YouMiWall *)adWall
{
    mYoumiFeaturedWallClosed = YES;
    mYoumiFeaturedWallShown = NO;
}
// 显示全屏页面
// 
// 详解:
//      全屏页面显示完成后回调该方法
// 补充:
//      查看YOUMI_WALL_VIEW_OPENED_NOTIFICATION
//
- (void)didShowWallView:(YouMiWall *)adWall
{
    mYoumiFeatureWallShowCount++;
    mYoumiFeaturedWallShown = YES;
    mYoumiFeaturedWallClosed = NO;
}
- (void)requestOffersOpenDataSuccess:(NSNotification *)note {
    NSLog(@"--*-1--[Rewarded]requestOffersOpenDataSuccess:-*--");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YOUMI_OFFERS_APP_DATA_RESPONSE_NOTIFICATION object:nil];
    
    
    {        
        AppDelegate* delegate= (AppDelegate*)[UIApplication sharedApplication].delegate;
        NSDictionary *info = [note userInfo];
        NSArray *apps = [info valueForKey:YOUMI_WALL_NOTIFICATION_USER_INFO_OFFERS_APP_KEY];
        NSString* docDir= [delegate applicationDocumentsDirectory];
        
        
        for (NSUInteger i = 0; i<[apps count]; ++i) {
            YouMiWallAppModel *model = [apps objectAtIndex:i];
            NSLog(@"model:%@",model) ;
            
            NSString* smallIconUrl = model.smallIconURL;
            
            NSString* smallIconFileName = [NSString stringWithFormat:@"%@%@",model.name,model.storeID];
            NSString* localIconFileName = [NSString stringWithFormat:@"%@%@%@",docDir,@"/",smallIconFileName];
            NSData* localData = [NSData dataWithContentsOfFile:localIconFileName];
            if (localData==nil || localData.length==0) {
                localData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", smallIconUrl]]];
                [localData writeToFile:localIconFileName atomically:YES];        
            }         
        }
        
        //add to listview
        if(apps && [apps count]>0)
        {
            if(openApps==nil)
            {
                openApps = [[NSMutableArray alloc] init];
            }
            [openApps addObjectsFromArray:apps];
            
            [self.tableView reloadData];
        }
    }
}

#pragma mark API
- (IBAction)modalViewAction:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"AboutTitle", @"") message:NSLocalizedString(@"About", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Done",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)popupAdsageRecommendView:(NSString*)wallName
{    
    if(NSOrderedSame==[AdsPlatformMobisageWall caseInsensitiveCompare:wallName])
    {        
        [self loadAdsageRecommendView:YES];
        [self.recmdView OpenAdSageRecmdModalView];
    }
    else if(NSOrderedSame==[AdsPlatformWapsWall caseInsensitiveCompare:wallName])
    {
        [AppConnect showOffers];
    }
    else if(NSOrderedSame==[AdsPlatformImmobWall caseInsensitiveCompare:wallName])
    {
        if(mImmobWall)
        {
            [mImmobWall release];
        }
        mImmobWall=[[immobView alloc] initWithAdUnitID:kImmobWallId];
        //此属性针对多账户用户，主要用于区分不同账户下的积分
        //        [mWall.UserAttribute setObject:@"immobSDK" forKey:@"accountname"];
        ((immobView*)mImmobWall).delegate=self;
        [mImmobWall release];
        [((immobView*)mImmobWall) immobViewRequest];
    }
    else //if(NSOrderedSame==[AdsPlatformYoumiWall caseInsensitiveCompare:wallName])
    {
        [self loadFeaturedYoumiWall];
    }
    
    AppDelegate* delegate = SharedDelegate;
    [delegate setShouldShowAdsWall:NO enableForNext:YES];
}
-(void)loadRecommendAdsWall:(NSString*)wallName
{
    [self loadAdsageRecommendView:YES];
    [self performSelector:@selector(popupAdsageRecommendView:) withObject:wallName afterDelay:kLoadMobisageRecommendViewDelayTime];
}
#pragma mark immob delegate
/**
 *email phone sms等所需要
 *返回当前添加immobView的ViewController
 */
- (UIViewController *)immobViewController{
    
    return self;
}

/**
 *根据广告的状态来决定当前广告是否展示到当前界面上 AdReady 
 *YES  当前广告可用
 *NO   当前广告不可用
 */
- (void) immobViewDidReceiveAd:(BOOL)AdReady{
    if (AdReady) {
        immobView* imView = (immobView*)(mImmobWall);       
        [self.view addSubview:imView];        
        [imView immobViewDisplay];
    }
    else {
        [self loadFeaturedYoumiWall];
    }    
}

#pragma closeAds temporarily
-(void)closeAds:(BOOL)popClosingTip
{    
    if(popClosingTip)
    {
        [self loadYoumiWall:YES];
        AppDelegate* delegate = SharedDelegate;
        [self loadRecommendAdsWall:[delegate currentAdsWall]];
        [self loadAdsageRecommendView:YES];
    }
    if (![AdsConfig neverCloseAds]) {
        return;
    }

}

#pragma mark AdSageRecommendDelegate
- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}

@end