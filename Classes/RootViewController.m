
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
#import "FileModel.h"
#import "CJSONDeserializer.h"
#import "ContentCellModel.h"
#import "ComposeBlogController.h"
#import "ThemeManager.h"
#import "MCSegmentedControl.h"
#import "AdsConfiguration.h"
#import "AutoHideMenuView.h"
#import "UpdateToPremiumController.h"

#define kTextLabeFontSize 25
#define kDetailTextLableFontSize 20
#define kToday @"kToday"
#define kTitle @"Title"
#define kOfferwallDelay 10//10s

//#define kNextDelayTime 60

#define kLocalContent 0
#define kOnlineContent 1


#define FTop      0
#define FRecent   1
#define FPhoto    2

#define kFileDir @"RootData"
#define kRefreshFileName @"Refresh"
#define kLoadMoreFileName @"Loadmore"

#define kInitPage 1
#define OnlineContentURLString(count,page,tag) [NSString stringWithFormat:@"http://www.idreems.com/openapi/gettagposts.php?count=%d&page=%d&tag=%@",count,page,tag]


#define kAdsTipCountKey @"kAdsTipCount"
#define kAdsTipCount 365

@interface RootViewController()

@property(nonatomic,assign)NSUInteger page;
@property(nonatomic,assign)NSUInteger selectedSegmentIndex;
-(void) SegmentBtnClicked:(id)sender;

-(void)loadNeededView;

@end


@implementation RootViewController
@synthesize data;
@synthesize page,selectedSegmentIndex;


#pragma mark -
#pragma mark View controller methods
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = NSLocalizedString(kToday, "");
        self.tabBarItem.image = [UIImage imageNamed:kIconHomePage];
        self.navigationItem.title = NSLocalizedString(kTitle, "");
    }
    return self;
}
-(void)loadNeededView
{
//    const NSInteger kSize = 50;
//    CGRect rcAppFrame = [[UIScreen mainScreen]applicationFrame];
//    CGRect rc = self.tabBarController.tabBar.frame;
//    
//    WQAdView* adviewBanner = [[[WQAdView alloc]init:NO]autorelease];
//    [adviewBanner setFrame:CGRectMake(0, rcAppFrame.size.height-rc.size.height-kSize, rcAppFrame.size.width, kSize)];
//    [adviewBanner startWithAdSlotID:kWQBannerSlotId AccountKey:kWQBannerKey InViewController:self];
//    [self.view addSubview:adviewBanner];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    page = kInitPage;
    self.m_contentViewController.delegate = self;
    [self loadSegmentBar];
    //TODO::load data
    [self.m_contentViewController launchRefreshing];
    
    [self loadNeededView];   

    UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc ]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(WriteBtnClicked:)]autorelease];
    rightButton.tintColor = TintColor;

    [[self navigationItem] setRightBarButtonItem:rightButton];
        
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Back",@"") style: UIBarButtonItemStyleBordered target: nil action: nil];
    newBackButton.tintColor = TintColor;
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    [newBackButton release];
    
    
	self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    self.data = delegate.data;
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
//        NSDate* now = [AdsConfig currentLocalDate];
//        NSDate* validDate = [now dateByAddingTimeInterval:kOneDay*kTrialDays];
//        NSDateFormatter* formatedDate = [[[NSDateFormatter alloc]init]autorelease];
//        [formatedDate setDateFormat:kDateFormatter];
//        NSString* validDateString = [formatedDate stringFromDate:validDate];
//        NSLog(@"valid date:%@",validDateString);
//        [AdsConfig setAdsOn:NO type:validDateString];
        
        [Flurry logEvent:kFlurryRemoveTempConfirm];
    }
    else
    {
        [Flurry logEvent:kFlurryRemoveTempCancel];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
    [data release];
    
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

#pragma mark API
- (IBAction)modalViewAction:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"AboutTitle", @"") message:NSLocalizedString(@"About", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Done",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}



#pragma  PullingRefreshDelegate
-(BOOL)refreshData:(FileModel*)fileModel
{
    NSString* url = [self getUrl:kInitPage];
    if (!url || url.length==0) {
        return NO;
    }
    fileModel.encrypt = NO;
    fileModel.fileURL = url;//for the latest page
    
    fileModel.destPath = kFileDir;
    fileModel.fileName = [NSString stringWithFormat:@"%d%@",selectedSegmentIndex,kRefreshFileName];
    
    [SharedDelegate beginRequest:fileModel isBeginDown:YES setAllowResumeForFileDownloads:NO];
    return YES;
}
-(BOOL)loadMoreData:(FileModel*)fileModel
{
    NSString* url = [self getUrl:++self.page];
    if (!url || url.length==0) {
        return NO;
    }
    fileModel.encrypt = NO;
    fileModel.fileURL = url;//for the latest page
    
    fileModel.destPath = kFileDir;
    fileModel.fileName = [NSString stringWithFormat:@"%d%@",selectedSegmentIndex,kLoadMoreFileName];
    
    [SharedDelegate beginRequest:fileModel isBeginDown:YES setAllowResumeForFileDownloads:NO];
    return YES;
}

-(NSArray*)parseData:(NSData*)stream
{
    //TODO::loca data
    if (selectedSegmentIndex==kLocalContent) {
        return [self provideLocalData];
    }
    
            
    NSMutableArray* dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    if (stream) {
        NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:stream error:nil];
        NSString* rootItem = @"posts";
        if ([dictionary objectForKey:rootItem]) {
            NSArray *array = [NSArray arrayWithArray:[dictionary objectForKey:rootItem]];
            for (NSDictionary *wordpress in array) {
                ContentCellModel *model = [[[ContentCellModel alloc]initWithWordPressDictionary:wordpress]autorelease];
                [dataArray addObject:model];
            }
        }
    }
    //not more content,keep initial page
    if ([dataArray count]==0) {
        page = kInitPage;
    }
    return dataArray;
}

