#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>


#define WAPS_SDK_VERSION_NUMBER            @"1.1.1"

enum WapsConnectionType {
    WAPS_CONNECT_TYPE_CONNECT = 0,
    WAPS_CONNECT_TYPE_ALT_CONNECT,
    WAPS_CONNECT_TYPE_USER_ID,
    WAPS_CONNECT_TYPE_SDK_LESS,
    WAPS_CONNECT_TYPE_SCHEME_INFO,
};

@interface AppConnect : NSObject {
@private
    NSString *appID_;
    NSString *userID_;
    NSString *plugin_;
    NSMutableData *data_;
    int connectAttempts_;
    BOOL isInitialConnect_;
    int responseCode_;
    NSURLConnection *connectConnection_;
    NSURLConnection *userIDConnection_;
    NSURLConnection *SDKLessConnection_;
    NSString *appChannel_;
}

@property(nonatomic, copy) NSString *appID;
@property(nonatomic, copy) NSString *appChannel;
@property(nonatomic, copy) NSString *userID;
@property(nonatomic, copy) NSString *plugin;
@property(nonatomic, copy) NSMutableDictionary *configItems;
@property(assign) BOOL isInitialConnect;


+ (AppConnect *)getConnect:(NSString *)appID;

+ (AppConnect *)getConnect:(NSString *)appID pid:(NSString*)appChannel;

+ (AppConnect *)actionComplete:(NSString *)actionID;

+ (AppConnect *)sharedAppConnect;

+ (void)deviceNotificationReceived;

+ (NSString *)getAppID;

+ (NSString *)getUserID;

+ (NSMutableDictionary *)getConfigItems;

+ (BOOL *)isShowBannerAd;

+ (void)setIsShowBannerAd:(BOOL *)isShow;

- (void)connectWithType:(int)connectionType withParams:(NSDictionary *)params;

- (NSString *)getURLStringWithConnectionType:(int)connectionType;

- (void)initiateConnectionWithConnectionType:(int)connectionType requestString:(NSString *)requestString;

- (BOOL)isJailBroken;

+ (NSString *)isJailBrokenStr;

- (NSMutableDictionary *)genericParameters;

- (NSString *)createQueryStringFromDict:(NSDictionary *)paramDict;

+ (NSString *)createQueryStringFromDict:(NSDictionary *)paramDict;

- (NSString *)createQueryStringFromString:(NSString *)string;

+ (NSString *)createQueryStringFromString:(NSString *)string;

+ (void)clearCache;


+ (NSString *)getMACAddress;

+ (NSString *)getMACID;

+ (NSString *)getSHA1MacAddress;

+ (NSString *)getUniqueIdentifier;

+ (NSString *)getTimeStamp;

@end
#import "AppConnectConstants.h"