//
//  CDetailView.m
//  AdvancedTableViewCells
//
//  Created by ramonqlee on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CDetailViewController.h"
#import "CDetailData.h"
#import "UIImageEx.h"
#import <UIKit/UIApplication.h>
#import "AdvancedTableViewCellsAppDelegate.h"
#import "CommonADView.h"
#import "ImpressionADView.h"

// 注释掉这行，可以演示Impression AD
//#define __DEMO_COMMONADVIEW

const NSUInteger kImageWidth = 240;
#if 1
const NSUInteger kImageHeight = 30;
#else
const NSUInteger kImageHeight = 320;
#endif
const CGFloat kFontSize = 20;//pt
const CGFloat kIPadFontSize = 24;//pt
#if 1
const CGFloat kHeightScale = 1;
#else
const CGFloat kHeightScale = 2;
#endif

const CGFloat kIPhoneScreenWidth = 320;


@implementation CDetailViewController
@synthesize srlView,xmlData,index;

-(id)initWithIndexPath:(NSIndexPath*)indexPath
{
    self = [super init];
    if(self)
    {
        self.index = indexPath;
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
-(id)initAds 
{
	if(self = [super init])
	{		
        CGRect frame = [UIScreen mainScreen].bounds;
        if(YES == [InAppPurchaseManager isPurchased])
        {
            return self;
        }
#ifdef __DEMO_COMMONADVIEW__
        if(myCommonADView)
        {
            return self;
        }
		myCommonADView = [[CommonADView alloc] initWithADWith:@"df4d4df3bb0440fea0a83c1b60c2fd5c" status:NO xLocation:0 yLocation:0 displayType:CommonBannerScreen horizontalOrientation:CommonOrientationPortrait];
		[self.view addSubview:myCommonADView];
        
        [myCommonADView setDisplayType:CommonBannerScreen setX:(frame.size.width-myCommonADView.frame.size.width)/2 setY:myCommonADView.frame.origin.y];
		[myCommonADView startADRequest];
#else
        if(myImpressionADView)
        {
            return self;
        }        
        myImpressionADView = [[ImpressionADView alloc] initWithADWith:@"df4d4df3bb0440fea0a83c1b60c2fd5c" status:NO offsetX:0 offsetY:0 displayType:BannerScreen horizontalOrientation:OrientationPortrait];
        [self.view addSubview:myImpressionADView];
        [myImpressionADView setDisplayType:BannerScreen setX:(frame.size.width-myImpressionADView.frame.size.width)/2 setY:myImpressionADView.frame.origin.y];
        myImpressionADView.requestADTimeIntervel=20.0;
        [myImpressionADView startADRequest];
#endif
        
	}
	return self;
}
- (void)dealloc
{     
    self.xmlData = nil;
    self.index = nil;
    [srlView release];
    
    [myCommonADView release];
    [myImpressionADView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)layoutScrollImages:(CGSize)screenSize
{
    
	UIView *view = nil;
	NSArray *subviews = [srlView subviews];
    
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curYLoc = 0;
	for (view in subviews)
	{
        //imageview
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
		{
            //locate in the middle(in horizontal direction)
			CGRect frame = view.frame;
			frame.origin = CGPointMake((screenSize.width-kImageWidth)/2,curYLoc);
			view.frame = frame;
			
			curYLoc += frame.size.height;
		}
        
        //textview
        if ([view isKindOfClass:[UITextView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(0,curYLoc);
            frame.size = screenSize;//reset its size
			view.frame = frame;
			
			curYLoc += frame.size.height;
		}
	}
	
	// set the content size so it can be scrollable
	[srlView setContentSize:CGSizeMake(screenSize.width, screenSize.height*kHeightScale)];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{ 
    [self layoutScrollImages:self.view.bounds.size];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    NSLog(@"didRotateFromInterfaceOrientation: size(%.2f, %.2f).", screenBound.size.width, screenBound.size.height);
    if([[UIApplication sharedApplication] statusBarOrientation] ==  UIInterfaceOrientationLandscapeLeft 
       || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)
    {
        
#ifdef __DEMO_COMMONADVIEW__
        [myCommonADView setDisplayType:CommonBannerScreen setX:(screenBound.size.height-myCommonADView.frame.size.width)/2 setY:myCommonADView.frame.origin.y];
#else
        [myImpressionADView setDisplayType:BannerScreen setX:(screenBound.size.height-myImpressionADView.frame.size.width)/2 setY:myImpressionADView.frame.origin.y];
#endif
    }
    else
    {        
#ifdef __DEMO_COMMONADVIEW__
        [myCommonADView setDisplayType:CommonBannerScreen setX:(screenBound.size.width-myCommonADView.frame.size.width)/2 setY:myCommonADView.frame.origin.y];
#else
        [myImpressionADView setDisplayType:BannerScreen setX:(screenBound.size.width-myImpressionADView.frame.size.width)/2 setY:myImpressionADView.frame.origin.y];
#endif
    }
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
        case kShareByEmail:
            [self emailShare];
            break;
            
        default:
            break;
    }
}
#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{    
    NSString *email = [NSString stringWithFormat:@"mailto:?&subject=%@&body=%@", [xmlData getTitle:index.row], [xmlData getContent:index.row]];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:[xmlData getTitle:index.row]];
    [picker setMessageBody:[xmlData getContent:index.row] isHTML:NO]; 
    
    // Set up recipients
    //    NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"]; 
    //    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
    //    NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
    //    
    //    [picker setToRecipients:toRecipients];
    //    [picker setCcRecipients:ccRecipients];  
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
    [picker release];
}

-(void)emailShare
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
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
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
- (void)viewDidLoad
{
    [super viewDidLoad]; 
    [self initAds];
    
    UIBarButtonItem *btnAction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(popupShareOption)];
    self.navigationItem.rightBarButtonItem = btnAction;
    
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    // Do any additional setup after loading the view from its nib.
    self.title = [xmlData getTitle:index.row];
    
    CGSize size = CGSizeMake(kImageWidth,kImageHeight);
    NSUInteger tag = 0;
    
    //screen size,for scrolling
    CGRect screenRc = [[UIScreen mainScreen] bounds];
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGSize screen = CGSizeMake(CGRectGetHeight(screenRc),CGRectGetWidth(screenRc));
    if(UIInterfaceOrientationPortrait == currentOrientation || 
       UIInterfaceOrientationPortraitUpsideDown == currentOrientation)
    {
        screen = CGSizeMake(CGRectGetWidth(screenRc),CGRectGetHeight(screenRc));
    }
    
    
    //incoporate into a scroll view
	[srlView setBackgroundColor:[UIColor whiteColor]];
	[srlView setCanCancelContentTouches:NO];
	srlView.clipsToBounds = YES;	// default is NO, we want to restrict drawing within our scrollview
	srlView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    if(enumIndex == [SharedDelegate getLevel])
    {        
        NSString* iconName = [NSString stringWithFormat:@"%.3d",index.row];     
        NSString *iconPath = [[NSBundle mainBundle] pathForResource:iconName ofType:@"jpg"]; 
        
        UIImage* image = [[UIImage alloc]initWithContentsOfFile:iconPath];  
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[image scaleWithSize:size]];
        [image release];
        
        //locate in the middle of the screen
        CGRect rc = [imageView frame];
        rc.origin = CGPointMake((screen.width-rc.size.width)/2,rc.origin.y);
        [imageView setFrame:rc];
        imageView.tag = ++tag;//identification    
        [srlView addSubview:imageView];	
        [imageView release];
    }
    
    UITextView* textView = [[UITextView alloc]initWithFrame:CGRectMake(0, size.height, screen.width, screen.height)];
    textView.editable = NO;
    textView.text = [xmlData getContent:index.row];
    textView.tag = ++tag;
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [textView setFont:[UIFont systemFontOfSize:kIPadFontSize]];
    }
    else
    {
        [textView setFont:[UIFont systemFontOfSize:kFontSize]];
    }
    [srlView addSubview:textView];
    [textView release];
    
    [srlView setContentSize:CGSizeMake(screen.width, screen.height*kHeightScale)];
    [srlView setScrollEnabled:YES];
    
    NSLog(@"No:%d",index.row);
    
    
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}
-(void) viewWillDisappear:(BOOL)animated {    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) 
    {       
        AdvancedTableViewCellsAppDelegate* delegate = SharedDelegate;
        // back button was pressed.  We know this is true because self is no longer  
        // in the navigation stack.
        if (enumContent == [delegate getLevel]) {
            [delegate switchLevel:enumSpec];
        }              
    }
    [super viewWillDisappear:animated];
} 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}




@end
