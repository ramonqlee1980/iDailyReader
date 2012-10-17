//
//  PointsManager.h
//  HappyLife
//
//  Created by ramon lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointsManager : NSObject

+(void)SavePoints:(NSInteger) points;//get new points and save them
+(void)CostPoints:(NSInteger) points;
+(NSInteger)GetPoints;
+(BOOL)NewUser;

@end
