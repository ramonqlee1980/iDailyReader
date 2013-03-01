//
//  StatusViewContrillerBase.m
//  zjtSinaWeiboClient
//
//  Created by jtone z on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "StatusViewContrillerBase.h"
#import "UITableViewCellResponse.h"


@interface StatusViewContrillerBase() 
-(void)setup;
@end

@implementation StatusViewContrillerBase
@synthesize table;
@synthesize statusCellNib;
@synthesize statuesArr;
@synthesize browserView;

-(void)dealloc
{
    self.statusCellNib = nil;
    self.statuesArr = nil;
    self.browserView = nil;
    _refreshHeaderView=nil;
    [table release];table = nil;
    [super dealloc];
}

-(void)setup
{
    self.title = @"主页";// NSLocalizedString(@"First", @"First");
    self.tabBarItem.image = [UIImage imageNamed:@"first"];
    
    CGRect frame = table.frame;
    frame.size.height = frame.size.height + REFRESH_FOOTER_HEIGHT;
    table.frame = frame;
    
    //init data
    isFirstCell = YES;
    shouldLoad = NO;
    shouldShowIndicator = YES;
    defaultNotifCenter = [NSNotificationCenter defaultCenter];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self != nil) {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

-(UINib*)statusCellNib
{
    if (statusCellNib == nil) 
    {
        [statusCellNib release];
        statusCellNib = [[StatusCell nib] retain];
    }
    return statusCellNib;
}

-(void)setUpRefreshView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = [view retain];
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}
							
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpRefreshView];
    self.tableView.contentInset = UIEdgeInsetsOriginal;
    
//    [defaultNotifCenter addObserver:self selector:@selector(mmRequestFailed:)   name:MMSinaRequestFailed object:nil];
//    [defaultNotifCenter addObserver:self selector:@selector(loginSucceed)       name:DID_GET_TOKEN_IN_WEB_VIEW object:nil];
}

-(void)viewDidUnload
{
//    [defaultNotifCenter removeObserver:self name:MMSinaRequestFailed        object:nil];
//    [defaultNotifCenter removeObserver:self name:DID_GET_TOKEN_IN_WEB_VIEW  object:nil];
    
    [super viewDidUnload];
}

#pragma mark - Methods
-(void)loginSucceed
{
    shouldLoad = YES;
}
-(void)mmRequestFailed:(id)sender
{
    [self stopLoading];
    [self doneLoadingTableViewData];
//    [[ZJTStatusBarAlertWindow getInstance] hide];
}

//上拉刷新
-(void)refresh
{
    [self startNetworkRequest];
//    [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
}

- (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib {
    static NSString *cellID = @"StatusCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSLog(@"statuss cell new");
        NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
        cell = [nibObjects objectAtIndex:0];
    }
    else {
        [(LPBaseCell *)cell reset];
    }
    
    return cell;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [statuesArr count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    NSString* kCellName = @"Cell";
    UITableViewCellResponse* cell = (UITableViewCellResponse*)[table dequeueReusableCellWithIdentifier:kCellName];
    if(nil==cell)
    {
        cell = [[[UITableViewCellResponse alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellName]autorelease];
    }
    cell.response = [statuesArr objectAtIndex:indexPath.row];
    //开始绘制第一个cell时，隐藏indecator.
    if (isFirstCell) {
//        [[SHKActivityIndicator currentIndicator] hide];
//        [[ZJTStatusBarAlertWindow getInstance] hide];
        isFirstCell = NO;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCellResponse measureCell:[statuesArr objectAtIndex:indexPath.row]].height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - StatusCellDelegate


-(void)cellImageDidTaped:(StatusCell *)theCell image:(UIImage *)image
{
    shouldShowIndicator = YES;
    
    if ([theCell.cellIndexPath row] > [statuesArr count]) {
//        NSLog(@"cellImageDidTaped error ,index = %d,count = %d",[theCell.cellIndexPath row],[statuesArr count]);
        return ;
    }
    
    Status *sts = [statuesArr objectAtIndex:[theCell.cellIndexPath row]];
    BOOL isRetwitter = sts.retweetedStatus && sts.retweetedStatus.originalPic != nil;    
    NSString* url = isRetwitter ? sts.retweetedStatus.originalPic : sts.originalPic;
    
    UIApplication *app = [UIApplication sharedApplication];    
    if (browserView == nil) {
        self.browserView = [[[ImageBrowser alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)] autorelease];
        [browserView setUp];
    }
    
    browserView.image = image;
    browserView.bigImageURL = url;
    [browserView loadImage];
    
    app.statusBarHidden = YES;
    [[app keyWindow]addSubview:browserView];
    
    
    if (shouldShowIndicator == YES && browserView) {
        //        [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:browserView];
    }
    else shouldShowIndicator = YES;  
}

#pragma mark -
#pragma mark  - Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
}

//调用此方法来停止。
- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    
    if (scrollView.contentOffset.y < 200) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    else
        [super scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.contentOffset.y < 200)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark update Data
-(NSString*)startNetworkRequest
{
    return @"";
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    _reloading = YES;
	[self startNetworkRequest];
//    [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


@end
