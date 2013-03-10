#import <UIKit/UIKit.h>

@class FileModel;

@protocol PullingRefreshDelegate <NSObject>

-(void)refreshData:(FileModel*)fileModel;
-(void)loadMoreData:(FileModel*)fileModel;
-(NSArray*)parseData:(NSData*)data;
@end

@interface ContentViewController : UIViewController

@property(nonatomic,assign)FileModel* fileModel;
@property(nonatomic,assign)id<PullingRefreshDelegate> delegate;

-(void)launchRefreshing;
@end
