//
//  OAToken.h
//  OAuthHelper
//
//  Created by Ryou Zhang on 12/2/10.
//  Copyright 2010 appSage. All rights reserved.
//

@interface MSOAToken : NSObject
{
}
@property(retain)NSString *key, *secret, *pin;

-(id)initWithHTTPResponseBody:(NSString *)body;
@end
