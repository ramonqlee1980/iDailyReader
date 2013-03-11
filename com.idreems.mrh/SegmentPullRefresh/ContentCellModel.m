//
//  QiuShi.m
//  NetDemo
//
//  Created by 海锋 周  on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentCellModel.h"
#import "NSString+HTML.h"

@implementation ContentCellModel
@synthesize imageMidURL;
@synthesize imageURL;
@synthesize published_at;
@synthesize tag;
@synthesize qiushiID;
@synthesize content;
@synthesize commentsCount;
@synthesize downCount,upCount;
@synthesize anchor;

-(id)initWithWordPressDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.content = [dictionary objectForKey:@"content"];
        if([self.content respondsToSelector:@selector(stringByConvertingHTMLToPlainText)])
        {
            self.content = [self.content stringByConvertingHTMLToPlainText];
        }
        
        NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* date = [formatter dateFromString:[dictionary objectForKey:@"modified"]];
        
        NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
        NSDate* newDate = (NSDate*)[date dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:date]];
        
        self.published_at = [newDate timeIntervalSince1970];
        self.commentsCount = [[dictionary objectForKey:@"comments_count"] intValue];
    }
    return self;
}
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.tag = [dictionary objectForKey:@"tag"];
        self.qiushiID = [dictionary objectForKey:@"id"];
#ifdef kIdreemsServerEnabled
        self.content = [dictionary objectForKey:@"description"];
#else
        self.content = [dictionary objectForKey:@"content"];
#endif//#ifdef kIdreemsServerEnabled
        self.published_at = [[dictionary objectForKey:@"published_at"] doubleValue];
        self.commentsCount = [[dictionary objectForKey:@"comments_count"] intValue];
        
        id image = [dictionary objectForKey:@"image"];
        if ((NSNull *)image != [NSNull null])
        {
#ifdef kIdreemsServerEnabled
            self.imageURL = [dictionary objectForKey:@"thumbnailUrl"];
            self.imageMidURL = [dictionary objectForKey:@"largeUrl"];
#else
            self.imageURL = [dictionary objectForKey:@"image"];
            
            NSRange range = NSRangeFromString(@"0,4");
            NSString* rangeId = [qiushiID substringWithRange:range];
            NSString *newImageURL = [NSString stringWithFormat:@"http://img.qiushibaike.com/system/pictures/%@/%@/small/%@",rangeId,qiushiID,imageURL];
            NSString *newImageMidURL = [NSString stringWithFormat:@"http://img.qiushibaike.com/system/pictures/%@/%@/medium/%@",rangeId,qiushiID,imageURL];
            self.imageURL = newImageURL;
            self.imageMidURL = newImageMidURL;
#endif
        }
        
        NSDictionary *vote = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"votes"]];
        self.downCount = [[vote objectForKey:@"down"]intValue];
        self.upCount = [[vote objectForKey:@"up"]intValue];
        
        id user = [dictionary objectForKey:@"user"];
        if ((NSNull *)user != [NSNull null])
        {
            NSDictionary *user = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"user"]];
            self.anchor = [user objectForKey:@"login"];
        }
        
    }
    return self;
}

- (void)dealloc {
    self.imageURL = nil;
    self.tag = nil;
    self.qiushiID = nil;
    self.content = nil;
    self.anchor = nil;
    [super dealloc];
}




@end
