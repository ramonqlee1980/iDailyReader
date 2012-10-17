#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>


typedef enum {
    WapsNotReachable = 0,
    WapsReachableViaWiFi,
    WapsReachableViaWWAN,
} WapsNetworkStatus;
#define kWapsReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"

@interface WapsNetReachability : NSObject {
    BOOL localWiFiRef;
    SCNetworkReachabilityRef reachabilityRef;
}

+ (WapsNetReachability *)reachabilityWithHostName:(NSString *)hostName;

+ (WapsNetReachability *)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;

+ (WapsNetReachability *)reachabilityForInternetConnection;

+ (WapsNetReachability *)reachabilityForLocalWiFi;

+ (NSString *)getReachibilityType;

+ (BOOL)isUsingWifi;

+ (BOOL)isUsingInternet;


- (BOOL)startNotifier;

- (void)stopNotifier;

- (WapsNetworkStatus)currentReachabilityStatus;

- (BOOL)connectionRequired;

@end
