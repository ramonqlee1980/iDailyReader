//
//  SoftRcmListViewController.h
//  Sample
//
//  Created by xiaolin liu on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SoftRcmList;
@class YouMiWall;
@interface SoftRcmListViewController : UITableViewController
{
    SoftRcmList *_softRcmList;
    YouMiWall *wall;
    NSMutableArray *openApps;
}

@end
