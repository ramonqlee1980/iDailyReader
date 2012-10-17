//
//  SinaAuthorize.h
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/23/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

//对应sina的v2版本API oauth2/authorize
//OAuth2的authorize接口

#import "../MSSinaWeiboPackage.h"

@interface MSSinaAuthorize : MSSinaWeiboPackage
{
    
}
-(id)initWithAppKey:(NSString*)appKey;
@end
