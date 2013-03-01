
#import "TextEventsController.h"
#import "NSString+HTML.h"
#import "TextEventDetailController.h"
#import "AppDelegate.h"
#import "FileModel.h"
#import "CommonHelper.h"
#import "JsonKeys.h"
#import "ImageViewController.h"

#define kYesterdaySegmentIndex 0
#define kTodaySegmentIndex 1
#define kTommorrowSegmentIndex 2

//offset from today
#define kYesterdayOffset -1
#define kTodayOffset 0
#define kTommorrowOffset 1
#define kDayAfterTommorrow 2

//format:1-2--1-4(start date to end date,inclusive)
#define kRssDatedUrl @"http://www.idreems.com/php/todayinhistory/index.php?channel=%@--%@"
#define kRssUrl @"http://www.idreems.com/php/todayinhistory/index.php?channel=textevents"
#define kFileName @"historyevent"
#define kDestinationName @"TextEvents"
#define kDataPath @"data"

#define kTextEventsChanged @"kTextEventsChanged"

#define kSubtitleNumberOfLines 1

@implementation TextEventsController

@synthesize itemsToDisplay;

#pragma mark -
#pragma mark View lifecycle

#pragma mark segmentbar
-(void)loadSegmentBar
{
    const CGFloat kNavigationBarInnerViewMargin = 7;
    const CGFloat segmentedControlHeight = self.navigationController.navigationBar.frame.size.height-kNavigationBarInnerViewMargin*2;
    // segmented control as the custom title view
	NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   NSLocalizedString(@"Yesterday", @""),
                                   NSLocalizedString(@"Today", @""),
                                   NSLocalizedString(@"Tommorrow", @""),
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
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
    //switch content
    [self loadContent:[self getFilePath:segmentedControl.selectedSegmentIndex]];
}
- (id)initWaitingView
{
    if (self) {
        const CGRect frame = self.view.frame;
        const CGFloat frameWidth = frame.size.width;
        const CGFloat frameHeight = frame.size.height;
        const CGFloat width = frame.size.width/2;
        activityViewLoad = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityViewLoad.frame = CGRectMake(frameWidth/2, frameHeight/2, width, width);
        activityViewLoad.center = CGPointMake(frameWidth/2, frameHeight/2);
        [self.view addSubview:activityViewLoad];
        [activityViewLoad release];
        [activityViewLoad startAnimating];
    }
    return self;
}
-(void)loadView
{
    [super loadView];
    [self initWaitingView];
    [self loadSegmentBar];
}
-(void)back
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    
	// Super
	[super viewDidLoad];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = backButton;
    [backButton release];
    
	// Setup
//	
    UITabBarItem *localTabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:0]autorelease];
    [self setTabBarItem:localTabBarItem];
    
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	parsedItems = [[NSMutableArray alloc] init];
	self.itemsToDisplay = [NSArray array];
	
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(contentChanged:) name:kTextEventsChanged object:nil];
    NSString* todayFile = [TextEventsController getDatedFile:kTodayOffset];
    if([CommonHelper isExistFile:todayFile])
    {
        [self loadContent:todayFile];
    }
    [self startNetworkRequest];
}
#pragma mark network request
-(NSString*)getNeedDataRssUrl
{
    NSDate* today = [NSDate date];
    NSString* startDate = [TextEventsController getDate:today offset:kYesterdayOffset];
    NSString* endDate = [TextEventsController getDate:today offset:kTommorrowOffset];
    
    NSString* startDateFile = [TextEventsController getDatedFile:kYesterdayOffset];
    if ([CommonHelper isExistFile:startDateFile]) {
        startDateFile = [TextEventsController getDatedFile:kTodayOffset];
        if([CommonHelper isExistFile:startDateFile])
        {
            startDate = nil;
            startDateFile = nil;
        }
        else
        {
            startDate = [TextEventsController getDate:today offset:kTodayOffset];
        }
    }
    
    NSString* endDateFile = [TextEventsController getDatedFile:kTommorrowOffset];
    if ([CommonHelper isExistFile:endDateFile]) {
        endDate = nil;
    }
    
#if 1
    return (nil==startDate && nil==endDate)?nil:kRssUrl;
#else
    startDate = (!startDate)?endDate:startDate;
    
    return [NSString stringWithFormat:kRssDatedUrl,startDate,endDate];
#endif
}
-(void)startNetworkRequest
{
    //TODO::fail to request
    
    //start request for data
    NSString* needDataUrl = [self getNeedDataRssUrl];
    if(!needDataUrl)
    {
        return;
    }
    FileModel* fileModel = [[[FileModel alloc]init]autorelease];
    //get data
    
    fileModel.fileURL = needDataUrl;
    fileModel.fileName = kFileName;
    fileModel.destPath = kDestinationName;
    fileModel.notificationName = kTextEventsChanged;
    [APPDELEGATE beginRequest:fileModel isBeginDown:YES setAllowResumeForFileDownloads:NO];
}

