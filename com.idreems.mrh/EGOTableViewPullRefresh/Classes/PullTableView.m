//
//  PullTableView.m
//  TableViewPull
//
//  Created by Emre Ergenekon on 2011-07-30.
//  Copyright 2011 Kungliga Tekniska Högskolan. All rights reserved.
//

#import "PullTableView.h"

@interface PullTableView (Private) <UIScrollViewDelegate>
- (void) config;
- (void) configDisplayProperties;
@end

@implementation PullTableView

# pragma mark - Initialization / Deallocation

@synthesize pullDelegate;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self config];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self config];
}


- (void)dealloc {
    [pullArrowImage release];
    [pullBackgroundColor release];
    [pullTextColor release];
    [pullLastRefreshDate release];
    
    [refreshView release];
    [loadMoreView release];
    [delegateInterceptor release];
    [super dealloc];
}

# pragma mark - Custom view configuration

- (void) config
{
    /* Message interceptor to intercept scrollView delegate messages */
    delegateInterceptor = [[MessageInterceptor alloc] init];
    delegateInterceptor.middleMan = self;
    delegateInterceptor.receiver = self.delegate;
    super.delegate = (id)delegateInterceptor;
    
    /* Status Properties */
    pullTableIsRefreshing = NO;
    pullTableIsLoadingMore = NO;
    
    /* Refresh View */
    refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
    refreshView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    refreshView.delegate = self;
    [self addSubview:refreshView];
    
    /* Load more view init */
    loadMoreView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
    loadMoreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    loadMoreView.delegate = self;
    [self addSubview:loadMoreView];
    
}


# pragma mark - View changes

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat visibleTableDiffBoundsHeight = (self.bounds.size.height - MIN(self.bounds.size.height, self.contentSize.height));
    
    CGRect loadMoreFrame = loadMoreView.frame;
    loadMoreFrame.origin.y = self.contentSize.height + visibleTableDiffBoundsHeight;
    loadMoreView.frame = loadMoreFrame;
    
    
    
    
}

#pragma mark - Preserving the original behaviour

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    if(delegateInterceptor) {
        super.delegate = nil;
        delegateInterceptor.receiver = delegate;
        super.delegate = (id)delegateInterceptor;
    } else {
        super.delegate = delegate;
    }
}

- (void)reloadData
{
    [super reloadData];
    // Give the footers a chance to fix it self.
    [loadMoreView egoRefreshScrollViewDidScroll:self];
}

#pragma mark - Status Propreties

@synthesize pullTableIsRefreshing;
@synthesize pullTableIsLoadingMore;

- (void)setPullTableIsRefreshing:(BOOL)isRefreshing
{
    if(!pullTableIsRefreshing && isRefreshing) {
        // If not allready refreshing start refreshing
        [refreshView startAnimatingWithScrollView:self];
        pullTableIsRefreshing = YES;
    } else if(pullTableIsRefreshing && !isRefreshing) {
        [refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
        pullTableIsRefreshing = NO;
    }
}

- (void)setPullTableIsLoadingMore:(BOOL)isLoadingMore
{
    if(!pullTableIsLoadingMore && isLoadingMore) {
        // If not allready loading more start refreshing
        [loadMoreView startAnimatingWithScrollView:self];
        pullTableIsLoadingMore = YES;
    } else if(pullTableIsLoadingMore && !isLoadingMore) {
        [loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
        pullTableIsLoadingMore = NO;
    }
}

#pragma mark - Display properties

@synthesize pullArrowImage;
@synthesize pullBackgroundColor;
@synthesize pullTextColor;
@synthesize pullLastRefreshDate;

- (void)configDisplayProperties
{
    [refreshView setBackgroundColor:self.pullBackgroundColor textColor:self.pullTextColor arrowImage:self.pullArrowImage];
    [loadMoreView setBackgroundColor:self.pullBackgroundColor textColor:self.pullTextColor arrowImage:self.pullArrowImage];
}

- (void)setPullArrowImage:(UIImage *)aPullArrowImage
{
    if(aPullArrowImage != pullArrowImage) {
        [pullArrowImage release];
        pullArrowImage = [aPullArrowImage retain];
        [self configDisplayProperties];
    }
}

- (void)setPullBackgroundColor:(UIColor *)aColor
{
    if(aColor != pullBackgroundColor) {
        [pullBackgroundColor release];
        pullBackgroundColor = [aColor retain];
        [self configDisplayProperties];
    } 
}

- (void)setPullTextColor:(UIColor *)aColor
{
    if(aColor != pullTextColor) {
        [pullTextColor release];
        pullTextColor = [aColor retain];
        [self configDisplayProperties];
    } 
}

- (void)setPullLastRefreshDate:(NSDate *)aDate
{
    if(aDate != pullLastRefreshDate) {
        [pullLastRefreshDate release];
        pullLastRefreshDate = [aDate retain];
        [refreshView refreshLastUpdatedDate];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [refreshView egoRefreshScrollViewDidScroll:scrollView];
    [loadMoreView egoRefreshScrollViewDidScroll:scrollView];
    
    // Also forward the message to the real delegate
    if ([delegateInterceptor.receiver
         respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [delegateInterceptor.receiver scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    [loadMoreView egoRefreshScrollViewDidEndDragging:scrollView];
    
    // Also forward the message to the real delegate
    if ([delegateInterceptor.receiver
         respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [delegateInterceptor.receiver scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [refreshView egoRefreshScrollViewWillBeginDragging:scrollView];
    
    // Also forward the message to the real delegate
    if ([delegateInterceptor.receiver
         respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [delegateInterceptor.receiver scrollViewWillBeginDragging:scrollView];
    }
}



#pragma mark - EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    pullTableIsRefreshing = YES;
    [pullDelegate pullTableViewDidTriggerRefresh:self];    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    return self.pullLastRefreshDate;
}

#pragma mark - LoadMoreTableViewDelegate

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view
{
    pullTableIsLoadingMore = YES;
    [pullDelegate pullTableViewDidTriggerLoadMore:self];
}


@end
