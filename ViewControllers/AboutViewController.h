//
//  MoreViewController.h
//  AccountSafe
//
//  Created by Lee Ramon on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface AboutViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>

@property(nonatomic,retain) IBOutlet UITableView* tableView;

- (IBAction)feedback:(id)sender;

-(void)launchMailAppOnDevice:(BOOL)feedback;
-(void)displayComposerSheet:(BOOL)feedback;
@end
