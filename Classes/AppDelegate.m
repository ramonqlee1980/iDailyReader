
#import "AppDelegate.h"
#import "RootViewController.h"
#import "CDetailData.h"
#import "XPathQuery.h"//another xml parser wrapper
#import "AdsConfig.h"
#import "NetworkManager.h"
#import "ASIFormDataRequest.h"
#import "RootViewController.h"
#import "Flurry.h"
#import "RootViewController.h"
#import "SoftRcmListViewController.h"
#import "FlipViewController.h"
#import "iRate.h"
#import <QuartzCore/QuartzCore.h>
#import "MoreViewController.h"
#import "InAppRageIAPHelper.h"
#import <ShareSDK/ShareSDK.h>
#import "CommonHelper.h"
#import "FileModel.h"
#import "MainZakerViewController.h"

#define kLocalNotificationSet @"LocalNotificationSet"
#define kAdsWallShowDelayTime 10*60 //ads display delay time
#define kLaunchTime @"kLaunchTime"
#define kRatingWhenLaunchTime 5
#define kDayPerYear  365

#define kUpdateApp 0
#define kOpenWeixin 1

#define kMaxConcurrentOperationCount 1


@interface AppDelegate()
// Properties that don't need to be seen by the outside world.

@property (nonatomic, assign, readonly ) BOOL                               isReceiving;
@property (nonatomic, retain,readwrite) NSURLConnection *                  connection;
@property (nonatomic, copy,   readwrite) NSString *                         filePath;
@property (nonatomic, retain,readwrite) NSOutputStream *                   fileStream;
-(void)cancelLocalNotificationFlag;
-(void)setLocalNotifictionFlag:(BOOL)flag;
-(BOOL)isLoalNotificationSet;
@end


@implementation AppDelegate

@synthesize connection    = _connection;
@synthesize filePath      = _filePath;
@synthesize fileStream    = _fileStream;

@synthesize window;
@synthesize navigationController;
@synthesize data;
@synthesize mCurrentFileName,mDataPath,mTrackViewUrl,mTrackName;
@synthesize asiRequest;
@synthesize isWhiteColor;
@synthesize downinglist;
@synthesize finishedlist;

#pragma mark -
#pragma mark Application lifecycle
#pragma mark -
#pragma mark Memory management
+ (void)initialize
{
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
#if 1
	[iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    [iRate sharedInstance].appStoreID = [kAppIdOnAppstore integerValue];
    
    [AppDelegate logLaunch];
    //enable preview mode
    [iRate sharedInstance].previewMode = [AppDelegate shouldPromptRating];
#endif
}

+(BOOL)shouldPromptRating
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    NSString* switchVal = [defaultSetting stringForKey:kLaunchTime];
    return (switchVal!=nil && (switchVal.integerValue == kRatingWhenLaunchTime));
}
+(void)logLaunch
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    NSString* switchVal = [defaultSetting stringForKey:kLaunchTime];
    NSInteger count = 0;
    if(switchVal)
    {
        count = switchVal.integerValue;
    }
    if(count<=kRatingWhenLaunchTime)
    {
        [defaultSetting setValue:[NSString stringWithFormat:@"%d",++count] forKey:kLaunchTime];
    }
}
-(id)init
{
    if(!mOperationQueue)
    {
        mOperationQueue = [[NSOperationQueue alloc]init];
        [mOperationQueue setMaxConcurrentOperationCount:kMaxConcurrentOperationCount];//serial operation
    }
    if(!finishedlist)
    {
        finishedlist = [[NSMutableArray alloc]init];
    }
    if(!downinglist)
    {
        downinglist = [[NSMutableArray alloc]init];
    }
    return [super init];
}
-(void)add2Favorite:(NSNotification*)notification
{
    if(notification && notification.userInfo)
    {
        NSMutableArray *dataMutableArray = [[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:kAppIdOnAppstore];
        NSString* title = [notification.userInfo valueForKey:@"date"];
        NSString* content = [notification.userInfo valueForKey:@"text"];
        
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:content,@"text",title,@"date", nil];
        [dataMutableArray addObject:dict];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshFlipView object:nil];
        
        UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:nil message:@"成功添加到收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]autorelease];
        [alert show];
        [Flurry logEvent:kFlurryDidSelectAppFromMainList withParameters:[NSDictionary dictionaryWithObject:[[NSDate date]description] forKey:title]];
    }
}


-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"didFinishLaunchingWithOptions begin");
    //TODO::key?
    [ShareSDK registerApp:@"287edfff80"];
    
    //向微信注册
    [WXApi registerApp:kWixinChatID];
    //in-app purchase
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[InAppRageIAPHelper sharedHelper]];
    
    [self loadData];
    // Override point for customization after application launch.
    window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController* v = [[RootViewController alloc]initWithNibName:@"RootViewController" bundle:nil];
    UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:v];
    SoftRcmListViewController* recommendCtrl = [[SoftRcmListViewController alloc]initWithStyle:UITableViewStyleGrouped];
    FlipViewController *flip = [[FlipViewController alloc]initWithNibName:@"FlipViewController" bundle:nil];
    UINavigationController* navi2 = [[UINavigationController alloc]initWithRootViewController:flip];
    
