#import <UIKit/UIKit.h>
#import "MobiSageSDK.h"
#import "AdsConfig.h"
#import "YouMiWall.h"
#import "AppDelegate.h"
#import "WapsOffer/AppConnect.h"
//#import "MiidiManager.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
    
    [[MobiSageManager getInstance] setPublisherID:kMobiSageID_iPhone];
    //NSLog(@"MobisagePulisherID: %@",[MobiSageManager getInstance]->m_publisherID);
    //disable youmi wall gps
    [YouMiWall setShouldGetLocation:NO];
    [YouMiWall setShouldCacheImage:YES];
    
    
    //注意:这里必须填写您的App_ID. 您可以从www.waps.cn注册后获取,pid为渠道编号,比如@"appstore",@"91"
	//[AppConnect getConnect:@"1bf390a13d540df7bf72418498dfe503" pid:@"appstore"];
    [AppConnect getConnect:kWapsId]; //不指定pid
    
    //
	// 设置发布应用的应用id, 应用密码等信息,必须在应用启动的时候呼叫
	// 参数 appID		:开发者应用ID ;     开发者到 www.miidi.net 上提交应用时候,获取id和密码
	// 参数 appPassword	:开发者的安全密钥 ;  开发者到 www.miidi.net 上提交应用时候,获取id和密码
	// 参数 testMode		:广告条请求模式 ;    正式发布应用,务必设置为NO,否则不能计费
	//
	//[MiidiManager setAppPublisher:@"6990"  withAppSecret:@"cc4hjf45qwrsi9rc" withTestMode: NO];

    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    [pool release];
    return retVal;
}