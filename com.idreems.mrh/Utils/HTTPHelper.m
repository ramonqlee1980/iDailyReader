//
//  HTTPHelper.m
//  HappyLife
//
//  Created by ramonqlee on 4/5/13.
//
//

#import "HTTPHelper.h"
#import "FileModel.h"
#import "ASIFormDataRequest.h"
#import "CommonHelper.h"
#import "Constants.h"

#define kMaxConcurrentOperationCount 1

@interface HTTPHelper()

@property(nonatomic,retain)NSOperationQueue* mOperationQueue;
@property(nonatomic,retain)NSMutableArray *finishedlist;//已下载完成的文件列表（文件对象）
@property(nonatomic,retain)NSMutableArray *downinglist;//正在下载的文件列表(ASIHttpRequest对象)
@end
@implementation HTTPHelper
@synthesize downinglist;
@synthesize finishedlist;
@synthesize mOperationQueue;

#pragma mark
Impl_Singleton(HTTPHelper)

-(id)init
{
    if (self = [super init]) {
        downinglist = [[NSMutableArray alloc]init];
        finishedlist = [[NSMutableArray alloc]init];
        mOperationQueue = [[NSOperationQueue alloc]init];
    }
    return self;
}

-(void)beginPostRequest:(NSString*)url withDictionary:(NSDictionary*)postData
{
    if (!url || url.length==0) {
        return;
    }
    NSString* tempUrl = ([url rangeOfString:@"%"].length==0)?[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:url;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:tempUrl]];
    [request setStringEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    for (NSString* key in postData) {
        [request setPostValue:[postData objectForKey:key] forKey:key];
    }
    [request setDelegate:self];
    [request setTimeOutSeconds:30.0f];
    [request startAsynchronous];
}
#pragma mark HTTPRequest
-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown setAllowResumeForFileDownloads:(BOOL)allow
{
    //如果不存在则创建临时存储目录
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[CommonHelper getTempFolderPath]])
    {
        [fileManager createDirectoryAtPath:[CommonHelper getTempFolderPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    //按照获取的文件名获取临时文件的大小，即已下载的大小
    fileInfo.isFistReceived=YES;
    NSData *fileData=[fileManager contentsAtPath:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]]];
    NSInteger receivedDataLength=[fileData length];
    fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%d",receivedDataLength];
    //url encoding
    NSString* fileURL = ([fileInfo.fileURL rangeOfString:@"%"].length==0)?[fileInfo.fileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:fileInfo.fileURL;
    //如果文件重复下载或暂停、继续，则把队列中的请求删除，重新添加
    for(ASIHTTPRequest *tempRequest in self.downinglist)
    {
        FileModel *f =(FileModel *)[tempRequest.userInfo objectForKey:@"File"];
        NSString* url = ([f.fileURL rangeOfString:@"%"].length==0)?[f.fileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]:f.fileURL;
        if([url isEqual:fileURL])
        {
            [tempRequest cancel];
            [downinglist removeObject:tempRequest];
            break;
        }
    }
    
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fileURL]];
    request.delegate=self;
    [request setDownloadDestinationPath:[[CommonHelper getTargetFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileInfo.fileName]]];
    [request setTemporaryFileDownloadPath:[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]]];
    [request setDownloadProgressDelegate:self];
    //    [request setDownloadProgressDelegate:downCell.progress];//设置进度条的代理,这里由于下载是在AppDelegate里进行的全局下载，所以没有使用自带的进度条委托，这里自己设置了一个委托，用于更新UI
    [request setAllowResumeForFileDownloads:allow];//支持断点续传
    if(isBeginDown)
    {
        fileInfo.isDownloading=YES;
    }
    else
    {
        fileInfo.isDownloading=NO;
    }
    [request setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信息
    [request setTimeOutSeconds:30.0f];
    if (isBeginDown) {
        [request startAsynchronous];
    }
    
    //    [downinglist addObject:request];
    
    [request release];
}
-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown
{
    [self beginRequest:fileInfo isBeginDown:isBeginDown setAllowResumeForFileDownloads:YES];
}
#pragma mark ASIHttpRequestDelegate

//出错了，如果是等待超时，则继续下载
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error=[request error];
    NSLog(@"ASIHttpRequest出错了!%@",error);
    FileModel *fileModel=[request.userInfo objectForKey:@"File"];
    
    if(fileModel && fileModel.notificationName && fileModel.notificationName.length)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:fileModel.notificationName object:error];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kPostNotification object:error];
    }
}

-(void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"开始了!");
    
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    if(fileInfo)
    {
        fileInfo.fileType=[[request responseHeaders] objectForKey:@"Content-Type"];
        fileInfo.fileSize=[CommonHelper getFileSizeString:[[request responseHeaders] objectForKey:@"Content-Length"]];
        NSLog(@"收到回复了！contentType:%@--fileSize:%@",fileInfo.fileType,fileInfo.fileSize);
        
        //文件开始下载时，把文件名、文件总大小、文件URL写入文件，上海滩.rtf中间用逗号隔开
        /*NSString *writeMsg=[fileInfo.fileName stringByAppendingFormat:@",%@,%@",fileInfo.fileSize,fileInfo.fileURL];
         NSRange range = [fileInfo.fileName rangeOfString:@"."];
         NSString *name=(range.length==0)?fileInfo.fileName:[fileInfo.fileName substringToIndex:range.location];
         [writeMsg writeToFile:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",name]] atomically:YES encoding:NSUTF8StringEncoding error:nil];*/
        
        [request setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信息
        
    }
}