//    EmbarassViewController* funZoneInner=[[EmbarassViewController alloc] initWithNibName:@"EmbarassViewController" bundle:nil];
    
    UIViewController* funZoneInner = [[MainZakerViewController alloc]init];
    
    UINavigationController* funZone = [[UINavigationController alloc]initWithRootViewController:funZoneInner];
    [funZoneInner release];
    
    UIViewController* moreCtrl = [[MoreViewController alloc]initWithNibName:@"MoreViewController" bundle:nil];
    UINavigationController* moreNavi = [[UINavigationController alloc]initWithRootViewController:moreCtrl];
    
#if 1
    NSArray* controllers = [NSArray arrayWithObjects:navi,funZone,navi2,recommendCtrl,moreNavi,nil];
#else
    NSArray* controllers = [NSArray arrayWithObjects:navi,funZone,navi2, nil];
#endif
    
    UITabBarController* tabCtrl = [[UITabBarController alloc]init];
    tabCtrl.viewControllers = controllers;
    
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController= tabCtrl;
    //[self.window addSubview:navi.view];
    [self.window makeKeyAndVisible];
    
    [moreCtrl release];
    [moreNavi release];
    [v release];
    [flip release];
    [recommendCtrl release];
    [navi release];
    [navi2 release];
    [funZone release];
    [controllers release];
    [tabCtrl release];
    
    [self splashScreenStart];
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    _EnterBylocalNotification = (localNotification!=nil);
    if(_EnterBylocalNotification)
    {
        [Flurry logEvent:kEnterBylocalNotification];
        //cancel notification flag
        [self cancelLocalNotificationFlag];
    }
    application.applicationIconBadgeNumber = 0;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(add2Favorite:) name:kAdd2Favorite object:nil];
    [self checkUpdate];
    [self startAdsConfigReceive];
    //flurry
    [Flurry startSession:kFlurryID];
    NSLog(@"didFinishLaunchingWithOptions begin");
    
        
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _EnterBylocalNotification = NO;
    NSLog(@"applicationDidEnterBackground");
    
//#ifndef kSingleFile
    //set local notification to pop up a tip
    const NSTimeInterval kDelay = 0;//1;
    NSString* popContent = NSLocalizedString(@"appFriendlyTip","");
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self scheduleLocalNotification:popContent delayTimeInterval:kDelay];
    
    //tomorrow's tip
    [self scheduleDailyNofification];
//#endif
}
-(void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate");
}
-(void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive");
}
-(void)sendTableViewUpdateMsg
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateTableView object:nil];
}

-(void)cancelLocalNotificationFlag
{
    [self setLocalNotifictionFlag:NO];
    NSLog(@"cancelLocalNotificationFlag");
}
-(void)setLocalNotifictionFlag:(BOOL)flag
{
    NSUserDefaults* setting = [NSUserDefaults standardUserDefaults];
    [setting setBool:flag forKey:kLocalNotificationSet];
    NSLog(@"cancelLocalNotificationFlag");
}
-(BOOL)isLoalNotificationSet
{
    NSUserDefaults* setting = [NSUserDefaults standardUserDefaults];
    BOOL r =[setting boolForKey:kLocalNotificationSet];
    NSLog(@"isLoalNotificationSet:%d",r);
    return r;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [Flurry logEvent:kEnterBylocalNotification];
    
    _EnterBylocalNotification = YES;
    application.applicationIconBadgeNumber = 0;
    [self loadData];
    
    [self performSelectorOnMainThread:@selector(sendTableViewUpdateMsg) withObject:self waitUntilDone:YES];
    
    //cancel notification flag
    [self cancelLocalNotificationFlag];
    NSLog(@"cancelLocalNotificationFlag");
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0)
{
    [self loadData];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self loadData];
}
#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (mDialogType==kUpdateApp) {
        // the user clicked one of the OK/Cancel buttons
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mTrackViewUrl]];
        }
    }
    else if(mDialogType == kOpenWeixin)
    {
#define kOkIndex 0
        if(buttonIndex == kOkIndex)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
            [Flurry logEvent:kFlurryConfirmOpenWeixinInAppstore];
        }
        else
        {
            [Flurry logEvent:kFlurryCancelOpenWeixinInAppstore];
        }
    }
}
-(void) GetVersionResult:(ASIHTTPRequest *)request
{
    if (!request ) {
        return;
    }
    
    //Response string of our REST call
    NSString* jsonResponseString = [request responseString];
    if (!jsonResponseString || [jsonResponseString length]==0) {
        return;
    }
    
    NSDictionary *loginAuthenticationResponse = [jsonResponseString performSelector:@selector(objectFromJSONString) withObject:nil];// objectFromJSONString];
    
    NSArray *configData = [loginAuthenticationResponse valueForKey:@"results"];
    NSString* releaseNotes;
    NSString *version = @"";
    for (id config in configData)
    {
        version = [config valueForKey:@"version"];
        self.mTrackViewUrl = [config valueForKey:@"trackViewUrl"];
        releaseNotes = [config valueForKey:@"releaseNotes"];
        self.mTrackName = [config valueForKey:@"trackName"];
        NSLog(@"%@",mTrackName);
    }
    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //Check your version with the version in app store
    if ([AppDelegate CompareVersionFromOldVersion:localVersion newVersion:version])
    {
        UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NewVersion", @"") message: @"" delegate:self cancelButtonTitle:NSLocalizedString(@"Back", @"") otherButtonTitles: NSLocalizedString(@"Ok", @""), nil];
        [createUserResponseAlert show];
        [createUserResponseAlert release];
        mDialogType = kUpdateApp;
    }
    
    [Flurry logEvent:[NSString stringWithFormat:@"localVersion:%@-newVersion:%@",localVersion,version]];
}
-(void)checkUpdate
{
    //not published on appstore
    if(kAppIdOnAppstore.length==0)
    {
        return;
    }
    
    NSString* updateLookupUrl = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kAppIdOnAppstore];
    NSURL *url = [NSURL URLWithString:updateLookupUrl];
    ASIFormDataRequest* versionRequest = [ASIFormDataRequest requestWithURL:url];
    [versionRequest setRequestMethod:@"GET"];
    [versionRequest setDelegate:self];
    [versionRequest setTimeOutSeconds:150];
    [versionRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    [versionRequest setDidFinishSelector:@selector(GetVersionResult:)];
    [versionRequest startAsynchronous];
    
}
// 比较oldVersion和newVersion，如果oldVersion比newVersion旧，则返回YES，否则NO
// Version format[X.X.X]
+(BOOL)CompareVersionFromOldVersion : (NSString *)oldVersion
                         newVersion : (NSString *)newVersion
{
    NSArray*oldV = [oldVersion componentsSeparatedByString:@"."];
    NSArray*newV = [newVersion componentsSeparatedByString:@"."];
    NSUInteger len = MAX(oldV.count,newV.count);
    
    for (NSInteger i = 0; i < len; i++) {
        NSInteger old = (i<oldV.count)?[(NSString *)[oldV objectAtIndex:i] integerValue]:0;
        NSInteger new = (i<newV.count)?[(NSString *)[newV objectAtIndex:i] integerValue]:0;
        if (old != new) {
            return (new>old);
        }        
    }
    return NO;    
}

