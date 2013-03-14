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

@interface RootViewController : PullRefreshBaseController<PullingRefreshDelegate,UIAlertViewDelegate,YouMiWallDelegate,UIAlertViewDelegate,MobiSageRecommendDelegate,immobViewDelegate
#ifdef kETMobOn
,ETMobAdWallDelegate
#endif
>
{
	//ApplicationCell *tmpCell;
    NSMutableArray *data;
	YouMiWall *wall;
    UIView* mImmobWall;//
	NSMutableArray *openApps;
    MobiSageRecommendView *_recmdView;
}
@property(nonatomic, retain) MobiSageRecommendView *recmdView;

@property (nonatomic, retain) NSMutableArray *data;

@end



