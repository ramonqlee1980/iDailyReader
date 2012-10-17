//
//  SoftInfo.m
//  Sample
//
//  Created by xiaolin liu on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SoftInfo.h"

@implementation SoftInfo

@synthesize name = _name;
@synthesize detail = _detail;
@synthesize url = _url;
@synthesize icon = _icon;

-(void) dealloc
{
    [_name release];
    [_detail release];
    [_url release];
    [_icon release];
    [super dealloc];
}
@end