-(NSInteger)newContentCount
{
    return _newContentCount;
}
-(BOOL)showNewContent
{
    NSLog(@"_EnterBylocalNotification::%d",_EnterBylocalNotification);
    return _EnterBylocalNotification;
}
-(void)scheduleDailyNofification
{
#ifndef kSingleFile
    // Load the data.
#ifdef kSingleFile
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"lyrics" ofType:@"xml"];
#elif defined kHistory
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:[AppDelegate getMonthDay4Tomorrow] ofType:@"xml"];
#else
    self.mCurrentFileName = [AppDelegate getTomorrowFileName];
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:self.mCurrentFileName ofType:@"txt"];
#endif
    
    if ([dataPath isEqualToString:mDataPath]) {
        return;
    }
    
    if ([mDataPath length] !=0 ) {
        [mDataPath release];
    }
    mDataPath = [[NSString alloc]initWithString:dataPath];
    
    NSData* responseData = [[NSData alloc] initWithContentsOfFile:mDataPath];
    //NSLog(@"%@",responseData);
    NSString *xpathQueryString = @"//channel/item/*";
    self.data = (NSMutableArray*)PerformXMLXPathQuery(responseData, xpathQueryString);
    [responseData release];
    
    
    //set local notification
    NSInteger count = [self.data count]/kItemPerSection;
    NSString* body = NSLocalizedString(@"NewContent","");
    const NSInteger kMinContentCount = 3;
    if (count>kMinContentCount) {
        body = [NSString stringWithFormat:@"%@|%@|%@",[self getTitle:0],[self getTitle:1],[self getTitle:2]];
    };
    
    [self scheduleLocalNotification:body];
    [self setLocalNotifictionFlag:YES];
#endif
}
- (void)loadData
{
    // Load the data.
#ifdef kSingleFile
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"lyrics" ofType:@"xml"];
#elif defined kHistory
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:[AppDelegate getMonthDay] ofType:@"xml"];
#else
    self.mCurrentFileName = [AppDelegate getTodayFileName];
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:self.mCurrentFileName ofType:@"txt"];
#endif
    
    //    if ([dataPath isEqualToString:mDataPath]) {
    //        return;
    //    }
    
    
    if ([mDataPath length] !=0 ) {
        [mDataPath release];
    }
    mDataPath = [[NSString alloc]initWithString:dataPath];
    
    NSData* responseData = [[NSData alloc] initWithContentsOfFile:dataPath];
    //NSLog(@"%@",responseData);
    NSString *xpathQueryString = @"//channel/item/*";
    self.data = (NSMutableArray*)PerformXMLXPathQuery(responseData, xpathQueryString);
    if (!self.data || self.data.count==0)
    {
        [mDataPath release];
        mDataPath = [[NSString alloc]initWithString:@"003_Unicode"];
        responseData = [[NSData alloc] initWithContentsOfFile:dataPath];
        self.data = (NSMutableArray*)PerformXMLXPathQuery(responseData, xpathQueryString);
    }
    [responseData release];
}
-(void)scheduleLocalNotification:(NSString*)alertBody
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSDate *now=[NSDate date];
#define kOneDayInSeconds 24*60*60
        notification.fireDate=[now dateByAddingTimeInterval:kOneDayInSeconds];
        NSLog(@"alertDate::%@",now);
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = notification.applicationIconBadgeNumber+1;
        notification.alertBody=alertBody;
        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
    }
    [notification release];
}
-(void)scheduleLocalNotification:(NSString*)alertBody delayTimeInterval:(NSTimeInterval)delay
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSDate *now=[NSDate date];
        notification.fireDate=[now dateByAddingTimeInterval:delay];
        NSLog(@"alertDate::%@",now);
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = notification.applicationIconBadgeNumber;
        notification.alertBody=alertBody;
        notification.hasAction = NO;
        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
    }
    [notification release];
}
/**
 parse ads config from server
 if failed to get configuration,just use the default config
 */
