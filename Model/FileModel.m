//
//  MusicModel.m
//  Hayate
//
//  Created by 韩 国翔 on 11-12-2.
//  Copyright 2011年 山东海天软件学院. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel
@synthesize fileID;
@synthesize fileName;
@synthesize fileType;
@synthesize fileSize;
@synthesize isFistReceived;
@synthesize fileReceivedData;
@synthesize fileReceivedSize;
@synthesize fileURL;
@synthesize isDownloading;
@synthesize isP2P;
@synthesize destPath;
@synthesize summary;
@synthesize category;
@synthesize subcategory;
@synthesize pages;
@synthesize pageSize;
@synthesize author;
@synthesize icon;
@synthesize notificationName;
@synthesize encrypt;

-(void)dealloc
{
    [notificationName release];
    [author release];
    [summary release];
    [category release];
    [subcategory release];
    [pages release];
    [pageSize release];
    
    [fileID release];
    [fileName release];
    [fileType release];
    [fileSize release];
    [fileReceivedSize release];
    [fileReceivedData release];//接受的数据
    [fileURL release];
    [destPath release];
    [icon release];
    [super dealloc];
}
@end
