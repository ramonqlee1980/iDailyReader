//
//  AdsConfig.h
//  HappyLife
//
//  Created by ramon lee on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//appstore switch
#define k91Appstore


//switch for ads config
//#define MHealth
//#define Foods
//#define LosingWeight
//#define careerGuide
//#define RaisingKids
//#define TodayinHistory
#define Makeup
//#define MakeToast
//#define TraditionalChineseMedicine
//#define SpouseTalks
//#define Humer
//#define EnglishPrefix
//#define EnglishSuffix
//#define LearnEnglishBySinging MakeToast


//ads url
#define kDefaultAds @"defaultAds"

#ifdef k91Appstore
#define AdsUrl @"http://www.idreems.com/example.php?adsconfigNonAppstore.xml"
#else
#define AdsUrl @"http://www.idreems.com/example.php?adsconfig20.xml"
#endif



#ifdef LosingWeight //ads to be replaced
#define kFlurryID @"255WD5F3T3WD385YSH5C"
//weibo key and secret
//sina weibo
#define kOAuthConsumerKey				@"1387173806"		//REPLACE ME
#define kOAuthConsumerSecret			@"b636a3548bd66152eab29cd19c5773ee"		//REPLACE ME


//appid
#define kAppIdOnAppstore @""

//wall
//修改为你自己的AppID和AppSecret
#define kDefaultAppID_iOS           @"9982ffa850423b4f" // youmi default app id
#define kDefaultAppSecret_iOS       @"a0b04cc29a97d380" // youmi default app secret


//id for ads
#define kMobiSageID_iPhone  @"b67b0ff55e244aa5a527db004a03261c"
#define kWiyunID_iPhone  @"e422a3e49716ba1f"
#define kWiyunID_iPad    @"626a94c2b610df0f"
#define kWoobooPublisherID  @"df4d4df3bb0440fea0a83c1b60c2fd5c"
#define kDomobPubliserID @"56OJyOqouMF2S3Yb0p"
#define kCaseeIPhoneId         @"4FB83ED3982EC730A8490A7BCAEDBAF0"
#define kCaseeIPadId @"D2C1D2621157FA73F29875AF3875AF4D"
#define kYoumiId kDefaultAppID_iOS
#define kYoumiSecret kDefaultAppSecret_iOS
#define kAdmobID @"a14f1b56e4ba533"


#elif defined careerGuide
#define kFlurryID @"SPP44Z2HJXGR4ZXWNRYF"
//weibo key and secret
//sina weibo
#define kOAuthConsumerKey				@"1387173806"		//REPLACE ME
#define kOAuthConsumerSecret			@"b636a3548bd66152eab29cd19c5773ee"		//REPLACE ME


//appid
#define kAppIdOnAppstore @"478589946"

//wall
//修改为你自己的AppID和AppSecret
#define kDefaultAppID_iOS           @"9982ffa850423b4f" // youmi default app id
#define kDefaultAppSecret_iOS       @"a0b04cc29a97d380" // youmi default app secret


//id for ads
#define kMobiSageID_iPhone  @"b67b0ff55e244aa5a527db004a03261c"
#define kWiyunID_iPhone  @"e422a3e49716ba1f"
#define kWiyunID_iPad    @"626a94c2b610df0f"
#define kWoobooPublisherID  @"df4d4df3bb0440fea0a83c1b60c2fd5c"
#define kDomobPubliserID @"56OJyOqouMF2S3Yb0p"
#define kCaseeIPhoneId         @"4FB83ED3982EC730A8490A7BCAEDBAF0"
#define kCaseeIPadId @"D2C1D2621157FA73F29875AF3875AF4D"
#define kYoumiId kDefaultAppID_iOS
#define kYoumiSecret kDefaultAppSecret_iOS
#define kAdmobID @"a14f1b56e4ba533"

