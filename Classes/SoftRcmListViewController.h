//
//  SoftRcmListViewController.h
//  Sample
//
//  Created by xiaolin liu on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SoftRcmList;
@interface SoftRcmListViewController : UITableViewController{
    SoftRcmList *_softRcmList;
    NSMutableArray *openApps;
}
@end
