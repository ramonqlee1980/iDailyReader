//
//  FlipDetailViewController.m
//  FlipViewTest
//
//  Created by Mac Pro on 6/6/12.
//  Copyright (c) Dawn(use for learn,base on CAShowcase demo). All rights reserved.
//

#import "FlipDetailViewController.h"
#import "AdsConfig.h"
#import "Flurry.h"


@implementation FlipDetailViewController
@synthesize delegate;
@synthesize indexNumber;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [Flurry logEvent:kOpenExistFavorite];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
	self.navigationItem.leftBarButtonItem = item;
	[item release];
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteItem:)];
    self.navigationItem.rightBarButtonItem = deleteButton;
    [deleteButton release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    [tap release];
    


    UIImageView *imageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"notepad.png"]] autorelease];
    imageView.userInteractionEnabled = YES;
//    imageView.frame =  CGRectMake(10, 10, 300, 350);
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
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(35, 50, 200, 180)];
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
    
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 285, 150, 30)];
    dateLabel.tag = 510;
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont fontWithName:@"AmericanTypewriter-CondensedLight" size:17];//MarkerFelt-Thin
    dateLabel.transform = CGAffineTransformMakeRotation(-M_PI_2/20);
    [imageView addSubview:dateLabel];  


}
- (void)viewWillAppear:(BOOL)animated
{
    NSMutableArray *dataMutableArray = [[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:kAppIdOnAppstore];
    textView.text = [[dataMutableArray objectAtIndex:indexNumber] objectForKey:@"text"];
//    dateLabel.text = [[dataMutableArray objectAtIndex:indexNumber]objectForKey:@"date"];

}
-(void)hideKeyboard:(UITapGestureRecognizer *)recognizer{
    [textView resignFirstResponder];
}
- (void)textViewDidEndEditing:(UITextView *)atextView
{
    NSMutableArray *dataMutableArray = [[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:kAppIdOnAppstore];
    NSDictionary *dataDic = [dataMutableArray objectAtIndex:indexNumber];
    NSString *dateString = [dataDic objectForKey:@"date"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:textView.text,@"text",dateString,@"date", nil];
    [dataMutableArray replaceObjectAtIndex:indexNumber withObject:dic];
}

-(void)close:(id)sender{
    [delegate FlipDetailViewControllerClose:self];
}
-(void)deleteItem:(id)sender{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定要删除么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //取消
            break;
        case 1:
            //确定
        {
            NSMutableArray *dataMutableArray = [[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:kAppIdOnAppstore];
            [dataMutableArray removeObjectAtIndex:indexNumber];
            [[NSUserDefaults standardUserDefaults]setObject:dataMutableArray forKey:kAppIdOnAppstore];
            [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshFlipViewAfterDelete object:nil];
        }
            break;    
        default:
            break;
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.delegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
