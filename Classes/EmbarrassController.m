//
//  EmbarrassController.m
//  HappyLife
//
//  Created by ramonqlee on 3/10/13.
//
//

#import "EmbarrassController.h"
#import "Constants.h"
#define FTop      0
#define FRecent   1
#define FPhoto    2


@interface EmbarrassController ()
-(void) BtnClicked:(id)sender;
@end

@implementation EmbarrassController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"kFun", "");
        self.tabBarItem.image = [UIImage imageNamed:kIconFun];
        self.navigationItem.title = NSLocalizedString(@"Title", "");
        self.navigationController.navigationBarHidden = YES;
    }
    return self;
}

#pragma mark segmentbar
-(void) BtnClicked:(id)sender
{
    UISegmentedControl *btn =(UISegmentedControl *) sender;
    QiuShiType type  = QiuShiTypeTop;
    switch (btn.selectedSegmentIndex) {
        case FTop:
        {
            type = QiuShiTypeTop;
        }
            break;
        case FRecent:
        {
            type = QiuShiTypeNew;
        }
            break;
        case FPhoto:
        {
            type = QiuShiTypePhoto;
        }
            break;
        default:
            break;
    }
    [m_contentViewController LoadPageOfQiushiType:type Time:QiuShiTimeRandom];
    
}
-(void)loadSegmentBar
{
    const CGFloat kNavigationBarInnerViewMargin = 7;
    const CGFloat segmentedControlHeight = self.navigationController.navigationBar.frame.size.height-kNavigationBarInnerViewMargin*2;
    // segmented control as the custom title view
	NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   NSLocalizedString(@"最糗", @""),
                                   NSLocalizedString(@"最新", @""),
                                   NSLocalizedString(@"真相", @""),
								   nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = FRecent;//the middle one
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 400, segmentedControlHeight);
	[segmentedControl addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventValueChanged];
    
	self.navigationItem.titleView = segmentedControl;
	[segmentedControl release];
}
#pragma mark view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", @"Back") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = backButton;
    [backButton release];
    
    [self loadSegmentBar];
}

#pragma mark util methods
-(void)back
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
