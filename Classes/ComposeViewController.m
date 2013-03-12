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
        BOOL success = (notification.object==nil);
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
	
	//参考地址 发纯文本用update  发图文用upload
	//http://open.weibo.com/wiki/index.php/Statuses/update
	//http://open.weibo.com/wiki/index.php/Statuses/upload
	
//	BOOL usePic = NO;
//	NSData *picData = UIImageJPEGRepresentation(imageView.image, 1.0);
//	if (picData && [picData length]<MAX_PIC_SIZE) {
//		usePic = YES;
//		NSLog(@"Use Pic");
//	}
//	
//	//url
//	NSString *stringURL = @"http://api.t.sina.com.cn/statuses/update.json";	
//	if (usePic)
//		stringURL = @"http://api.t.sina.com.cn/statuses/upload.json";
//	
//	//signature
//	OAConsumer *consumer = [[OAConsumer alloc] initWithKey:APPKEY secret:APPSECRET];
//	OAToken *token_Access = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:TOKEN_PROVIDER prefix:TOKEN_PREFIX];
//	
//	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:stringURL]
//																   consumer:consumer
//																	  token:token_Access
//																	  realm:nil
//														  signatureProvider:nil];
//	
//	//content
//	NSString *status = [NSString stringWithFormat:@"status=%@",textView.text];
//	NSData *bodyData = [status dataUsingEncoding:NSUTF8StringEncoding];
//	[request setHTTPBody:bodyData];
//	[request setHTTPMethod:@"POST"];
//	
//	//if use picture (Form-based File Upload in HTML http://www.ietf.org/rfc/rfc1867.txt )
//	if (usePic) {
//		NSString *boundary = @"AAAVVVAAA";
//		NSString *boundaryEnd = [NSString stringWithFormat:@"\r\n--%@--\r\n",boundary];
//		NSString *Content_Type = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//		
//		NSMutableString *bodyString = [NSMutableString stringWithCapacity:100];
//		[bodyString appendFormat:@"--%@",boundary];
//		[bodyString appendString:@"\r\nContent-Disposition: form-data; name=\"status\"\r\n\r\n"];
//		[bodyString appendString:textView.text];
//		[bodyString appendFormat:@"\r\n--%@",boundary];
//		[bodyString appendString:@"\r\nContent-Disposition: form-data; name=\"pic\"; filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"];
//		//image.jpg image/jpeg | image.png image/png | image.gif image/gif
//		
//		//data
//		NSMutableData *bodyDataWithPic = [NSMutableData dataWithData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
//		[bodyDataWithPic appendData:picData];
//		[bodyDataWithPic appendData:[boundaryEnd dataUsingEncoding:NSUTF8StringEncoding]];
//		
//		//set header
//		[request setValue:Content_Type forHTTPHeaderField:@"Content-Type"];
//		[request setValue:[NSString stringWithFormat:@"%d",[bodyDataWithPic length]] forHTTPHeaderField:@"Content-Length"];
//		
//		[request prepare];//先让bodyData签名 再修改为bodyDataWithPic
//		[request setHTTPBody:bodyDataWithPic];
//	}
//	else {
//		[request setOAuthParameterName:@"Content-Length" withValue:[NSString stringWithFormat:@"%d",[bodyData length]]];
//		[request prepare];
//	}
//	
//	//log
//	NSString *tempStringASCII = [[[NSString alloc] initWithData:[request HTTPBody] encoding:NSASCIIStringEncoding] autorelease];
//	NSLog(@"HTTPBody:%@",tempStringASCII);
//	NSLog(@"allHTTPHeaderFields:%@",[request allHTTPHeaderFields]);
//	
//	//send data
//	dispatch_queue_t queue = dispatch_queue_create("blocks",NULL);
//	dispatch_async(queue,^{
//		
//		NSError *error = nil;
//		NSURLResponse *response = nil;
//		
//		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//		
//		NSString *stringData = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
//		NSLog(@"%@",stringData);
//		
//		BOOL success = NO;
//		NSString *errString = nil;
//		
//		if (!error && data) {
//			id json = [[CJSONDeserializer deserializer] deserialize:data error:&error];
//			if (!error && json) {
//				if ([json isKindOfClass:[NSDictionary class]]) {
//					NSString *text = [json objectForKey:@"text"];
//					if (text && [text length]>0) {
//						success = YES;
//						NSLog(@"success");
//					}
//					else {
//						errString = [[json objectForKey:@"error"] retain];
//						NSLog(@"%@",errString);
//					}
//				}
//			}	 
//			else {
//				NSLog(@"error:%@",[error description]);
//			}
//		}
//		else {
//			NSLog(@"error:%@",[error description]);
//		}
//		
//		dispatch_async(dispatch_get_main_queue(),^{
//			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:success?@"恭喜你，发表成功！":@"发表失败，请重试！" message:success?nil:errString delegate:nil cancelButtonTitle:@"O  K" otherButtonTitles:nil];
//			[alertView show];
//			[alertView release];
//			[errString release];
//			
//			isSending = NO;
//		});
//	});
//	
//	dispatch_release(queue);
//	[request release];
//	
//	[consumer release];
//	[token_Access release];
	
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
