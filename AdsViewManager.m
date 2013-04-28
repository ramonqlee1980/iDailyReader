//
//  AdsViewManager.m
//  HappyLife
//
//  Created by ramonqlee on 4/4/13.
//
//

#import "AdsViewManager.h"
#import "AdsConfiguration.h"
#import "YoumiOfferWall.h"
#import "AdSageManager.h"
#import "MobiSageSDK.h"
#import "AdSageView.h"
#import "WQAdView.h"

#define kAdView @"view"//save for adview,inner use only

#define kMobisageRecommendWallValueCount 1
#define kYoumiOfferwallValueCount 2
#define kWQMobileRecommendWallValueCount 4

@interface AdJson : NSObject
@property(nonatomic,retain)NSString* owner;
@property(nonatomic,retain)NSMutableArray* values;
@property(nonatomic,retain)NSString* type;
@property(nonatomic,retain)NSString* scene;

@property(nonatomic,retain)NSObject* view;
@end


@implementation AdJson
@synthesize owner,values,type,scene;
-(id)init
{
    if (self = [super init]) {
        values = [[NSMutableArray alloc]init];
    }
    return self;
}
+(AdJson*)initWithDictionary:(NSDictionary*)dict
{
    if (!dict) {
        return  nil;
    }
    AdJson* json = [[[AdJson alloc]init]autorelease];
    id obj = [dict objectForKey:kOwerTag];
    if (obj && [obj isKindOfClass:[NSString class]]) {
        json.owner = obj;
    }
    
    obj = [dict objectForKey:kTypeTag];
    if (obj && [obj isKindOfClass:[NSString class]]) {
        json.type = obj;
    }
    
    obj = [dict objectForKey:kSceneTag];
    if (obj && [obj isKindOfClass:[NSString class]]) {
        json.scene = obj;
    }
    
//    obj = [dict objectForKey:kAdView];
//    if (obj && [obj isKindOfClass:[NSObject class]]) {
//        json.view = obj;
//    }
    
    //values
    NSString* key = nil;
    NSInteger i = 0;
    do {
        key = [NSString stringWithFormat:kValueSeriesX,++i];
        obj = [dict objectForKey:key];
        if (obj && [obj isKindOfClass:[NSString class]]) {
            [json.values addObject:obj];
        }
    } while (obj);
    
    return json;
}
@end


@interface AdsViewManager()
{
    UIView* view;
}
-(NSObject*)initYoumiwall:(AdJson*)json;
@end

static AdsViewManager* sAdsViewManager;
@implementation AdsViewManager
@synthesize configDict;
Impl_Singleton(AdsViewManager)

-(id)init
{
    if (self = [super init]) {
        configDict = [[NSDictionary alloc]init];
    }
    return self;
}
-(UIView*)getBannerView:(NSDictionary*)adsItem inViewController:(UIViewController*)controller
{
    //refer to AdsConfiguration.h for tag definition
    //mobisage banner
    //init view and set its value
    UIView* object = [self getMobisageBannerView:adsItem inViewController:controller];
    if (object) {
        return object;
    }
    return nil;
}
-(UIView*)getFullscreenView:(NSDictionary*)adsItem inViewController:(UIViewController*)controller
{
    //init view and set its value
    UIView* object = [self getAdSageFullScreenAdView:adsItem inViewController:controller];
    if (object) {
        return object;
    }
    return nil;
}
-(UIView*)getAdSageFullScreenAdView:(NSDictionary*)item inViewController:(UIViewController*)controller
{
    AdSageView* adView = nil;
    if (!item) {
        return adView;
    }
    
    //map view in configDict
    AdJson* json = [AdJson initWithDictionary:item];
    if (json && [kAdDisplay caseInsensitiveCompare:json.scene]==NSOrderedSame &&
        [kFullScreenAd caseInsensitiveCompare:json.type]==NSOrderedSame &&
        [kMobisage caseInsensitiveCompare:json.owner]==NSOrderedSame) {
        [[AdSageManager getInstance]setAdSageKey:[json.values objectAtIndex:0]];
        adView = [AdSageView requestAdSageFullScreenAdView:self]; //设置广告显示位置
    }
    return adView;
}

-(UIView*)getMobisageBannerView:(NSDictionary*)item inViewController:(UIViewController*)controller
{
    AdSageView* adView = nil;
    if (!item) {
        return adView;
    }
    
    //map view in configDict
    AdJson* json = [AdJson initWithDictionary:item];
    if (json && [kAdDisplay caseInsensitiveCompare:json.scene]==NSOrderedSame &&
        [kBanner caseInsensitiveCompare:json.type]==NSOrderedSame &&
        [kMobisage caseInsensitiveCompare:json.owner]==NSOrderedSame) {
        [[AdSageManager getInstance]setAdSageKey:[json.values objectAtIndex:0]];
            adView = [AdSageView requestAdSageBannerAdView:self sizeType:AdSageBannerAdViewSize_320X50]; //设置广告显示位置
            adView.frame = CGRectMake(0, 0, 320, 50);           
    }
    return adView;
}

-(BOOL)initRecommendWall:(NSDictionary*)item
{
    if (!item) {
        return NO;
    }
    
    //map view in configDict
    AdJson* json = [AdJson initWithDictionary:item];
    if (json && [kAdDisplay caseInsensitiveCompare:json.scene]==NSOrderedSame &&
        [kRecommendWall caseInsensitiveCompare:json.type]==NSOrderedSame) {
        if (json.view) {
            return YES;
        }
        else
        {
            //init view and set its value
            NSObject* object = [self initMobisageRecommendWall:json];
            if (object) {
                [item setValue:object forKey:kAdView];
                return YES;
            }
            
            object = [self initWQRecommendWall:json];
            if (object) {
                [item setValue:object forKey:kAdView];
                return YES;
            }
            
        }
    }
    return NO;
}
-(void)showRecommendWall:(NSDictionary*)item
{
    if (item) {
        if ([self showMobisageRecommendWall:item]) {
            return;
        }
        if ([self showWQRecommendWall:item]) {
            return;
        }
    }
}

