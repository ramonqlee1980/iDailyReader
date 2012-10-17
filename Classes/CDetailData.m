//
//  CDetailData.m
//  AdvancedTableViewCells
//
//  Created by ramonqlee on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CDetailData.h"


@implementation CDetailData
@synthesize name;
@synthesize description;
@synthesize picture;

-(void) dealloc 
{ 
    [name release];
    [description release]; 
    [picture release];
    [super dealloc];
}
@end
