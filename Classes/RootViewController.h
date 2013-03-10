#import <UIKit/UIKit.h>
#import "ApplicationCell.h"
#import "ModalViewController.h"
#import "Constants.h"
#import "YouMiWall.h"
#import "MobiSageRecommendSDK.h"
#import <immobSDK/immobView.h>
#import "PullRefreshBaseController.h"

#ifdef kETMobOn
#import "ETMobAdWall.h"
#endif

@interface RootViewController : PullRefreshBaseController<PullingRefreshDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,YouMiWallDelegate,UIAlertViewDelegate,MobiSageRecommendDelegate,immobViewDelegate
#ifdef kETMobOn
,ETMobAdWallDelegate
#endif
>
{
	//ApplicationCell *tmpCell;
    NSMutableArray *data;
    UITableView* tableView;
	YouMiWall *wall;
    UIView* mImmobWall;//
	NSMutableArray *openApps;
    MobiSageRecommendView *_recmdView;
}
@property(nonatomic, retain) MobiSageRecommendView *recmdView;

@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) NSMutableArray *data;

-(void)updateTableView:(id)sender;
//@property (nonatomic, retain) UINib *cellNib;

@end