#elif defined RaisingKids
#define kFlurryID @"KN8WBCH24R3V3PFVSSY2"
//weibo key and secret
//sina weibo
#define kOAuthConsumerKey				@"1387173806"		//REPLACE ME
#define kOAuthConsumerSecret			@"b636a3548bd66152eab29cd19c5773ee"		//REPLACE ME


//appid
#define kAppIdOnAppstore @"533237826"

//wall
//修改为你自己的AppID和AppSecret
#define kDefaultAppID_iOS           @"9982ffa850423b4f" // youmi default app id
#define kDefaultAppSecret_iOS       @"a0b04cc29a97d380" // youmi default app secret


//id for ads
#define kMobiSageID_iPhone  @"b67b0ff55e244aa5a527db004a03261c"
#define kWiyunID_iPhone  @"e422a3e49716ba1f"
#define kWiyunID_iPad    @"626a94c2b610df0f"
#define kWoobooPublisherID  @"df4d4df3bb0440fea0a83c1b60c2fd5c"
#define kDomobPubliserID @"56OJyOqouMF2S3Yb0p"
#define kCaseeIPhoneId         @"4FB83ED3982EC730A8490A7BCAEDBAF0"
#define kCaseeIPadId @"D2C1D2621157FA73F29875AF3875AF4D"
#define kYoumiId kDefaultAppID_iOS
#define kYoumiSecret kDefaultAppSecret_iOS
#define kAdmobID @"a14f1b56e4ba533"

#elif defined TodayinHistory
//flurry
#define kFlurryID @"VD57WGD28683BPMSQ9X9"

#define kHistory
//weibo key and secret
//sina weibo
#define kOAuthConsumerKey				@"1387173806"		//REPLACE ME
#define kOAuthConsumerSecret			@"b636a3548bd66152eab29cd19c5773ee"		//REPLACE ME


//appid
#define kAppIdOnAppstore @"480812170"

//wall
//修改为你自己的AppID和AppSecret
#define kDefaultAppID_iOS           @"9982ffa850423b4f" // youmi default app id
#define kDefaultAppSecret_iOS       @"a0b04cc29a97d380" // youmi default app secret


//id for ads
#define kMobiSageID_iPhone  @"b67b0ff55e244aa5a527db004a03261c"
#define kWiyunID_iPhone  @"e422a3e49716ba1f"
#define kWiyunID_iPad    @"626a94c2b610df0f"
#define kWoobooPublisherID  @"df4d4df3bb0440fea0a83c1b60c2fd5c"
#define kDomobPubliserID @"56OJyOqouMF2S3Yb0p"
#define kCaseeIPhoneId         @"4FB83ED3982EC730A8490A7BCAEDBAF0"
#define kCaseeIPadId @"D2C1D2621157FA73F29875AF3875AF4D"
#define kYoumiId kDefaultAppID_iOS
#define kYoumiSecret kDefaultAppSecret_iOS
#define kAdmobID @"a14f1b56e4ba533"

#elif defined Makeup
//weibo key and secret
//sina weibo
#define kOAuthConsumerKey				@"1833188142"		//REPLACE ME
#define kOAuthConsumerSecret			@"249f839bf79ddf8cf755f96e947e01a9"		//REPLACE ME

//flurry
#define kFlurryID @"ZVSNS9NXX922ZMYBV436"
//appid
#define kAppIdOnAppstore @"469269134"

//wall
//修改为你自己的AppID和AppSecret
#define kDefaultAppID_iOS           @"5aa5eabf0f6bef1d" // youmi default app id
#define kDefaultAppSecret_iOS       @"5e9ee87631d15545" // youmi default app secret


//id for ads
#define kMobiSageIDOther_iPhone @"aef1fcef8e0b48d9978c1d3b1928a76f"
#define kMobiSageID_iPhone  @"c6edb00a37f4435ca06eef7f016df0bb"
#define kWiyunID_iPhone  @"cbd2ecdce0638c28"
#define kWiyunID_iPad    @"7ef7469b8144e036"
#define kWoobooPublisherID  @"3edc2f2cce9c4cc9a530f297a6cc54a1"
#define kDomobPubliserID @"56OJyOqouMF2Jf1Hdq"
#define kCaseeIPhoneId         @"4FB83ED3982EC730A8490A7BCAEDBAF0"
#define kCaseeIPadId @"D2C1D2621157FA73F29875AF3875AF4D"
#define kYoumiId kDefaultAppID_iOS
#define kYoumiSecret kDefaultAppSecret_iOS
#define kAdmobID @"a14f1b56e4ba533"
#define kWapsId @"6742d5de04cf0a6a5bf45fd3cdc9001a"

