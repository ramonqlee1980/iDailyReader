//
//  iOfferwall.h
//  com.idreems.mrh
//
//  Created by ramonqlee on 2/23/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//
//  实现积分墙的管理

#import <Foundation/Foundation.h>

@protocol iOfferwallDelegate

@required
/**
 *  open offer wall
 */
-(void)open;

-(void)setViewController:(UIViewController*)controller;

-(UIViewController*)viewController;

@end


@interface iOfferwallManager : NSObject
{
    UIViewController* _viewController;
}
@property (nonatomic, assign) UIViewController* viewController;

+ (iOfferwallManager *)sharedInstance;
-(void)open:(NSArray*)wallName;//right now,only one offer wall is supported,others will be ignored
-(void)close:(NSArray*)wallName;

@end
