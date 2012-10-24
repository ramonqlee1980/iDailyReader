//
//  MobiSageSDK.h
//  MobiSageSDK
//
//  Created by sdk team on 12/08/10.
//  Copyright (c) 2012 adsage. All rights reserved.
//  Version 4.0.0




#pragma mark - 当前版本支持的广告尺寸
#pragma mark 

#define Ad_320X50                               38    //iphone 使用的横幅广告尺寸

#define Ad_300X250                              40    //ipad 使用的横幅广告尺寸
#define Ad_468X60                               41    //ipad 使用的横幅广告尺寸
#define Ad_728X90                               42    //ipad 使用的横幅广告尺寸


#define Poster_320X320                          22    //iphone 使用的半屏广告尺寸
#define Poster_320X460                          19    //iphone 使用的全屏广告尺寸

#define Poster_768X768                          24    //ipad 使用的半屏广告尺寸
#define Poster_1024X748                         17    //ipad 使用的全屏广告尺寸





#pragma mark - 宏定义
#pragma mark 

#define Track_Server_System_Launching            @"In"                      // 程序启动
#define Track_Server_System_Teminating           @"Out"                     // 程序退出

#define MobiSageAdView_Start_Show_AD             @"MobiSageAdView_Start_Show_AD"     //    广告展示通知
#define MobiSageAdView_Refresh_AD                @"MobiSageAdView_Refresh_AD"        //    广告刷新通知
#define MobiSageAdView_Pause_Show_AD             @"MobiSageAdView_Pause_Show_AD"     //    广告暂停通知

#define MobiSageAdView_Pop_AD_Window             @"MobiSageAdView_Pop_AD_Window"     //    广告窗口弹出通知
#define MobiSageAdView_Hide_AD_Window            @"MobiSageAdView_Hide_AD_Window"    //    广告窗口隐藏通知

#define MobiSageAdView_Click_AD                  @"MobiSageAdView_Click_AD"          //    广告点击事件通知
#define MobiSageAction_Error                     @"MobiSageAction_Error"             //    广告错误事件通知


#pragma mark - 枚举变量


/*系统事件*/
#ifndef SYSTEM_EVENT_ENUM
#define SYSTEM_EVENT_ENUM
typedef enum SYSTEM_EVENT_ENUM
{
    CustomerEvent         = 0,      //    0 非系统事件，即用户事件
    AppLaunchingEvent     = 1,      //    1 程序启动事件
    AppTerminatingEvent   = 2      //    2 程序退出事件
    
}SystemEventEnum;

#endif
/*广告切换动画枚举*/
typedef enum
{
    Random      = 1,        //    随机
    Fade        = 2,        //    淡入淡出
    FlipL2R     = 3,        //    水平翻转从左到右
    FlipT2B     = 4,        //    水平翻转从上到下
    CubeT2B     = 5,        //    立体翻转从左到右
    CubeL2R     = 6,        //    立体翻转从上到下
    Ripple      = 7,        //    水波纹效果
    PageCurl    = 8,        //    翻页效果从下到上
    PageUnCurl  = 9        //    翻页效果从上到下
    
} MobiSageAnimeType;        //    广告切换动画效果

/*广告刷新周期枚举*/
typedef enum
{
    Ad_NO_Refresh = 0,        //    不轮显
    Ad_Refresh_15 = 1,        //    15秒
    Ad_Refresh_20 = 2,        //    20秒
    Ad_Refresh_25 = 3,        //    25秒
    Ad_Refresh_30 = 4,        //    30秒
    Ad_Refresh_60 = 5        //    60秒
    
}MSAdRefreshInterval;         //    广告自动轮显时间


#pragma mark - 类文件申明
#pragma mark
#define MobiSagePackage_Finish  @"MobiSagePackage_Finish"

@interface MobiSagePackage : NSObject
{
    @package
    NSString*   packageGUID;
    NSUInteger  statusCode;
    id          resultData;
    NSString*   errorText;
}

-(NSMutableURLRequest*)createURLRequest;
@end

/**
 *  资源文件包,使用方式见示例工程
 */
@interface MobiSageResourcePackage : NSObject
{
    
}



/**    
 *  构造一个资源包  
 *  @param strURL	资源包的网络路径
 *  @param strLocalPath	资源包的本地路径
 */
- (id)initWithNetPath:(NSString *)strURL localPath:(NSString *)strLocalPath;

/**    
 *  构造一个资源包  
 *  @param strURL	资源包的网络路径
 *  @param strLocalPath	资源包的本地路径
 *  @param strCachePath	资源包的本地临时缓存路径
 */
