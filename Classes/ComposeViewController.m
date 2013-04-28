//
//  ComposeViewController.m
//  SinaOAuth
//
//  Created by liuyuning on 11-7-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ComposeViewController.h"
#import "GetImage.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ThemeManager.h"

#define kWordPressPostUrl @"http://www.idreems.com/wordpressTest/demo.php"
#define kTitle @"Title"
#define kBody @"Body"

#define MAX_PIC_SIZE (5*1024*1024)

@implementation ComposeViewController
@synthesize textView,imageView,insertImgBtn,activityIndicator;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//set self
	self.title = @"发发";
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue.png"]];
	
	UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleBordered target:self action:@selector(send:)];
    send.tintColor = TintColor;
	self.navigationItem.rightBarButtonItem = send;
	[send release];
	
	[textView becomeFirstResponder];
	
	getImage = [[GetImage alloc] init];
    [activityIndicator setHidden:YES];
	getImage.parentViewController = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getResult:) name:kPostNotification object:nil];
}
-(void)getResult:(NSNotification*)notification
{
    if (notification) {
        BOOL success = ![notification.object isKindOfClass:[NSError class]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:success?@"恭喜你，发表成功！":@"发表失败，请重试！" message:success?nil:notification.object delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
	
	[imageView release];
	[textView release];
	[insertImgBtn release];
    self.activityIndicator = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
	getImage.parentViewController = nil;
	[getImage release];
	
    [super dealloc];
}

- (void)send:(id)sender{
	if (isSending)
		return;
	isSending = YES;
	
	if (!textView.text || [textView.text isEqualToString:@""])
		return;
    [activityIndicator setHidden:NO];
    //title & content
    //send to server
   
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:kTitle,kTitle,textView.text,kBody,nil];
    [SharedDelegate beginPostRequest:kWordPressPostUrl withDictionary:data];
}

- (void)insertImage:(id)sender{
	NSLog(@"insertImage");
	if (imageView.image) {
		imageView.image = nil;
		[insertImgBtn setTitle:@"插入图片"];
	}
	else {
		[getImage selectImage];
	}
}

- (void)setImage:(UIImage*)image{
	imageView.image = image;
	if (imageView.image) {
		[insertImgBtn setTitle:@"删除图片"];
	}
}
@end
