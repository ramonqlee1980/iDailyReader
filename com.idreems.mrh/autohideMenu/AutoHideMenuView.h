//
//  HHYoukuMenuView.h
//  youku
//
//  Created by Eric on 12-3-12.
//  Copyright (c) 2012年 Tian Tian Tai Mei Net Tech (Bei Jing) Lt.d. All rights reserved.
//

#import <UIKit/UIKit.h>


//delegate for view
#define kThirdRowLeftMost 6
#define kThirdRowRightMost 0
#define kSecondRowLeftMost 9
#define kSecondRowRightMost 7
#define kHome 10

@protocol MenuDelegate<NSObject>
- (void)menuButtonClick:(id)sender;
@end


@interface AutoHideMenuView : UIView

@property(nonatomic,retain)id<MenuDelegate> delegate;

+ (CGRect)getFrame;

- (BOOL)menuHidden;
- (void)showOrHideMenu;
@end
