//
//  XmlModelBas.h
//  HappyLife
//
//  Created by ramonqlee on 10/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XmlModelBase : NSObject {    
    NSArray *data;//in a autorelease pool,so retain objects in it to prevent autoreleased before this object
    NSUInteger xmlPerSegElementNumber;
}

@property (nonatomic, retain) NSArray* data;

- (id)initWithResource:(NSString *)fileName;
//:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath;

-(NSString *)getTitle:(const NSUInteger)index;
-(NSString *)getContent:(const NSUInteger)index;
-(NSString*)getNodeContent:(const NSString*)nodeName andIndex:(const NSUInteger)index;
-(NSUInteger)getCount;

//for NSArray,reasons above-mentioned
-(void) retainAllSubObjects;
-(void) releaseAllSubObjects;

+(NSUInteger)getPerSegElementNumber:(NSArray*)data;
@end