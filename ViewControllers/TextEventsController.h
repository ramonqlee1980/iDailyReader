#import <UIKit/UIKit.h>

@interface TextEventsController : UITableViewController {
	
	// Parsing
	NSMutableArray *parsedItems;
	
	// Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
    UIActivityIndicatorView *activityViewLoad;
    NSString* mDataPath;
}

// Properties
@property (nonatomic, retain) NSArray *itemsToDisplay;

+(NSString*)getDataPath:(NSString*)destinationDir subPath:(NSString*)dataPath;

@end
