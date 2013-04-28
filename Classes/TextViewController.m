#import "TextViewController.h"
#import "AppDelegate.h" // for SharedAdBannerView macro
#import "Constants.h"
#import "AdsConfig.h"
#import "RewardedWallViewController.h"
#import "AdsConfig.h"
#import "Flurry.h"
#import "AddNewNoteViewController.h"

//#import "WapsOffer/AppConnect.h"
#import "InAppRageIAPHelper.h"
#import "MBProgressHUD.h"
#import "ReachabilityAs.h"
#import <ShareSDK/ShareSDK.h>
#import "ThemeManager.h"
#import "CoinsManager.h"
#import "AdsViewManager.h"
#import "AdsConfiguration.h"
#import "RMIndexedArray.h"

const CGFloat kMinFontSize = 20;//[UIFont systemFontSize];

enum ShareOption
{
    kShareByEmailOption = 0
};

@interface TextViewController()

{
    UIView *contentView;
    UITextView* textView;
    AppDelegate* delegate;
    UIView* mAdView;
    UITabBarItem *mAdsSwitchBarItem;
    
    OAuthEngine				*_engine;
    BOOL mWeibo;
    BOOL mLoginWeiboCanceled;
    BOOL mAdsWallShouldShow;
    BOOL _tempCloseRequest;
    
    MBProgressHUD *_hud;
}
-(void)setRightAdButton:(BOOL)closeAdsButton;
-(void)closeAds:(BOOL)popClosingTip;
-(void)closeAdsTemp;


@property (retain) MBProgressHUD *hud;
@property (nonatomic, retain) IBOutlet UITabBarItem *mAdsSwitchBarItem;
@property(nonatomic, retain) UIView *mAdView;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic, retain) IBOutlet UIView *contentView;


- (IBAction)compose:(id)sender;
- (IBAction)feedback:(id)sender;
- (IBAction)signOut:(id)sender;
- (IBAction)closeAd:(id)sender;
-(IBAction)emailShare;
-(IBAction)add2Favorate;
-(IBAction)share2WixinChat;
-(IBAction)share2WixinFriends;
-(IBAction)changeColor;

-(void)launchMailAppOnDevice:(BOOL)feedback;
-(void)displayComposerSheet:(BOOL)feedback;

-(void)loadAd;
- (void)adjustAdSize;
@end

@implementation TextViewController

@synthesize contentView,textView,mAdView,mAdsSwitchBarItem,hud;
@synthesize content;

#pragma mark -

-(void)setRightAdButton:(BOOL)closeAdsButton
{
    NSString* title = closeAdsButton?NSLocalizedString(@"AdsWallSwitch",@""):NSLocalizedString(@"Donate",@"");
    if (!closeAdsButton) {//hide this button
        return;
    }
    UIBarButtonItem *showOffersItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(rightItemClickInAppPurchase:)];
    self.navigationItem.rightBarButtonItem = showOffersItem;
    showOffersItem.tintColor = TintColor;
    [showOffersItem release];
}

