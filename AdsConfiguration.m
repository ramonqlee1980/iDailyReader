//
//  AdsConfiguration.m
//  HappyLife
//
//  Created by ramonqlee on 4/4/13.
//
//

#import "AdsConfiguration.h"
#import "AdsViewManager.h"
#import "RMIndexedArray.h"
#import "CoinsManager.h"

#define kAdsOnTag @"adson"
#define kAdsListTag @"adslist"

#define kAdsOnValue @"on"

@interface AdsConfiguration()
{
    NSMutableArray* adsArray;
}
@property(nonatomic,retain)NSMutableArray* adsArray;
@property(nonatomic,assign)BOOL adsOn;
-(void)initAdViewManager;
@end

@implementation AdsConfiguration
@synthesize adsArray,adsOn;

Impl_Singleton(AdsConfiguration)

-(void)dealloc
{
    self.adsArray = nil;
    [super dealloc];
}
-(id)init
{
    if(self = [super init])
    {
        self.adsArray = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)initWithFile:(NSString*)fileName
{
    NSData* data = [NSData dataWithContentsOfFile:fileName];
    [self initWithJson:data];
}

-(void)initWithJson:(NSData*)data
{
    if (data) {
        NSError* error;
        id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (res && [res isKindOfClass:[NSDictionary class]]) {
            NSObject* on = [res objectForKey:kAdsOnTag];
            adsOn = (on && [on isKindOfClass:[NSString class]] && NSOrderedSame==[kAdsOnValue caseInsensitiveCompare:(NSString*)on]);
            //            if (adsOn)
            {
                NSArray* arr = [res objectForKey:kAdsListTag];
                
                if (arr && [arr count]) {
                    [self.adsArray removeAllObjects];
                    [self.adsArray addObjectsFromArray:arr];
                    NSLog(@"get ads list");
                    [self initAdViewManager];
                }
            }
        } else {
            //NSLog(@"arr dataSourceDidError == %@",arrayData);
        }
    }
}

-(NSInteger)getCount
{
    return (adsArray!=nil)?[adsArray count]:0;
}

-(NSDictionary*)getItem:(NSInteger)index
{
    if (adsArray) {
        return [adsArray objectAtIndex:index];
    }
    return nil;
}

-(RMIndexedArray*)getScenedItems:(NSString*)scene withType:(NSString*)type
{
    RMIndexedArray* ret = [[[RMIndexedArray alloc]init]autorelease];
    if (!scene) {
        return ret;
    }
    
    if (([kAdDisplay caseInsensitiveCompare:scene]==NSOrderedSame && !adsOn) ||
        [[CoinsManager sharedInstance]getLeftCoins]>0) {
        return ret;
    }
    
    for (NSDictionary* item in self.adsArray) {
        if (item && [item objectForKey:kVisibility]) {
            id obj = [item objectForKey:kSceneTag];
            BOOL identified = NO;
            if (obj && [obj isKindOfClass:[NSString class]] && [scene caseInsensitiveCompare:obj]==NSOrderedSame) {
                
                if (type && type.length>0) {
                    obj = [item objectForKey:kTypeTag];
                    identified = (obj && [obj isKindOfClass:[NSString class]] && [type caseInsensitiveCompare:obj]==NSOrderedSame);
                }
                else
                {
                    identified = YES;
                }
            }
            
            if (identified) {
                [ret addObject:item];
            }
        }
    }
    return ret;
}

#pragma util methods
-(void)initAdViewManager
{
    AdsViewManager* adViewManager = [AdsViewManager sharedInstance];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    if ([[CoinsManager sharedInstance]getLeftCoins]<=0) {
        //banner
        RMIndexedArray* list = [self getScenedItems:kAdDisplay withType:kBanner];
        if (list && [list count]) {
            [dict setValue:list forKey:kBanner];
        }
        //offerwall
        list = [self getScenedItems:kAdDisplay withType:kOfferWall];
        if (list && [list count]) {
            [dict setValue:list forKey:kOfferWall];
        }
        //recommendwall
        list = [self getScenedItems:kAdDisplay withType:kRecommendWall];
        if (list && [list count]) {
            [dict setValue:list forKey:kRecommendWall];
        }
        
        list = [self getScenedItems:kAdDisplay withType:kFullScreenAd];
        if (list && [list count]) {
            [dict setValue:list forKey:kFullScreenAd];
        }
    }
    
    adViewManager.configDict = dict;
}
-(AdsViewManager*)getAdsViewManager
{
    return [AdsViewManager sharedInstance];
}

-(NSString*)appOnlineTag
{
    static NSString* postTag = @"";
    
    if(postTag && postTag.length>0)
    {
        return postTag;
    }
    AdsConfiguration* config = [AdsConfiguration sharedInstance];
    if ([config getCount]>0) {
        RMIndexedArray* arr = [config getScenedItems:kPostBlog withType:@""];
        if (arr && [arr count]>0) {
            NSDictionary* dict = [arr objectAtIndex:0];
            postTag = [dict objectForKey:[NSString stringWithFormat:kValueSeriesX,1]];
        }
    }
    return postTag;
}

-(NSInteger)appleId
{
    static NSInteger appleId = kInvalidID;
    
    if(appleId!=kInvalidID)
    {
        return appleId;
    }
    AdsConfiguration* config = [AdsConfiguration sharedInstance];
    if ([config getCount]>0) {
        RMIndexedArray* arr = [config getScenedItems:kSoftUpdate withType:@""];
        if (arr && [arr count]>0) {
            NSDictionary* dict = [arr objectAtIndex:0];
            id appId = [dict objectForKey:[NSString stringWithFormat:kValueSeriesX,1]];
            if (appId) {
                appleId = [appId integerValue];
            }
        }
    }
    return appleId;
}

-(NSString*)wechatId
{
    static NSString* wechatId = @"";
    
    if(wechatId && wechatId.length>0)
    {
        return wechatId;
    }
    AdsConfiguration* config = [AdsConfiguration sharedInstance];
    if ([config getCount]>0) {
        RMIndexedArray* arr = [config getScenedItems:kSNSShare withType:@""];
        if (arr && [arr count]>0) {
            for (NSInteger i =0; i< [arr count];++i) {
                NSDictionary* dict = [arr objectAtIndex:i];
                NSString* owner = [dict objectForKey:kOwerTag];
                if (owner && [kWechatId caseInsensitiveCompare:owner]==NSOrderedSame) {
                    wechatId = [dict objectForKey:[NSString stringWithFormat:kValueSeriesX,1]];
                    break;
                }
            }
            
        }
    }
    return wechatId;
}
-(NSString*)FlurryId
{
    static NSString* flurryId = @"";
    
    if(flurryId && flurryId.length>0)
    {
        return flurryId;
    }
    AdsConfiguration* config = [AdsConfiguration sharedInstance];
    if ([config getCount]>0) {
        RMIndexedArray* arr = [config getScenedItems:kStatistics withType:@""];
        if (arr && [arr count]>0) {
            NSDictionary* dict = [arr objectAtIndex:0];
            flurryId = [dict objectForKey:[NSString stringWithFormat:kValueSeriesX,1]];
            
        }
    }
    return flurryId;
}
-(NSString*)mobisageId
{
    static NSString* mobisageId = @"";
    if (mobisageId && mobisageId.length>0) {
        return mobisageId;
    }
    RMIndexedArray* arr = [self getScenedItems:kAdDisplay withType:kRecommendWall];
    for (NSInteger i = 0; i< [arr count]; ++i) {
        NSDictionary* dict = [arr objectAtIndex:i];
        NSString* owner = [dict objectForKey:kOwerTag];
        if ([kMobisage caseInsensitiveCompare:owner]==NSOrderedSame) {
            mobisageId = [dict objectForKey:[NSString stringWithFormat:kValueSeriesX,1]];
        }
    }
    return mobisageId;
}
-(NSString*)youmiAppId
{
    static NSString* youmiAppId = @"";
    if (youmiAppId && youmiAppId.length>0) {
        return youmiAppId;
    }
    RMIndexedArray* arr = [self getScenedItems:kAdDisplay withType:kOfferWall];
    for (NSInteger i = 0; i< [arr count]; ++i) {
        NSDictionary* dict = [arr objectAtIndex:i];
        NSString* owner = [dict objectForKey:kOwerTag];
        if ([kYoumi caseInsensitiveCompare:owner]==NSOrderedSame) {
            youmiAppId = [dict objectForKey:[NSString stringWithFormat:kValueSeriesX,1]];
        }
    }
    return youmiAppId;
}
-(NSString*)youmiSecret
{
    static NSString* youmiSecret = @"";
    if (youmiSecret && youmiSecret.length>0) {
        return youmiSecret;
    }
    RMIndexedArray* arr = [self getScenedItems:kAdDisplay withType:kOfferWall];
    for (NSInteger i = 0; i< [arr count]; ++i) {
        NSDictionary* dict = [arr objectAtIndex:i];
        NSString* owner = [dict objectForKey:kOwerTag];
        if ([kYoumi caseInsensitiveCompare:owner]==NSOrderedSame) {
            youmiSecret = [dict objectForKey:[NSString stringWithFormat:kValueSeriesX,2]];
        }
    }
    return youmiSecret;
}
@end
