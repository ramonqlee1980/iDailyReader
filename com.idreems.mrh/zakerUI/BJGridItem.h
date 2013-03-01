//
//  BJGridItem.h
//  :
//
//  Created by bupo Jung on 12-5-15.
//  Copyright (c) 2012年 Wuxi Smart Sencing Star. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    BJGridItemNormalMode = 0,
    BJGridItemEditingMode = 1,
}BJMode;
@protocol BJGridItemDelegate;
@class GridItemProperty;

@interface BJGridItem : UIView{
    UIImage *normalImage;
    UIImage *editingImage;
    NSString *itemDisplayName;
    BOOL isEditing;
    BOOL isRemovable;
    UIButton *deleteButton;
    UIButton *button;
    NSInteger index;
    CGPoint point;//long press point
}
@property(nonatomic) BOOL isEditing;
@property(nonatomic) BOOL isRemovable;
@property(nonatomic) NSInteger index;
@property(retain,nonatomic)id<BJGridItemDelegate> delegate;
- (id) initWithTitle:(NSString *)title withImageName:(NSString *)imageName atIndex:(NSInteger)aIndex editable:(BOOL)removable;
- (void) enableEditing;
- (void) disableEditing;
@end
@protocol BJGridItemDelegate <NSObject>

- (void) gridItemDidClicked:(BJGridItem *) gridItem;
- (void) gridItemDidEnterEditingMode:(BJGridItem *) gridItem;
- (void) gridItemDidDeleted:(BJGridItem *) gridItem atIndex:(NSInteger)index;
- (void) gridItemDidMoved:(BJGridItem *) gridItem withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer*)recognizer;
- (void) gridItemDidEndMoved:(BJGridItem *) gridItem withLocation:(CGPoint)point moveGestureRecognizer:(UILongPressGestureRecognizer*) recognizer;
@end

@interface GridItemProperty: NSObject<NSCoding>
{
    NSString* itemDisplayName;
    NSString* url;
    NSString* className;
    NSString* xibName;
}
@property(nonatomic,retain) NSString* className;
@property(nonatomic,retain) NSString* xibName;
@property(nonatomic,retain) NSString* itemDisplayName;
@property(nonatomic,retain) NSString* url;
@end