-(void)parseAdsConfig
{
    AdsConfig *config = [AdsConfig sharedAdsConfig];
    [config init:self.filePath];
}

#pragma mark * Core transfer code

// This is the code that actually does the networking.

- (BOOL)isReceiving
{
    return (self.connection != nil);
}
-(void) GetErr:(ASIHTTPRequest *)request
{
    NSLog(@"连接网络失败，请检查是否开启移动数据");
}

-(void) GetResult:(ASIHTTPRequest *)request
{
    NSLog(@"开启移动数据");
}
- (void)startAdsConfigReceive
// Starts a connection to download the current URL.
{
    if([AppDelegate isPurchased])
    {
        return;
    }
#if 0
    NSURL *url = [[NetworkManager sharedInstance] smartURLForString:AdsUrl];
    if(asiRequest==nil)
    {
        asiRequest = [ASIHTTPRequest requestWithURL:url];
        [asiRequest setDelegate:self];
        [asiRequest setDidFinishSelector:@selector(GetResult:)];
        [asiRequest setDidFailSelector:@selector(GetErr:)];
    }
    [asiRequest startAsynchronous];
#else
    BOOL                success;
    NSURL *             url;
    NSURLRequest *      request;
    if(self.connection!=nil)
    {
        return;
    }
    
    assert(self.connection == nil);         // don't tap receive twice in a row!
    assert(self.fileStream == nil);         // ditto
    assert(self.filePath == nil);           // ditto
    
    // First get and check the URL.
    
    url = [[NetworkManager sharedInstance] smartURLForString:AdsUrl];
    success = (url != nil);
    
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    
    if ((url != nil)) {
        
        // Open a stream for the file we're going to receive into.
        
        self.filePath = [[NetworkManager sharedInstance] pathForTemporaryFileWithPrefix:@"Get"];
        assert(self.filePath != nil);
        
        //remove this file first
        NSError* error;
        NSFileManager* fileMgr = [NSFileManager defaultManager];
        if ([fileMgr fileExistsAtPath:self.filePath]) {
            if (![fileMgr removeItemAtPath:self.filePath error:&error])
                NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        }
        self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:NO];
        assert(self.fileStream != nil);
        
        [self.fileStream open];
        
        // Open a connection for the URL.
        
        request = [NSURLRequest requestWithURL:url];
        assert(request != nil);
        
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
        assert(self.connection != nil);
        [[NetworkManager sharedInstance] didStartNetworkOperation];
    }
