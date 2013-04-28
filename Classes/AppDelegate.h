
#import "ASIHTTPRequest.h"
#import "WXApi.h"

#define SharedDelegate (AppDelegate*)[[UIApplication sharedApplication]delegate]
#define kAdd2Favorite @"kAdd2Favorite"
@class FileModel;

@interface AppDelegate : NSObject <UIApplicationDelegate,WXApiDelegate>
{
    UIWindow *window;
    UINavigationController *navigationController;
    NSMutableArray *data;
    NSString* mCurrentFileName;
    NSString* mDataPath;
    NSString* mTrackViewUrl;
    NSString* mTrackName;
    NSInteger _newContentCount;
    BOOL      _EnterBylocalNotification;
    
    //ads wall display
    NSUInteger mAdsWallIndex;
    NSArray* mAdsWalls;
    BOOL mShouldShowAdsWall;
    ASIHTTPRequest* asiRequest;
    
    UIImageView *zView;//Z图片ImageView
    UIImageView *fView;//F图片ImageView
    
    
    UIView *rView;//图片的UIView
    NSUInteger mDialogType;
    BOOL isWhiteColor;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSMutableArray* data;
@property (nonatomic, assign) NSString* mCurrentFileName;
@property (nonatomic, assign) NSString* mDataPath;
@property (nonatomic, retain) NSString* mTrackViewUrl;
@property (nonatomic, retain) NSString* mTrackName;
@property(nonatomic,retain) ASIHTTPRequest *asiRequest;
@property(nonatomic,assign) BOOL isWhiteColor;

-(UIViewController*)rootViewController;
//current ads wall 
-(NSString*)currentAdsWall;
-(BOOL)shouldShowAdsWall;
-(void)setShouldShowAdsWall:(BOOL)show enableForNext:(BOOL)enable;
-(void)setShouldShowAdsWall:(BOOL)show;

- (NSString *)getTitle:(const NSUInteger)index;
- (NSString *)getContent:(const NSUInteger)index;
-(NSString*)getNodeContent:(const NSUInteger)index firstContent:(BOOL) first;
+(NSString*)getMonthDay;
+(NSString*)getMonthDay4Tomorrow;
+(NSString*)getTodayFileName;
+(NSString*)getTomorrowFileName;
-(void)releaseMemory;
- (void)loadData;

//for ads config
-(void)startAdsConfigReceive;
-(void)parseAdsConfig;
-(NSInteger)newContentCount;
-(BOOL)showNewContent;
-(void)sendTableViewUpdateMsg;
-(void)scheduleLocalNotification:(NSString*)alertBody;
//update
-(void)checkUpdate;
// 比较oldVersion和newVersion，如果oldVersion比newVersion旧，则返回YES，否则NO
// Version format[X.X.X]
+(BOOL)CompareVersionFromOldVersion : (NSString *)oldVersion
                         newVersion : (NSString *)newVersion;
- (NSString *)applicationDocumentsDirectory ;

- (void) sendAppContent:(NSString*)title description:(NSString*)description image:(NSString*)name scene:(int)scene;
- (void) shareByShareKit:(NSString*)title description:(NSString*)description image:(UIImage*)image;

+(BOOL)isPurchased;
-(BOOL)isQuitTipOff;
-(void)setQuitTipOff:(BOOL)off;

-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown setAllowResumeForFileDownloads:(BOOL)allow;
-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown;
-(void)beginPostRequest:(NSString*)url withDictionary:(NSDictionary*)postData;
@end

