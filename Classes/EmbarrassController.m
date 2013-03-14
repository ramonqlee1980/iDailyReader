//
//  EmbarrassController.m
//  HappyLife
//
//  Created by ramonqlee on 3/10/13.
//
//

#import "EmbarrassController.h"
#import "Constants.h"
#import "CJSONDeserializer.h"
#import "ContentCellModel.h"
#import "FileModel.h"
#import "AppDelegate.h"
#import "MCSegmentedControl.h"
#import "ThemeManager.h"

#define FTop      0
#define FRecent   1
#define FPhoto    2

#define kFileDir @"EMData"
#define kRefreshFileName @"Refresh"
#define kLoadMoreFileName @"Loadmore"

#define kInitPage 1

@interface EmbarrassController ()

@property(nonatomic,assign)NSUInteger page;
@property(nonatomic,assign)NSUInteger selectedSegmentIndex;
-(void) BtnClicked:(id)sender;
@end

@implementation EmbarrassController
@synthesize page;
@synthesize selectedSegmentIndex;
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

#pragma  PullingRefreshDelegate
-(BOOL)refreshData:(FileModel*)fileModel
{
    NSString* url = [self getUrl];
    fileModel.fileURL = [NSString stringWithFormat:url,++self.page];//for the latest page
    
    fileModel.destPath = kFileDir;
    fileModel.fileName = [NSString stringWithFormat:@"%@%d",kRefreshFileName,selectedSegmentIndex];
        
    [SharedDelegate beginRequest:fileModel isBeginDown:YES setAllowResumeForFileDownloads:NO];
    return YES;
}
-(BOOL)loadMoreData:(FileModel*)fileModel
{
    NSString* url = [self getUrl];
    fileModel.fileURL = [NSString stringWithFormat:url,++self.page];//for the latest page
    
    fileModel.destPath = kFileDir;
    fileModel.fileName = [NSString stringWithFormat:@"%@%d",kLoadMoreFileName,selectedSegmentIndex];
    
    [SharedDelegate beginRequest:fileModel isBeginDown:YES setAllowResumeForFileDownloads:NO];
    return YES;
}

-(NSArray*)parseData:(NSData*)data
{
    NSMutableArray* dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    if (data) {
        NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:nil];
#ifdef kIdreemsServerEnabled
        NSString* rootItem = @"data";
#else
        NSString* rootItem = @"items";
#endif
        if ([dictionary objectForKey:rootItem]) {
            NSArray *array = [NSArray arrayWithArray:[dictionary objectForKey:rootItem]];
            for (NSDictionary *qiushi in array) {
                ContentCellModel *model = [[[ContentCellModel alloc]initWithDictionary:qiushi]autorelease];
                [dataArray addObject:model];
            }
        }
    }
    return dataArray;
}

#pragma mark segmentbar
-(void) BtnClicked:(id)sender
{
    //reset page
    page = kInitPage;//page starts from 1
    
    UISegmentedControl *btn =(UISegmentedControl *) sender;
    //same?
    if (selectedSegmentIndex==btn.selectedSegmentIndex) {
        return;
    }
    selectedSegmentIndex = btn.selectedSegmentIndex;
    [self.m_contentViewController launchRefreshing];
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
	MCSegmentedControl *segmentedControl = [[MCSegmentedControl alloc] initWithItems:segmentTextContent];
    selectedSegmentIndex = FRecent;
	segmentedControl.selectedSegmentIndex = FRecent;//the middle one
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    segmentedControl.tintColor = TintColor;
    segmentedControl.selectedItemColor = [UIColor purpleColor];
    segmentedControl.unselectedItemColor = [UIColor grayColor];
	segmentedControl.frame = CGRectMake(0, 0, 400, segmentedControlHeight);
	[segmentedControl addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventValueChanged];
    
	self.navigationItem.titleView = segmentedControl;
	[segmentedControl release];
}


#pragma mark view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    page = kInitPage;
    self.m_contentViewController.delegate = self;
    [self loadSegmentBar];
    
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", @"Back") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    backButton.tintColor = TintColor;
    self.navigationItem.rightBarButtonItem = backButton;
    [backButton release];
    
    
}

-(void)dealloc
{
    [super dealloc];
}
#pragma mark util methods
-(void)back
{
    [self dismissModalViewControllerAnimated:YES];
}
-(NSString*)getUrl
{
    int count = 30;
    
    NSString* url = @"";
    switch (selectedSegmentIndex) {
        case FTop:
        {
            url = SuggestURLString(count,page);
        }
            
            break;
        case FPhoto:
        {
            url = ImageURLString(count, page);
        }
            break;
        case FRecent:
        default:
        {
            url = LastestURLString(count, page);
        }
            break;
    }
    
    return url;
}
@end
