//
//  ViewController.h
//  PSCollectionViewDemo
//
//  Created by Eric on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"
#import "PullPsCollectionView.h"


@interface CollectionViewController : UIViewController<PSCollectionViewDelegate,PSCollectionViewDataSource,UIScrollViewDelegate,PullPsCollectionViewDelegate>
@property(nonatomic,retain) PullPsCollectionView *collectionView;
@property(nonatomic,retain)NSMutableArray *items;

-(void)notifyDataChanged;
@end
