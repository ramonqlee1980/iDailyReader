//
//  RewardedWallViewController.h
//  YouMiSDK_Sample_Wall
//
//  Created by  on 12-1-5.
//  Copyright (c) 2012年 YouMi Mobile Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YouMiWall;

@interface RewardedWallViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    
    NSInteger point;  // 用户的积分
    UITableView* _tableView;    
    // 
    YouMiWall *wall;
    NSMutableArray *openApps;
    BOOL mRequestOffersFail;
    BOOL mAdsClosedSupport;
}

-(id)init:(BOOL)adsClosedSupport;
@end