#pragma mark segmentbar

-(void)loadSegmentBar
{
    const CGFloat kNavigationBarInnerViewMargin = 7;
    const CGFloat segmentedControlHeight = self.navigationController.navigationBar.frame.size.height-kNavigationBarInnerViewMargin*2;
    const CGFloat kItemWidth = 70;
    // segmented control as the custom title view
	NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   NSLocalizedString(@"kLocalContent", @""),
                                   NSLocalizedString(@"kOnlineContent", @""),
								   nil];
	MCSegmentedControl *segmentedControl = [[MCSegmentedControl alloc] initWithItems:segmentTextContent];
    selectedSegmentIndex = kLocalContent;
	segmentedControl.selectedSegmentIndex = kLocalContent;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    segmentedControl.tintColor = TintColor;
    segmentedControl.selectedItemColor = [UIColor purpleColor];
    segmentedControl.unselectedItemColor = [UIColor grayColor];
    
	segmentedControl.frame = CGRectMake(0, 0, segmentTextContent.count*kItemWidth, segmentedControlHeight);
	[segmentedControl addTarget:self action:@selector(SegmentBtnClicked:) forControlEvents:UIControlEventValueChanged];
    
	self.navigationItem.titleView = segmentedControl;
	[segmentedControl release];
}
-(void)WriteBtnClicked:(id)sender
{
    ComposeBlogController *composeViewController = [[ComposeBlogController alloc] initWithNibName:@"ComposeBlogController" bundle:nil];
	[self.navigationController pushViewController:composeViewController animated:YES];
	[composeViewController release];
}
-(void) SegmentBtnClicked:(id)sender
{
    //reset page
    page = kInitPage;//page starts from 1    
    
    UISegmentedControl *btn =(UISegmentedControl *) sender;
    //same?
    if (selectedSegmentIndex==btn.selectedSegmentIndex) {
        return;
    }
    
    selectedSegmentIndex = btn.selectedSegmentIndex;
    [self.m_contentViewController launchRefreshing];
}

-(NSString*)getUrl:(NSInteger)currentPage
{
    int count = 30;
    
    return (selectedSegmentIndex==kOnlineContent)?OnlineContentURLString(count,currentPage,[[AdsConfiguration sharedInstance] appOnlineTag]):@"";
}
-(NSArray*)provideLocalData
{
    NSInteger count = [data count]/kItemPerSection;
    NSMutableArray* dataArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i<count; ++i) {
        ContentCellModel *model = [[[ContentCellModel alloc]initWithTitleAndContent:[SharedDelegate getTitle:i] content:[SharedDelegate getContent:i]]autorelease];
        [dataArray addObject:model];
    }
    
    return dataArray;
}


@end