//
//  Unrar4iOS.mm
//  Unrar4iOS
//
//  Created by Rogerio Pereira Araujo on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Unrar4iOSEx.h"
#import "RARExtractException.h"
#import <string.h>
#import <Foundation/NSFileHandle.h>

@implementation Unrar4iOSEx

-(BOOL) unrarFileTo:(NSString*)path overWrite:(BOOL)overwrite {
    try {
        if(![self validRarFile:[self filename]])
        {
            return NO;
        }
        NSArray *files = [self unrarListFiles];
        NSError* err;
        if(![[NSFileManager defaultManager]fileExistsAtPath:path isDirectory:nil])
        {
            [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
        }
        for (NSString *name in files) {
            //NSLog(@"File: %@", name);
            
            // Extract a stream
            
            NSData *data = [self extractStream:[files objectAtIndex:0]];
            if (data != nil) {
                [[NSFileManager defaultManager]createFileAtPath:[path stringByAppendingPathComponent:name] contents:data attributes:nil];
            }
            
        }
    }
    catch(...) {
        //if(error.status == RARArchiveProtected) {        
        NSLog(@"Password protected archive!");
        //}
        return NO;
    }
    return YES;
}
-(BOOL)validRarFile:(NSString*)path
{
    const int kRarHeaderLength = 7;
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];
    [handle seekToFileOffset:0];
    NSData *data = [handle readDataOfLength:kRarHeaderLength];
    if(handle)
    {
        [handle closeFile];
    }
    if(kRarHeaderLength!=data.length)
    {
        return NO;
    }
    //52,61,72,21,1A,07,00
    Byte rarHeader[] = {0x52,0x61,0x72,0x21,0x1A,0x07,0x00};
    const Byte* fileData = (const Byte*)[data bytes];
    return (0==memcmp(rarHeader,fileData,sizeof(rarHeader)/sizeof(rarHeader[0])));
}
@end
