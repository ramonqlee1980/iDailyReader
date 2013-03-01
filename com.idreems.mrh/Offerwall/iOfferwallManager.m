//
//  iOfferwall.m
//  com.idreems.mrh
//
//  Created by ramonqlee on 2/23/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import "iOfferwallManager.h"
#import "MobiSageOfferwall.h"


@implementation iOfferwallManager
@synthesize viewController=_viewController;

+ (iOfferwallManager *)sharedInstance
{
    static iOfferwallManager *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [[iOfferwallManager alloc] init];
    }
    return sharedInstance;
}
-(void)open:(NSArray*)wallNames
{
    if (!wallNames || [wallNames count]==0) {
        return;
    }
    //
//    NSString* wallName = [wallNames objectAtIndex:0];
    id<iOfferwallDelegate> offerwall = [MobiSageOfferwall sharedInstance];
//    if (NSOrderedSame==[AdsPlatformMobisage compare:wallName options:NSCaseInsensitiveSearch]) {
        [offerwall setViewController:self.viewController];
//    }
    [offerwall open];
    
}
-(void)close:(NSArray*)wallName
{
    
}



@end
