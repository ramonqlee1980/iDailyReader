//
//  AddNewNoteViewController.m
//  FlipViewTest
//
//  Created by Mac Pro on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddNewNoteViewController.h"
#import "AdsConfig.h"
#import "Flurry.h"
#import "AdsConfiguration.h"
@implementation AddNewNoteViewController
//@synthesize delegateForAdd;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveNote)];
        self.navigationItem.rightBarButtonItem = save;
        [save release];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Flurry logEvent:kEnterNewFavorite];
    
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShowed:) name:UIKeyboardWillShowNotification object:self.view.window];
    UIImageView *imageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"notepad.png"]] autorelease];
    CGRect rc = [[UIScreen mainScreen]bounds];
    const NSUInteger kWidthMargin = 20;
    const NSUInteger kHeightMargin = 40;
    imageView.userInteractionEnabled = YES;
    BOOL phone = UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone;
    if(phone)
    {
        imageView.frame =  CGRectMake(10, 0, rc.size.width-kWidthMargin, rc.size.height-kHeightMargin);
    }
    else
    {
    imageView.frame =  CGRectMake(10, 10, rc.size.width-kWidthMargin, rc.size.height-kHeightMargin);
    }
    imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageView];
    if(phone)
    {
        textView = [[UITextView alloc]initWithFrame:CGRectMake(35, 60, rc.size.width-4*kWidthMargin, rc.size.height-4*kHeightMargin)];
    }
    else
    {
        textView = [[UITextView alloc]initWithFrame:CGRectMake(35, 200, rc.size.width-7*kWidthMargin, rc.size.height-5*kHeightMargin)];
    }
    textView.delegate = self;
    textView.tag = 500;
    textView.font = [UIFont fontWithName:@"KaiTi_GB2312" size:21];
    textView.backgroundColor = [UIColor clearColor];
    [imageView addSubview:textView];
//    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 285, 150, 30)];
    dateLabel.tag = 510;
    dateLabel.backgroundColor = [UIColor clearColor];
    NSDate * newDate = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * newDateOne = [dateformat stringFromDate:newDate];
    [dateformat setFormatterBehavior:NSDateFormatterFullStyle];
    [dateformat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];      
    textView.text = @"在这里输入记事本内容";
    //dateLabel.text = newDateOne;
    [dateformat release];
    dateString = [[NSString alloc]initWithString:newDateOne];
    dateLabel.font = [UIFont fontWithName:@"AmericanTypewriter-CondensedLight" size:17];//MarkerFelt-Thin
    dateLabel.transform = CGAffineTransformMakeRotation(-M_PI_2/20);
    [imageView addSubview:dateLabel];  
//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeButton setBackgroundImage:[UIImage imageNamed:@"closecurrentnote.png"] forState:UIControlStateNormal];
//    closeButton.frame = CGRectMake(10, 350, 300, 60);
//    closeButton.tag = 1000;
//    closeButton.hidden = YES;
//    [closeButton addTarget:self.navigationController.exposeController action:@selector(toggleExpose) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:closeButton];
//    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sendButton setBackgroundImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
//    sendButton.frame = CGRectMake(10, 0, 100, 50);
//    sendButton.tag = 1001;
//    sendButton.hidden = YES;
//    [sendButton addTarget:self.navigationController.exposeController action:@selector(tapOnSendButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:sendButton];

}
- (void)viewDidDisappear:(BOOL)animated
{
  //  [delegateForAdd refreshFlipView];
}// Called after the view was dismissed, covered or otherwise hidden. Default does nothing

#pragma mark - keyboard will show
-(void)hideKeyboard:(UITapGestureRecognizer *)recognizer{
    [textView resignFirstResponder];
    if (textView.text.length <=0) {
        textView.text = @"在这里输入记事本内容";
    }
}
//-(void)keyboardWillShowed:(NSNotification *)notification{
////    UITextView *textView = [self currentTextView];
//  NSLog(@"textview.tag:%d",textView.tag);
//  //  [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 0)];
//}
#pragma mark - UITextViewDelegate
//- (BOOL)textViewShouldBeginEditing:(UITextView *)atextView
//{
//    return YES;
//}
- (void)textViewDidBeginEditing:(UITextView *)atextView
{
    if ([textView.text isEqualToString:@"在这里输入记事本内容"]) {
        textView.text = nil;
    }
}
-(void)saveNote{
    NSMutableArray *dataMutableArray = [[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:[[AdsConfiguration sharedInstance]appleId]];
    [dataMutableArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:textView.text,@"text",dateString,@"date", nil]];
    //UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:nil message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]autorelease];
    //[alert show];
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshFlipView object:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

//- (void)textViewDidChange:(UITextView *)textView
//{
////    [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 0)];
//}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //self.delegateForAdd  = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
