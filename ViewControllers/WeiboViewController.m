//
//  FirstViewController.m
//  zjtSinaWeiboClient
//
//  Created by jtone z on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "WeiboViewController.h"
#import "ZJTHelpler.h"
#import "ZJTStatusBarAlertWindow.h"
#import "FileModel.h"
#import "AppDelegate.h"
#import "CommonHelper.h"
#import "ResponseJson.h"

#define kTimelineJson @"http://www.idreems.com/php/embarrasepisode/embarrassing.php?type=image_latest&page=1&count=20"
#define kFileName @"timelinejson"
#define kDestinationName @"Timeline"
#define kDataPath @"data"

#define kTimelineJsonChanged @"kTimelineJsonChanged"

#define kWeiboTimelineResponseDataJson @"data"

@interface WeiboViewController()
@end

@implementation WeiboViewController
@synthesize fileModel;
-(void)dealloc
{
    self.fileModel = nil;
    [super dealloc];
}
							
#pragma mark - View lifecycle
-(void)back
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(nil == statuesArr)
    {
        statuesArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    [self loadData];
    [defaultNotifCenter addObserver:self selector:@selector(didGetTimeLine:)    name:kTimelineJsonChanged          object:nil];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = backButton;
    [backButton release];
}

-(void)viewDidUnload
{
    [defaultNotifCenter removeObserver:self];
        
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    if (shouldLoad) 
    {
        shouldLoad = NO;
        [self loadData];
//        [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
    }
}

#pragma mark - Methods
-(void)loadData
{   
    //load cache
    NSString* fileDir = [self cacheFile];
    [statuesArr removeAllObjects];
    [self.statuesArr addObjectsFromArray:[self loadContent:fileDir]];
    
    [self startNetworkRequest];
}
-(FileModel*)fileModel
{
    if(fileModel)
    {
        return fileModel;
    }
    
    fileModel = [[FileModel alloc]init];
    //get data
    
    fileModel.fileURL = kTimelineJson;
    fileModel.fileName = kFileName;
    fileModel.destPath = kDestinationName;
    fileModel.notificationName = kTimelineJsonChanged;
    
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
    [APPDELEGATE beginRequest:model isBeginDown:YES setAllowResumeForFileDownloads:NO];
    
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
            [dataArray removeAllObjects];
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
    [self stopLoading];
    [self doneLoadingTableViewData];
    //[[ZJTStatusBarAlertWindow getInstance] hide];
    [table reloadData];
    [self.tableView reloadData];
}

-(void)didGetTimeLine:(NSNotification*)notification
{        
    if(notification)
    {
        if([notification.object isKindOfClass:[NSString class]])
        {
            NSString* fileDir = (NSString*)notification.object;
            if(nil == statuesArr)
            {
                statuesArr = [[NSMutableArray alloc]initWithCapacity:0];
            }
            [statuesArr removeAllObjects];
            [self.statuesArr addObjectsFromArray:[self loadContent:fileDir]];
        }
        else if([notification.object isKindOfClass:[NSError class]])//error
        {
            //fail to load data
            [self stopLoading];
        }
    }  
    
    
    [self performSelectorOnMainThread:@selector(didGetTimeLineOnMainThread) withObject:nil waitUntilDone:TRUE];
}

@end