#import "TextViewController.h"
#import "AppDelegate.h" // for SharedAdBannerView macro
#import "Constants.h"
#import "MobiSageSDK.h"
#import "AdsConfig.h"
#import "DoMobView.h"
#import "RewardedWallViewController.h"
#import "AdsConfig.h"
#import "YouMiView.h"
#import "CaseeAdView.h"
#import "GADBannerView.h"
#import "Flurry.h"
#import "AddNewNoteViewController.h"
#import "MobiSageSDK.h"
#import "WQAdView.h"
#import "WapsOffer/AppConnect.h"

@interface TextViewController()

-(void)setRightAdButton:(BOOL)closeAdsButton;
-(void)closeAds:(BOOL)popClosingTip;
-(void)closeAdsTemp;


@end

@implementation TextViewController

@synthesize contentView,textView,index,mAdView,mAdsSwitchBarItem;
@synthesize recmdView = _recmdView;
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
        immobView* imView = (immobView*)(mWallOpened?mWall:mAdView);       
        [self.view addSubview:imView];        
        [imView immobViewDisplay];
        [self adjustAdSize];
    }
    else {
        //UIAlertView *uA=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前广告不可用" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
        //[uA show];
        //[uA release];
    }
    
}
/**
 * Called when an ad is clicked and about to return to the application. </br>
 * 当（全屏）广告被点击或者被关闭，将要返回返回主程序见面时被调用。
 *
 */
- (void) onDismissScreen:(immobView *)immobView
{
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark - 
#pragma mark ad delegate for Casee
-(NSString*) appId {
    BOOL isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);    
    return isPad?kCaseeIPadId:kCaseeIPhoneId;
}

-(void)setRightAdButton:(BOOL)closeAdsButton
{    
    NSString* title = closeAdsButton?NSLocalizedString(@"AdsWallSwitch",@""):NSLocalizedString(@"Donate",@"");
    if (!closeAdsButton) {//hide this button
        return;
    }
    UIBarButtonItem *showOffersItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(closeAd:)];
    self.navigationItem.rightBarButtonItem = showOffersItem;
    [showOffersItem release];
}

