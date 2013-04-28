//
//  AdsConfiguration.h
//  HappyLife
//
//  Created by ramonqlee on 4/4/13.
//
//

#import <Foundation/Foundation.h>
#import "CommonHelper.h"


#define kAppIdOnAppstore [NSString stringWithFormat:@"%d",[[AdsConfiguration sharedInstance]appleId]]
#define kAppIdOnAppstoreInt [[AdsConfiguration sharedInstance]appleId]
#define kMobiSageID_iPhone [[AdsConfiguration sharedInstance]mobisageId]
#define kAppOnlineTag [[AdsConfiguration sharedInstance]appOnlineTag]
#define kYoumiWallAppId [[AdsConfiguration sharedInstance]youmiAppId]
#define kYoumiWallAppSecret [[AdsConfiguration sharedInstance]youmiSecret]

//upload
#define kAppChannel @"appstore"
//#define kAppChannel @"91"



//tag for push item 
#define kOwerTag @"owner"
#define kValueSeriesX @"value%d"
#define kTypeTag @"type"
#define kSceneTag @"scene"
#define kVisibility @"visibility"

//owner
#define kAppstoreId @"appleId"
#define kWechatId @"wechat"
#define kYoumi @"youmi"
#define kMobisage @"mobisage"
#define kWQmobile @"wqmobile"

//scene
#define kStatistics @"stat"
#define kAdDisplay @"ad"
#define kSNSShare @"sns"
#define kSoftUpdate @"softupdate"
#define kPostBlog @"postBlog"


//type

//type for scene kAdDisplay
#define kBanner @"banner"
#define kOfferWall @"offerwall"
#define kRecommendWall @"recommendwall"
#define kFullScreenAd @"fullscreen"


#define kAdsJsonUrl @"http://www.idreems.com/adsconfig/getadsconfig.php"

@class AdsViewManager;
@class RMIndexedArray;
@interface AdsConfiguration : NSObject
Decl_Singleton(AdsConfiguration)

-(void)initWithJson:(NSData*)data;
-(void)initWithFile:(NSString*)fileName;
/**
 return count of ads,return 0 if this list is empty
 */
-(NSInteger)getCount;
-(NSDictionary*)getItem:(NSInteger)index;

//get filtered items
-(RMIndexedArray*)getScenedItems:(NSString*)scene withType:(NSString*)type;
-(AdsViewManager*)getAdsViewManager;



//util methods
-(NSString*)appOnlineTag;
-(NSInteger)appleId;
-(NSString*)wechatId;
-(NSString*)FlurryId;
-(NSString*)mobisageId;
-(NSString*)youmiAppId;
-(NSString*)youmiSecret;
@end
