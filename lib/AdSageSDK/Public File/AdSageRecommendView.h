//
//  AdSageRecommendView.h
//  AdSageSDK
//
//  Created by 苹果 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    AdSageRecommendColorTypeBlack       = 0,
    AdSageRecommendColorTypeWhite       = 1,
    AdSageRecommendColorTypeRed         = 2,
    AdSageRecommendColorTypeOrange      = 3,
    AdSageRecommendColorTypeYellow      = 4,
    AdSageRecommendColorTypeGreen       = 5,
    AdSageRecommendColorTypeBlue        = 6,
    AdSageRecommendColorTypeCyan        = 7,
    AdSageRecommendColorTypePurple      = 8,
} AdSageRecommendColorType;

UIImage *(*getImageAdSageRecommend)(int color);
UIImage *(*getImageAdSageBadge)(int type);

@protocol AdSageRecommendDelegate;
@interface AdSageRecommendView : UIView

+ (AdSageRecommendView *)requestWithDelegate:(id<AdSageRecommendDelegate>)delegate color:(AdSageRecommendColorType)color;

@end
