//
//  CoinsManager.m
//  HappyLife
//
//  Created by ramonqlee on 3/31/13.
//
//

#import "CoinsManager.h"
static CoinsManager* sCoinsManager;

#define kCoinsManagerAccount @"kCoinsManagerAccount"

@implementation CoinsManager
+(CoinsManager*)sharedInstance
{
    if (!sCoinsManager) {
        sCoinsManager = [[CoinsManager alloc]init];
    }
    return sCoinsManager;
}
-(NSInteger)getLeftCoins
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    return [defaultSetting integerForKey:kCoinsManagerAccount];    
}
#define kTrialPremium @"kTrialPremium"
+(BOOL)trialed
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    return [defaultSetting boolForKey:kTrialPremium];
}
+(void)setTrialed:(BOOL)trial
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    [defaultSetting setBool:trial forKey:kTrialPremium];

}
-(void)addCoins:(NSInteger)account
{
    if(account<=0)
    {
        return;
    }
    NSInteger c = [self getLeftCoins];
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    [defaultSetting setInteger:(c+account) forKey:kCoinsManagerAccount];
}
-(BOOL)spendCoins:(NSInteger)account
{
    NSInteger c = [self getLeftCoins];
    if (c>=account) {
        NSInteger left = c-account;
        if (left<0) {
            left = 0;
        }
        NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
        [defaultSetting setInteger:left forKey:kCoinsManagerAccount];
        return YES;
    }
    return NO;
}
@end
