#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "BaseViewController.h"

@class OAuthEngine;

@class AppDelegate;
@class MBProgressHUD;

@interface TextViewController : BaseViewController <MFMailComposeViewControllerDelegate,UIActionSheetDelegate>

@property(nonatomic, copy) NSString* content;

@end

