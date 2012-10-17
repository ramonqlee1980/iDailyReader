//
//  PointsManager.m
//  HappyLife
//
//  Created by ramon lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PointsManager.h"
#import "Constants.h"


@implementation PointsManager
+(void)SavePoints:(NSInteger)pt
{
    if (pt<=0) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:[PointsManager GetPoints]+pt forKey:kYouMiPointsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)CostPoints:(NSInteger) pt
{    
    NSInteger point = [PointsManager GetPoints];
    point -= pt;
    
    if(point<=0)
    {
        point =0;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:point forKey:kYouMiPointsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSInteger)GetPoints
{
    //for new user,award certain points
    if ([PointsManager NewUser]) {
        [PointsManager SavePoints:AWARD_NEWUSER_POINTS];
    }
    // enable the pro features
    return [[NSUserDefaults standardUserDefaults] integerForKey:kYouMiPointsKey];
    
}

+(BOOL)NewUser
{
    NSInteger userCount = [[NSUserDefaults standardUserDefaults] integerForKey:kNewUser];
    if (userCount==0) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kNewUser];
    }
    return userCount==0;
}
@end