#endif
}
- (void)receiveDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        assert(self.filePath != nil);
        //load ads config
        [AdsConfig reset];
        [self parseAdsConfig];
        
        AdsConfig* config = [AdsConfig sharedAdsConfig];
        mShouldShowAdsWall = [config wallShouldShow];
        //show close ads
        if(mShouldShowAdsWall)
        {
            mAdsWalls = [config getAdsWalls];
            //notify observers
            if(![AppDelegate isPurchased])
                [[NSNotificationCenter defaultCenter]postNotificationName:kAdsUpdateDidFinishLoading object:nil];
        }
        
    }
    [[NetworkManager sharedInstance] didStopNetworkOperation];
}
- (void)stopReceiveWithStatus:(NSString *)statusString
// Shuts down the connection and displays the result (statusString == nil)
// or the error status (otherwise).
{
    if (self.connection != nil) {
        [self.connection cancel];
        self.connection = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    [self receiveDidStopWithStatus:statusString];
    self.filePath = nil;
}

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
// A delegate method called by the NSURLConnection when the request/response
// exchange is complete.  We look at the response to check that the HTTP
// status code is 2xx and that the Content-Type is acceptable.  If these checks
// fail, we give up on the transfer.
{
#pragma unused(theConnection)
    NSHTTPURLResponse * httpResponse;
    NSString *          contentTypeHeader;
    
    assert(theConnection == self.connection);
    
    httpResponse = (NSHTTPURLResponse *) response;
    assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
    
    if ((httpResponse.statusCode / 100) != 2) {
        [self stopReceiveWithStatus:[NSString stringWithFormat:@"HTTP error %zd", (ssize_t) httpResponse.statusCode]];
    } else {
        // -MIMEType strips any parameters, strips leading or trailer whitespace, and lower cases
        // the string, so we can just use -isEqual: on the result.
        contentTypeHeader = [httpResponse MIMEType];
        if (contentTypeHeader == nil) {
            [self stopReceiveWithStatus:@"No Content-Type!"];
        }
        //        else if ( ! [contentTypeHeader isEqual:@"image/jpeg"]
        //                   && ! [contentTypeHeader isEqual:@"image/png"]
        //                   && ! [contentTypeHeader isEqual:@"image/gif"] ) {
        //            [self stopReceiveWithStatus:[NSString stringWithFormat:@"Unsupported Content-Type (%@)", contentTypeHeader]];
        //        }
    }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)dataRev
// A delegate method called by the NSURLConnection as data arrives.  We just
// write the data to the file.
{
#pragma unused(theConnection)
    NSInteger       dataLength;
    const uint8_t * dataBytes;
    NSInteger       bytesWritten;
    NSInteger       bytesWrittenSoFar;
    
    assert(theConnection == self.connection);
    
    dataLength = [dataRev length];
    dataBytes  = [dataRev bytes];
    
    bytesWrittenSoFar = 0;
    do {
        bytesWritten = [self.fileStream write:&dataBytes[bytesWrittenSoFar] maxLength:dataLength - bytesWrittenSoFar];
        assert(bytesWritten != 0);
        if (bytesWritten == -1) {
            [self stopReceiveWithStatus:@"File write error"];
            break;
        } else {
            bytesWrittenSoFar += bytesWritten;
        }
    } while (bytesWrittenSoFar != dataLength);
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
// A delegate method called by the NSURLConnection if the connection fails.
// We shut down the connection and display the failure.  Production quality code
// would either display or log the actual error.
{
#pragma unused(theConnection)
#pragma unused(error)
    assert(theConnection == self.connection);
    
    [self stopReceiveWithStatus:@"Connection failed"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
// A delegate method called by the NSURLConnection when the connection has been
// done successfully.  We shut down the connection with a nil status, which
// causes the image to be displayed.
{
#pragma unused(theConnection)
    assert(theConnection == self.connection);
    
    [self stopReceiveWithStatus:nil];
}

-(void)releaseMemory
{
    self.data = nil;
    //self.mCurrentFileName = nil;
    [[AdsConfig sharedAdsConfig] release];
}
- (void)dealloc
{
    if ([mDataPath length] !=0 ) {
        [mDataPath release];
    }
    [mTrackViewUrl release];
    [mTrackName release];
    [navigationController release];
    //[window release];
    [self releaseMemory];
    [super dealloc];
}

+(int)getDayCountBeforeMonth:(int)month
{
    int c = 0;
    switch (month) {
        case 1:
            c = 31;
            break;
            
        case 2:
        {
            c = 28 + [AppDelegate getDayCountBeforeMonth:month-1];
        }
            break;
            
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
        {
            c = 31 + [AppDelegate getDayCountBeforeMonth:month-1];
        }
            break;
            
        case 4:
        case 6:
        case 9:
        case 11:
        {
            c = 30 + [AppDelegate getDayCountBeforeMonth:month-1];
        }
            break;
            
        default:
            break;
    }
    return c;
}
+(int)getTodayOffset:(int)month day:(int)day
{
    return [AppDelegate getDayCountBeforeMonth:month]+day;
}
+(NSString*)getTodayFileName
{

    //get today
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit ;
    NSDateComponents *dd = [cal components:unitFlags fromDate:[NSDate date]];
    
    //get date count before today
    int count = ([dd month]==1)?[dd day]:[AppDelegate getTodayOffset:[dd month]-1 day:[dd day]];
    count %= kDayPerYear;
    //get file name
    NSString* fileName = [NSString stringWithFormat:@"%.03d_Unicode",count];
    NSLog(@"%@",fileName);
    return fileName;
}
+(NSString*)getTomorrowFileName
{
    //get today
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit ;
    NSDateComponents *dd = [cal components:unitFlags fromDate:[AppDelegate getTomorrowDate]];
    //get date count before today
    int count = ([dd month]==1)?[dd day]:[AppDelegate getTodayOffset:[dd month]-1 day:[dd day]];
    count %= kDayPerYear;
    //get file name
    NSString* fileName = [NSString stringWithFormat:@"%.03d_Unicode",count];
    NSLog(@"%@",fileName);
    return fileName;
}
+(NSString*)getMonthDay
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit ;
    NSDateComponents *dd = [cal components:unitFlags fromDate:[NSDate date]];
    
#define kTen 10
    int month = [dd month];
    int day = [dd day];
    
    NSString* ret =  [NSString stringWithFormat:@"%d%d",month,day];
    
    return ret;
}
+(NSDate*)getTomorrowDate
{
    const NSTimeInterval kOneDayTimeInterval = 24*60*60;
    return [NSDate dateWithTimeIntervalSinceNow:kOneDayTimeInterval];
}
+(NSString*)getMonthDay4Tomorrow
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit ;
    NSDateComponents *dd = [cal components:unitFlags fromDate:[AppDelegate getTomorrowDate]];
    
    return [NSString stringWithFormat:@"%d%d",[dd month],[dd day]];
}

- (NSString *)getContent:(const NSUInteger)index
{
    return [self getNodeContent:index firstContent:NO];
}
// Retrieves the content of an XML node, such as the temperature, wind,
// or humidity in the weather report.
//
-(NSString *)getTitle:(const NSUInteger)index
{
    return [self getNodeContent:index firstContent:YES];
}
-(NSString*)getNodeContent:(const NSUInteger)index firstContent:(BOOL) first
{
    NSString* result = @"";
    const NSUInteger plusCount = 2;//
    const NSUInteger contentIndex = index*plusCount+((YES==first)?0:1);
    if(contentIndex < [data count])
    {
        NSDictionary* dict = [data objectAtIndex:contentIndex];
        result = [dict objectForKey:@"nodeContent"];
    }
    return result;
}

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

#pragma mark adswall
-(NSString*)currentAdsWall
{
    if(mAdsWalls)
    {
        //reset index
        if(mAdsWallIndex >= [mAdsWalls count])
        {
            mAdsWallIndex = 0;
        }
        
        //return and prepare for next
        return [mAdsWalls objectAtIndex:mAdsWallIndex++];
    }
    //default wall
    return AdsPlatformDefaultWall;
}
-(void)enableShouldShowAdsWall
{
    [self setShouldShowAdsWall:YES enableForNext:NO];
}
-(void)setShouldShowAdsWall:(BOOL)show
{
    [self setShouldShowAdsWall:show enableForNext:NO];
}
-(void)setShouldShowAdsWall:(BOOL)show enableForNext:(BOOL)enable
{
    mShouldShowAdsWall = show;
    if(enable)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        //prepare for the next time to show ads wall
        [self performSelector:@selector(enableShouldShowAdsWall) withObject:self afterDelay:kAdsWallShowDelayTime];
    }
}
-(BOOL)shouldShowAdsWall
{
    return mShouldShowAdsWall;
}


#pragma mark splashScreen
-(void)splashScreenStart
{
    fView =[[UIImageView alloc]initWithFrame:self.window.frame];//初始化fView
    fView.image=[UIImage imageNamed:@"640_960"];//图片f.png 到fView
    
    zView=[[UIImageView alloc]initWithFrame:self.window.frame];//初始化zView
    zView.image=[UIImage imageNamed:@"640_960_splash"];//图片z.png 到zView
    
    rView=[[UIView alloc]initWithFrame:self.window.frame];//初始化rView
    
    [rView addSubview:fView];//add 到rView
    [rView addSubview:zView];//add 到rView
    
    [self.window addSubview:rView];//add 到window
    
    [self performSelector:@selector(TheAnimation) withObject:nil afterDelay:2];//秒后执行TheAnimation
    
}

- (void)TheAnimation{
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.7 ;  // 动画持续时间(秒)
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;//淡入淡出效果
    
    NSUInteger f = [[rView subviews] indexOfObject:fView];
    NSUInteger z = [[rView subviews] indexOfObject:zView];
    [rView exchangeSubviewAtIndex:z withSubviewAtIndex:f];
    
    [[rView layer] addAnimation:animation forKey:@"animation"];
    
    [self performSelector:@selector(ToUpSide) withObject:nil afterDelay:2];//2秒后执行TheAnimation
}


- (void)ToUpSide {
    
    [self moveToUpSide];//向上拉界面
    
}

- (void)moveToUpSide {
    [UIView animateWithDuration:0.7 //速度0.7秒
                     animations:^{//修改rView坐标
                         rView.frame = CGRectMake(self.window.frame.origin.x,
                                                  -self.window.frame.size.height,
                                                  self.window.frame.size.width,
                                                  self.window.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [rView removeFromSuperview];
                     }];
    
}

#pragma mark openURL

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
    //return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
    //return  [WXApi handleOpenURL:url delegate:self];
}

#pragma mark WXApiDelegate
/*! @brief 收到一个来自微信的请求，处理完后调用sendResp
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        //[self onRequestAppMessage];
        NSString *strTitle = [NSString stringWithFormat:@"消息来自微信"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strTitle delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        [self onShowMediaMessage:temp.message];
    }
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送提示"];
        NSString *strMsg = [NSString stringWithFormat:@"发送成功"];
        if (resp.errCode!=WXSuccess) {
            strMsg = [resp errStr];
        }
        else
        {
            //if([AdsConfig isAdsOn])
            {
                strMsg = [strMsg stringByAppendingString:@"。恭喜：作为奖励，已经永久关闭广告。"];
                [AdsConfig setAdsOn:NO type:kPermanent];
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        //NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
        NSString *strMsg = [NSString stringWithFormat:@"Auth成功"];
        if (resp.errCode!=WXSuccess) {
            strMsg = [resp errStr];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

#pragma mark Weixin SendAppContent
- (void) shareByShareKit:(NSString*)title description:(NSString*)content image:(UIImage*)image
{
    UIViewController*ctrl = [[UIApplication sharedApplication]keyWindow].rootViewController;
    id<ISSPublishContent> publishContent = [ShareSDK publishContent:content defaultContent:content
                                                              image:image imageQuality:0.8
                                                          mediaType:SSPublishContentMediaTypeApp title:title
                                                                url:mTrackViewUrl                                                        musicFileUrl:nil
                                                            extInfo:nil fileData:nil];
    
    NSArray* shareList = [ShareSDK getShareListWithType:
                          ShareTypeSinaWeibo, /**< 新浪微博 */
                          ShareTypeTencentWeibo, /**< 腾讯微博 */
                          ShareTypeSohuWeibo, /**< 搜狐微博 */
                          ShareType163Weibo, /**< 网易微博 */
                          ShareTypeDouBan, /**< 豆瓣社区 */
                          ShareTypeQQSpace, /**< QQ空间 */
                          ShareTypeRenren, /**< 人人网 */
                          ShareTypeKaixin, /**< 开心网 */
                          ShareTypePengyou, /**< 朋友网 */
                          ShareTypeFacebook, /**< Facebook */
                          ShareTypeTwitter, /**< Twitter */
                          ShareTypeEvernote, /**< 印象笔记 */
                          ShareTypeFoursquare, /**< Foursquare */
                          ShareTypeGooglePlus, /**< Google＋ */
                          ShareTypeInstagram, /**< Instagram */
                          ShareTypeLinkedIn, /**< LinkedIn */
                          ShareTypeTumbir, /**< Tumbir */
                          ShareTypeMail, /**< 邮件分享 */
                          ShareTypeSMS, /**< 短信分享 */
                          ShareTypeAirPrint, /**< 打印 */
                          ShareTypeCopy, /**< 拷贝 */
                          ShareTypeWeixiSession, /**< 微信好友 */
                          ShareTypeWeixiTimeline, /**< 微信朋友圈 */
                          ShareTypeQQ /**< QQ */];
    
    [ShareSDK showShareActionSheet:ctrl shareList:shareList
                           content:publishContent statusBarTips:YES
                   oneKeyShareList:[NSArray defaultOneKeyShareList]
                    shareViewStyle:ShareViewStyleDefault
                    shareViewTitle:@"内容分享"
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo>
                                     statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    [Flurry logEvent:kShareByShareKit];
                                    
                                    [AdsConfig setAdsOn:NO type:kPermanent];

                                    NSLog(@"成功!");
                                }
                                else if(state == SSPublishContentStateFail) {
                                    NSLog(@"失败!"); }
                            }];
}
//scene:WXSceneSession;//WXSceneTimeline
- (void) sendAppContent:(NSString*)title description:(NSString*)description image:(NSString*)name scene:(int)scene
{
    if (![WXApi isWXAppInstalled]) {
        [self openWeixinInAppstore];
        return;
    }
    // 发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
//    if(name && [name length]>0)
//    {
//        [message setThumbImage:[UIImage imageNamed:name]];
//    }
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    //ext.extInfo = @"<xml>test</xml>";
    ext.url = self.mTrackViewUrl;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
    
    [Flurry logEvent:kShareByWeixin];
    
    [AdsConfig setAdsOn:NO type:kPermanent];
}

