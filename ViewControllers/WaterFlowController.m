#import "WaterFlowController.h"
#import "FileModel.h"
#import "AppDelegate.h"
#import "CommonHelper.h"
#import "JsonKeys.h"
#import "ImageViewController.h"

//internal use
#define kNumberOfColumnsInWaterFlowView 3
#define kDataPath @"data"

@interface WaterFlowController()
{
    WaterFlowView *waterFlow;
    NSString* mDataUrl;
}

- (void)dataSourceDidLoad;
- (void)dataSourceDidError;
@end

@implementation WaterFlowController
@synthesize mArrayData;
@synthesize mFileModel;

#pragma mark init
-(id)init
{
    self.mFileModel = [self fileModel];
    return [super init];
}

#pragma mark network request
-(void)startNetworkRequest
{    
    //start request for data
    [APPDELEGATE beginRequest:mFileModel isBeginDown:YES setAllowResumeForFileDownloads:NO];
}
#pragma mark file util
-(NSString*)getImagesFile
{
    NSString* desFilePath = [self getDataPath];
    return [desFilePath stringByAppendingPathComponent:mFileModel.fileName];
}
-(NSString*)getDataPath
{
    NSString* desFilePath = [CommonHelper getTargetBookPath:mFileModel.destPath];
    return desFilePath;//[desFilePath stringByAppendingPathComponent:kDataPath];
}

#pragma  mark contentChanged notification
-(void)contentChanged:(NSNotification*)notification
{
    if(notification)
    {
        if([notification.object isKindOfClass:[NSString class]])
        {            
            mDataUrl = [self getImagesFile];
            [self loadInternetData];
        }
    }
}

#pragma mark loadContent
#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mArrayData = [[NSMutableArray alloc] init];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStyleBordered target:self action:@selector(loadMore)];
    
    waterFlow = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-44)];
    waterFlow.waterFlowViewDelegate = self;
    waterFlow.waterFlowViewDatasource = self;
    waterFlow.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:waterFlow];
    [waterFlow release];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(contentChanged:) name:mFileModel.notificationName object:nil];
    mDataUrl = [self getImagesFile];
    if([CommonHelper isExistFile:mDataUrl])
    {
        [self loadInternetData];
    }
    [self startNetworkRequest];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)jsonDecode:(NSData*)data
{
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (res && [res isKindOfClass:[NSDictionary class]]) {

        [mArrayData addObjectsFromArray:[res objectForKey:kGoogleSearchResponseDataJson]];
        //arrayData = [[res objectForKey:@"gallery"] retain];
        //NSLog(@"arr == %@",arrayData);
        [self dataSourceDidLoad];
    } else {
        [self dataSourceDidError];
        
        //NSLog(@"arr dataSourceDidError == %@",arrayData);
    }
}
- (void)loadInternetData {

    // Request
    NSURL *URL = [NSURL URLWithString:mDataUrl];
    if(!URL)
    {
        NSData* data = [NSData dataWithContentsOfFile:mDataUrl];
        [self jsonDecode:data];
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (!error && responseCode == 200) {
            [self jsonDecode:data];
        } else {
            [self dataSourceDidError];
            //NSLog(@"dataSourceDidError == %@",arrayData);
        }
    }];
}

- (void)dataSourceDidLoad {
    [waterFlow reloadData];
}

- (void)dataSourceDidError {
    [waterFlow reloadData];
}



-(void)loadMore{

    [mArrayData addObjectsFromArray:mArrayData];
    [waterFlow reloadData];
}

#pragma mark WaterFlowViewDataSource
- (NSInteger)numberOfColumsInWaterFlowView:(WaterFlowView *)waterFlowView{

    return kNumberOfColumnsInWaterFlowView;
}

- (NSInteger)numberOfAllWaterFlowView:(WaterFlowView *)waterFlowView{

    return [mArrayData count];
}

- (UIView *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(IndexPath *)indexPath{
    
    ImageViewCell *view = [[ImageViewCell alloc] initWithIdentifier:nil];
    
    return view;
}

-(void)waterFlowView:(WaterFlowView *)waterFlowView  relayoutCellSubview:(UIView *)view withIndexPath:(IndexPath *)indexPath{
    
    //arrIndex是某个数据在总数组中的索引
    int arrIndex = indexPath.row * waterFlowView.columnCount + indexPath.column;
    
    
    NSDictionary *object = [mArrayData objectAtIndex:arrIndex];
    NSString* imageUrl = [NSString stringWithFormat:@"%@",[object objectForKey:ktbUrl]];
    NSObject* urls  = [object objectForKey:ktbUrl];
    if([urls isKindOfClass:[NSArray class]])
    {
        if([((NSArray*)urls) count]>0)
        {
            imageUrl = [((NSArray*)urls)objectAtIndex:0];
        }
    }
    
    
    NSURL *URL = [NSURL URLWithString:[imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ImageViewCell *imageViewCell = (ImageViewCell *)view;
    imageViewCell.indexPath = indexPath;
    imageViewCell.columnCount = waterFlowView.columnCount;
    [imageViewCell relayoutViews];
    [(ImageViewCell *)view setImageWithURL:URL];
}


#pragma mark WaterFlowViewDelegate
- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(IndexPath *)indexPath{

    int arrIndex = indexPath.row * waterFlowView.columnCount + indexPath.column;
    NSDictionary *dict = [mArrayData objectAtIndex:arrIndex];
    
    float width = 0.0f;
    float height = 0.0f;
    if (dict) {
        
        width = [[dict objectForKey:ktbWidth] floatValue];
        height = [[dict objectForKey:ktbHeight] floatValue];
    }
    
    const CGFloat kZero = 0.01;
    const CGFloat kNonZero = 100;
    width = (width<kZero)?kNonZero:width;
    height = (height<kZero)?kNonZero:height;  
    
    
    return waterFlowView.cellWidth * (height/width);
}

- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(IndexPath *)indexPath{

    NSLog(@"indexpath row == %d,column == %d",indexPath.row,indexPath.column);
    ImageViewController* detail = [ImageViewController new];
    
    int arrIndex = indexPath.row * waterFlowView.columnCount + indexPath.column;
    NSDictionary* item = (NSDictionary *)[mArrayData objectAtIndex:arrIndex];
    [detail initWithData:[item objectForKey:kTitleNoFormatting] imageUrl:[item objectForKey:kUnescapeImageUrl] placeHolderImageUrl:[item objectForKey:ktbUrl] imageWidth:[[item objectForKey:kWidth] intValue] imageHeight:[[item objectForKey:kHeight] intValue]];
	[self.navigationController pushViewController:detail animated:YES];
    [detail release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [mArrayData release];
    [mFileModel release];
    [super dealloc];
}

@end