-(void)loadAd
{
    if ([[CoinsManager sharedInstance]getLeftCoins]>0) {
        return;
    }
    //#warning banner view to be inited
    CGSize adSize = mAdView.frame.size;
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    int screenWidth = [[UIScreen mainScreen]bounds].size.width;
    if (UIDeviceOrientationIsLandscape(deviceOrientation))
        screenWidth = [[UIScreen mainScreen]bounds].size.height;
    CGRect frame = textView.frame;
    frame.size.height -= adSize.height;
    textView.frame = frame;
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
    
    NSString* description = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>\r\n\n\n%@",delegate.mTrackViewUrl,delegate.mTrackName,content];
    
    NSString * email = nil;
    if (feeback) {
        email = [NSString stringWithFormat:@"mailto:&subject=%@&body=%@", self.title, @""];
    }
    else
    {
        email = [NSString stringWithFormat:@"mailto:feedback4iosapp@gmail.com&subject=%@&body=%@", self.title, description];
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
    
    [picker setSubject:self.title];
    
    
    NSString* description = nil;
    if(!feedback)
    {
        description = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>\r\n\n\n%@",delegate.mTrackViewUrl,delegate.mTrackName,content];
    }
    else
    {
        description = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>\r\n\n\n",delegate.mTrackViewUrl,delegate.mTrackName];
    }
    
    [picker setMessageBody:description isHTML:YES];
    
    
    // Set up recipients
    //    NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    //    NSArray *bccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    if(feedback)
    {
        NSArray *recipients = [NSArray arrayWithObject:@"feedback4iosapp@gmail.com"];
        
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
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addBannerView
{
    AdsViewManager* adViewManager = [AdsViewManager sharedInstance];
    RMIndexedArray* list = (RMIndexedArray*)[adViewManager.configDict objectForKey:kBanner];
    if (list && [list count]) {
        
        list.taggedIndex = (list.taggedIndex>=0&&list.taggedIndex<[list count])?list.taggedIndex:0;
        NSLog(@"list.taggedIndex:%d",list.taggedIndex);
        //get index
        NSDictionary* item = [list objectAtIndex:list.taggedIndex++];
        
        self.mAdView = [adViewManager getBannerView:item inViewController:self];
        if (self.mAdView) {
            [self.view addSubview:mAdView];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBannerView];
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Back",@"") style: UIBarButtonItemStyleBordered target: self action: @selector(back)];
    newBackButton.tintColor = TintColor;
    [[self navigationItem] setLeftBarButtonItem:newBackButton];
    [newBackButton release];
    
    _tempCloseRequest = YES;
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeAdsTemp) name:kAdsUpdateDidFinishLoading object:nil];
    mWeibo = FALSE;
    mLoginWeiboCanceled = FALSE;
    
    [self loadAd];
    
    // Do any additional setup after loading the view from its nib.
    //    self.title = [delegate getTitle:index.row];
    
    [self adjustAdSize];
    
    textView.editable = NO;
    //    NSMutableString* content= [NSMutableString stringWithString:[delegate getContent:index.row]];
    //    [content replaceOccurrencesOfString:@"\n\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [content length])];
    NSString* tipContent = [NSString stringWithFormat:@"(字体过小，手势缩放下吧)\n\n%@",content];
    
    textView.text = tipContent;
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        //textView.font = [UIFont fontWithName:kHuakangFontName size:kIPadFontSizeEx];
    }
    else
    {
        //textView.font = [UIFont fontWithName:kHuakangFontName size:kIPhoneFontSize];
    }
    textView.textColor = [UIColor blueColor];
    textView.font = [UIFont systemFontOfSize:[self getFontSize]];
    [self setColor];
    
    // Create a pinch gesture recognizer instance.
    UIGestureRecognizer* pinchGestureRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)] autorelease];
    
    // And add it to your text view.
    [textView addGestureRecognizer:pinchGestureRecognizer];
        
    //popup remove ad tip only once
    AdsConfiguration* config = [AdsConfiguration sharedInstance];
    if([config getCount]>0)
    {
        [self setRightAdButton:YES];
        if(![self isInAppTipOff])
        {
            [self rightItemClickInAppPurchase:nil];
            [self setInAppTipOff:YES];
        }
    }
}
#define kIN_APP_TIP @"inapp-tip"
-(BOOL)isInAppTipOff
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    return [defaultSetting boolForKey:kIN_APP_TIP];
}
-(void)setInAppTipOff:(BOOL)off
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    [defaultSetting setBool:off forKey:kIN_APP_TIP];
}

- (IBAction)compose:(id)sender {
    [Flurry logEvent:kShareByWeibo];
}
-(IBAction)add2Favorate
{
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:content,@"text",self.title,@"date", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:kAdd2Favorite object:nil userInfo:dict];
    
}
#ifndef __IN_APP_SUPPORT__
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}
#endif//__IN_APP_SUPPORT__

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (mLoginWeiboCanceled) {
        mWeibo = FALSE;
        mLoginWeiboCanceled = FALSE;
    }
    
    [self adjustAdSize];
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
    [mAdView release];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_hud release];
    _hud = nil;
    
    self.content = nil;
    
    [mAdView release];
	[contentView release];
    contentView = nil;
    
    [_engine release];
    [super dealloc];
}

- (void)adjustAdSize {
    
    //reposition  textview
    CGRect rc = textView.frame;
    rc.origin.y = mAdView.frame.size.height;
    
    textView.frame = rc;
    
    
	//[UIView commitAnimations];
}

#pragma mark weixin share
-(IBAction)share2WixinChat
{
    NSString* title = self.title;
    NSString* url = ((AppDelegate*)SharedDelegate).mTrackViewUrl;
    NSString* description = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>\r\n\n\n%@",url,((AppDelegate*)SharedDelegate).mTrackName,content];
    
    NSString* kEllipseString = @"...";
    const NSUInteger kEllipseLength = kEllipseString.length;
    const NSUInteger kTrim2Length = kWeiboMaxLength+kEllipseLength;
    if (description.length>=kTrim2Length) {
        description = [content substringToIndex:kTrim2Length];
        description = [NSString stringWithFormat:@"%@%@",content,kEllipseString];
    }
    [SharedDelegate sendAppContent:title description:description image:nil scene:WXSceneSession];
}
-(IBAction)share2WixinFriends
{
    [SharedDelegate sendAppContent:self.title description:content image:nil scene:WXSceneSession];
}


