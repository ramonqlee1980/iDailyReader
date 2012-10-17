//
//  XmlModelBas.m
//  HappyLife
//
//  Created by ramonqlee on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XmlModelBase.h"
#import "XPathQuery.h"//another xml parser wrapper

static const NSString* kTitle = @"title";
static const NSString* kLink = @"link";

@implementation XmlModelBase

@synthesize data;

-(id)initWithResource:(NSString *)fileName
{
    return nil;    
}
-(void)retainAllSubObjects
{
    if (data) {
        for (NSInteger i = 0; i < [data count]; ++i) {
            NSDictionary* dict = [data objectAtIndex:i];
            NSLog(@"obj retainCount:%d",[dict retainCount]);
            [dict retain];
        }
    }
}
-(void) releaseAllSubObjects
{
    if (data) {
        for (NSInteger i = 0; i < [data count]; ++i) {
            NSDictionary* dict = [data objectAtIndex:i];
            NSLog(@"obj retainCount:%d",[dict retainCount]);
            [dict release];
        }
    }
}
-(NSUInteger)getCount
{
    NSLog(@"retainCount:%d",[data retainCount]);
    return [data count]/xmlPerSegElementNumber;
}
- (NSString *)getContent:(const NSUInteger)index
{
    return [self getNodeContent:kLink andIndex:index];
}
// Retrieves the content of an XML node, such as the temperature, wind, 
// or humidity in the weather report. 
//
-(NSString *)getTitle:(const NSUInteger)index
{    
    return [self getNodeContent:kTitle andIndex:index];
}
-(NSString*)getNodeContent:(const NSString*)nodeName andIndex:(const NSUInteger)index
{
    NSDictionary* dict = nil;
    NSUInteger i = 0;
    NSString* result = @"";
    if([nodeName length]>0 )
    {
        NSUInteger baseIndex = xmlPerSegElementNumber*index;
        for (i = baseIndex; i < baseIndex+xmlPerSegElementNumber; ++i) 
        {
            dict = [self.data objectAtIndex:i];
            if(YES == [nodeName isEqualToString:[dict objectForKey:@"nodeName"]])
            {
                result = [dict objectForKey:@"nodeContent"];
                break;
            }
        }
    }
    return result;
}
+(NSUInteger)getPerSegElementNumber:(NSArray*)_data
{
    //interate to get the -(NSUInteger)getPerSegElementNumber
    //1.only 1 kTitle, getPerSegElementNumber
    //2.multiple kTitle
    NSString* firstName = nil;
    NSDictionary* dict = nil;
    NSUInteger i = 0;
    for (i = 0; i < [_data count]; ++i) 
    {
       dict = [_data objectAtIndex:i];
        if (nil == firstName) {
            firstName= [dict objectForKey:@"nodeName"];
        }
        else
        {
            if(YES == [firstName isEqualToString:[dict objectForKey:@"nodeName"]])
            {
                break;
            }
        }
    }
    
    //only one node found        
    return i;
}

- (void)dealloc
{
    //iterate array to release retain owership
    [self releaseAllSubObjects];
    self.data = nil;   
    [super dealloc];
}

@end

