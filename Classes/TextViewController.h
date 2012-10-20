#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DoMobDelegateProtocol.h"
#import "CaseeAdDelegate.h"
#import "AdSageRecommendDelegate.h"
#import "WQAdProtocol.h"
#import <immobSDK/immobView.h>

@class AdSageRecommendView;
@class OAuthEngine;


enum ShareOption
{
    kShareByEmailOption = 0
};


@class AppDelegate;


@interface TextViewController : UIViewController <MFMailComposeViewControllerDelegate,UIActionSheetDelegate,DoMobDelegate,CaseeAdDelegate,AdSageRecommendDelegate,WQAdProtocol,immobViewDelegate>
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
    AdSageRecommendView *_recmdView;
    BOOL mWallOpened;//open ad wall
    NSString* mWallName;
    UIView* mWall;
}
@property(nonatomic, retain) AdSageRecommendView *recmdView;
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

-(void)launchMailAppOnDevice:(BOOL)feedback;
-(void)displayComposerSheet:(BOOL)feedback;

-(void)loadAd;
- (void)adjustAdSize;
@end

