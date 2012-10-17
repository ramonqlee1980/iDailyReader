//
// Created by guang on 12-9-14.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "WapsCoreFetcherHandler.h"

@class UILabel;


@interface WapsRequest :WapsCoreFetcherHandler <WapsWebFetcherDelegate>  {
    NSMutableData *connectionData_;
    NSURLConnection *conn_;
    UIView *view_;
    UIProgressView *progressView_;
    UILabel *status_;
    UIAlertView *downView_;
    UIAlertView *installView_;
    NSFileManager *fileManager_;
    int total_size_;
}
@property(nonatomic, copy) NSMutableData *connectionData;
@property(nonatomic, copy) NSURLConnection *conn;
@property (retain) UIView* view;
@property (retain) UIProgressView* progressView;
@property (retain) UILabel* status;
@property (retain) UIAlertView *downView;
@property (retain) UIAlertView *installView;
@property (retain) NSFileManager * fileManager;
@property (nonatomic) int total_size;

+ (void)objectPath:(NSString *)filePath status:(NSString *)aKey;

@end