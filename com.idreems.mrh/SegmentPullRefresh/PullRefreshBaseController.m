#import "PullRefreshBaseController.h"

@implementation PullRefreshBaseController
@synthesize m_contentViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}
-(void)hideContentView:(BOOL)hide
{
    if (self.m_contentViewController) {
        self.m_contentViewController.view.hidden = hide;
        [self.m_contentViewController tableViewDidFinishedLoading];
    }
}
#pragma mark view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];   
    // Do any additional setup after loading the view from its nib.
    
    //设置背景颜色
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    
    //添加内容的TableView
    self.m_contentViewController = [[ContentViewController alloc]initWithNibName:@"ContentViewController" bundle:nil];
    if (!self.m_contentViewController.navigationController) {
        self.m_contentViewController.customNavigationController = self.navigationController;
    }
    [self.view addSubview:m_contentViewController.view];
}


@end
