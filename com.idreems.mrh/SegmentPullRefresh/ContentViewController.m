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
#import "TextViewController.h"
#import "ThemeManager.h"

#define kNumberOfLines  100

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
@synthesize customNavigationController;


- (void)dealloc{
    [_list release];
    _list = nil;
    [self.tableView release];
    self.fileModel = nil;
    self.customNavigationController = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark - LoadPage
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Back",@"") style: UIBarButtonItemStyleBordered target: nil action: nil];
    newBackButton.tintColor = TintColor;
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    [newBackButton release];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetMore:)    name:kTimelineJsonLoadMoreChanged          object:nil];
    
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
        
        //load local cache
        if(delegate)
        {
            NSString* fileName = [self cacheFile];
            NSArray* d = [delegate parseData:[NSData dataWithContentsOfFile:fileName]];
            if(d && [d count]>0)
            {
                [self.list removeAllObjects];
                [self.list addObjectsFromArray:d];
                
                [self.tableView reloadData];
            }
        }
        
        if(![delegate refreshData:fileModel])//load local data
        {            
            [self stopRefresh];
            return;
        }
    }
}
-(void)loadMoreData
{
    if (delegate) {
        if (fileModel) {
            fileModel.notificationName = kTimelineJsonLoadMoreChanged;
        }
        if(![delegate loadMoreData:fileModel])
        {
            [self stopRefresh];
        }
    }
}
-(void)stopRefresh
{
    if (self.refreshing) {
        self.refreshing = NO;
    }
    
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd  = NO;
    [self.tableView reloadData];
}

-(void)didGetMoreOnMainThread:(NSNotification*)notification
{
    //    [Flurry logEvent:@"RequestQiushiSuccess"];
    
    //    if (self.refreshing) {
    //        self.refreshing = NO;
    //    }
    
    if(delegate)
    {
        NSString* fileName = [self cacheFile];
        
        //clear and refresh or keep current data
        NSArray* array = [delegate parseData:[NSData dataWithContentsOfFile:fileName]];
        if (array && [array count]) {
            [self.list addObjectsFromArray:array];
        }
    }
    [self stopRefresh];
    //    [self.tableView tableViewDidFinishedLoading];
    //    self.tableView.reachedTheEnd  = NO;
    //    [self.tableView reloadData];
    //    [Flurry logEvent:kQiushiRefreshed];
    
}

-(void)didGetTimeLineOnMainThread:(NSNotification*)notification
{
    //    [Flurry logEvent:@"RequestQiushiSuccess"];
    
    if(delegate)
    {
        NSString* fileName = [self cacheFile];
        
        //clear and refresh or keep current data
        NSArray* array = [delegate parseData:[NSData dataWithContentsOfFile:fileName]];
        if (array && [array count]) {
            [self.list removeAllObjects];
            [self.list addObjectsFromArray:array];
        }
    }
    
    
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd  = NO;
    [self.tableView reloadData];
    
    [self stopRefresh];
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
-(void)didGetMore:(NSNotification*)notification
{
    if(notification && [notification.object isKindOfClass:[NSError class]])//error
    {
        [self GetErr:nil];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(didGetMoreOnMainThread:) withObject:notification waitUntilDone:YES];
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
        [cell.txtContent setNumberOfLines:kNumberOfLines];
    }
    
    ContentCellModel *qs = [self.list objectAtIndex:[indexPath row]];
    //设置内容
    
    cell.txtContent.text =qs.content ;
    //设置图片
    if (qs.thumbnailUrl!=nil && [qs.thumbnailUrl length]!=0) {
        cell.imgUrl = qs.thumbnailUrl;
        cell.imgMidUrl = qs.largeImageUrl;
        // cell.imgPhoto.hidden = NO;
    }else
    {
        cell.imgUrl = @"";
        cell.imgMidUrl = @"";
        // cell.imgPhoto.hidden = YES;
    }
    //设置用户名
    if (qs.author!=nil && qs.author.length!=0)
    {
        cell.txtAnchor.text = qs.author;
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
- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath:%d",indexPath.row);
    
    UIViewController *controller = nil;
    ContentCellModel *data = [self.list objectAtIndex:[indexPath row]];
    if (!data.largeImageUrl || data.largeImageUrl.length==0) {
        TextViewController *detail = [(TextViewController*)[[TextViewController alloc] init]autorelease];
        detail.title = data.author;
        detail.content = data.content;
        detail.hidesBottomBarWhenPushed = YES;
        controller = detail;
    }
    else
    {
        ImageViewController* detail = [[[ImageViewController alloc]init]autorelease];
        [detail initWithData:data.content imageUrl:data.largeImageUrl placeHolderImageUrl:data.thumbnailUrl imageWidth:1 imageHeight:1];
        controller = detail;
    }
    if(self.navigationController)
    {
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        [self.customNavigationController pushViewController:controller animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];    
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
    if (qs.thumbnailUrl==nil) {
        height = size.height+bottomMargin;//140;
    }else
    {
        height = size.height+bottomMargin+80;//220;
    }
    // 返回需要的高度
    return height;
}
@end