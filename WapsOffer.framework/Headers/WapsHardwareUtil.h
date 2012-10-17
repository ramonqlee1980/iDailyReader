#import <UIKit/UIKit.h>


// Platforms
// iFPGA	 ->	??
// iPhone1,1 ->	iPhone 1G
// iPhone1,2 ->	iPhone 3G
// iPhone2,1 ->	iPhone 3GS
// iPhone3,1 ->	iPhone 4/AT&T
// iPhone3,2 ->	iPhone 4/Other Carrier?
// iPhone3,3 ->	iPhone 4/Other Carrier?
// iPhone4,1 ->	??iPhone 5
// iPod1,1   -> iPod touch 1G 
// iPod2,1   -> iPod touch 2G 
// iPod2,2   -> ??iPod touch 2.5G
// iPod3,1   -> iPod touch 3G
// iPod4,1   -> iPod touch 4G
// iPod5,1   -> ??iPod touch 5G
// iPad1,1   -> iPad 1G, WiFi
// iPad1,?   -> iPad 1G, 3G <- needs 3G owner to test
// iPad2,1   -> iPad 2G (iProd 2,1)

// i386, x86_64 -> iPhone Simulator
typedef enum UIDevicePlatform {
    UIDeviceUnknown,
    UIDeviceiPhoneSimulator,
    UIDeviceiPhoneSimulatoriPhone, // both regular and iPhone 4 devices
    UIDeviceiPhoneSimulatoriPad,
    UIDevice1GiPhone,
    UIDevice3GiPhone,
    UIDevice3GSiPhone,
    UIDevice4iPhone,
    UIDevice5iPhone,
    UIDevice1GiPod,
    UIDevice2GiPod,
    UIDevice3GiPod,
    UIDevice4GiPod,
    UIDevice1GiPad, // both regular and 3G
    UIDevice2GiPad,
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceIFPGA,
    UIDeviceMAX,
} UIDevicePlatform;

@interface UIDevice (Hardware)

- (NSString *)platform;

- (NSString *)hwmodel;

- (NSUInteger)platformType;

- (NSString *)platformString;

- (NSString *)platformCode;

- (NSUInteger)cpuFrequency;

- (NSUInteger)busFrequency;

- (NSUInteger)totalMemory;

- (NSUInteger)userMemory;

- (NSNumber *)totalDiskSpace;

- (NSNumber *)freeDiskSpace;

@end
