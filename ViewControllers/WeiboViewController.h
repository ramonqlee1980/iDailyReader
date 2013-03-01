//
//  FirstViewController.h
//  zjtSinaWeiboClient
//
//  Created by jtone z on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusViewContrillerBase.h"

@class FileModel;

@interface WeiboViewController : StatusViewContrillerBase
{
    FileModel* fileModel;
}
@property(nonatomic,retain) FileModel* fileModel;
@end
