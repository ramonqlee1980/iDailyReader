#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DoMobDelegateProtocol.h"
#import "CaseeAdDelegate.h"
#import "WQAdProtocol.h"
#import <immobSDK/immobView.h>
#import "MobiSageRecommendSDK.h"
#import "BaseViewController.h"

@class OAuthEngine;

@class AppDelegate;
@class MBProgressHUD;

@interface TextViewController : BaseViewController <MFMailComposeViewControllerDelegate,UIActionSheetDelegate,DoMobDelegate,CaseeAdDelegate,MobiSageRecommendDelegate,WQAdProtocol,immobViewDelegate>

@property(nonatomic, copy) NSString* content;

@end

