//
//  AdsConfig.h
//  HappyLife
//
//  Created by ramon lee on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define HealthSecretsForGirls//美女保健小贴士
//#define MHealth
//#define Foods
//#define LosingWeight
//#define careerGuide//职场秘笈
//#define RaisingKids //育儿指南
//#define TodayinHistory//史上今日
//#define Makeup//美容秘笈
//#define MakeToast//场面话之祝酒词
//#define TraditionalChineseMedicine //中医小窍门
//#define SpouseTalks
//#define Humer//搞笑集锦
//#define EnglishPrefix//英语前缀
//#define EnglishSuffix//英语词根

//in-app purchase
#ifndef kInAppPurchaseProductName
#define kInAppPurchaseProductName @"com.idreems.maketoast.inapp"
#endif

#define kAdsConfigUpdated @"kAdsConfigUpdated"

#define kNewContentScale 5
#define kMinNewContentCount 3

#define kWeiboMaxLength 140
#define kAdsSwitch @"AdsSwitch"
#define kPermanent @"Permanent"
#define kDateFormatter @"yyyy-MM-dd"

//for notification
#define kAdsUpdateDidFinishLoading @"AdsUpdateDidFinishLoading"
#define  kUpdateTableView @"UpdateTableView"

#define kOneDay (24*60*60)
#define kTrialDays  1

//flurry event
#define kFlurryRemoveTempConfirm @"kRemoveTempConfirm"
#define kFlurryRemoveTempCancel  @"kRemoveTempCancel"
#define kEnterMainViewList       @"kEnterMainViewList"
#define kFlurryOpenRemoveAdsList @"kOpenRemoveAdsList"

#define kFlurryDidSelectApp2RemoveAds @"kDidSelectApp2RemoveAds"
#define kFlurryRemoveAdsSuccessfully  @"kRemoveAdsSuccessfully"
#define kDidShowFeaturedAppNoCredit   @"kDidShowFeaturedAppNoCredit"

#define kShareByWeibo @"kShareByWeibo"
#define kShareByEmail @"kShareByEmail"

#define kEnterBylocalNotification @"kEnterBylocalNotification"
#define kDidShowFeaturedAppCredit @"kDidShowFeaturedAppCredit"

#define kFlurryDidSelectAppFromRecommend @"kFlurryDidSelectAppFromRecommend"
#define kFlurryDidSelectAppFromMainList  @"kFlurryDidSelectAppFromMainList"
#define kFlurryDidReviewContentFromMainList  @"kFlurryDidReviewContentFromMainList"
#define kLoadRecommendAdsWall @"kLoadRecommendAdsWall"
//favorite
#define kEnterNewFavorite @"kEnterNewFavorite"
#define kOpenExistFavorite @"kOpenExistFavorite"
#define kQiushiReviewed @"kQiushiReviewed"
#define kQiushiRefreshed @"kQiushiRefreshed"
#define kReviewCloseAdPlan @"kReviewCloseAdPlan"
#define kOpenYoumiWall @"openYoumiWall"
#define TrialPoints @"TrialPoints"
#define GetCoins @"GetCoins"

//weixin
#define kFlurryConfirmOpenWeixinInAppstore @"kConfirmOpenWeixinInAppstore"
#define kFlurryCancelOpenWeixinInAppstore @"kCancelOpenWeixinInAppstore"
#define kShareByWeixin @"kShareByWeixin"
#define kShareByShareKit @"kShareByShareKit"

#define kCountPerSection 3
#ifndef kMobiSageIDOther_iPhone
#define kMobiSageIDOther_iPhone kMobiSageID_iPhone
#endif

