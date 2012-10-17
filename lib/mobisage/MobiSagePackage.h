//
//  MobiSagePackage.h
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/18/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#define MobiSagePackage_Finish  @"MobiSagePackage_Finish"

@interface MobiSagePackage : NSObject
{
@package
    NSString*   packageGUID;
    NSUInteger  statusCode;
    id          resultData;
    NSString*   errorText;
}

-(NSMutableURLRequest*)createURLRequest;
@end