-(void)openWeixinInAppstore
{
    NSString* title = @"提示";
    NSString* msg = @"您需要安装微信后，才能分享，现在去下载？";
    NSString* okMsg =  NSLocalizedString(@"Ok", "");
    NSString* cancelMsg =  NSLocalizedString(@"Cancel", "");
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:okMsg otherButtonTitles:cancelMsg, nil]autorelease];
    [alert show];
    mDialogType = kOpenWeixin;
}

#pragma mark Weixin OnReq
-(void) onShowMediaMessage:(WXMediaMessage *) message
{
    // 微信启动， 有消息内容。
    [self viewContent:message];
}
- (void) viewContent:(WXMediaMessage *) msg
{
    //显示微信传过来的内容
    WXAppExtendObject *obj = msg.mediaObject;
    
    NSString *strTitle = [NSString stringWithFormat:@"消息来自微信"];
    NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

+(BOOL)isPurchased
{
#ifdef __IN_APP_SUPPORT__
    BOOL r = [[InAppRageIAPHelper sharedHelper].purchasedProducts containsObject:kInAppPurchaseProductName];
    NSLog(@"isPurchased:%d",r);
    return r;
#else
    return NO;
#endif
}

#pragma mark HTTPRequest
-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown setAllowResumeForFileDownloads:(BOOL)allow
{
    //如果不存在则创建临时存储目录
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[CommonHelper getTempFolderPath]])
    {
        [fileManager createDirectoryAtPath:[CommonHelper getTempFolderPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    //按照获取的文件名获取临时文件的大小，即已下载的大小
    fileInfo.isFistReceived=YES;
    NSData *fileData=[fileManager contentsAtPath:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]]];
    NSInteger receivedDataLength=[fileData length];
    fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%d",receivedDataLength];
    //url encoding
    NSString* fileURL = ([fileInfo.fileURL rangeOfString:@"%"].length==0)?[fileInfo.fileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:fileInfo.fileURL;
    //如果文件重复下载或暂停、继续，则把队列中的请求删除，重新添加
    for(ASIHTTPRequest *tempRequest in self.downinglist)
    {
        FileModel *f =(FileModel *)[tempRequest.userInfo objectForKey:@"File"];
        NSString* url = ([f.fileURL rangeOfString:@"%"].length==0)?[f.fileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:f.fileURL;
        if([url isEqual:fileURL])
        {
            [tempRequest cancel];
            [downinglist removeObject:tempRequest];
            break;
        }
    }
    
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fileURL]];
    request.delegate=self;
    [request setDownloadDestinationPath:[[CommonHelper getTargetFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileInfo.fileName]]];
    [request setTemporaryFileDownloadPath:[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]]];
    [request setDownloadProgressDelegate:self];
    //    [request setDownloadProgressDelegate:downCell.progress];//设置进度条的代理,这里由于下载是在AppDelegate里进行的全局下载，所以没有使用自带的进度条委托，这里自己设置了一个委托，用于更新UI
    [request setAllowResumeForFileDownloads:allow];//支持断点续传
    if(isBeginDown)
    {
        fileInfo.isDownloading=YES;
    }
    else
    {
        fileInfo.isDownloading=NO;
    }
    [request setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信息
    [request setTimeOutSeconds:30.0f];
    if (isBeginDown) {
        [request startAsynchronous];
    }
    
    //    [downinglist addObject:request];
    
    [request release];
}
-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown
{
    [self beginRequest:fileInfo isBeginDown:isBeginDown setAllowResumeForFileDownloads:YES];
}
#pragma mark ASIHttpRequestDelegate

