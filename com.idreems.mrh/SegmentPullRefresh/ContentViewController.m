#import "ContentViewController.h"
#import "PullingRefreshTableView.h"
#import "CJSONDeserializer.h"
#import "ContentCellModel.h"
#import "Flurry.h"
#import "AdsConfig.h"
#import "ImageViewController.h"
#import "FileModel.h"
#import "CommonHelper.h"
#import "AppDelegate.h"
#import "ContentCell.h"
#import "tools.h"

#define kTimelineJsonRefreshChanged @"kEMTimelineJsonRefreshChanged"
#define kTimelineJsonLoadMoreChanged @"kEMTimelineJsonLoadMoreChanged"

@interface ContentViewController () <
PullingRefreshTableViewDelegate,ASIHTTPRequestDelegate,
UITableViewDataSource,
UITableViewDelegate
>
@property (retain,nonatomic) PullingRefreshTableView *tableView;
@property (retain,nonatomic) NSMutableArray *list;
@property (nonatomic) BOOL refreshing;

-(CGFloat) getTheHeight:(NSInteger)row;
@end

@implementation ContentViewController
@synthesize tableView = _tableView;
@synthesize list = _list;
@synthesize refreshing = _refreshing;
@synthesize delegate;
@synthesize fileModel;


- (void)dealloc{
    [_list release];
    _list = nil;
    [self.tableView release];
    self.fileModel = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark - LoadPage
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor clearColor]];
    _list = [[NSMutableArray alloc] init ];
    
    CGRect bounds = [[UIScreen mainScreen]bounds];//self.view.bounds;
    bounds.size.height -= 44.f;//44.f*2;
    self.tableView = [[PullingRefreshTableView alloc] initWithFrame:bounds pullingDelegate:self];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    fileModel = [[FileModel alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetTimeLine:)    name:kTimelineJsonRefreshChanged          object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetTimeLine:)    name:kTimelineJsonLoadMoreChanged          object:nil];
    
    [self launchRefreshing];
    
//    [Flurry logEvent:kQiushiReviewed];
}
-(void)launchRefreshing
{
    [self.tableView launchRefreshing];
}

#pragma mark - Your actions
-(void)refreshData
{
    if (delegate) {
        if (fileModel) {
            fileModel.notificationName = kTimelineJsonRefreshChanged;
        }       
        
        [delegate refreshData:fileModel];
        //load local cache
        if(delegate)
        {
            NSString* fileName = [self cacheFile];
            [self.list addObjectsFromArray:[delegate parseData:[NSData dataWithContentsOfFile:fileName]]];
            [self.tableView reloadData];
        }
    }
}
-(void)loadMoreData
{
    if (delegate) {
        if (fileModel) {
            fileModel.notificationName = kTimelineJsonLoadMoreChanged;
        }
        [delegate loadMoreData:fileModel];
    }
}
-(void)didGetTimeLineOnMainThread:(NSNotification*)notification
{
    //    [Flurry logEvent:@"RequestQiushiSuccess"];
    
    if (self.refreshing) {
        //        self.page = 1;
        self.refreshing = NO;
        [self.list removeAllObjects];
    }
    
    if(delegate)
    {
        NSString* fileName = [self cacheFile];
        [self.list addObjectsFromArray:[delegate parseData:[NSData dataWithContentsOfFile:fileName]]];
    }
    
    //    if (self.page >=20) {
    //        [self.tableView tableViewDidFinishedLoadingWithMessage:@"下面没有了.."];
    //        self.tableView.reachedTheEnd  = YES;
    //    }
    //    else
    {
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd  = NO;
        [self.tableView reloadData];
    }
    //    [Flurry logEvent:kQiushiRefreshed];
    
}