#pragma mark request purchase
// Add new method
-(IBAction)rightItemClickInAppPurchase:(id)sender
{
    if ([AppDelegate isPurchased]) {
        //        NSString* ret = NSLocalizedString(@"try2delete", "");
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"purchased already" delegate:self cancelButtonTitle:NSLocalizedString(@"OK","") otherButtonTitles:nil]autorelease];
        [alert show];
        return;
    }
    ReachabilityAs *reach = [ReachabilityAs reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        NSLog(@"No internet connection!");
    } else {
        //if ([InAppRageIAPHelper sharedHelper].products == nil)
        {
            
            [[InAppRageIAPHelper sharedHelper] requestProducts];
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = NSLocalizedString(@"Loading","");
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
        }
    }
}

#pragma notification handler
- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    //    NSString *productIdentifier = (NSString *) notification.object;
    //    NSLog(@"Purchased: %@", productIdentifier);
    
    //hide purchase button
    self.navigationItem.rightBarButtonItem = nil;
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"purchased","") delegate:self cancelButtonTitle:NSLocalizedString(@"OK","") otherButtonTitles:nil]autorelease];
    [alert show];
    
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
    if (transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!"
                                                         message:transaction.error.localizedDescription
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
    }
    
}
- (void)dismissHUD:(id)arg {
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.hud = nil;
    
}
- (void)updateInterfaceWithReachability: (ReachabilityAs*) curReach {
    
}
#pragma  mark inapp purchase

#ifdef __IN_APP_SUPPORT__
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
#define kPurchaseConfirmIndex 1
    
    if(buttonIndex == kPurchaseConfirmIndex)
    {
        SKProduct *product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:0];
        
        NSLog(@"Buying %@...", product.productIdentifier);
        
        [[InAppRageIAPHelper sharedHelper] buyProduct:product];
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.labelText = NSLocalizedString(@"Purchasing","");
        [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
    }
}
#endif//__IN_APP_SUPPORT__
- (NSString *)localizedPrice:(NSLocale *)priceLocale price:(NSDecimalNumber *)price
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:price];
    [numberFormatter release];
    return formattedString;
}
- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    //purchase request
    SKProduct *product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:0];
    NSString* msg = [NSString stringWithFormat:@"%@(%@)",product.localizedDescription,[self localizedPrice:product.priceLocale price:product.price]];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:product.localizedTitle message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel","") otherButtonTitles:NSLocalizedString(@"OK","") ,nil]autorelease];
    [alert show];
}

- (void)timeout:(id)arg {
    
    _hud.labelText = @"Timeout,try again later.";
    //_hud.detailsLabelText = @"Please try again later.";
    //_hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
	//_hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    
}
-(void)setRightClick:(NSString*)title buttonName:(NSString*)buttonName action:(SEL)action
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:buttonName style:UIBarButtonItemStyleBordered target:self action:action];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.title = title;
    [rightItem release];
}

#pragma mark toolbar
-(IBAction)changeColor
{
    if(!delegate)
    {
        delegate = (AppDelegate*)SharedDelegate;
    }
    if(delegate.isWhiteColor)
    {
        delegate.isWhiteColor = NO;
        textView.textColor = [UIColor blueColor];
        textView.backgroundColor = [UIColor whiteColor];
    }
    else {
        delegate.isWhiteColor = YES;
        textView.textColor = [UIColor whiteColor];
        textView.backgroundColor = [UIColor blackColor];
    }
}
-(void)setColor
{
    if(!delegate)
    {
        delegate = (AppDelegate*)SharedDelegate;
    }
    if(!delegate.isWhiteColor)
    {
        delegate.isWhiteColor = NO;
        textView.textColor = [UIColor blueColor];
        textView.backgroundColor = [UIColor whiteColor];
    }
    else {
        delegate.isWhiteColor = YES;
        textView.textColor = [UIColor whiteColor];
        textView.backgroundColor = [UIColor blackColor];
    }
}

#define kFontSize @"kFontSize"
-(CGFloat)getFontSize
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    CGFloat size = [def floatForKey:kFontSize];
    if (size<kMinFontSize) {
        size = kMinFontSize;
    }
    return size;
}
-(void)setFontSize:(CGFloat)size
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setFloat:size forKey:kFontSize];
}
- (void)pinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer
{
	NSLog(@"*** Pinch: Scale: %f Velocity: %f", gestureRecognizer.scale, gestureRecognizer.velocity);
    
	UIFont *font = textView.font;
	CGFloat pointSize = font.pointSize;
	NSString *fontName = font.fontName;
    
	pointSize = ((gestureRecognizer.velocity > 0) ? 1 : -1) * 1 + pointSize;
    
	if (pointSize < 13) pointSize = 13;
	if (pointSize > 42) pointSize = 42;
    
	textView.font = [UIFont fontWithName:fontName size:pointSize];
    
	// Save the new font size in the user defaults.
    [self setFontSize:pointSize];
}
@end
