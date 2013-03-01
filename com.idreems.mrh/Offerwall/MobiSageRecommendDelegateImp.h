//
//  MobiSageRecommendDelegateImp.h
//  com.idreems.mrh
//
//  Created by ramonqlee on 2/24/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobiSageRecommendSDK.h"

@interface MobiSageRecommendDelegateImp : NSObject<MobiSageRecommendDelegate>
{
    UIViewController* _viewControllerForPresentingModalView;
}
@property(nonatomic,assign)UIViewController* viewControllerForPresentingModalView;
@end
