//
//  YoumiWall.m
//  HappyLife
//
//  Created by ramonqlee on 3/31/13.
//
//

#import "YoumiOfferWall.h"
#import "YoumiWall.h"
#import "YouMiConfig.h"
#import "AdsConfig.h"

@interface YoumiOfferWall()
{
    YouMiWall* wall;
    BOOL didReceiveOffers;
    BOOL showOfferAfterReady;
    BOOL reward;
    id<YouMiOfferWallDelegate> delegate;
}
@property(nonatomic,retain)id<YouMiOfferWallDelegate> delegate;
@property(nonatomic)BOOL reward;
@end

static YoumiOfferWall* sYoumiOfferWall;
@implementation YoumiOfferWall
@synthesize delegate,reward;

+(YoumiOfferWall*)shareInstance:(NSString*)appId appKey:(NSString*)appKey reward:(BOOL)credit
{
    if (!sYoumiOfferWall) {
        sYoumiOfferWall = [[YoumiOfferWall alloc]init];
        [YouMiConfig setShouldGetLocation:NO];
        // 初始化信息
        [YouMiConfig launchWithAppID:appId appSecret:appKey];
    }
    [sYoumiOfferWall prepareWall:credit];
    return sYoumiOfferWall;
}

-(void)prepareWall:(BOOL)credit
{
    if(!wall)
    {
        wall = [[YouMiWall alloc] init];
        wall.delegate = self;
    }

    self.reward = credit;
    [wall requestOffers:credit];
}

-(BOOL)showOffer:(BOOL)credit
{
    if (!wall) {
        return NO;
    }
    if (didReceiveOffers) {
        reward = NO;
        return [wall showOffers];
    }
    reward = YES;
    [self prepareWall:credit];
    return NO;    
}

- (void)requestEarnedPoints:(id<YouMiOfferWallDelegate>)obj
{
    self.delegate = obj;
    if (wall) {
        [wall requestEarnedPoints];
    }
}
-(BOOL)spendPoints:(NSInteger)points
{
    NSInteger localPoints = [self localPoints];
    if (points >= localPoints) {
        [self setLocalPoints:localPoints-points];
        return YES;
    }
    return NO;
}


#pragma mark util method
#define kLocalYoumiwallPoints @"kLocalYoumiwallPoints"
-(NSInteger)localPoints
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    return [defaultSetting integerForKey:kLocalYoumiwallPoints];
}
-(void)setLocalPoints:(NSInteger)points
{
    if(points>=0)
    {
        NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
        [defaultSetting setInteger:points forKey:kLocalYoumiwallPoints];
    }
}
#pragma mark request delegate
// 请求应用列表成功
//
// 说明:
//      应用列表请求成功后回调该方法
//
- (void)didReceiveOffers:(YouMiWall *)adWall
{
    didReceiveOffers = YES;
    if(showOfferAfterReady)
    {
        [self showOffer:reward];
    }
}

// 请求应用列表失败
//
// 说明:
//      应用列表请求失败后回调该方法
//
- (void)didFailToReceiveOffers:(YouMiWall *)adWall error:(NSError *)error
{
    didReceiveOffers = NO;
}

// 查询积分情况成功
// @info 里面包含 [积分记录] 的 NSDictionary
//
// 说明:
//      积分查询请求成功后回调该方法
- (void)didReceiveEarnedPoints:(YouMiWall *)adWall info:(NSArray *)info
{
    //get all points
    if (info) {
        NSInteger pt = 0;
        for (NSDictionary* item in info) {
            id obj = [item objectForKey:kYouMiEarnedPointsPoinstsOpenKey];
            if ([obj isKindOfClass:[NSNumber class]]) {
                NSNumber *points = (NSNumber*)obj;
                pt += [points intValue];                             
            }
        }

        if(pt>0)
        {
            [self setLocalPoints:(pt+[self localPoints])];
        }
    }
    
    if (self.delegate) {
        [self.delegate didReceiveOffers:[self localPoints]];
    }
}

// 查询积分情况失败
//
// 说明:
//      积分查询请求失败后回调该方法
- (void)didFailToReceiveEarnedPoints:(YouMiWall *)adWall error:(NSError *)error
{
    if (self.delegate) {
        [self.delegate didFailToReceiveOffers:[self localPoints] error:error];
    }
}

@end
