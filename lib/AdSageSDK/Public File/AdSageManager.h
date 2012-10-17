//
//  AdSageManager.h
//  AdSageSDK
//
//  Created by  on 12-2-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
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