-(void)loadAd
{
    mAdsWallShouldShow = NO;
    AdsConfig* config = [AdsConfig sharedAdsConfig];     
    if ([AdsConfig isAdsOff] ) {        
        [self setRightAdButton:NO];
        return;
    }  
    
    
    //show close ads 
    mAdsWallShouldShow = [config wallShouldShow];
    [self setRightAdButton:mAdsWallShouldShow];
    
#ifdef k91Appstore//for 91 app,this is a top level switch
    if(!mAdsWallShouldShow)
    {
        return;
    }
#endif
    
    
    NSString* currentAds = [config getCurrentAd];
    
    while (![config isCurrentAdsValid]) {
        currentAds = [config toNextAd];
        //last one?
        if ([config getCurrentIndex]==[config getAdsCount]-1) {
            if (![config isCurrentAdsValid]) {
                currentAds = @"";
            }
            break;
        }
    }   
    if ([currentAds length]==0) {
        return;
    }
    NSLog(@"getCurrentAd()::%@--(%d,%d)",currentAds,config.mCurrentIndex,[config getAdsCount]);
    
    //iPad or not
    BOOL isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);   
    if(NSOrderedSame==[AdsPlatformImmob caseInsensitiveCompare:currentAds])
    {
        immobView* adView_Banner=[[immobView alloc] initWithAdUnitID:kImmobBannerId];
        adView_Banner.delegate=self;
        self.mAdView = adView_Banner;
        [adView_Banner release];
        [adView_Banner immobViewRequest];
        
    }
    else if(NSOrderedSame==[AdsPlatformWQMobile caseInsensitiveCompare:currentAds])
    {
        //        CGRect rc = CGRectZero;
        //        rc.size = WQMOB_SIZE_320x48;
        WQAdView* adView = [WQAdView requestAdByLocation:WQ_LOCATION_TOP withSize:WQMOB_SIZE_320x48 withDelegate:self];	//创建广告控件
        self.mAdView = adView;
        [self.view addSubview:adView];	//添加广告控件至视图中
        [adView startRequestAd];	//开始获取广告
        [adView release];
    }
    else if(NSOrderedSame==[AdsPlatformAdmob caseInsensitiveCompare:currentAds])
    {
        // 在屏幕底部创建标准尺寸的视图。
        CGSize size = isPad?GAD_SIZE_728x90:GAD_SIZE_320x50;
        GADBannerView* bannerView_ = [[GADBannerView alloc]
                                      initWithFrame:CGRectMake(0.0,
                                                               0.0,
                                                               //self.view.frame.size.height -size.height,
                                                               size.width,
                                                               size.height)];
        
        // 指定广告的“单元标识符”，也就是您的 AdMob 发布商 ID。
        bannerView_.adUnitID = kAdmobID;
        
        // 告知运行时文件，在将用户转至广告的展示位置之后恢复哪个 UIViewController 
        // 并将其添加至视图层级结构。
        bannerView_.rootViewController = self;       
        [self.view addSubview:bannerView_];
        
        // 启动一般性请求并在其中加载广告。
        [bannerView_ loadRequest:[GADRequest request]];
        
        self.mAdView = bannerView_;        
        [bannerView_ release];
    }
    else if(NSOrderedSame==[AdsPlatformCasee caseInsensitiveCompare:currentAds])
    {
        int width = isPad?728:320;
        int height = isPad?90:48;
        CaseeAdView* adseeview = [CaseeAdView adViewWithDelegate:self caseeRectStyle:isPad?caseeAdSizeIdentifier_728x90:caseeAdSizeIdentifier_320x48];
        adseeview.frame= CGRectMake(0, 0, width, height);
        self.mAdView = adseeview;
        [self.view addSubview:adseeview];
    }
    else if(NSOrderedSame==[AdsPlatformDomob caseInsensitiveCompare:currentAds])
    { 
        
        DoMobView* domobView = [DoMobView requestDoMobViewWithSize:isPad?DOMOB_SIZE_748x110:DOMOB_SIZE_320x48 WithDelegate:self];
        self.mAdView = domobView;
        
    }
    else if(NSOrderedSame==[AdsPlatformYoumi caseInsensitiveCompare:currentAds])
    {
        //disable location ability
        [YouMiView setShouldGetLocation:NO];
        // add youmi ad
        YouMiView* youmiAdView = [[YouMiView alloc] initWithContentSizeIdentifier:isPad?YouMiBannerContentSizeIdentifier728x90:YouMiBannerContentSizeIdentifier320x50 delegate:nil];
        
        ////////////////[必填]///////////////////
        // 设置APP ID 和 APP Secret
        youmiAdView.appID = kYoumiId;
        youmiAdView.appSecret = kYoumiSecret;
        
        ////////////////[可选]///////////////////
        // 设置您应用的版本信息
        youmiAdView.appVersion = @"1.0";
        
        // 设置您应用的推开渠道号
        // adView_200x200.channelID = 1;
        
        // 设置您应用的广告请求模式
        youmiAdView.testing = NO;
        
        self.mAdView = youmiAdView;
        [self.view addSubview:youmiAdView];
        [youmiAdView start];
        [youmiAdView release];
        
    }
    
