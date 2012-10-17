//
//  SinaAccessToken.h
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/23/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

//对应sina的v2版本API oauth2/access_token
//OAuth2的access_token

#import "../MSSinaWeiboPackage.h"

@interface MSSinaAccessToken : MSSinaWeiboPackage
{
    
}
-(id)initWithAppKey:(NSString*)appKey Secret:(NSString*)appSecret;
@end