//出错了，如果是等待超时，则继续下载
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error=[request error];
    NSLog(@"ASIHttpRequest出错了!%@",error);
    FileModel *fileModel=[request.userInfo objectForKey:@"File"];
    if(fileModel && fileModel.notificationName && fileModel.notificationName.length)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:fileModel.notificationName object:error];
    }
}

-(void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"开始了!");
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    if(fileInfo)
    {
        fileInfo.fileType=[[request responseHeaders] objectForKey:@"Content-Type"];
        fileInfo.fileSize=[CommonHelper getFileSizeString:[[request responseHeaders] objectForKey:@"Content-Length"]];
        NSLog(@"收到回复了！contentType:%@--fileSize:%@",fileInfo.fileType,fileInfo.fileSize);
        
        //文件开始下载时，把文件名、文件总大小、文件URL写入文件，上海滩.rtf中间用逗号隔开
        /*NSString *writeMsg=[fileInfo.fileName stringByAppendingFormat:@",%@,%@",fileInfo.fileSize,fileInfo.fileURL];
         NSRange range = [fileInfo.fileName rangeOfString:@"."];
         NSString *name=(range.length==0)?fileInfo.fileName:[fileInfo.fileName substringToIndex:range.location];
         [writeMsg writeToFile:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",name]] atomically:YES encoding:NSUTF8StringEncoding error:nil];*/
        
        [request setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信息
        
    }
}


