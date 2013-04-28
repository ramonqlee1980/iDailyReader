//
//  HTTPHelper.h
//  HappyLife
//
//  Created by ramonqlee on 4/5/13.
//
//

#import <Foundation/Foundation.h>
#import "CommonHelper.h"
@class FileModel;

@interface HTTPHelper : NSObject


Decl_Singleton(HTTPHelper)

-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown setAllowResumeForFileDownloads:(BOOL)allow;
-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown;

-(void)beginPostRequest:(NSString*)url withDictionary:(NSDictionary*)postData;
@end
