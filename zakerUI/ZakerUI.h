//
//  ZakerUI.h
//  ZakerLike
//
//  Created by ramonqlee on 1/17/13.
//  Copyright (c) 2013 Wuxi Smart Sencing Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BJGridItem.h"


@protocol ZakerDelegate;

@interface ZakerUI :UIView<UIScrollViewDelegate,BJGridItemDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *gridItems;
    int page;
    float preX;
    BOOL isMoving;
    CGRect preFrame;
    BOOL isEditing;
    id<ZakerDelegate> delegate;
}
@property (retain, nonatomic) UIImageView *backgoundImage;
@property (retain,nonatomic)id<ZakerDelegate> delegate;
- (void)addItem;
-(void)addItem:(NSString *)title withImageName:(NSString *)imageName editable:(BOOL)removable;
@end

@protocol ZakerDelegate <NSObject>

- (void) gridItemDidClicked:(BJGridItem *) gridItem;
- (void) gridItemDidDeleted:(BJGridItem *) gridItem atIndex:(NSInteger)index;
- (void) gridItemExchanged:(NSInteger)oldIndex withposition:(NSInteger)newIndex;
@end
