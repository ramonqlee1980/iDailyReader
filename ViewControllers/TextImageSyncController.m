//
//  TextImageSyncController.m
//  com.idreems.mrh
//
//  Created by ramonqlee on 2/3/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import "TextImageSyncController.h"
#import "ImageWithTextCell.h"
#import "ResponseJson.h"
#import "FileModel.h"
#import "CommonHelper.h"
#import "AppDelegate.h"
#import "ZJTStatusBarAlertWindow.h"

//url and related file name on local machine
//url is pulled from server and others are derived from this url
#define kDefaultResouceUrl @"http://www.idreems.com/php/embarrasepisode/embarrassing.php?type=image_latest&page=%d&count=20"
#define kDefaultResouceName @"Timeline"

#define kRefreshFileName @"timelinejson"
#define kLoadMoreFileName @"timelinejsonloadmore"


#define kInitPage 1

#define kTimelineJsonRefreshChanged @"kTimelineJsonRefreshChanged"
#define kTimelineJsonLoadMoreChanged @"kTimelineJsonLoadMoreChanged"

#define kWeiboTimelineResponseDataJson @"data"

@interface TextImageSyncController ()
{
    NSUInteger mCurrentLoadMorePage;
    FileModel* fileModel;
}
@property(nonatomic,retain)FileModel* fileModel;
@end

@implementation TextImageSyncController
@synthesize fileModel;
@synthesize resourceName;
@synthesize resourceUrl;

#pragma mark - PullTableViewDelegate

- (void)pullPsCollectionViewDidTriggerRefresh:(PullPsCollectionView *)pullTableView
{
    [self refreshData];
}

- (void)pullPsCollectionViewDidTriggerLoadMore:(PullPsCollectionView *)pullTableView
{
    [self loadMoreData];
}



#pragma mark - Methods
-(void)refreshData
{
    //load cache
    NSString* fileDir = [self cacheFile];
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:[self loadContent:fileDir]];
    if([self.items count])
    {
        [self notifyDataChanged];
    }
    
    FileModel* model = [self fileModel];
    if (!self.resourceUrl) {
        self.resourceUrl = kDefaultResouceUrl;
    }
    model.fileURL = [NSString stringWithFormat:self.resourceUrl,kInitPage];//for the latest page
    model.notificationName = kTimelineJsonRefreshChanged;
    model.fileName = kRefreshFileName;
    
    [SharedDelegate beginRequest:model isBeginDown:YES setAllowResumeForFileDownloads:NO];
    
    [[CommonHelper getTargetBookPath:model.destPath] stringByAppendingPathComponent:model.fileName];
}
-(void)loadMoreData
{
    //more data
    FileModel* model = [self fileModel];
    if (!self.resourceUrl) {
        self.resourceUrl = kDefaultResouceUrl;
    }
    model.fileURL = [NSString stringWithFormat:self.resourceUrl,(++mCurrentLoadMorePage)];
    model.notificationName = kTimelineJsonLoadMoreChanged;
    model.fileName = kLoadMoreFileName;
    
    [SharedDelegate beginRequest:model isBeginDown:YES];
    
    [[CommonHelper getTargetBookPath:model.destPath] stringByAppendingPathComponent:model.fileName];
}
-(FileModel*)fileModel
{
    if(fileModel)
    {
        return fileModel;
    }
    
    fileModel = [[FileModel alloc]init];
    //get data
    
//    fileModel.fileURL = kTimelineJson;
    fileModel.fileName = kRefreshFileName;
    fileModel.destPath = kDefaultResouceName;
    if (self.resourceName) {
        fileModel.destPath = self.resourceName;
    }
    fileModel.notificationName = kTimelineJsonRefreshChanged;
    
    return fileModel;
}
-(NSString*)cacheFile
{
    FileModel* model = [self fileModel];
    
    return [[CommonHelper getTargetBookPath:model.destPath] stringByAppendingPathComponent:model.fileName];
}
-(NSString*)startNetworkRequest
{
    //start request for data
    FileModel* model = [self fileModel];
    [SharedDelegate beginRequest:model isBeginDown:YES setAllowResumeForFileDownloads:NO];
    
    return [[CommonHelper getTargetBookPath:model.destPath] stringByAppendingPathComponent:model.fileName];
}
-(NSMutableArray*)loadContent:(NSString*)fileName
{
    NSMutableArray  *dataArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    NSData* data = [NSData dataWithContentsOfFile:fileName];
    if (data) {
        NSError* error;
        id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (res && [res isKindOfClass:[NSDictionary class]]) {
            NSArray* arr = [res objectForKey:kWeiboTimelineResponseDataJson];
            for (id item in arr) {
                ResponseJson* sts = [ResponseJson statusWithJsonDictionary:item];
                [dataArray addObject:sts];
            }
        } else {
            //NSLog(@"arr dataSourceDidError == %@",arrayData);
        }
    }
    return dataArray;
    
}
-(void)didGetTimeLineOnMainThread
{
    [self notifyDataChanged];
}

-(void)didGetTimeLine:(NSNotification*)notification
{    
    if(notification)
    {
        if([notification.object isKindOfClass:[NSString class]])
        {
            NSString* fileDir = (NSString*)notification.object;
            if(nil == self.items)
            {
                self.items = [[NSMutableArray alloc]initWithCapacity:0];
            }
            //remove duplicate one
            NSMutableArray* dataArray = [self loadContent:fileDir];
            if ([kTimelineJsonRefreshChanged isEqualToString:notification.name] && [self.items count]>0) {
                [self mergeArray:dataArray withObjects:self.items];
//                [dataArray addObjectsFromArray:self.items];
                [self.items removeAllObjects];
                [self.items addObjectsFromArray:dataArray];
            }
            else
            {
                [self mergeArray:self.items withObjects:dataArray];
//                [self.items addObjectsFromArray:dataArray];
            }
        }
        else if([notification.object isKindOfClass:[NSError class]])//error
        {
            //fail to load data
            [[ZJTStatusBarAlertWindow getInstance]showWithString:NSLocalizedString(@"LoadError", @"")];
            [self notifyDataChanged];
        }
    }
    
    
    [self performSelectorOnMainThread:@selector(didGetTimeLineOnMainThread) withObject:nil waitUntilDone:TRUE];
}
//merge and remove duplicate items
-(void)mergeArray:(NSMutableArray*)desArray withObjects:(NSArray *)objects
{    
    if(!desArray || !objects)
    {
        return;
    }
    
    for (NSObject* obj in objects) {
        if(NSNotFound==[desArray indexOfObject:obj])
        {
            [desArray addObject:obj];
        }
    }
}

#pragma mark view lifecircle
-(void)back
{
    [self dismissModalViewControllerAnimated:YES];
}
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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", @"Back") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = backButton;
    [backButton release];
    
    mCurrentLoadMorePage = kInitPage;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetTimeLine:)    name:kTimelineJsonRefreshChanged          object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetTimeLine:)    name:kTimelineJsonLoadMoreChanged          object:nil];
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.fileModel = nil;
    self.resourceName = nil;
    self.resourceUrl = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
