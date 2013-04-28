//
//  RMRunningAdConfig.m
//  HappyLife
//
//  Created by ramonqlee on 4/5/13.
//
//

#import "RMIndexedArray.h"

@interface RMIndexedArray()
@property(nonatomic,readonly)NSMutableArray* array;
@end

@implementation RMIndexedArray
@synthesize taggedIndex;
@synthesize array;

-(id)init
{
    if (self = [super init]) {
        array = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)addObject:(id)anObject
{
    if (anObject) {
        [array addObject:anObject];
    }
}
- (id)objectAtIndex:(NSUInteger)index
{
    return array?[array objectAtIndex:index]:nil;
}
-(NSInteger)count
{
    return array?[array count]:0;
}
@end
