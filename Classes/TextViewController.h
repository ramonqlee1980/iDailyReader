#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DoMobDelegateProtocol.h"
#import "CaseeAdDelegate.h"
#import "WQAdProtocol.h"
#import <immobSDK/immobView.h>
#import "MobiSageRecommendSDK.h"

@class OAuthEngine;


enum ShareOption
{
    kShareByEmailOption = 0
};


@class AppDelegate;
@class MBProgressHUD;

@interface TextViewController : UIViewController <MFMailComposeViewControllerDelegate,UIActionSheetDelegate,DoMobDelegate,CaseeAdDelegate,MobiSageRecommendDelegate,WQAdProtocol,immobViewDelegate>
{
    UIView *contentView;
    NSIndexPath* index;
    UITextView* textView;
    AppDelegate* delegate;
    UIView* mAdView;
    UITabBarItem *mAdsSwitchBarItem;
    
    OAuthEngine				*_engine;
    BOOL mWeibo;    
    BOOL mLoginWeiboCanceled;
    BOOL mAdsWallShouldShow;
    BOOL _tempCloseRequest;
    MobiSageRecommendView *_recmdView;
    BOOL mWallOpened;//open ad wall
    NSString* mWallName;
    UIView* mWall;
    
    MBProgressHUD *_hud;
}
@property (retain) MBProgressHUD *hud;

@property(nonatomic, retain) MobiSageRecommendView *recmdView;
@property (nonatomic, retain) IBOutlet UITabBarItem *mAdsSwitchBarItem;
@property(nonatomic, retain) UIView *mAdView;
//@property(nonatomic,assign) NSInteger mAdIndex;
@property (nonatomic, retain) IBOutlet UITextView *textView;

@property(nonatomic, retain) IBOutlet UIView *contentView;
@property(nonatomic, retain) NSIndexPath* index;

-(id)initWithIndexPath:(NSIndexPath*)indexPath;
- (IBAction)compose:(id)sender;
- (IBAction)feedback:(id)sender;
- (IBAction)signOut:(id)sender;
- (IBAction)closeAd:(id)sender;
-(IBAction)emailShare;
-(IBAction)add2Favorate;
-(IBAction)share2WixinChat;
-(IBAction)share2WixinFriends;
-(IBAction)changeColor;

-(void)launchMailAppOnDevice:(BOOL)feedback;
-(void)displayComposerSheet:(BOOL)feedback;

-(void)loadAd;
- (void)adjustAdSize;
@end

