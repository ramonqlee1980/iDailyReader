//
//  CoinsManager.h
//  HappyLife
//
//  Created by ramonqlee on 3/31/13.
//
//

#import <Foundation/Foundation.h>

#define kCoinsPerUse 2

@interface CoinsManager : NSObject
+(CoinsManager*)sharedInstance;
-(NSInteger)getLeftCoins;
-(void)addCoins:(NSInteger)account;
-(BOOL)spendCoins:(NSInteger)account;

+(BOOL)trialed;
+(void)setTrialed:(BOOL)trial;
@end