#pragma  mark contentChanged notification
-(void)contentChanged:(NSNotification*)notification
{
    if(notification)
    {
        if([notification.object isKindOfClass:[NSString class]])
        {
            NSString* fileDir = (NSString*)notification.object;
            NSRange r = [fileDir rangeOfString:kFileName options:NSBackwardsSearch];
            if (r.length) {
                fileDir = [fileDir substringToIndex:r.location];
                fileDir = [fileDir stringByAppendingPathComponent:kDataPath];
            }
            mDataPath = [fileDir retain];
            
            [self loadContent:[TextEventsController getDatedFile:kTodayOffset]];
        }
        else if([notification.object isKindOfClass:[NSError class]])//error
        {
            //TODO::fail to load data
            [self stopActiviyViewLoader];
        }
    }
}
-(NSString*)getFilePath:(NSInteger)index
{
    switch (index) {
        case kYesterdaySegmentIndex:
            return [TextEventsController getDatedFile:kYesterdayOffset];
        case kTodaySegmentIndex:
            return [TextEventsController getDatedFile:kTodayOffset];
        case kTommorrowSegmentIndex:
            return [TextEventsController getDatedFile:kTommorrowOffset];
        default:
            break;
    }
    return [TextEventsController getDatedFile:kTodayOffset];
}

#pragma mark loadContent
-(void)loadContent:(NSString*)path
{
    NSData* data = [NSData dataWithContentsOfFile:path];
    if (data) {
        [self jsonDecode:data];
    }
}

-(void)jsonDecode:(NSData*)data
{
    if (!data) {
        return;
    }
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (res && [res isKindOfClass:[NSDictionary class]]) {
        [parsedItems removeAllObjects];
        [parsedItems addObjectsFromArray:[res objectForKey:kGoogleSearchResponseDataJson]];
        //arrayData = [[res objectForKey:@"gallery"] retain];
        //NSLog(@"arr == %@",arrayData);
        [self updateTableWithParsedItems];
    } else {
        //NSLog(@"arr dataSourceDidError == %@",arrayData);
    }
}
-(void)stopActiviyViewLoader
{
    if (activityViewLoad) {
        
        [activityViewLoad stopAnimating];
        [activityViewLoad removeFromSuperview];
        activityViewLoad = nil;
    }
}
- (void)updateTableWithParsedItems {
    [self stopActiviyViewLoader];
    
    
    
	self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
						   [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"date"
																				 ascending:NO] autorelease]]];
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itemsToDisplay.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	// Configure the cell.
	NSDictionary *item = [itemsToDisplay objectAtIndex:indexPath.row];
    
	if (item) {
		// Process
		NSString *itemTitle = [item objectForKey:kTitle] ? [[item objectForKey:kTitle] stringByConvertingHTMLToPlainText] : @"[No Title]";
		NSString *itemSummary = [item objectForKey:kDescription];
        
        if(!itemSummary)
           itemSummary = @"[No Summary]";
		
		// Set
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
		cell.textLabel.text = itemTitle;
        NSObject* urls  = [item objectForKey:ktbUrl];
        if([urls isKindOfClass:[NSArray class]])
        {
            if([((NSArray*)urls) count]>0)
            {
                NSString* url = [((NSArray*)urls)objectAtIndex:0];
                cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            }
        }
        
		NSMutableString *subtitle = [NSMutableString string];
		[subtitle appendString:itemSummary];
        cell.detailTextLabel.numberOfLines = kSubtitleNumberOfLines;
		cell.detailTextLabel.text = subtitle;
		
	}
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// Show detail
#if 0
	TextEventDetailController *detail = [[TextEventDetailController alloc] initWithStyle:UITableViewStyleGrouped];
	detail.item = (NSDictionary *)[itemsToDisplay objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:detail animated:YES];
	[detail release];
#else
    ImageViewController* detail = [ImageViewController new];
    NSDictionary* item = (NSDictionary *)[itemsToDisplay objectAtIndex:indexPath.row];
    [detail initWithData:[item objectForKey:kDescription] imageUrl:[item objectForKey:kImageUrl] placeHolderImageUrl:[item objectForKey:kImageUrl] imageWidth:[[item objectForKey:kWidth] intValue] imageHeight:[[item objectForKey:kHeight] intValue]];
	[self.navigationController pushViewController:detail animated:YES];
    [detail release];
#endif
	
	// Deselect
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [mDataPath release];
	[formatter release];
	[parsedItems release];
	[itemsToDisplay release];
    [super dealloc];
}

#pragma mark file util
+(NSString*)getDatedFile:(NSInteger)dayOffset
{
    NSString* fileName = [NSString stringWithFormat:@"%@.json",[TextEventsController getDate:[NSDate date] offset:dayOffset]];
    
    return [TextEventsController getFilePath:fileName destinationDir:kDestinationName subPath:kDataPath];

}
+(NSString*)getDate:(NSDate*)date offset:(NSInteger)dayOffset
{
    NSDateComponents *componentsToSubtract = [[[NSDateComponents alloc] init] autorelease];
    [componentsToSubtract setDay:dayOffset];
    
    NSDate *retDate = [[NSCalendar currentCalendar] dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit ;
    NSDateComponents *dd = [cal components:unitFlags fromDate:retDate];
    return [NSString stringWithFormat:@"%d-%d",[dd month],[dd day]];
}
+(NSString*)getFilePath:(NSString*)fileName destinationDir:(NSString*)destinationDir subPath:(NSString*)dataPath
{    
    NSString* path = [[TextEventsController getDataPath:destinationDir subPath:dataPath] retain];
    
    return [path stringByAppendingPathComponent:fileName];
}
+(NSString*)getDataPath:(NSString*)destinationDir subPath:(NSString*)dataPath
{
    NSString* desFilePath = [CommonHelper getTargetBookPath:destinationDir];
    return [desFilePath stringByAppendingPathComponent:dataPath];
}

@end