#pragma common
-(void)tableViewDidFinishedLoading
{
    if (self.refreshing) {
        self.refreshing = NO;
    }
    [self.tableView tableViewDidFinishedLoading];    
}
-(void)didGetTimeLine:(NSNotification*)notification
{
    if(notification && [notification.object isKindOfClass:[NSError class]])//error
    {
        [self GetErr:nil];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(didGetTimeLineOnMainThread:) withObject:notification waitUntilDone:YES];
    }
}
-(void) GetErr:(ASIHTTPRequest *)request
{
    self.refreshing = NO;
    [self.tableView tableViewDidFinishedLoading];
    [tools MsgBox:@"连接网络失败，请检查是否开启移动数据"];
    
}
-(NSString*)cacheFile
{
    FileModel* model = [self fileModel];
    if (!model) {
        return @"";
    }
    
    return [[CommonHelper getTargetBookPath:model.destPath] stringByAppendingPathComponent:model.fileName];
}
-(NSString*)startNetworkRequest
{
    //start request for data
    FileModel* model = [self fileModel];
    [SharedDelegate beginRequest:model isBeginDown:YES setAllowResumeForFileDownloads:NO];
    
    return [[CommonHelper getTargetBookPath:model.destPath] stringByAppendingPathComponent:model.fileName];
}

#pragma mark
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

#pragma mark - TableView*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Contentidentifier = @"_ContentCELL";
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:Contentidentifier];
    if (cell == nil){
        //设置cell 样式
        cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Contentidentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        [cell.txtContent setNumberOfLines:12];
    }
    
    ContentCellModel *qs = [self.list objectAtIndex:[indexPath row]];
    //设置内容
    
    cell.txtContent.text =qs.content ;
    //设置图片
    if (qs.imageURL!=nil && [qs.imageURL length]!=0) {
        cell.imgUrl = qs.imageURL;
        cell.imgMidUrl = qs.imageMidURL;
        // cell.imgPhoto.hidden = NO;
    }else
    {
        cell.imgUrl = @"";
        cell.imgMidUrl = @"";
        // cell.imgPhoto.hidden = YES;
    }
    //设置用户名
    if (qs.anchor!=nil && qs.anchor.length!=0)
    {
        cell.txtAnchor.text = qs.anchor;
    }else
    {
        cell.txtAnchor.text = @"匿名";
    }
    //设置标签
    if (qs.tag!=nil && qs.tag.length!=0)
    {
        cell.txtTag.text = qs.tag;
    }else
    {
        cell.txtTag.text = @"";
    }
    //设置up ，down and commits
    //    [cell.goodbtn setTitle:[NSString stringWithFormat:@"%d",qs.upCount] forState:UIControlStateNormal];
    [cell.goodbtn setTitle:NSLocalizedString(@"add2FavTip", "") forState:UIControlStateNormal];
    [cell.badbtn setTitle:NSLocalizedString(@"share2WixinChat", "")  forState:UIControlStateNormal];
    [cell.commentsbtn setTitle:NSLocalizedString(@"share2WixinFriends", "") forState:UIControlStateNormal];
    //[cell.badbtn setTitle:[NSString stringWithFormat:@"%d",qs.downCount] forState:UIControlStateNormal];
    //[cell.commentsbtn setTitle:[NSString stringWithFormat:@"%d",qs.commentsCount] forState:UIControlStateNormal];
    //自适应函数
    [cell resizeTheHeight];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getTheHeight:indexPath.row];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:1.f];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadMoreData) withObject:nil afterDelay:1.f];
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContentCellModel *qs = [self.list objectAtIndex:[indexPath row]];
    
    ImageViewController* detail = [[[ImageViewController alloc]init]autorelease];
    
    [detail initWithData:qs.content imageUrl:qs.imageMidURL placeHolderImageUrl:qs.imageURL imageWidth:1 imageHeight:1];
	[self.navigationController pushViewController:detail animated:YES];
}


-(CGFloat) getTheHeight:(NSInteger)row
{
    CGFloat contentWidth = 280;
    // 设置字体
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    
    ContentCellModel *qs =[self.list objectAtIndex:row];
    // 显示的内容
    NSString *content = qs.content;
    // 计算出长宽
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:UILineBreakModeTailTruncation];
    CGFloat height;
    const NSInteger bottomMargin = 140;
    if (qs.imageURL==nil) {
        height = size.height+bottomMargin;//140;
    }else
    {
        height = size.height+bottomMargin+80;//220;
    }
    // 返回需要的高度
    return height;
}
@end