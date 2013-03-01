//
//  MobiSageOfferwall.h
//  com.idreems.mrh
//
//  Created by ramonqlee on 2/24/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iOfferwallManager.h"

@interface MobiSageOfferwall : NSObject<iOfferwallDelegate>

+ (MobiSageOfferwall *)sharedInstance;
@end
