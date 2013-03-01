//
//  StatusViewContrillerBase.h
//  zjtSinaWeiboClient
//
//  Created by jtone z on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusCell.h"
#import "PullRefreshTableViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "ImageBrowser.h"
#import "Status.h"
#import "User.h"
#import "SHKActivityIndicator.h"

@interface StatusViewContrillerBase : PullRefreshTableViewController<EGORefreshTableHeaderDelegate,StatusCellDelegate>{

    NSNotificationCenter *defaultNotifCenter;
    
    UITableView         *table;
    UINib               *statusCellNib;
    NSMutableArray      *statuesArr;
    ImageBrowser        *browserView;
    
    BOOL                shouldShowIndicator;
    BOOL                shouldLoad;
    
    BOOL                isFirstCell;
    
	EGORefreshTableHeaderView *_refreshHeaderView;
    
	BOOL _reloading;
}

@property (retain, nonatomic)   IBOutlet UITableView    *table;
@property (nonatomic, retain)   UINib                   *statusCellNib;
@property (nonatomic, retain)   NSMutableArray          *statuesArr;
@property (nonatomic, retain)   ImageBrowser            *browserView;

- (void)getImages;
- (void)doneLoadingTableViewData;
-(NSString*)startNetworkRequest;
@end
