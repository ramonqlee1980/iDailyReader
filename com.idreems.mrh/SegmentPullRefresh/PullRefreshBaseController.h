
#import <UIKit/UIKit.h>
#import "ContentViewController.h"

@interface PullRefreshBaseController : UIViewController
{
    ContentViewController *m_contentViewController;  //内容页面    
}
@property (nonatomic,retain) ContentViewController *m_contentViewController;

-(void)hideContentView:(BOOL)hide;
@end