#elif defined MakeToast
//code macro
#define kSingleFile

#define kFlurryID @"D5WYXYC4R9C6273W7M9Q"
//weibo key and secret
//sina weibo
#define kOAuthConsumerKey				@"319938111"		//REPLACE ME
#define kOAuthConsumerSecret			@"1618d139b2ea94d0ddb5ef931245265a"		//REPLACE ME

//appid
#define kAppIdOnAppstore @"471656942"

//wall
//修改为你自己的AppID和AppSecret
#define kDefaultAppID_iOS           @"6b875a1db75ff9e5" // youmi default app id
#define kDefaultAppSecret_iOS       @"e6983e250159ac64" // youmi default app secret


//id for ads
#define kMobiSageID_iPhone  @"e270159b22cc4c98a64e4402db48e96d"
#define kMobiSageIDOther_iPhone  @"242f601007b249fa8a2577890e80e217"
#define kWiyunID_iPhone  @"84f03bdec273a137"
#define kWiyunID_iPad    @"29ae6d7c8172f013"
#define kWoobooPublisherID  @"3126e9a7c08e452090ff8fa179495797"
#define kDomobPubliserID @"56OJyOqouMF2HGNhFr"
#define kCaseeIPhoneId         @"4FB83ED3982EC730A8490A7BCAEDBAF0"
#define kCaseeIPadId @"D2C1D2621157FA73F29875AF3875AF4D"
#define kYoumiId kDefaultAppID_iOS
#define kYoumiSecret kDefaultAppSecret_iOS
#define kAdmobID @"a14f1b56e4ba533"
#define kWapsId @"5a3029e17a29d1f8d8fb764318406970"
#elif defined TraditionalChineseMedicine
#define kFlurryID @"C82CN6MQ328XV3BHX5TN"
//weibo key and secret
//sina weibo
#define kOAuthConsumerKey				@"319938111"		//REPLACE ME
#define kOAuthConsumerSecret			@"1618d139b2ea94d0ddb5ef931245265a"		//REPLACE ME


//appid
#define kAppIdOnAppstore @"495815697"

//wall
//修改为你自己的AppID和AppSecret
#define kDefaultAppID_iOS           @"6b875a1db75ff9e5" // youmi default app id
#define kDefaultAppSecret_iOS       @"e6983e250159ac64" // youmi default app secret


//id for ads
#define kMobiSageID_iPhone  @"72e2cc8d57084b0399d9d69565fb20e0"
#define kMobiSageIDOther_iPhone  @"013f5b8388bf4c9c9fcc24b788724232"
#define kWiyunID_iPhone  @"2d6890f29731ab0b"
#define kWiyunID_iPad    @"fccb122fc023a241"
#define kWoobooPublisherID  @"5aded4d9ce6243fda3e3aae4d120cc3e"
#define kDomobPubliserID @"56OJyOqouMF2HGNhFr"
#define kCaseeIPhoneId         @"4FB83ED3982EC730A8490A7BCAEDBAF0"
#define kCaseeIPadId @"D2C1D2621157FA73F29875AF3875AF4D"
#define kYoumiId kDefaultAppID_iOS
#define kYoumiSecret kDefaultAppSecret_iOS
#define kAdmobID @"a14f1b56e4ba533"
#define kWapsId @"6742d5de04cf0a6a5bf45fd3cdc9001a"
#elif defined SpouseTalks

#define kFlurryID @"S32DNZTRR5WVPV8F2KM6"
//weibo key and secret

