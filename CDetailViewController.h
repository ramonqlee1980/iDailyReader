//
//  CDetailView.h
//  AdvancedTableViewCells
//
//  Created by ramonqlee on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XmlModelBase.h"
#import <MessageUI/MFMailComposeViewController.h>

enum ShareOption
{
    kShareByEmail = 0
};

@class CommonADView;
@class ImpressionADView;

@interface CDetailViewController : UIViewController <MFMailComposeViewControllerDelegate,UIActionSheetDelegate>  {
    
    NSIndexPath* index;
    IBOutlet UIScrollView* srlView;
    XmlModelBase* xmlData;
    
    CommonADView *myCommonADView;
    ImpressionADView *myImpressionADView;
}
@property (nonatomic, retain) UIView *srlView;
@property (nonatomic, retain) XmlModelBase* xmlData;
@property (nonatomic, retain) NSIndexPath* index;

-(id)initWithIndexPath:(NSIndexPath*)indexPath;
- (void)layoutScrollImages:(CGSize)screenSize;
-(void)emailShare;

@end
