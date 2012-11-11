//
//  MoreViewController.m
//  AccountSafe
//
//  Created by Lee Ramon on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"
#import "AppDelegate.h"
#import "AccountData.h"
#import "UILocalNotification.h"

@interface MoreViewController ()
- (IBAction)modalViewAction:(id)sender;
-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;
-(void)changePasscode;
@end

@implementation MoreViewController
@synthesize tableView;

//tag for identifying views when changing passcode
#define kOriginalPasscodeViewTag 0x100
#define kNewPasscodeViewTag      0x101

//passcode changing tips
#define kChangePasscodeTipCommonErrorKey @"kChangePasscodeTipCommonErrorKey"
#define kChangePasscodeTipIncorrectOriginalKey @"kChangePasscodeTipIncorrectOriginalKey"
#define kChangePasscodeTipSuccessfulKey @"kChangePasscodeTipSuccessfulKey"

#define kOriginalPasscodePlaceholerKey @"OriginalPasscodeKey"
#define kNewPasscodePlaceholerKey @"NewPasscodeKey"   


#define kMoreFeatureCount 3

#define kMoreAbout 0
#define kMoreFeedBack 1
#define kMoreLocalAlert 2
#define kMoreChangePasscode 3

#define kMoreAboutKey @"kMoreAboutKey"
#define kMoreFeedBackKey @"kMoreFeedBackKey"
#define kMoreChangePasscodeKey @"kMoreChangePasscodeKey" 
#define kMoreLocalAlertKey @"kMoreLocalAlertKey"

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
        CASE_BRANCH(kMoreChangePasscode)            
        CASE_BRANCH(kMoreLocalAlert)
        default:
            break;
    }
    
    if (key) {
        NSString* t = NSLocalizedString(key, "");
        //special case
        if (indexPath.section == kMoreLocalAlert) {
            t = [NSString stringWithFormat:t,[UILocalNotification getBadgeNumber]];
        }
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
        case kMoreChangePasscode:
            [self changePasscode];
            break;
        case kMoreLocalAlert:
            break;            
        default:
            break;
    }
    
}

#pragma mark about
- (IBAction)modalViewAction:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"AboutTitle", @"") message:NSLocalizedString(@"About", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
#define kOK 1
    if (buttonIndex == kOK) {
        UITextField* originalPasscode = nil;
        UITextField* newPasscode = nil;
        //find textfield
        NSArray* subviews = [alertView subviews];
        for (id view in subviews) {
            if([view isKindOfClass:[UITextField class]])
            {  
                switch (((UIView*)view).tag) {
                    case kOriginalPasscodeViewTag:
                        originalPasscode = (UITextField*)view;
                        break;
                    case kNewPasscodeViewTag:
                        newPasscode = (UITextField*)view;
                    default:
                        break;
                }
            }
        }       
       
        //check for correctness        
        //null content
        if (nil==originalPasscode || nil == originalPasscode.text || 0 == originalPasscode.text.length ||
            nil==newPasscode || nil == newPasscode.text || 0 == newPasscode.text.length) {
            [self showAlertViewWithTitle:@"" message:NSLocalizedString(kChangePasscodeTipCommonErrorKey,"")];
            return;
        }
        
        //original passcode incorrect
        if(![[AccountData getOpenDoorKey] isEqualToString:originalPasscode.text])
        {
            //TODO::pop tip
            [self showAlertViewWithTitle:@"" message:NSLocalizedString(kChangePasscodeTipIncorrectOriginalKey,"")];
            return;
        }        
        
        [AccountData setOpenDoorKey:newPasscode.text];
        //pop successful tip
        [self showAlertViewWithTitle:@"" message:NSLocalizedString(kChangePasscodeTipSuccessfulKey,"")];
    }
}

-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK","") otherButtonTitles:nil]autorelease];                              
    [alert show];
}

-(void)changePasscode
{
    //layout params
#define kTextFieldHeight 25.0
#define kTextFieldWidth  260.0
#define kFirstTextFieldOriginX 12.0
#define kFirstTextFieldOriginY 45.0
#define kTextFieldSpacingY 12.0
   
    
    //alert view for changing passcode
    UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(kMoreChangePasscodeKey, "") message:@"\n\n\n" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", "") otherButtonTitles:NSLocalizedString(@"OK", ""), nil]autorelease];
    
    // Adds a username Field
    UITextField* utextfield = [[UITextField alloc] initWithFrame:CGRectMake(kFirstTextFieldOriginX, kFirstTextFieldOriginY, kTextFieldWidth, kTextFieldHeight)]; 
    utextfield.placeholder = NSLocalizedString(kOriginalPasscodePlaceholerKey, "");
    [utextfield setBackgroundColor:[UIColor whiteColor]];
    utextfield.enablesReturnKeyAutomatically = YES;
    [utextfield setReturnKeyType:UIReturnKeyDone];    
    utextfield.secureTextEntry = YES;
    utextfield.tag = kOriginalPasscodeViewTag;
    utextfield.borderStyle = UITextBorderStyleRoundedRect;
    [utextfield performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.05]; 
    
    
    UITextField* newPasscodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(kFirstTextFieldOriginX, kFirstTextFieldOriginY+kTextFieldHeight+kTextFieldSpacingY, kTextFieldWidth, kTextFieldHeight)]; 
    newPasscodeTextField.placeholder = NSLocalizedString(kNewPasscodePlaceholerKey, "");
    [newPasscodeTextField setBackgroundColor:[UIColor whiteColor]];
    newPasscodeTextField.enablesReturnKeyAutomatically = YES;
    [newPasscodeTextField setReturnKeyType:UIReturnKeyDone];
    newPasscodeTextField.secureTextEntry = YES;
    newPasscodeTextField.tag = kNewPasscodeViewTag;
    newPasscodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    [alertView addSubview:utextfield];
    [alertView addSubview:newPasscodeTextField];
    
    [utextfield release];
    [newPasscodeTextField release];
    
    // Show alert on screen.
    [alertView show];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
        self.title = NSLocalizedString(@"TabTitleMore", "");
        self.tabBarItem.image = [UIImage imageNamed:@"ICN_more_ON"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"CFBundleDisplayName", @"");
    tableView.delegate = self;
    tableView.dataSource = self;
    if([AppDelegate isPurchased])    
    {
        tableView.separatorColor = [UIColor orangeColor];
        self.navigationItem.rightBarButtonItem = nil;
    }
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
    
    NSString * email = [NSString stringWithFormat:@"mailto:&subject=%@&body=%@", NSLocalizedString(@"CFBundleDisplayName", @""), @""];
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
    
    [picker setSubject:NSLocalizedString(@"CFBundleDisplayName", @"")];    
    [picker setMessageBody:@"" isHTML:YES];     
    
    // Set up recipients
    //    NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"]; 
    //    NSArray *bccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
    NSArray *recipients = [NSArray arrayWithObject:@"ramonqlee1980@gmail.com"]; 
    
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
