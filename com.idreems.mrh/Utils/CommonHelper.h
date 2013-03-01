//
//  CommonHelper.h
//  Hayate
//
//  Created by 韩 国翔 on 11-12-2.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RJSingleBook;
@class CoreDataMgr;
@class FileModel;

@interface CommonHelper : NSObject {
    
}


////将字节转化成M单位，不附带M
//+(NSString *)transformToM:(NSString *)size;
////将不M的字符串转化成字节
//+(float)transformToBytes:(NSString *)size;
//将文件大小转化成M单位或者B单位
+(NSString *)getFileSizeString:(NSString *)size;
+(NSString *)getFileSizeStringWithFileName:(NSString *)fileName;
//经文件大小转化成不带单位ied数字
+(float)getFileSizeNumber:(NSString *)size;

+(void)makesureDirExist:(NSString*)directory;

+(NSString *)getDocumentPath;
+(NSString *)getTargetFolderPath;//得到实际文件存储文件夹的路径
+(NSString *)getTempFolderPath;//得到临时文件存储文件夹的路径
+(NSString*) getTargetBookPath:(NSString*)bookName;//得到当前书籍的保存目录
+(BOOL)isExistFile:(NSString *)fileName;//检查文件名是否存在

//传入文件总大小和当前大小，得到文件的下载进度
+(CGFloat) getProgress:(float)totalSize currentSize:(float)currentSize;

//extract packaged file to desFile
//zip,rar are supported right now
+(void)extractFile:(NSString*)srcFile toFile:(NSString*)desFilePath fileType:(NSString*)fileType;

+(NSStringEncoding)dataEncoding:(const Byte*) header;

+(BOOL)CompareVersionFromOldVersion : (NSString *)oldVersion
                         newVersion : (NSString *)newVersion;
+(id)performSelector:(NSObject*)obj selector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;
+ (UIViewController *)getCurrentRootViewController;
+(NSString*)appStoreUrl;
@end
