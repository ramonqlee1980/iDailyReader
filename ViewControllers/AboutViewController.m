//
//  MoreViewController.m
//  AccountSafe
//
//  Created by Lee Ramon on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "AppDelegate.h"
#import "iRate.h"
#import "AdsConfig.h"
#import "Constants.h"

@interface AboutViewController ()
- (IBAction)modalViewAction:(id)sender;
-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;
-(void)changePasscode;
@end

@implementation AboutViewController
@synthesize tableView;

#define kMoreFeatureCount 3

#define kMoreAbout 0
#define kMoreFeedBack 1
#define kMoreRate 2

#define kMoreAboutKey @"kMoreAboutKey"
#define kMoreFeedBackKey @"kMoreFeedBackKey"
#define kMoreRateKey @"kMoreRateKey" 


#pragma  mark tableview datasource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kMoreFeatureCount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define kVIPCell @"VIPCell"
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:kVIPCell];
    if (nil==cell) {
        cell = [[[UITableViewCell alloc]init]autorelease];
    }
    
    //1 category edit
    //1.1add new category count
    //1.2delete category
    NSString* key = nil;
    
#define CASE_BRANCH(s) case s:\
key=s##Key;\
break;
    
    //2.alarm to change passcode    
    switch (indexPath.section) {
        CASE_BRANCH(kMoreAbout)
        CASE_BRANCH(kMoreFeedBack)
        CASE_BRANCH(kMoreRate)
        default:
            break;
    }
    if (key) {
        NSString* t = NSLocalizedString(key, "");
        cell.textLabel.text = t;
    }
    
    return cell;
}
#pragma mark tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kMoreAbout:
            [self modalViewAction:nil];
            break;
        case kMoreFeedBack:
            [self feedback:nil];
            break;
        case kMoreRate:
            [self rate];
            break;
        default:
            break;
    }
    
}

#pragma mark about
-(void)rate
{
    iRate* rate = [iRate sharedInstance];
    rate.appStoreID = [kAppIdOnAppstore integerValue];
    
    //enable preview mode
    [rate openRatingsPageInAppStore];
}
- (IBAction)modalViewAction:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"AboutTitle", @"") message:NSLocalizedString(@"About", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK","") otherButtonTitles:nil]autorelease];                              
    [alert show];
}

-(void)changePasscode
{
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
        self.title = NSLocalizedString(@"AboutTitle", "");
        self.tabBarItem.image = [UIImage imageNamed:kIconSetting];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"Title", @"");
    tableView.delegate = self;
    tableView.dataSource = self;
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

#pragma mark -
#pragma mark Workaround

- (void)mailComposeController:(MFMailComposeViewController*)controller             didFinishWithResult:(MFMailComposeResult)result                          error:(NSError*)error;
{   
    if (result == MFMailComposeResultSent) 
    {    
        UIAlertView* alert = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"EmailAlertViewTitle", @"") message:NSLocalizedString(@"EmailAlertViewMsg", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil]autorelease];
        [alert show];
    }  
    [self dismissModalViewControllerAnimated:YES]; 
} 

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice:(BOOL)feeback
{
    //    NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
    //    NSString *body = @"&body=It is raining in sunny California!";
    
    NSString * email = [NSString stringWithFormat:@"mailto:&subject=%@&body=%@", NSLocalizedString(@"Title", @""), @""];
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
    
    [picker setSubject:NSLocalizedString(@"Title", @"")];
    [picker setMessageBody:@"" isHTML:YES];     
    
    // Set up recipients
    //    NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"]; 
    //    NSArray *bccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
    NSArray *recipients = [NSArray arrayWithObject:@"feedback4iosapp@gmail.com"]; 
    
    //    
    //    [picker setToRecipients:toRecipients];
    [picker setToRecipients:recipients]; 
    
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
@end
