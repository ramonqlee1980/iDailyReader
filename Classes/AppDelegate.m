
#import "AppDelegate.h"
#import "RootViewController.h"
#import "CDetailData.h"
#import "XPathQuery.h"//another xml parser wrapper
#import "AdsConfig.h"
#import "NetworkManager.h"
#import "ASIFormDataRequest.h"
#import "RootViewController.h"
#import "Flurry.h"
//#import "JSONKit.h"
#import "RootViewController.h"
#import "SoftRcmListViewController.h"
#import "FlipViewController.h"
#import "iRate.h"
#import "MainViewController.h"

#define kLocalNotificationSet @"LocalNotificationSet"
#define kAdsWallShowDelayTime 30//seconds

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
#define kLaunchTime @"kLaunchTime"
#define kRatingWhenLaunchTime 5
+(BOOL)shouldPromptRating
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    NSString* switchVal = [defaultSetting stringForKey:kLaunchTime];
    return (switchVal!=nil && (switchVal.integerValue % kRatingWhenLaunchTime)==0);
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
    
    [defaultSetting setValue:[NSString stringWithFormat:@"%d",++count] forKey:kLaunchTime];
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(add2Favorite:) name:kAdd2Favorite object:nil];
    //flurry
    [Flurry startSession:kFlurryID];
    [self loadData];
    
    // Override point for customization after application launch.
    window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController* v = [[RootViewController alloc]initWithNibName:@"RootViewController" bundle:nil];
    UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:v];
    SoftRcmListViewController* recommendCtrl = [[SoftRcmListViewController alloc]initWithStyle:UITableViewStyleGrouped];
    FlipViewController *flip = [[FlipViewController alloc]initWithNibName:@"FlipViewController" bundle:nil];
    UINavigationController* navi2 = [[UINavigationController alloc]initWithRootViewController:flip];
    MainViewController* funZone=[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
#if 1
    NSArray* controllers = [NSArray arrayWithObjects:navi,funZone,navi2,recommendCtrl,nil];
#else
    NSArray* controllers = [NSArray arrayWithObjects:navi,funZone,navi2, nil];
#endif
    
    UITabBarController* tabCtrl = [[UITabBarController alloc]init];
    tabCtrl.viewControllers = controllers;
    
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController= tabCtrl;
    //[self.window addSubview:navi.view];
    [self.window makeKeyAndVisible];
    
    [v release];
    [flip release];
    [recommendCtrl release];
    [navi release];
    [navi2 release];
    [funZone release];
    [controllers release];
    [tabCtrl release];
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    _EnterBylocalNotification = (localNotification!=nil);
    if(_EnterBylocalNotification)
    {
        [Flurry logEvent:kEnterBylocalNotification];
        //cancel notification flag
        [self cancelLocalNotificationFlag];
    }
    application.applicationIconBadgeNumber = 0;
    
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _EnterBylocalNotification = NO;
    NSLog(@"applicationDidEnterBackground");
    
#ifndef kSingleFile
    //set local notification to pop up a tip
    const NSTimeInterval kDelay = 0;//1;
    NSString* popContent = NSLocalizedString(@"appFriendlyTip","");
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self scheduleLocalNotification:popContent delayTimeInterval:kDelay];
        
    //tomorrow's tip
    [self scheduleDailyNofification];
#endif
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
    
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mTrackViewUrl]];
    }
}
-(void)checkUpdate
{
    //not published on appstore
    if(kAppIdOnAppstore.length==0)
    {
        return;
    }
    NSString *version = @"";
    NSString* updateLookupUrl = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kAppIdOnAppstore];
    NSURL *url = [NSURL URLWithString:updateLookupUrl];
    ASIFormDataRequest* versionRequest = [ASIFormDataRequest requestWithURL:url];
    [versionRequest setRequestMethod:@"GET"];
    [versionRequest setDelegate:self];
    [versionRequest setTimeOutSeconds:150];
    [versionRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    [versionRequest startSynchronous];
    
    //Response string of our REST call
    NSString* jsonResponseString = [versionRequest responseString];
    
    NSDictionary *loginAuthenticationResponse = [jsonResponseString objectFromJSONString];
    
    NSArray *configData = [loginAuthenticationResponse valueForKey:@"results"];
    NSString* releaseNotes;
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
    }
    
    [Flurry logEvent:[NSString stringWithFormat:@"localVersion:%@-newVersion:%@",localVersion,version]];
    
}
// 比较oldVersion和newVersion，如果oldVersion比newVersion旧，则返回YES，否则NO
// Version format[X.X.X]
+(BOOL)CompareVersionFromOldVersion : (NSString *)oldVersion
                         newVersion : (NSString *)newVersion
{
    NSArray*oldV = [oldVersion componentsSeparatedByString:@"."];
    NSArray*newV = [newVersion componentsSeparatedByString:@"."];
    
    if (oldV.count == newV.count) {
        for (NSInteger i = 0; i < oldV.count; i++) {
            NSInteger old = [(NSString *)[oldV objectAtIndex:i] integerValue];
            NSInteger new = [(NSString *)[newV objectAtIndex:i] integerValue];
            if (old < new) {
                return YES;
            }
        }
        return NO;
    } else {
        return NO;
    }
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
    
    if ([dataPath isEqualToString:mDataPath]) {
        return;
    }
    
    [self checkUpdate];
    [self startAdsConfigReceive];
    
    if ([mDataPath length] !=0 ) {
        [mDataPath release];
    }
    mDataPath = [[NSString alloc]initWithString:dataPath];
    
    NSData* responseData = [[NSData alloc] initWithContentsOfFile:mDataPath];
    //NSLog(@"%@",responseData);
    NSString *xpathQueryString = @"//channel/item/*";
    self.data = (NSMutableArray*)PerformXMLXPathQuery(responseData, xpathQueryString); 
    
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
    int count = ([dd month]==1)?[dd day]:[AppDelegate getTodayOffset:[dd month] day:[dd day]];
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
    int count = ([dd month]==1)?[dd day]:[AppDelegate getTodayOffset:[dd month] day:[dd day]];
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
    
    return [NSString stringWithFormat:@"%d%d",[dd month],[dd day]];
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
@end

