
#import <UIKit/UIKit.h>

@interface ModalViewController : UIViewController
{
	UILabel *appName, *copyright;
    UIButton* done;
}

@property (nonatomic, retain) IBOutlet UILabel *appName, *copyright;
@property (nonatomic, retain) IBOutlet UIButton* done;

- (IBAction)dismissAction:(id)sender;

@end