- (id)initWithNetPath:(NSString *)strURL localPath:(NSString *)strLocalPath localCachePath:(NSString *)strCachePath;

@end

#ifndef _MobiSageManager_
#define _MobiSageManager_

@interface MobiSageManager : NSObject {
    
}

/**    
 *  获得MobiSage平台管理单例
 */
+(MobiSageManager*)getInstance;


/**    
 *  设置publisherID  
 *  @param publisherID	AC平台分配给应用的id
 */
-(void)setPublisherID:(NSString *)publisherID;

/**    
 *  设置应用分发渠道 
 *  @param deployChannel	分发渠道名称 
 */
-(void)setDeployChannel:(NSString *)deployChannel;

/**    
 *  反馈应用系统事件，  
 *  @param event	事件类型    
 *  @note    例如应用进入后台或退出或重新回到前台等事件
 */
-(void)trackSystemEvent:(SystemEventEnum)event;

/**    
 *  反馈应用系统事件，  
 *  @param event	事件类型
 *  @param object	开发者自定义的附加反馈信息 
 *  @note    例如应用进入后台或退出或重新回到前台等事件
 */
-(void)trackSystemEvent:(SystemEventEnum)event WithObject:(NSString *)object; 

/**    
 *  返回开发者自定义事件  
 *  @param event	事件类型
 *  @param object	开发者自定义的附加反馈信息
 */
-(void)trackCustomerEvent:(NSString *)event WithObject:(NSString *)object; 


/**    
 *  从网络获取数据包
 *  @param package	请求信息包    
 *  @note    从网络获取数据包：例如图片、音乐等    
 */
-(void)pushMobiSagePackage:(MobiSageResourcePackage *)package;

/**    
 *  从网络获取多个数据包，比如图片、音乐等  
 *  @param packageArray	请求信息包数组,元素为MobiSageResourcePackage类的实例  
 *  @note    从网络获取数据包：例如图片、音乐等  
 */
-(void)pushMobiSagePackageArray:(NSArray *)packageArray;

/**    
 *  取消或停止从网络获取数据包  
 *  @param package	请求信息包  
 *  @note    从网络获取数据包：例如图片、音乐等      
 */
-(void)cancelMobiSagePackage:(MobiSageResourcePackage *)package;

/**    
 *  取消或停止多个从网络获取数据包
 *  @param packageArray 请求信息包数组,元素为MobiSageResourcePackage类的实例    
 *  @note    从网络获取数据包：例如图片、音乐等   
 */
-(void)cancelMobiSagePackageArray:(NSArray *)packageArray;

@end

#endif
@interface MobiSageAdBanner : UIView {
    
}
/**    
 *  初始化，并设置广告尺寸  
 *  @param adSize 广告视图大小  
 */
-(id)initWithAdSize:(NSUInteger)adSize;

/**    
 *  初始化，并设置广告尺寸和publisherID  
 *  @param adSize 广告视图大小
 *  @param publisherID AC平台分配的应用发布ID
 */
-(id)initWithAdSize:(NSUInteger)adSize PublisherID:(NSString *)publisherID;

/**    
 *  设置广告刷新间隔时间  
 *  @param interval 广告刷新间隔时间，单位是“秒” 
 */
-(void)setInterval:(MSAdRefreshInterval)interval;

/**    
 *  设置多个广告之间过渡（切换）效果 
 *  @param switchAnimeType	多个广告之间过渡（切换）效果  
 */
-(void)setSwitchAnimeType:(MobiSageAnimeType)switchAnimeType;

/**    
 *  设置应用展示广告的关键字，期望多展示与关键字相关的广告
 *  @param keyword 关键字
 */
-(void)setKeyword:(NSString *)keyword;

/**    
 *  设置开发者自定义数据
 *  @param customData 开发者自定义数据 
 */
-(void)setCustomData:(NSString *)customData;

@end


@interface MobiSageAdNoBanner : NSObject {
    
}

-(id)init;

/**    
 *  初始化，并设置广告尺寸和publisherID
 *  @param publisherID	AC平台分配的应用发布ID
 */
-(id)initWithPublisherID:(NSString *)publisherID;

/**    
 *  设置广告刷新间隔时间  
 *  @param interval 广告刷新间隔时间，单位是“秒” 
 */
-(void)setInterval:(MSAdRefreshInterval)interval;

/**    
 *  设置应用展示广告的关键字，期望多展示与关键字相关的广告
 *  @param keyword 关键字
 */
-(void)setKeyword:(NSString *)keyword;

/**    
 *  设置开发者自定义数据
 *  @param customData 开发者自定义数据 
 */
