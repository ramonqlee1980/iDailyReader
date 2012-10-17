#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface WapsUtil : NSObject {

}


+ (NSString *)revertUrl:(NSString *)url;

+ (NSString *)escapeUrl:(NSString *)url;

+ (NSString *)stringByDecodingURLFormat:(NSString *)string;

+ (BOOL)caseInsenstiveCompare:(NSString *)str1 AndString2:(NSString *)str2;


+ (NSData *)dataWithBase64EncodedString:(NSString *)string;


+ (id)initWithBase64EncodedString:(NSString *)string;


+ (NSMutableDictionary*)getQueryStringParams:(NSString *)queryString;

+ (NSMutableData *)getQueryStringParamsFroNSData:(NSString *)queryString;

+(NSString*)getSchemeURL:(NSString *)schemeString;

+(NSString*)getSchemeID:(NSString *)schemeString;

+(NSString*)getSchemeName:(NSString *)schemeString;

+ (BOOL)isPad;

+ (NSString *)getShortScheme:(NSString *)schemeString;


@end