//    else if(NSOrderedSame==[AdsPlatformWooboo caseInsensitiveCompare:currentAds])
//    {
//        CommonADView* myCommonADView = [[CommonADView alloc] initWithPID:kWoobooPublisherID
//                                                                  status:NO
//                                                               locationX:0 
//                                                               locationY:0 
//                                                             displayType:CommonBannerScreen 
//                                                       screenOrientation:CommonOrientationPortrait];
//        self.mAdView = myCommonADView;
//        [self.view addSubview:myCommonADView];
//        [myCommonADView release];
//        CGRect frame = [UIScreen mainScreen].bounds;
//        [myCommonADView setDisplayType:CommonBannerScreen 
//                             locationX:(frame.size.width-myCommonADView.frame.size.width)/2 
//                             locationY:myCommonADView.frame.origin.y];
//        [myCommonADView startADRequest];
//    }    
//    else if(NSOrderedSame==[AdsPlatformWiyun caseInsensitiveCompare:currentAds])
//    {
//        NSString* publisherID = kWiyunID_iPhone;
//        WiAdViewStyle style = kWiAdViewStyleBanner320_50;
//        if(isPad)
//        {
//            publisherID = kWiyunID_iPad;
//            style = kWiAdViewStyleBanner768_110;
//        }
//        
//        //创建广告窗口
//        WiAdView* adView = [WiAdView adViewWithResId:publisherID style:style];
//        self.mAdView = adView;
//        //设置Delegate对象
//        //adView.delegate = self;
//        //设置广告背景色
//        adView.adBgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
//        adView.adTextColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0f];
//        //把广告窗口加入窗口View
//        [self.view addSubview:adView];
//        //开始请求广告窗口
//        [adView requestAd];
//    }
    else if(NSOrderedSame==[AdsPlatformMobisageRecommend caseInsensitiveCompare:currentAds] ||
            NSOrderedSame==[AdsPlatformMobisageRecommendOther caseInsensitiveCompare:currentAds])
    {
        if (self.recmdView == nil) {
            BOOL otherMobisage = (NSOrderedSame==[AdsPlatformMobisageRecommendOther caseInsensitiveCompare:currentAds]);
            [[MobiSageManager getInstance] setPublisherID:otherMobisage?kMobiSageIDOther_iPhone:kMobiSageID_iPhone];
            //NSLog(@"MobisagePulisherID: %@",[MobiSageManager getInstance]->m_publisherID);
            
            self.recmdView = [[MobiSageRecommendView alloc]initWithDelegate:self andImg:nil];
            CGFloat height = self.navigationController.navigationBar.frame.size.height;//self.recmdView.frame.size.height
            self.recmdView.frame = CGRectMake(0, 0, self.recmdView.frame.size.width, height);
            if ([self.recmdView respondsToSelector:@selector(setTitle:)]) {
                [self.recmdView setTitle:@"免费热门应用推荐"];
            }
            if([self.recmdView respondsToSelector:@selector(setSubtitle:)])
            {
                [self.recmdView setSubtitle:@"游戏，小说，团购，MM美图..."];
            }  
            if([self.recmdView respondsToSelector:@selector(setBanner:)])
            {
                [self.recmdView setBanner:YES];
            }
            
        }
        self.mAdView = self.recmdView; 
        [self.view addSubview:self.recmdView];
    }
    else //if(NSOrderedSame==[AdsPlatformMobisage caseInsensitiveCompare:currentAds])
    {            
        //    //一般Banner广告，320X40的banner广告，设置广告轮显效果
        //other mobisage?
        BOOL otherMobisage = (NSOrderedSame==[AdsPlatformMobisageOther caseInsensitiveCompare:currentAds]);
        [[MobiSageManager getInstance] setPublisherID:otherMobisage?kMobiSageIDOther_iPhone:kMobiSageID_iPhone];
        //NSLog(@"MobisagePulisherID: %@",[MobiSageManager getInstance]->m_publisherID);
        int width = 320;
        int height = 40;
        int marginTop = 0;
        if (isPad) {
            width = 748;
            height = 110;
        }
        
        MobiSageAdBanner * adBanner = [[MobiSageAdBanner alloc] initWithAdSize:isPad?Ad_728X90:Ad_320X50];
        self.mAdView = adBanner;
        //设置广告轮显方式
        [adBanner setSwitchAnimeType:Random];
        adBanner.frame = CGRectMake(([[UIScreen mainScreen] applicationFrame].size.width -width)/2, marginTop, width, height);
        [self.view addSubview:adBanner];
        [adBanner release];            
    }  
    CGSize adSize = mAdView.frame.size;	    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    int screenWidth = [[UIScreen mainScreen]bounds].size.width;
    if (UIDeviceOrientationIsLandscape(deviceOrientation))
        screenWidth = [[UIScreen mainScreen]bounds].size.height;
    CGRect frame = mAdView.frame;
	frame.origin.x = (screenWidth - adSize.width)/2;
    //mAdView.frame = frame;
    
    //index adjusted
    [config toNextAd];
    while (![config isCurrentAdsValid]) {
        [config toNextAd];
    }
}
#pragma mark -
#pragma mark DoMobDelegate methods
- (UIViewController *)domobCurrentRootViewControllerForAd:(DoMobView *)doMobView
{
	return self;
}

