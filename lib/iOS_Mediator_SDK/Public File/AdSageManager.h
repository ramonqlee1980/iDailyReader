//
//  AdSageManager.h
//  AdSageSDK
//
//  Created by sdk team on 2013/03/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//  SDK Aggregation Version 2.1.7
//

#import <Foundation/Foundation.h>

@interface AdSageManager : NSObject

+ (AdSageManager *)getInstance;

- (void)setAdSageKey:(NSString *)adSageKey;

/**
 * Called by Adapters
 */
- (void)registerClass:(Class)adapterClass;

@end
