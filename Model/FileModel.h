//
//  MusicModel.h
//  Hayate
//
//  Created by 韩 国翔 on 11-12-2.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface FileModel : NSObject {
    
}

@property(nonatomic,retain)NSString *fileName;
@property(nonatomic,retain)NSString *fileURL;
@property(nonatomic,retain)NSString *destPath;
@property(nonatomic,retain)NSString *notificationName;

@property(nonatomic,retain) NSString* author;
@property(nonatomic,retain) NSString* summary;
@property(nonatomic,retain) NSString* category;
@property(nonatomic,retain) NSString* icon;
@property(nonatomic,retain) NSString* subcategory;
@property(nonatomic,retain) NSMutableArray* pages;
@property(nonatomic,retain) NSMutableArray* pageSize;
@property(nonatomic,retain)NSString *fileID;
@property(nonatomic,retain)NSString *fileType;
@property(nonatomic,retain)NSString *fileSize;
@property(nonatomic)BOOL isFistReceived;//是否是第一次接受数据，如果是则不累加第一次返回的数据长度，之后变累加
@property(nonatomic,retain)NSString *fileReceivedSize;
@property(nonatomic,retain)NSMutableData *fileReceivedData;//接受的数据
@property(nonatomic)BOOL isDownloading;//是否正在下载
@property(nonatomic)BOOL isP2P;//是否是p2p下载
@property(nonatomic)BOOL encrypt;//是否encrypt

@end
