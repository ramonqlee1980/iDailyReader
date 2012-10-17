//
//  MobiSageResourcePackage.h
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/30/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

@class MobiSagePackage;

@interface MobiSageResourcePackage : MobiSagePackage
{
@package
    NSString*   sourceURL;
    NSString*   targetPath;
    NSString*   tempPath;
}
@end