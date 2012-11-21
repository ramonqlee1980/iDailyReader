//
//  AdsConfig.m
//  HappyLife
//
//  Created by ramon lee on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdsConfig.h"
#import "XPathQuery.h"
#import "AppDelegate.h"

#define kAdsValid @"1"


static AdsConfig * sSharedInstance;
@interface AdsConfig()

- (NSString *)getAdsValidity:(const NSUInteger)index;

-(NSString *)getAdsName:(const NSUInteger)index;

-(NSString*)getNodeContent:(const NSUInteger)index firstContent:(BOOL) first;
-(NSString*)getNodeContent:(NSUInteger)index Offset:(NSUInteger) offset;
@end

@implementation AdsConfig
@synthesize mData,mCurrentIndex;

-(BOOL)wallShouldShow
{
    if(self.mData!=nil && [self getAdsCount]>0)
    {  
        NSString* bundleIdentifier = [[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString*)kCFBundleIdentifierKey];
        NSLog(@"bundleIdentifier:%@",bundleIdentifier);
        NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        for (NSUInteger i = 0; i < [self getAdsCount]; i++ ) {
            if(NSOrderedSame==[[self getAdsName:i] caseInsensitiveCompare:bundleIdentifier])
            {
                return NO==[[self getAdsTestVersion:i]isEqualToString:localVersion];
            }
        }
    }    
    return NO;
}

-(NSString*)wallShowString
{
    if(self.mData!=nil && self.mData.count>0)
    {
        NSString* bundleIdentifier = [[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString*)kCFBundleIdentifierKey];
        NSLog(@"bundleIdentifier:%@",bundleIdentifier);
        for (NSUInteger i = 0; i < self.mData.count; i++ ) {
            if(NSOrderedSame==[[self getAdsName:i] caseInsensitiveCompare:bundleIdentifier])
            {
                return [self getAdsValidity:i];
            }
        }
    }
    return NSLocalizedString(@"RemoveAdsContent", "");
}
/**
 return all ads walls
 */
-(NSArray*)getAdsWalls
{
    if(mAdsWalls)
    {
        return mAdsWalls;
    }
     NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    mAdsWalls = [[NSMutableArray alloc]initWithCapacity:2];
    if(self.mData!=nil && [self getAdsCount]>0)
    {  
        NSString* kAdsWallIdentifier = @"Wall";
        
        for (NSUInteger i = 0; i < [self getAdsCount]; i++ ) {
            NSString* name = [self getAdsName:i];
            NSRange r = [name rangeOfString:kAdsWallIdentifier];
            
            if(r.length>0 && NO==[[self getAdsTestVersion:i]isEqualToString:localVersion])
            {                
                [mAdsWalls addObject:name];
                NSLog(@"open wall:%@",name);
            }
        }
    }    
    return mAdsWalls;
}

-(void)dealloc
{
    [mData release];
    [super dealloc];
}

+(void)reset
{
    if(!sSharedInstance)
    {
        return;
    }
    [sSharedInstance release];
    sSharedInstance = nil;
//    [AdsConfig sharedAdsConfig];
}
+(AdsConfig*)sharedAdsConfig
{    
    if(!sSharedInstance)
    {
        sSharedInstance = [[AdsConfig alloc] init];
    };
    
    if (![sSharedInstance isInitialized]) {
        [sSharedInstance init:@""];
    }
    return sSharedInstance;
}
-(BOOL)isInitialized
{
    return mData!=nil && [mData count]>0;
}
//TODO::init with data 
-(void)init:(NSString*)path
{    
    if(path != nil && path.length>0)
    {
        NSData* responseData = [[NSData alloc] initWithContentsOfFile:path];
        //NSLog(@"%@",responseData);
        NSString *xpathQueryString = @"//channel/item/*"; 
        self.mData = (NSMutableArray*)PerformXMLXPathQuery(responseData, xpathQueryString);
        [responseData release];
    }
    
    //load local one
    if (self.mData == nil) {
        NSString* defaultConfig = [[NSBundle mainBundle] pathForResource:kDefaultAds ofType:@"xml"];
        
        NSData*  responseData = [[NSData alloc] initWithContentsOfFile:defaultConfig];
        NSString *xpathQueryString = @"//channel/item/*";
        if (mData!=nil) {
            [mData release];
        }
        self.mData = (NSMutableArray*)PerformXMLXPathQuery(responseData, xpathQueryString);
        [responseData release];
    }
    
    mCurrentIndex = 0;
}
-(NSString*)getFirstAd
{
    mCurrentIndex = 0;
    if (self.mData != nil) {
        return  [self getAdsName:mCurrentIndex];     
    }
    return @"";
}
-(NSString*)getLastAd
{
    mCurrentIndex = 0;
    if (self.mData != nil) {
        mCurrentIndex = [mData count] -1;
        return  [self getAdsName:mCurrentIndex];     
    }
    return @"";
}
-(NSInteger)getCurrentIndex
{
    return mCurrentIndex;
}
-(NSInteger)getAdsCount
{
    return (self.mData==nil)?0:[self.mData count]/kCountPerSection;
}
-(NSString*)toNextAd
{
    mCurrentIndex++;
    if (mCurrentIndex > [self getAdsCount]) {
        mCurrentIndex = 0;
    }
    return [self getCurrentAd];
}
-(NSString*)getCurrentAd
{
    if (self.mData != nil && mCurrentIndex < [mData count]) {
        return  [self getAdsName:mCurrentIndex];     
    }
    return @"";
}
-(BOOL)isCurrentAdsValid
{
    return [[self getAdsValidity:mCurrentIndex] isEqualToString:kAdsValid];
}

