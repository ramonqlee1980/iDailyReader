//
//  ViewController.m
//  PSCollectionViewDemo
//
//  Created by Eric on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CollectionViewController.h"
#import "PSCollectionViewCell.h"
#import "ImageWithTextCell.h"
#import "UIImageView+WebCache.h"
#import "UITableViewCellResponse.h"
#import "ImageViewController.h"
#import "ResponseJson.h"
@interface CollectionViewController ()

@end

@implementation CollectionViewController
@synthesize collectionView;
@synthesize items;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.items = [NSMutableArray array];
    }
    return self;
}
-(void)dealloc{
    [collectionView release];
    [items release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];  
    
    
    collectionView = [[PullPsCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:collectionView];
    collectionView.collectionViewDelegate = self;
    collectionView.collectionViewDataSource = self;
    collectionView.pullDelegate=self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    collectionView.numColsPortrait = 1;
    collectionView.numColsLandscape = 1;
    
    collectionView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    collectionView.pullBackgroundColor = [UIColor grayColor];
    collectionView.pullTextColor = [UIColor blackColor];

    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:self.collectionView.bounds];
    loadingLabel.text = @"Loading...";
    loadingLabel.textAlignment = UITextAlignmentCenter;
    collectionView.loadingView = loadingLabel;
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
}

#pragma mark util methods
-(void)notifyDataChanged
{
//    if (self.collectionView.pullTableIsRefreshing)
    {
        [self refreshTableDone];
    }
//    else
    {
        [self loadMoreDataToTableDone];
    }
}
- (void) refreshTableDone
{
    self.collectionView.pullLastRefreshDate = [NSDate date];
    self.collectionView.pullTableIsRefreshing = NO;
    [self.collectionView reloadData];
}
- (void) loadMoreDataToTableDone
{
    [self.collectionView reloadData];
    self.collectionView.pullTableIsLoadingMore = NO;
}
#pragma mark - PullTableViewDelegate

- (void)pullPsCollectionViewDidTriggerRefresh:(PullPsCollectionView *)pullTableView
{
}

- (void)pullPsCollectionViewDidTriggerLoadMore:(PullPsCollectionView *)pullTableView
{
}
- (void)viewDidUnload
{
    [self setCollectionView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark PSCollectionViewDataSource
- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndex:(NSInteger)index {
    ResponseJson *item = [self.items objectAtIndex:index];
    
    // You should probably subclass PSCollectionViewCell
    ImageWithTextCell *v = (ImageWithTextCell *)[self.collectionView dequeueReusableView];
    CGRect rc = CGRectMake(0, 0, kDeviceWidth/self.collectionView.numColsPortrait, KDeviceHeight);
    if(v == nil) {
        v = [[[ImageWithTextCell alloc]initWithFrame:rc]autorelease];
    }
    v.frame = rc;
    v.response = item;
           
    
    return v;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index {
    return [ImageWithTextCell measureCell:[self.items objectAtIndex:index] width:kDeviceWidth/self.collectionView.numColsPortrait].height;
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index {
    // Do something with the tap
    NSLog(@"didSelect:%d",index);
    ImageViewController* detail = [[[ImageViewController alloc]init]autorelease];
    
    ResponseJson *currentItem = [self.items objectAtIndex:index];
    
    [detail initWithData:currentItem.description imageUrl:currentItem.largeUrl placeHolderImageUrl:currentItem.largeUrl imageWidth:1 imageHeight:1];
	[self.navigationController pushViewController:detail animated:YES];
}

- (NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView {
    return [self.items count];
}

- (void)loadDataSource {
    // Request
    NSString *URLPath = [NSString stringWithFormat:@"http://imgur.com/gallery.json"];
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                self.items = [res objectForKey:@"data"];
                [self dataSourceDidLoad];
            } else {
                [self dataSourceDidError];
            }
        } else {
            [self dataSourceDidError];
        }
    }];
}

- (void)dataSourceDidLoad {
    [self refreshTableDone];
}

- (void)dataSourceDidError {
    [self.collectionView reloadData];
}
@end
