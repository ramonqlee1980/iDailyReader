//
//  SoftInfo.h
//  Sample
//
//  Created by xiaolin liu on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoftInfo : NSObject
{
    NSString *_name;
    NSString *_detail;
    NSString *_icon;
    NSString *_url;
}

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* detail;
@property (nonatomic, copy) NSString* icon;
@property (nonatomic, copy) NSString* url;

@end
