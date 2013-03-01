#import <UIKit/UIKit.h>
#import "WaterFlowView.h"
#import "ImageViewCell.h"

@class FileModel;

@interface WaterFlowController : UIViewController<WaterFlowViewDelegate,WaterFlowViewDataSource>
{    
    NSMutableArray *mArrayData;
    FileModel* mFileModel;
}

@property (nonatomic, assign) NSMutableArray *mArrayData;
@property (nonatomic, retain) FileModel* mFileModel;
@end
