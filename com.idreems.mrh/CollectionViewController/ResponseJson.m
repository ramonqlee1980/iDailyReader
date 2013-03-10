//
//  Response.m
//  com.idreems.mrh
//
//  Created by ramonqlee on 2/3/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import "ResponseJson.h"
#import "NSDictionaryAdditions.h"

@implementation ResponseJson
@synthesize description;
@synthesize thumbnailUrl;
@synthesize largeUrl;

-(BOOL)isEqual:(id)object
{
    if(!object)
    {
        return NO;
    }
    ResponseJson* cmp = (ResponseJson*)object;
    if(0==[self.description length])
    {
        return [self.thumbnailUrl isEqualToString:cmp.thumbnailUrl];
    }
    else
    {
        return [self.description isEqualToString:cmp.description];
    }
}
- (ResponseJson*)initWithJsonDictionary:(NSDictionary*)dict
{
    if (self = [super init]) {
		self.description = [dict getStringValueForKey:@"description" defaultValue:@""];
        self.thumbnailUrl = [dict getStringValueForKey:@"thumbnailUrl" defaultValue:@""];
        self.largeUrl = [dict getStringValueForKey:@"largeUrl" defaultValue:@""];
    }
    return self;
}

+ (ResponseJson*)statusWithJsonDictionary:(NSDictionary*)dict
{
    return [[[ResponseJson alloc]initWithJsonDictionary:dict]autorelease];
}


-(void)dealloc
{
    self.description = nil;
    self.thumbnailUrl = nil;
    self.largeUrl = nil;
    [super dealloc];
}
@end