- (NSString *)getAdsValidity:(const NSUInteger)index
{
    return [self getNodeContent:index firstContent:NO];
}
// Retrieves the content of an XML node, such as the temperature, wind, 
// or humidity in the weather report. 
//
-(NSString *)getAdsName:(const NSUInteger)index
{    
    return [self getNodeContent:index firstContent:YES];
}
-(NSString *)getAdsTestVersion:(const NSUInteger)index
{    
    return [self getNodeContent:index Offset:2];
}
-(NSString*)getNodeContent:(NSUInteger)index Offset:(NSUInteger) offset
{
    NSString* result = @"";
    const NSUInteger plusCount = kCountPerSection;//count persection
    const NSUInteger contentIndex = index*plusCount+offset;
    if(contentIndex < [mData count])
    {
        NSDictionary* dict = [mData objectAtIndex:contentIndex];
        result = [dict objectForKey:@"nodeContent"];
    }
    return result;
}
-(NSString*)getNodeContent:(const NSUInteger)index firstContent:(BOOL) first
{
    NSString* result = @"";
    const NSUInteger plusCount = kCountPerSection;//count persection
    const NSUInteger contentIndex = index*plusCount+((YES==first)?0:1);
    if(contentIndex < [mData count])
    {
        NSDictionary* dict = [mData objectAtIndex:contentIndex];
        result = [dict objectForKey:@"nodeContent"];
    }
    return result;
}

+(BOOL) isAdsOff
{
    if([AppDelegate isPurchased])
    {
        return YES;
    }
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];
    
    //1.temp:valid date;
    //2.permanent:permanent
    NSString* switchVal = [defaultSetting stringForKey:kAdsSwitch];
    if(switchVal==nil || switchVal.length == 0)
    {
        return NO;
    }

    //permanent?
    //temp?
    //other as on
    if ([switchVal isEqualToString:kPermanent]) {
        return YES;
    }
    else
    {
        NSDateFormatter* dateFormater = [[[NSDateFormatter alloc]init]autorelease];
        [dateFormater setDateFormat:kDateFormatter];
        NSDate* today = [AdsConfig currentLocalDate];
        NSDate* validDate = [dateFormater dateFromString:switchVal];
        NSComparisonResult compare = [validDate compare:today];
        //after valid date
        return (compare == NSOrderedDescending);   
    }
    return NO;    
}
+(BOOL) isAdsOn
{
    return (![AdsConfig isAdsOff]); 
}

//type:
//1.temp:valid date;
//2.permanent:permanent

//ads on:@"" in this section
+(void) setAdsOn:(BOOL)enable type:(NSString*)type
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];   
    [defaultSetting setValue:enable?@"":type forKey:kAdsSwitch];
}

+(NSDate*)currentLocalDate
{    
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];  
    
    NSLog(@"%@", localeDate);
    return date;    
}
+(BOOL)neverCloseAds
{
    NSUserDefaults* defaultSetting = [NSUserDefaults standardUserDefaults];   
    
    //1.temp:valid date;
    //2.permanent:permanent
    NSString* switchVal = [defaultSetting stringForKey:kAdsSwitch];
    return (switchVal==nil || switchVal.length == 0);
}
@end