- (NSString *)domobPublisherIdForAd:(DoMobView *)doMobView
{
	// 请到www.domob.cn网站注册获取自己的publisher id
	return kDomobPubliserID;
}

// 发布前请取消下面函数的注释

- (NSString *)domobKeywords
{
    return @"iPhone,game";
}

- (NSString *)domobSpot:(DoMobView *)doMobView;
{
	return @"all";
}

// Sent when an ad request loaded an ad; 
// it only send once per DoMobView
- (void)domobDidReceiveAdRequest:(DoMobView *)doMobView
{
    mAdView.frame = CGRectMake((self.view.frame.size.width - self.mAdView.frame.size.width)/2,0, self.mAdView.frame.size.width, self.mAdView.frame.size.height);
	[self.view addSubview:self.mAdView];
}

- (void)domobDidFailToReceiveAdRequest:(DoMobView *)doMobView
{
}
- (void)domobWillPresentFullScreenModalFromAd:(DoMobView *)doMobView
{
	NSLog(@"The view will Full Screen");
}

- (void)domobDidPresentFullScreenModalFromAd:(DoMobView *)doMobView
{
	NSLog(@"The view did Full Screen");
}

- (void)domobWillDismissFullScreenModalFromAd:(DoMobView *)doMobView
{
	NSLog(@"The view will Dismiss Full Screen");
}

- (void)domobDidDismissFullScreenModalFromAd:(DoMobView *)doMobView
{
	NSLog(@"The view did Dismiss Full Screen");
}

