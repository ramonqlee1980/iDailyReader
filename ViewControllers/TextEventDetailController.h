#import <UIKit/UIKit.h>

@interface TextEventDetailController : UITableViewController {
	NSDictionary *item;
	NSString *dateString, *summaryString;
}

@property (nonatomic, retain) NSDictionary *item;
@property (nonatomic, retain) NSString *dateString, *summaryString;

@end
