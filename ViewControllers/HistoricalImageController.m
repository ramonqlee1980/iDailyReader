//
//  HistoricalImageController.m
//  com.idreems.mrh
//
//  Created by ramonqlee on 1/1/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import "HistoricalImageController.h"
#import "FileModel.h"

@interface HistoricalImageController ()

@end

@implementation HistoricalImageController
@synthesize options=_options;
#pragma mark fileModel
-(FileModel*)fileModel
{
#define kImageEventFile @"imageevents.json"
#define kImagesEventsChanged @"kImagesEventsChanged"
    
#define kMinSearchLength 1
//when q's length less than kMinSearchLength,server will give it a default keyword
#define kRssImageSearch @"http://www.idreems.com/php/imagesearch/index.php?q=%@"
#define kDestinationName @"TextEvents"
    
    FileModel* fileModel = [[[FileModel alloc]init]autorelease];
    fileModel.fileURL = [NSString stringWithFormat:kRssImageSearch,@"1"];
    fileModel.fileName = kImageEventFile;
    fileModel.destPath = kDestinationName;
    fileModel.notificationName = kImagesEventsChanged;
    return fileModel;
}
#pragma mark segmentbar
-(void)loadSegmentBar
{
    const CGFloat kNavigationBarInnerViewMargin = 7;
    const CGFloat segmentedControlHeight = self.navigationController.navigationBar.frame.size.height-kNavigationBarInnerViewMargin*2;
    // segmented control as the custom title view
	NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   NSLocalizedString(@"MM", @""),
                                   NSLocalizedString(@"VIP", @""),
                                   NSLocalizedString(@"GUY", @""),
                                   
								   nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = 1;//the middle one
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 400, segmentedControlHeight);
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
    //	defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
    
	self.navigationItem.titleView = segmentedControl;
	[segmentedControl release];
}

- (IBAction)segmentAction:(id)sender
{
	// The segmented control was clicked, handle it here
//	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
//	NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
    //switch content
//    [self loadContent:[self getFilePath:segmentedControl.selectedSegmentIndex]];
}
#pragma mark view lifecycle
-(void)loadView
{
    [super loadView];
    //[self loadSegmentBar];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Image";
    }
    return self;
}
-(void)back
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStyleBordered target:self action:@selector(showListView)];
	// Do any additional setup after loading the view.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = backButton;
    [backButton release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showListView
{
    if(!_options)
    {
        _options = [[NSArray arrayWithObjects:
                     [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"facebook.png"],@"img",@"Facebook",@"text", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"twitter.png"],@"img",@"Twitter",@"text", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"tumblr.png"],@"img",@"Tumblr",@"text", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"google-plus.png"],@"img",@"Google+",@"text", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"linkedin.png"],@"img",@"LinkedIn",@"text", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"pinterest.png"],@"img",@"Pinterest",@"text", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"dribbble.png"],@"img",@"Dribbble",@"text", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"deviant-art.png"],@"img",@"deviantArt",@"text", nil],
                     nil] retain];
    }
    PopupTableView *lplv = [[PopupTableView alloc] initWithTitle:@"FindMoreImages" options:_options];
    lplv.delegate = self;
    [lplv showInView:self.view.window animated:YES];
    [lplv release];
}

#pragma mark - PopupTableView delegates
- (void)popTableView:(PopupTableView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    //_infoLabel.text = [NSString stringWithFormat:@"You have selected %@",[[_options objectAtIndex:anIndex] objectForKey:@"text"]];
}
- (void)popTableViewDidCancel
{
   //_infoLabel.text = @"You have cancelled";
}
-(void)dealloc
{
    [_options release];
    [super dealloc];
}
@end
