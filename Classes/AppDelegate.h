
#define SharedDelegate (AppDelegate*)[[UIApplication sharedApplication]delegate]

@interface AppDelegate : NSObject <UIApplicationDelegate>
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
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSMutableArray* data;
@property (nonatomic, assign) NSString* mCurrentFileName;
@property (nonatomic, assign) NSString* mDataPath;
@property (nonatomic, retain) NSString* mTrackViewUrl;
@property (nonatomic, retain) NSString* mTrackName;

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
@end

