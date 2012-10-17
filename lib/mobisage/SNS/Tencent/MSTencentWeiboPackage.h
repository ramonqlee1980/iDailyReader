//
//  TencentWeiboPackage.h
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/23/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//


@class MSOAToken;
@class MSOAConsumer;

#import "../../MobiSagePackage.h"

@interface MSTencentWeiboPackage : MobiSagePackage
{
@protected
    MSOAToken*              m_OAuthToken;
    MSOAConsumer*           m_OAuthConsumer;
    
    NSString*               m_UrlPath;
    NSString*               m_HttpMethod;
    
    NSMutableDictionary*    m_ParamDic;
}
-(id)initWithToken:(MSOAToken*)token Consumer:(MSOAConsumer*)consumer;

-(void)addParameter:(NSString*)name Value:(NSString*)value;

-(NSString*)generateOAuthParameter;

-(void)generateHTTPBody:(NSMutableURLRequest*)request;
@end
