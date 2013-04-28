//
//  RMIndexedArray.h
//  HappyLife
//
//  Created by ramonqlee on 4/5/13.
//
//

#import <Foundation/Foundation.h>

@interface RMIndexedArray:NSObject

@property(nonatomic,assign)NSInteger taggedIndex;

-(id)init;
-(NSInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (void)addObject:(id)anObject;
@end