-(id)initWithIndexPath:(NSIndexPath*)indexPath
{
    self = [super init];
    if(self)
    {
        self.index = indexPath;
        delegate = SharedDelegate;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)popupShareOption
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:NSLocalizedString(@"ShareTip",@"")
                                  delegate:self cancelButtonTitle:NSLocalizedString(@"Back", @"")
                                  destructiveButtonTitle:NSLocalizedString(@"EmailAlertViewTitle",@"") otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    switch (buttonIndex) {
        case kShareByEmailOption:
            [self emailShare];
            break;
            
        default:
            break;
    }
}
#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice:(BOOL)feeback
{
    //    NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
    //    NSString *body = @"&body=It is raining in sunny California!";
    
    NSString* content = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>\r\n\n\n%@",delegate.mTrackViewUrl,delegate.mTrackName,[delegate getContent:index.row]];
    
    NSString * email = nil;
    if (feeback) {
        email = [NSString stringWithFormat:@"mailto:&subject=%@&body=%@", [delegate getTitle:index.row], @""];
    }
    else
    {
        email = [NSString stringWithFormat:@"mailto:ramonqlee1980@gmail.com&subject=%@&body=%@", [delegate getTitle:index.row], content];
    }
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet:(BOOL)feedback 
{
    MFMailComposeViewController *picker = [[[MFMailComposeViewController alloc] init]autorelease];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:[delegate getTitle:index.row]];
    
    
    NSString* content = nil;
    if(!feedback)
    {
        content = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>\r\n\n\n%@",delegate.mTrackViewUrl,delegate.mTrackName,[delegate getContent:index.row]];
    }
    else
    {
        content = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>\r\n\n\n",delegate.mTrackViewUrl,delegate.mTrackName];
    }
    
    [picker setMessageBody:content isHTML:YES]; 
    
    
    // Set up recipients
    //    NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"]; 
    //    NSArray *bccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
    if(feedback)
    {
        NSArray *recipients = [NSArray arrayWithObject:@"ramonqlee1980@gmail.com"]; 
        
        //    
        //    [picker setToRecipients:toRecipients];
        [picker setToRecipients:recipients]; 
    }
    //    [picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
    //    NSData *myData = [NSData dataWithContentsOfFile:path];
    //    [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
    //    
    //    // Fill out the email body text
    //    NSString *emailBody = @"It is raining in sunny California!";
    //    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentModalViewController:picker animated:YES];
}
-(IBAction)feedback:(id)sender
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet:YES];
        }
        else
        {
            [self launchMailAppOnDevice:YES];
        }
    }
    else
    {
        [self launchMailAppOnDevice:YES];
    }
}
-(IBAction)emailShare
{
    // This sample can run on devices running iPhone OS 2.0 or later  
    // The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
    // So, we must verify the existence of the above class and provide a workaround for devices running 
    // earlier versions of the iPhone OS. 
    // We display an email composition interface if MFMailComposeViewController exists and the device can send emails.
    // We launch the Mail application on the device, otherwise.
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet:NO];
        }
        else
        {
            [self launchMailAppOnDevice:NO];
        }
    }
    else
    {
        [self launchMailAppOnDevice:NO];
    }
    [Flurry logEvent:kShareByEmail];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller             didFinishWithResult:(MFMailComposeResult)result                          error:(NSError*)error;
{   
    if (result == MFMailComposeResultSent) 
    {    
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"EmailAlertViewTitle", @"") message:NSLocalizedString(@"EmailAlertViewMsg", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"") otherButtonTitles:nil];
        [alert show];
        [alert release];
    }  
    [self dismissModalViewControllerAnimated:YES]; 
} 

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tempCloseRequest = YES;
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeAdsTemp) name:kAdsUpdateDidFinishLoading object:nil];
    mWeibo = FALSE;
    mLoginWeiboCanceled = FALSE;
    
    [self loadAd];
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Back",@"") style: UIBarButtonItemStyleBordered target: nil action: nil];  
    [[self navigationItem] setBackBarButtonItem: newBackButton];  
    [newBackButton release]; 
    
    // Do any additional setup after loading the view from its nib.
    self.title = [delegate getTitle:index.row];
    
    [self adjustAdSize];
    
    textView.editable = NO;
    NSMutableString* content= [NSMutableString stringWithString:[delegate getContent:index.row]];
    [content replaceOccurrencesOfString:@"\n\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    textView.text = content;
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        //textView.font = [UIFont fontWithName:kHuakangFontName size:kIPadFontSizeEx];
    }
    else
    {        
        //textView.font = [UIFont fontWithName:kHuakangFontName size:kIPhoneFontSize];
    }  
    textView.textColor = [UIColor blueColor];        
}
- (IBAction)compose:(id)sender {
    [Flurry logEvent:kShareByWeibo];
}
-(IBAction)add2Favorate
{     
    NSString* title = self.title;
    NSString* content = textView.text;
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:content,@"text",title,@"date", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:kAdd2Favorite object:nil userInfo:dict];
    
}
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{   
#define kOkIndex 0    
    if(buttonIndex == kOkIndex && _tempCloseRequest == YES)
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
    _tempCloseRequest = YES;
}
-(void)closeAdsTemp
{
    if (![AdsConfig neverCloseAds]) {
        return;
    }
    
    UIAlertView *alert = nil ;
    BOOL b = [AdsConfig isAdsOn];
    
    if(b)
    {
        _tempCloseRequest = YES;
        NSString* title = NSLocalizedString(@"RemoveAdsTitle", "");
        NSString* msg = NSLocalizedString(@"RemoveAdsTemp", "");
        NSString* okMsg =  NSLocalizedString(@"Ok", "");
        NSString* cancelMsg =  NSLocalizedString(@"Cancel", "");
        alert = [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:okMsg otherButtonTitles:cancelMsg, nil]autorelease];        
    }        
    if(nil!=alert)
    {
        [alert show];
    }
}