//1.实现ASIProgressDelegate委托，在此实现UI的进度条更新,这个方法必须要在设置[request setDownloadProgressDelegate:self];之后才会运行
//2.这里注意第一次返回的bytes是已经下载的长度，以后便是每次请求数据的大小
//费了好大劲才发现的，各位新手请注意此处
-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    if(fileInfo && !fileInfo.isFistReceived)
    {
        fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%lld",[fileInfo.fileReceivedSize longLongValue]+bytes];
    }
    fileInfo.isFistReceived=NO;
}

//将正在下载的文件请求ASIHttpRequest从队列里移除，并将其配置文件删除掉,然后向已下载列表里添加该文件对象
-(void)requestFinished:(ASIHTTPRequest *)request
{
    const NSUInteger kHTTPOK =  200;
    FileModel *fileInfo=(FileModel *)[request.userInfo objectForKey:@"File"];
    //[self playDownloadFinishSound];
    if([request isKindOfClass:[ASIFormDataRequest class]]){//POST
        NSObject *postObject=nil;
        NSDictionary* dict = nil;
        if(kHTTPOK != request.responseStatusCode)
        {
            NSError* error=[request error];
            NSLog(@"ASIHttpRequest出错了!%@",postObject);
            postObject = error;
        }
        else
        {
            NSString* responseData = [[[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding]autorelease];
            if (!responseData) {
                responseData = [[[NSString alloc]initWithData:request.responseData encoding:NSUTF16StringEncoding]autorelease];
            }
            dict = [NSDictionary dictionaryWithObject:request.responseData forKey:kPostResponseData];
            postObject = responseData;
            NSLog(@"post: %@",responseData);
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kPostNotification object:postObject userInfo:dict];
        return;
    }
    
    
    NSLog(@"fileInfo refCount:%d",[fileInfo retainCount]);
    fileInfo.fileType = [[request responseHeaders] objectForKey:@"Content-Type"];
    
    NSRange range=[fileInfo.fileName rangeOfString:@"."];
    NSString *name=(range.length==0)?fileInfo.fileName:[fileInfo.fileName substringToIndex:range.location];
    if (!fileInfo.destPath) {
        fileInfo.destPath = name;
    }
    NSString *configPath=[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[name stringByAppendingString:@".rtf"]];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    
    if([fileManager fileExistsAtPath:configPath])//如果存在临时文件的配置文件
    {
        [fileManager removeItemAtPath:configPath error:&error];
    }
    if(!error)
    {
        NSLog(@"%@",[error description]);
    }
    NSLog(@"request.responseStatusCode:%d",request.responseStatusCode);
    if(kHTTPOK != request.responseStatusCode)
    {
        //pop up a tip only
        //[[NSNotificationCenter defaultCenter]postNotificationName:kFileDownloadFail object:fileInfo];
        NSError *error=[request error];
        NSLog(@"ASIHttpRequest出错了!%@",error);
        FileModel *fileModel=[request.userInfo objectForKey:@"File"];
        if(fileModel && fileModel.notificationName && fileModel.notificationName.length)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:fileModel.notificationName object:error];
        }
        
    }
    else
    {
        //add to operation queue
        NSInvocationOperation* operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(saveDownloadedResources:) object:fileInfo];
        [mOperationQueue addOperation:operation];
        [operation release];
        
        
        [finishedlist addObject:fileInfo];
        [downinglist removeObject:request];
        [downinglist removeObject:request];
        
    }
}

#pragma mark after-download
-(void)saveDownloadedResources:(FileModel*)fileModel
{
    NSLog(@"saveDownloadedResources:%@",fileModel.fileName);
    
    NSString *documentsDirectory = [CommonHelper getTargetFolderPath];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:fileModel.fileName];
    NSFileManager* fileManager =[NSFileManager defaultManager];
    NSRange range=[fileModel.fileName rangeOfString:@"."];
    NSString *name=(range.length==0)?fileModel.fileName:[fileModel.fileName substringToIndex:range.location];
    if (!fileModel.destPath) {
        fileModel.destPath = name;
    }
    
    //unzip(zip,rar,txt)
    NSString* desFilePath = [CommonHelper getTargetBookPath:fileModel.destPath];
    [CommonHelper extractFile:fileName toFile:[CommonHelper getTargetBookPath:fileModel.destPath] fileType:fileModel.fileType];
    
    //TODO::decrypt
    if (fileModel.encrypt) {
        NSString* stream = [NSString stringWithContentsOfFile:desFilePath encoding:NSUTF8StringEncoding error:nil];
        if (stream) {
            
            [fileManager removeItemAtPath:desFilePath error:nil];
            int encryptKey = 'L';
            NSString* temp = [CommonHelper xor_string:stream key:encryptKey];
            NSMutableData *writer = [[[NSMutableData alloc]init]autorelease];
            
            
            NSData *reader = [temp dataUsingEncoding:NSUTF8StringEncoding];
            [writer appendData:reader];
            [writer writeToFile:desFilePath atomically:YES];
        }
    }
    
    [fileManager removeItemAtPath:fileName error:nil];
    
    if(fileModel.notificationName && fileModel.notificationName.length)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:fileModel.notificationName object:[desFilePath stringByAppendingPathComponent:fileModel.fileName]];
    }
}
@end
