//
//  SoftRcmListViewController.h
//  Sample
//
//  Created by xiaolin liu on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobiSageRecommendSDK.h"

@class SoftRcmList;
@class YouMiWall;
@interface SoftRcmListViewController : UITableViewController<MobiSageRecommendDelegate>
{
    SoftRcmList *_softRcmList;
    YouMiWall *wall;
    NSMutableArray *openApps;
    MobiSageRecommendView *_recmdView;
}
@property(nonatomic, retain) MobiSageRecommendView *recmdView;
@end