-(BOOL)initOfferwall:(NSDictionary*)item
{
    if (!item) {
        return NO;
    }
    //map view in configDict
    AdJson* json = [AdJson initWithDictionary:item];
    if (json && [kAdDisplay caseInsensitiveCompare:json.scene]==NSOrderedSame &&
        [kOfferWall caseInsensitiveCompare:json.type]==NSOrderedSame) {
        if (json.view) {
            return YES;
        }
        else
        {
            //init view and set its value
            NSObject* object = [self initYoumiwall:json];
            if (object) {
                [item setValue:object forKey:kAdView];
                return YES;
            }
        }
    }
    return NO;
}

-(void)showOfferWall:(NSDictionary*)item
{
    if (item) {
        if ([self showYoumiWall:item]) {
            return;
        }
    }
}

#pragma utils method
-(NSObject*)initYoumiwall:(AdJson*)json
{
    id obj = nil;
    if (!json) {
        return obj;
    }
    
    if ([json.owner caseInsensitiveCompare:kYoumi]==NSOrderedSame) {
        if ([json.values count]==kYoumiOfferwallValueCount) {
            obj = [YoumiOfferWall shareInstance:(NSString*)[json.values objectAtIndex:0] appKey:(NSString*)[json.values objectAtIndex:1] reward:YES];
        }
    }
    return obj;
}
-(BOOL)showYoumiWall:(NSDictionary*)item
{
    AdJson* json = [AdJson initWithDictionary:item];
    if (json && [json.owner caseInsensitiveCompare:kYoumi]==NSOrderedSame)
    {
        id obj = [item valueForKey:kAdView];
        YoumiOfferWall* wall = (YoumiOfferWall*)obj;
        [wall showOffer:YES];
        return YES;
    }
    return NO;
}
-(NSObject*)initWQRecommendWall:(AdJson*)json
{
    return nil;
//    NSObject* obj = nil;
//    if (!json) {
//        return obj;
//    }
//    
//    if ([json.owner caseInsensitiveCompare:kWQmobile]==NSOrderedSame) {
//        if ([json.values count]==kWQMobileRecommendWallValueCount) {
//            WQAdView* recmdView = (WQAdView*)json.view;
//            if(!recmdView)
//            {
//                recmdView = [[[WQAdView alloc]init:NO]autorelease];
//                [recmdView setFrame:CGRectMake([[json.values objectAtIndex:2]intValue], [[json.values objectAtIndex:3]intValue], 50, 50)];
//            }
//            obj = recmdView;
//        }
//    }
//    return obj;
}
-(BOOL)showWQRecommendWall:(NSDictionary*)item
{
    AdJson* json = [AdJson initWithDictionary:item];
    if (json && [json.owner caseInsensitiveCompare:kWQmobile]==NSOrderedSame)
    {
        UIViewController* controller = [[[UIApplication sharedApplication]keyWindow]rootViewController];
        [WQAdView openAdWallWithAdSlotId:[json.values objectAtIndex:0] accountKey:[json.values objectAtIndex:1] inViewController:controller];
//        id obj = [item valueForKey:kAdView];
//        WQAdView* recmdView = (WQAdView*)obj;
//        if(recmdView)
//        {
//
//            [recmdView startWithAdSlotID:[json.values objectAtIndex:0] AccountKey:[json.values objectAtIndex:1] InViewController:controller];
//            [controller.view addSubview:recmdView];        
//            
//        }
        return YES;
    }
    return NO;
}

-(NSObject*)initMobisageRecommendWall:(AdJson*)json
{
    NSObject* obj = nil;
    if (!json) {
        return obj;
    }
    
    if ([json.owner caseInsensitiveCompare:kMobisage]==NSOrderedSame) {
        if ([json.values count]==kMobisageRecommendWallValueCount) {
            [[AdSageManager getInstance]setAdSageKey:[json.values objectAtIndex:0]];
            
            MobiSageRecommendView* recmdView = (MobiSageRecommendView*)json.view;            
            if (recmdView == nil)
            {               
                const NSUInteger size = 24;//mobisage recommend default view size
                recmdView = [[MobiSageRecommendView alloc]initWithDelegate:self andImg:nil];
                recmdView.frame = CGRectMake(0, size/2, size, size);
            }
            obj = recmdView;
        }
    }
    return obj;
}
-(BOOL)showMobisageRecommendWall:(NSDictionary*)item
{
    AdJson* json = [AdJson initWithDictionary:item];
    if (json && [json.owner caseInsensitiveCompare:kMobisage]==NSOrderedSame)
    {
        id obj = [item valueForKey:kAdView];
        MobiSageRecommendView* recmdView = (MobiSageRecommendView*)obj;
        [recmdView OpenAdSageRecmdModalView];
        return YES;
    }
    return NO;
}

#pragma mobisage delegate

- (void) adSageWillOpenRecommendModalView
{
    NSLog(@"推荐弹出");
}

- (void) adSageFailToOpenRecommendModalView
{
    NSLog(@"推荐弹出失败");
}

- (void) adSageDidCloseRecommendModalView
{
    NSLog(@"推荐关闭");
    
}

/**
 *  嵌入应用推荐界面对象中实现Delegate
 */
- (UIViewController *)viewControllerForPresentingModalView
{
    return [[[UIApplication sharedApplication]keyWindow]rootViewController];

}

@end


