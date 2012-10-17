#import <UIKit/UIKit.h>
#import "ApplicationCell.h"
#import "ModalViewController.h"
#import "Constants.h"
#import "YouMiWall.h"
#import "AdSageRecommendDelegate.h"
#import <immobSDK/immobView.h>

@class AdSageRecommendView;

@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,YouMiWallDelegate,UIAlertViewDelegate,AdSageRecommendDelegate,immobViewDelegate>
{
	//ApplicationCell *tmpCell;
    NSMutableArray *data;
    UITableView* tableView;
	YouMiWall *wall;
    UIView* mImmobWall;//
	NSMutableArray *openApps;
    AdSageRecommendView *_recmdView;
}
@property(nonatomic, retain) AdSageRecommendView *recmdView;

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) NSMutableArray *data;

-(void)updateTableView:(id)sender;
//@property (nonatomic, retain) UINib *cellNib;

@end