//1.实现ASIProgressDelegate委托，在此实现UI的进度条更新,这个方法必须要在设置[request setDownloadProgressDelegate:self];之后才会运行
//2.这里注意第一次返回的bytes是已经下载的长度，以后便是每次请求数据的大小
//费了好大劲才发现的，各位新手请注意此处
-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    if(fileInfo && !fileInfo.isFistReceived)
    {
        fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%lld",[fileInfo.fileReceivedSize longLongValue]+bytes];
    }
    fileInfo.isFistReceived=NO;
}

//将正在下载的文件请求ASIHttpRequest从队列里移除，并将其配置文件删除掉,然后向已下载列表里添加该文件对象
-(void)requestFinished:(ASIHTTPRequest *)request
{
    const NSUInteger kHTTPOK =  200;
    //[self playDownloadFinishSound];
    FileModel *fileInfo=(FileModel *)[request.userInfo objectForKey:@"File"];
    NSLog(@"fileInfo refCount:%d",[fileInfo retainCount]);
    fileInfo.fileType = [[request responseHeaders] objectForKey:@"Content-Type"];
    
    NSRange range=[fileInfo.fileName rangeOfString:@"."];
    NSString *name=(range.length==0)?fileInfo.fileName:[fileInfo.fileName substringToIndex:range.location];
    if (!fileInfo.destPath) {
        fileInfo.destPath = name;
    }
    NSString *configPath=[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[name stringByAppendingString:@".rtf"]];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    
    if([fileManager fileExistsAtPath:configPath])//如果存在临时文件的配置文件
    {
        [fileManager removeItemAtPath:configPath error:&error];
    }
    if(!error)
    {
        NSLog(@"%@",[error description]);
    }
    if(kHTTPOK != request.responseStatusCode)
    {
        //pop up a tip only
        //[[NSNotificationCenter defaultCenter]postNotificationName:kFileDownloadFail object:fileInfo];
    }
    else
    {
        //add to operation queue
        NSInvocationOperation* operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(saveDownloadedResources:) object:fileInfo];
        [mOperationQueue addOperation:operation];
        [operation release];
        
        
        [finishedlist addObject:fileInfo];
        [downinglist removeObject:request];
        [downinglist removeObject:request];
        
    }
}

#pragma mark after-download
-(void)saveDownloadedResources:(FileModel*)fileModel
{
    NSLog(@"saveDownloadedResources:%@",fileModel.fileName);
    
    NSString *documentsDirectory = [CommonHelper getTargetFolderPath];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:fileModel.fileName];
    NSFileManager* fileManager =[NSFileManager defaultManager];
    NSRange range=[fileModel.fileName rangeOfString:@"."];
    NSString *name=(range.length==0)?fileModel.fileName:[fileModel.fileName substringToIndex:range.location];
    if (!fileModel.destPath) {
        fileModel.destPath = name;
    }
    
    //unzip(zip,rar,txt)
    NSString* desFilePath = [CommonHelper getTargetBookPath:fileModel.destPath];
    [CommonHelper extractFile:fileName toFile:[CommonHelper getTargetBookPath:fileModel.destPath] fileType:fileModel.fileType];
    
    [fileManager removeItemAtPath:fileName error:nil];
    
    if(fileModel.notificationName && fileModel.notificationName.length)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:fileModel.notificationName object:[desFilePath stringByAppendingPathComponent:fileModel.fileName]];
    }
}
@end

