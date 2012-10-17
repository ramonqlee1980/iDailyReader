#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define WAPS_NAV_BTN_HEIGHT 30
#define WAPS_NAV_BAR_HEIGHT 44
#define WAPS_NAV_BTN_LEFT_RIGHT_MARGIN 5


@class WapsUtil;


@interface WapsUINavigationBarView : UINavigationBar {
    UINavigationBar *navBar;
    UINavigationItem *navBarTitle;
    UIBarButtonItem *navBarLeftBtn;
    UIBarButtonItem *navBarRightBtn;
    UIImage *bgImage;
    UILabel *titleLabel;
}


@property(nonatomic, readonly) UINavigationBar *navBar;
@property(nonatomic, readonly) UINavigationItem *navBarTitle;
@property(nonatomic, readonly) UIBarButtonItem *navBarLeftBtn;
@property(nonatomic, readonly) UIBarButtonItem *navBarRightBtn;
@property(nonatomic, readonly) UILabel *titleLabel;

- (id)initWithTitle:(NSString *)title withFrame:(CGRect)frame  AtY:(int)y;

- (void)setNavBarLeftBtnWithTitle:(NSString *)title;

- (void)setNavBarRightBtnWithTitle:(NSString *)title;

- (void)updateLeftNavBarBtnWithTitle:(NSString *)title;

- (void)updateRightNavBarBtnWithTitle:(NSString *)title;

- (void)addLeftButtonTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)addRightButtonTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)setNavBarLeftBtn:(UIBarButtonItem *)button;

- (void)setNavBarRightBtn:(UIBarButtonItem *)button;

- (void)setCustomBackgroundImage:(UIImage *)image;

@end