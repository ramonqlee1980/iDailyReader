//
//  WQAdView.h
//  ORMMA
//
//  Created by hucent on 9/7/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    WQAdViewTypeDefault = 0,
    WQAdViewTypeWall = 1,
    WQAdViewTypeVideo = 2
}WQAdViewType;

@class WQAdView;

@protocol WQAdViewDelegate;
@protocol WQAdViewDelegate <NSObject>
@optional

//Called after sdk failed to load ad
- (void)failureLoadingAd;

// Called after the ad is resized in place to allow the parent application to
// animate things if desired.
- (void)didResizeAdToSize:(CGSize)size;



// Called just before to an ad is displayed
- (void)adWillShow;

// Called just after to an ad is displayed
- (void)adDidShow;

// Called just before to an ad is Hidden
- (void)adWillHide;

// Called just after to an ad is Hidden
- (void)adDidHide;

// Called just before an ad expands
- (void)willExpandAdToFrame:(CGRect)frame;

// Called just after an ad expands
- (void)didExpandAdToFrame:(CGRect)frame;

// Called just before an ad closes
- (void)adWillClose;

// Called just after an ad closes
- (void)adDidClose;

// called when the ad will begin heavy content (usually when the ad goes full screen)
- (void)appShouldSuspendForAd;

// called when the ad is finished with it's heavy content (usually when the ad returns from full screen)
- (void)appShouldResumeFromAd;


// allows the application to override the click to app store, for example
// display an alert to the user before hand
- (void)placeCallToAppStore:(NSString *)urlString;

// allows the application to override the create calendar event process to, for
// example display an alert to the user before hand
- (void)createCalendarEntryForDate:(NSDate *)date
							 title:(NSString *)title
							  body:(NSString *)body;

// allows the application to inject itself into the full screen browser menu
// to handle the "go" method (for example, send to safari, facebook, etc)
- (void)showURLFullScreen:(NSURL *)url
			   sourceView:(UIView *)view;

- (void)emailNotSetupForAd;

- (void)onWQAdReceived:(WQAdView *)adview;

- (void)onWQAdFailed:(WQAdView *)adview;

- (void)onWQAdDismiss:(WQAdView *)adview;

- (void)onWQAdLoadTimeout:(WQAdView*) adview;

- (void)onWQAdClicked:(WQAdView*) adview;

- (void)onWQAdClickedFailed:(WQAdView*) adview;

- (void)onWQAdViewed:(WQAdView*) adview;

-(void)onWQAdWillPresentScreen:(WQAdView *) adview;

-(void)onWQAdDidDismissScreen:(WQAdView *) adview;
@end
@interface WQAdView : UIView
@property(nonatomic,retain) NSMutableArray *adviews;
@property(nonatomic,retain) id <WQAdViewDelegate> delegate;
@property(nonatomic,assign) BOOL isViewable;
@property(nonatomic,assign) BOOL isActiveNotification;
@property WQAdViewType adType;

+(void) openAdWallWithAdSlotId:(NSString*)pSlotId accountKey:(NSString*)pAccountKey inViewController:(UIViewController*)pController;

-(id) initWithFrame:(CGRect)pFrame andAdType:(WQAdViewType)pAdType;

- (id)init;

- (id)init:(BOOL)enableLocation;

- (id)initWithLocation;

- (id)initWithFrame:(CGRect)frame;

- (id)initWithLocationWithFrame:(CGRect)frame;

-(void) stop;

- (void)startWithAdSlotID:(NSString *)adslotid AccountKey:(NSString *)accountKey InViewController:(UIViewController *)controller;

-(void) presentWall;

- (BOOL)isAdCachedWithAdSlotID:(NSString *)adslotID;

- (void)setAdPlatform:(NSString *)AdPlatform AdPlatformVersion:(NSString *)AdPlatformVersion;
@end
