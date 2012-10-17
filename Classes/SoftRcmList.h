//
//  SoftRcmList.h
//  Sample
//
//  Created by xiaolin liu on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SoftInfo;

@interface SoftRcmList : NSObject<NSXMLParserDelegate>
{
    NSMutableArray *softList;
    SoftInfo *_softInfo;
    NSString *_elmName;
}

@property (nonatomic, retain) NSMutableArray * softList;
@property (nonatomic, copy) NSString *elmName;


-(BOOL) loadData:(NSString*) xmlName;

@end
