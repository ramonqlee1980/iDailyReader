#import <UIKit/UIKit.h>
#import "ApplicationCell.h"
#import "ModalViewController.h"
#import "Constants.h"
#import "PullRefreshBaseController.h"

@interface RootViewController : PullRefreshBaseController<PullingRefreshDelegate,UIAlertViewDelegate,UIAlertViewDelegate>
{
	//ApplicationCell *tmpCell;
    NSMutableArray *data;
}

@property (nonatomic, retain) NSMutableArray *data;

@end