-(void)closeAds:(BOOL)closeAds
{   
    //which wall to open
    //youmi
    //immoi
    //miidi
    //waps
    
    mWallName = [delegate currentAdsWall];
    if(NSOrderedSame==[AdsPlatformWapsWall caseInsensitiveCompare:mWallName])
    {
        [AppConnect showOffers];
    }
    else if(NSOrderedSame==[AdsPlatformYoumiWall caseInsensitiveCompare:mWallName])
    {        
        UIViewController *detailViewController;
        detailViewController = [[[RewardedWallViewController alloc] init:closeAds]autorelease];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else //if(NSOrderedSame==[AdsPlatformImmobWall caseInsensitiveCompare:mWallName])
    {
        self.navigationController.navigationBarHidden = YES;
        mWallOpened = YES;
        if(mWall)
        {
            [mWall release];
        }
        mWall=[[immobView alloc] initWithAdUnitID:kImmobWallId];
        //此属性针对多账户用户，主要用于区分不同账户下的积分
        //        [mWall.UserAttribute setObject:@"immobSDK" forKey:@"accountname"];
        ((immobView*)mWall).delegate=self;
        [mWall release];
        [((immobView*)mWall) immobViewRequest];
    }
    [delegate setShouldShowAdsWall:NO enableForNext:YES];
    
    [Flurry logEvent:kFlurryOpenRemoveAdsList];
}
- (IBAction)closeAd:(id)sender
{    
    [Flurry logEvent:kDidShowFeaturedAppCredit];
    [self closeAds:mAdsWallShouldShow];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    mWallOpened = NO;
    
    if (mLoginWeiboCanceled) {
        mWeibo = FALSE;
        mLoginWeiboCanceled = FALSE;
    }

    
}
- (void)loadTimeline {
	
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{    
    [self adjustAdSize];
}

- (void)viewDidUnload
{
	self.contentView = nil;
    if ([mAdView isKindOfClass:[DoMobView class]]) {
        ((DoMobView*)mAdView).doMobDelegate = nil;
    }
    [mAdView release];
}

- (void)dealloc
{
    self.index = nil;   
    if ([mAdView isKindOfClass:[DoMobView class]]) {
        ((DoMobView*)mAdView).doMobDelegate = nil;
    }
    [mAdView release];
	[contentView release]; 
    contentView = nil;  
    
    [_engine release];
    [super dealloc];
}

- (void)adjustAdSize {	
	//[UIView beginAnimations:@"AdResize" context:nil];
	//[UIView setAnimationDuration:0.7];
    
	/*CGSize adSize = mAdView.frame.size;
     CGRect newFrame = mAdView.frame;
     newFrame.size.height = adSize.height;
     newFrame.size.width = adSize.width;    
     
     newFrame.origin.x = (textView.frame.size.width - adSize.width)/2;
     newFrame.origin.y = 0;//self.view.bounds.size.height-adSize.height;
     mAdView.frame = newFrame;*/
    
    //reposition  textview
    CGRect rc = textView.frame;
    rc.origin.y = mAdView.frame.size.height;   
    
    textView.frame = rc;
    
    
	//[UIView commitAnimations];
} 


#pragma mark adsageRecommend delegate
- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}
@end
