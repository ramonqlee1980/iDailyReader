//
//  Response.h
//  com.idreems.mrh
//
//  Created by ramonqlee on 2/3/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseJson : NSObject
{
    NSString* description;
    NSString* thumbnailUrl;
    NSString* largeUrl;
}
@property(nonatomic,retain) NSString* description;
@property(nonatomic,retain) NSString* thumbnailUrl;
@property(nonatomic,retain) NSString* largeUrl;

- (ResponseJson*)initWithJsonDictionary:(NSDictionary*)dict;

+ (ResponseJson*)statusWithJsonDictionary:(NSDictionary*)dict;

@end
