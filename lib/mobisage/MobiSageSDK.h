//
//  MobiSageSDK.h
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/25/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//  Version 2.3.0

#define Track_Server_System_Launching            @"In"                      // 程序启动
#define Track_Server_System_Teminating           @"Out"                     // 程序退出


#pragma Banner_Size_List
#define Ad_480X40                               1   //ipad
#define Ad_320X270                              2   //ipad
#define Ad_748X110                              4   //ipad
#define Ad_256X192                              11  //ipad
#define Ad_748X60                               12  //ipad
#define Ad_120X480                              13  //ipad
#define Ad_210X177                              14  //ipad
#define Ad_48X48                                15  //iphone & ipad
#define Ad_320X40                               16  //iphone
#define Ad_No_Banner                            25  //iphone & ipad

#pragma Poster_Size_List
#define Poster_1024X748                         17  //ipad
#define Poster_320X460                          19  //iphone
#define Poster_320X320                          22  //iphone
#define Poster_768X768                          24  //ipad


typedef enum SYSTEM_EVENT_ENUM
{
    CustomerEvent         = 0,      //    0 非系统事件，即用户事件
    AppLaunchingEvent     = 1,      //    1 程序启动事件
    AppTerminatingEvent   = 2,      //    2 程序退出事件
}SystemEventEnum;

#define MobiSageAdView_Start_Show_AD    @"MobiSageAdView_Start_Show_AD"
#define MobiSageAdView_Refresh_AD       @"MobiSageAdView_Refresh_AD"
#define MobiSageAdView_Pause_Show_AD    @"MobiSageAdView_Pause_Show_AD"

#define MobiSageAdView_Pop_AD_Window    @"MobiSageAdView_Pop_AD_Window"
#define MobiSageAdView_Hide_AD_Window   @"MobiSageAdView_Hide_AD_Window"

typedef enum
{
    Random      = 1,
    Fade        = 2,
    FlipL2R     = 3,
    FlipT2B     = 4,
    CubeT2B     = 5,
    CubeL2R     = 6,
    Ripple      = 7,
    PageCurl    = 8,
    PageUnCurl  = 9,
} MobiSageAnimeType;


typedef enum
{
    Ad_NO_Refresh = 0,
    Ad_Refresh_15 = 1,
    Ad_Refresh_20 = 2,
    Ad_Refresh_25 = 3,
    Ad_Refresh_30 = 4,
    Ad_Refresh_60 = 5,
}MSAdRefreshInterval;

@class MobiSagePackage;

@interface MobiSageAdNoBanner : NSObject
{
    
}
-(id)init;
-(id)initWithPublisherID:(NSString *)publisherID;
-(void)setInterval:(MSAdRefreshInterval)interval;
-(void)setKeyword:(NSString*)keyword;
-(void)setCustomData:(NSString*)customData;
-(void)popADView;
@end

@interface MobiSageAdBanner : UIView
{

}
-(id)initWithAdSize:(NSUInteger)adSize;
-(id)initWithAdSize:(NSUInteger)adSize PublisherID:(NSString *)publisherID;

-(void)setInterval:(MSAdRefreshInterval)interval;
-(void)setSwitchAnimeType:(MobiSageAnimeType)switchAnimeType;
-(void)setKeyword:(NSString*)keyword;
-(void)setCustomData:(NSString*)customData;
@end

@interface MobiSageAdPoster : UIView
{
    
}
-(id)initWithAdSize:(NSUInteger)adSize;
-(id)initWithAdSize:(NSUInteger)adSize PublisherID:(NSString *)publisherID;

-(void)setKeyword:(NSString*)keyword;
-(void)setCustomData:(NSString*)customData;

-(void)startRequestAD;
@end


@interface MobiSageManager : NSObject
{
@package
    NSString*   m_publisherID;
}
+(MobiSageManager*)getInstance;

-(void)setPublisherID:(NSString*)publisherID;
-(void)setDeployChannel:(NSString*)deployChannel;

-(void)trackSystemEvent:(SystemEventEnum)event; 
-(void)trackSystemEvent:(SystemEventEnum)event WithObject:(NSString*)object; 
-(void)trackCustomerEvent:(NSString*)event WithObject:(NSString*)object; 

-(void)pushMobiSagePackage:(MobiSagePackage*)package;
-(void)pushMobiSagePackageArray:(NSArray *)packageArray;
-(void)cancelMobiSagePackage:(MobiSagePackage*)package;
-(void)cancelMobiSagePackageArray:(NSArray*)packageArray;
@end;

@interface MobiSageBaiduBar : UISearchBar<UISearchBarDelegate>
{
}
@end