//sina weibo
#define kOAuthConsumerKey				@"2886644695"
#define kOAuthConsumerSecret			@"a228f8dcfb9a9c1d9b5cb033a55d847c"

//appid
#define kAppIdOnAppstore @"472818080"

//wall
//修改为你自己的AppID和AppSecret
#define kDefaultAppID_iOS           @"6b875a1db75ff9e5" // youmi default app id
#define kDefaultAppSecret_iOS       @"e6983e250159ac64" // youmi default app secret

//id for ads
#define kMobiSageID_iPhone  @"6d72113c585b40c594a879eff708c7bf"
#define kWiyunID_iPhone  @"414121e947429b2e"
#define kWiyunID_iPad    @"86a3f5d37440f024"
#define kWoobooPublisherID  @"3f7625340cb7490a95f92a0bef2b4b3b"
#define kDomobPubliserID @"56OJyOqouMEW97fZ+N"
#define kCaseeIPhoneId         @"4FB83ED3982EC730A8490A7BCAEDBAF0"
#define kCaseeIPadId @"D2C1D2621157FA73F29875AF3875AF4D"
#define kYoumiId kDefaultAppID_iOS
#define kYoumiSecret kDefaultAppSecret_iOS
#define kAdmobID @"a14f1b56e4ba533"

#elif defined Humer

//flurry
#define kFlurryID @"TDGR5K49JJPSX4G7HZJ8"
//sina weibo
#define kOAuthConsumerKey				@"2951554241"
#define kOAuthConsumerSecret			@"1d89a8b78ddd95d32c20bf72ca6dcfb6"


//appid
#define kAppIdOnAppstore @"469265895"

//wall
//修改为你自己的AppID和AppSecret
#define kDefaultAppID_iOS           @"9982ffa850423b4f" // youmi default app id
#define kDefaultAppSecret_iOS       @"a0b04cc29a97d380" // youmi default app secret


//id for ads
#define kMobiSageIDOther_iPhone @"aef1fcef8e0b48d9978c1d3b1928a76f"
#define kMobiSageID_iPhone  @"009a0187005c4e3989a5e8009fed8a47"
#define kWiyunID_iPhone  @"f4c8b82394761b8a"
#define kWiyunID_iPad    @"07b740b29274e601"
#define kWoobooPublisherID  @"09967f2472a14ca389ded0a82484836d"
#define kDomobPubliserID @"56OJyOqouMEW97fZ+N"
#define kCaseeIPhoneId         @"4FB83ED3982EC730A8490A7BCAEDBAF0"
#define kCaseeIPadId @"D2C1D2621157FA73F29875AF3875AF4D"
#define kAdmobID @"a14f1b56e4ba533"
#define kYoumiId kDefaultAppID_iOS
#define kYoumiSecret kDefaultAppSecret_iOS
#define kWapsId @"6742d5de04cf0a6a5bf45fd3cdc9001a"

#elif defined EnglishSuffix

//flurry
#define kFlurryID @"ZYPQPYTD683PDWZH47SS"

//code macro
#define kSingleFile
//sina weibo
#define kOAuthConsumerKey				@"2951554241"
#define kOAuthConsumerSecret			@"1d89a8b78ddd95d32c20bf72ca6dcfb6"

//appid
#define kAppIdOnAppstore @"471768694"

//wall
//修改为你自己的AppID和AppSecret
#define kDefaultAppID_iOS           @"be4ff0dc2f9e7eb5" // youmi default app id
#define kDefaultAppSecret_iOS       @"2262cc0dbff4ebca" // youmi default app secret