-(void)setCustomData:(NSString *)customData;

/**    
 *  弹出广告页面   
 */
-(void)popADView;

@end



@interface MobiSageAdPoster : UIView {
    
}

/**    
 *  初始化，并设置广告尺寸  
 *  @param adSize 广告视图大小  
 */
-(id)initWithAdSize:(NSUInteger)adSize;

/**    
 *  初始化，并设置广告尺寸和publisherID  
 *  @param adSize 广告视图大小
 *  @param publisherID AC平台分配的应用发布ID
 */
-(id)initWithAdSize:(NSUInteger)adSize PublisherID:(NSString *)publisherID;

/**    
 *  设置应用展示广告的关键字，期望多展示与关键字相关的广告
 *  @param keyword 关键字
 */
-(void)setKeyword:(NSString *)keyword;

/**    
 *  设置开发者自定义数据
 *  @param customData 开发者自定义数据 
 */
-(void)setCustomData:(NSString *)customData;

/**    
 *  请求广告并展示广告   
 */
-(void)startRequestAD;
@end


/**
 *  文字链广告
 *  可以自定义任意尺寸、背景色、文字颜色、字体等
 */
@interface MobiSageAdWordBanner : UIView {
    
    
}

/**
 *  字体尺寸访问器
 */
@property(nonatomic,assign) NSInteger fontSize;
/**
 *  字体颜色访问器
 */
@property(nonatomic,retain) UIColor *textColor;
/**
 *  背景色访问器
 */
@property(nonatomic,retain) UIColor *backgroundColor;
/**
 *  HTML格式字体颜色访问器,例如#ff0000，或则rgba(0,0,255,1.0)
 */
@property(nonatomic, copy) NSString *textColorForHtml;
/**
 *  HTML格式背景色访问器,例如#ff0000，或则rgba(0,255,0,1.0)
 */
@property(nonatomic, copy) NSString *backgroundColorForHtml;

 /**    
 *  使用指定frame、publisherID初始化广告
 *  @param frame 广告 VIEW 的frame
 *  @param publisherID 该广告所使用的publisherID
 *  @note publisherID可以和默认publisherID不同
 */
-(id)initWithFrame:(CGRect)frame publisherID:(NSString *)publisherID;

/**    
 *  使用指定参数初始化广告
 *  @param frame 广告 VIEW 的frame
 *  @param iFontSize 字体大小
 *  @param strTextColor HTML格式的字体颜色
 *  @param strBackgroundColor HTML格式的背景色
 *  @note 该方法可使用HTML中的颜色格式
 */
-(id)initWithFrame:(CGRect)frame fontSize:(NSInteger)iFontSize textColorForHtml:(NSString *)strTextColor backgroundColorForHtml:(NSString *)strBackgroundColor;


/**    
 *  使用指定参数初始化广告
 *  @param frame 广告 VIEW 的frame
 *  @param publisherID可以和默认publisherID不同
 *  @param iFontSize 字体大小
 *  @param strTextColor HTML格式的字体颜色
 *  @param strBackgroundColor HTML格式的背景色
 *  @note 该方法可使用HTML中的颜色格式，使用指定的publisherID
 */
-(id)initWithFrame:(CGRect)frame publisherId:(NSString *)publisherID fontSize:(NSInteger)iFontSize textColorForHtml:(NSString *)strTextColor backgroundColorForHtml:(NSString *)strBackgroundColor;

/**    
 *  使用指定参数初始化广告
 *  @param frame 广告 VIEW 的frame
 *  @param iFontSize 字体大小
 *  @param textColor 字体颜色
 *  @param backgroundcolor 背景色
 *  @note 该方法可使用iOS程序员熟悉的颜色格式
 */
-(id)initWithFrame:(CGRect)frame fontSize:(NSInteger)iFontSize textColor:(UIColor *) textColor backgroundColor:(UIColor *)backgroundcolor;

/**    
 *  使用指定参数初始化广告
 *  @param frame 广告 VIEW 的frame
 *  @param publisherID可以和默认publisherID不同
 *  @param iFontSize 字体大小
 *  @param textColor 字体颜色
 *  @param backgroundcolor 背景色
 *  @note 该方法可使用iOS程序员熟悉的颜色格式
 */
-(id)initWithFrame:(CGRect)frame publisherId:(NSString *)publisherID fontSize:(NSInteger)iFontSize textColor:(UIColor *) textColor backgroundColor:(UIColor *)backgroundcolor;

@end


/**
 *  百度搜索栏
 */
@interface MobiSageBaiduBar : UISearchBar<UISearchBarDelegate> {
    
}
@end







