//
//  ComposeBlogController.m
//  HappyLife
//
//  Created by ramonqlee on 3/16/13.
//
//

#import "ComposeBlogController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ThemeManager.h"
#import "AdsConfig.h"
#import "AdsConfiguration.h"

#define kMaxTitleLength 50
#define kMaxBodyLength 1000
#define kWordPressPostUrl @"http://www.idreems.com/openapi/post.php"

#define kTitle @"Title"
#define kBody @"Body"
#define kTag @"Tag"

#define kDefaultBlogBody @"kDefaultBlogBody"
#define kDefaultBlogTitle @"kDefaultBlogTitle"

#define kDefaultNavigationTitle @"分享"

@interface ComposeBlogController ()
{
    BOOL isSending;
}
@end

@implementation ComposeBlogController
@synthesize titleTextView,bodyTextView,activityIndicator;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //set self
	self.title = kDefaultNavigationTitle;
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue.png"]];
	
	UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleBordered target:self action:@selector(send:)];
    send.tintColor = TintColor;
	self.navigationItem.rightBarButtonItem = send;
	[send release];
	
	[titleTextView becomeFirstResponder];
    bodyTextView.delegate = self;
    titleTextView.delegate = self;
    bodyTextView.text = NSLocalizedString(kDefaultBlogBody, @"");
    titleTextView.text = NSLocalizedString(kDefaultBlogTitle, @"");
 
//    bodyTextView.layer.cornerRadius = 10;
//    titleTextView.layer.cornerRadius = 5;
	
    [activityIndicator setHidden:YES];
	    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getResult:) name:kPostNotification object:nil];
}
-(void)dealloc
{
    [titleTextView release];
    [bodyTextView release];
    self.activityIndicator = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark util
- (void)send:(id)sender{
	if (isSending)
		return;
	isSending = YES;
	
	if (!titleTextView.text || [titleTextView.text isEqualToString:@""] ||
        !bodyTextView.text || [bodyTextView.text isEqualToString:@""])
		return;
    [activityIndicator setHidden:NO];
    //title & content
    //send to server
#ifdef kAdminVersion
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:titleTextView.text,kTitle,bodyTextView.text,kBody,kAppOnlineTag,kTag,@"1",@"Draft",nil];
#else
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:titleTextView.text,kTitle,bodyTextView.text,kBody,kAppOnlineTag,kTag,nil];
#endif
    [SharedDelegate beginPostRequest:kWordPressPostUrl withDictionary:data];
}


-(void)getResult:(NSNotification*)notification
{
    if (notification) {
        BOOL success = (![notification.object isKindOfClass:[NSError class]]);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:success?@"恭喜你，发表成功！":@"发表失败，请重试！" message:success?nil:notification.object delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView==bodyTextView) {
        bodyTextView.text = @"";
    }
    else
    {
        titleTextView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //set a placeholder
    if (textView.text.length) {
        return;
    }
    
    if (textView==bodyTextView) {
        bodyTextView.text = NSLocalizedString(kDefaultBlogBody, @"");
    }
    else
    {
        titleTextView.text = NSLocalizedString(kDefaultBlogTitle, @"");
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSUInteger length = textView.text.length;
    if (length==0) {
        return;
    }
    
    if (textView==bodyTextView) {
        if(length>kMaxBodyLength)
        {
            length = kMaxBodyLength;
        }
    }
    else
    {
        if(length>kMaxTitleLength)
        {
            length = kMaxTitleLength;
        }
    }

    textView.text = [textView.text substringToIndex:length];
}
@end