//id for ads
#define kMobiSageID_iPhone  @"146761bebeb844e3aadfff30cb52d26e"
#define kMobiSageIDOther_iPhone  @"6bf36b0b0d6d427cb596eadff372e968"
#define kWiyunID_iPhone  @"fbb38fa6d2042250"
#define kWiyunID_iPad    @"b88e5d4dd473e1a3"
#define kWoobooPublisherID  @"211021fd50d14a2c83ba906420b29719"
#define kDomobPubliserID @"56OJyOqouMEW97fZ+N"
#define kCaseeIPhoneId         @"4FB83ED3982EC730A8490A7BCAEDBAF0"
#define kCaseeIPadId @"D2C1D2621157FA73F29875AF3875AF4D"
#define kYoumiId kDefaultAppID_iOS
#define kYoumiSecret kDefaultAppSecret_iOS
#define kAdmobID @"a14f1b56e4ba533"
#define kWapsId @"5a3029e17a29d1f8d8fb764318406970"
#elif defined EnglishPrefix
//flurry
#define kFlurryID @"RSJY3SX8QV95QQM5GJ5Y"
//code macro
#define kSingleFile
//sina weibo
#define kOAuthConsumerKey				@"2951554241"
#define kOAuthConsumerSecret			@"1d89a8b78ddd95d32c20bf72ca6dcfb6"


//appid
#define kAppIdOnAppstore @"472058981"

//wall
//修改为你自己的AppID和AppSecret
#define kDefaultAppID_iOS           @"be4ff0dc2f9e7eb5" // youmi default app id
#define kDefaultAppSecret_iOS       @"2262cc0dbff4ebca" // youmi default app secret


//id for ads
#define kMobiSageID_iPhone  @"c441c7a278a24c66b33cb6ae149e3929"
#define kWiyunID_iPhone  @"6093441723009b0f"
#define kWiyunID_iPad    @"2701171f41658221"
#define kWoobooPublisherID  @"211021fd50d14a2c83ba906420b29719"
#define kDomobPubliserID @"56OJyOqouMEW97fZ+N"
#define kCaseeIPhoneId         @"4FB83ED3982EC730A8490A7BCAEDBAF0"
#define kCaseeIPadId @"D2C1D2621157FA73F29875AF3875AF4D"
#define kYoumiId kDefaultAppID_iOS
#define kYoumiSecret kDefaultAppSecret_iOS
#define kAdmobID @"a14f1b56e4ba533"
#define kWapsId @"5a3029e17a29d1f8d8fb764318406970"

#else//other cases,from today in history
//flurry
#define kFlurryID @"VD57WGD28683BPMSQ9X9"

//weibo key and secret
//sina weibo
#define kOAuthConsumerKey				@"1387173806"		//REPLACE ME
#define kOAuthConsumerSecret			@"b636a3548bd66152eab29cd19c5773ee"		//REPLACE ME


//appid
#define kAppIdOnAppstore @""

//wall
//修改为你自己的AppID和AppSecret
#define kDefaultAppID_iOS           @"9982ffa850423b4f" // youmi default app id
#define kDefaultAppSecret_iOS       @"a0b04cc29a97d380" // youmi default app secret


//id for ads
#define kMobiSageID_iPhone  @"b67b0ff55e244aa5a527db004a03261c"
#define kWiyunID_iPhone  @"e422a3e49716ba1f"
#define kWiyunID_iPad    @"626a94c2b610df0f"
#define kWoobooPublisherID  @"df4d4df3bb0440fea0a83c1b60c2fd5c"
#define kDomobPubliserID @"56OJyOqouMF2S3Yb0p"
#define kCaseeIPhoneId         @"4FB83ED3982EC730A8490A7BCAEDBAF0"
#define kCaseeIPadId @"D2C1D2621157FA73F29875AF3875AF4D"
#define kYoumiId kDefaultAppID_iOS
#define kYoumiSecret kDefaultAppSecret_iOS
#define kAdmobID @"a14f1b56e4ba533"

#endif

#define kImmobBannerId @"25d37c3d48c33556e68fcd9ceb1fdd67"
#define kImmobWallId @"69b92a0f35cd484d4d93de787397b7d9"


//ads platform names
#define AdsPlatformWooboo @"Wooboo"
#define AdsPlatformWiyun @"Wiyun"
#define AdsPlatformMobisage @"Mobisage"
#define AdsPlatformMobisageOther @"MobisageOther"
#define AdsPlatformDomob @"Domob"
#define AdsPlatformYoumi @"Youmi"//not implemented right now
#define AdsPlatformCasee @"Casee"
#define AdsPlatformAdmob @"Admob"
#define AdsPlatformMobisageRecommend @"MobisageRecommend"
#define AdsPlatformMobisageRecommendOther @"MobisageRecommendOther"
#define AdsPlatformWQMobile @"WQMobile"
#define AdsPlatformImmob @"Immob"
#define AdsPlatformMiidi @"miidi"
#define AdsPlatformWaps @"waps"

//ads wall
#define AdsPlatformImmobWall @"ImmobWall"
#define AdsPlatformYoumiWall @"YoumiWall"
#define AdsPlatformWapsWall @"WapsWall"
#define AdsPlatformDefaultWall AdsPlatformYoumiWall



#define kNewContentScale 5
#define kMinNewContentCount 3

#define kWeiboMaxLength 140
#define kAdsSwitch @"AdsSwitch"
#define kPermanent @"Permanent"
#define kDateFormatter @"yyyy-MM-dd"

//for notification
#define kAdsUpdateDidFinishLoading @"AdsUpdateDidFinishLoading"
#define  kUpdateTableView @"UpdateTableView"

#define kOneDay (24*60*60)
#define kTrialDays  1

//flurry event
#define kFlurryRemoveTempConfirm @"kRemoveTempConfirm"
#define kFlurryRemoveTempCancel  @"kRemoveTempCancel"
#define kEnterMainViewList       @"kEnterMainViewList"
#define kFlurryOpenRemoveAdsList @"kOpenRemoveAdsList"

#define kFlurryDidSelectApp2RemoveAds @"kDidSelectApp2RemoveAds"
#define kFlurryRemoveAdsSuccessfully  @"kRemoveAdsSuccessfully"
#define kDidShowFeaturedAppNoCredit   @"kDidShowFeaturedAppNoCredit"

#define kShareByWeibo @"kShareByWeibo"
#define kShareByEmail @"kShareByEmail"

#define kEnterBylocalNotification @"kEnterBylocalNotification"
#define kDidShowFeaturedAppCredit @"kDidShowFeaturedAppCredit"

#define kFlurryDidSelectAppFromRecommend @"kFlurryDidSelectAppFromRecommend"
#define kFlurryDidSelectAppFromMainList  @"kFlurryDidSelectAppFromMainList"
#define kFlurryDidReviewContentFromMainList  @"kFlurryDidReviewContentFromMainList"
#define kLoadRecommendAdsWall @"kLoadRecommendAdsWall"
//favorite
#define kEnterNewFavorite @"kEnterNewFavorite"
#define kOpenExistFavorite @"kOpenExistFavorite"

#define kCountPerSection 3
@interface AdsConfig : NSObject
{
    NSMutableArray *mData;
    NSInteger mCurrentIndex;
    NSMutableArray* mAdsWalls;
}
@property (nonatomic, retain) NSMutableArray* mData;
@property (nonatomic, assign) NSInteger mCurrentIndex;

+(AdsConfig*)sharedAdsConfig;
+(void)reset;
+(NSDate*)currentLocalDate;

+(BOOL) isAdsOn;
+(BOOL) isAdsOff;
+(void) setAdsOn:(BOOL)enable type:(NSString*)type;
+(BOOL)neverCloseAds;

-(NSString*)wallShowString;
-(NSString *)getAdsTestVersion:(const NSUInteger)index;
-(BOOL)wallShouldShow;
-(void)init:(NSString*)path;
-(NSArray*)getAdsWalls;

-(NSString*)getFirstAd;

-(NSString*)getLastAd;

-(NSInteger)getAdsCount;

-(NSString*)toNextAd;

-(NSString*)getCurrentAd;

-(BOOL)isCurrentAdsValid;
-(NSInteger)getCurrentIndex;

-(BOOL)isInitialized;

-(void)dealloc;

@end
