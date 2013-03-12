//
//  ComposeViewController.h
//  SinaOAuth
//
//  Created by liuyuning on 11-7-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GetImage;
@interface ComposeViewController : UIViewController {
	
	UITextView *textView;
	UIImageView *imageView;
	UIBarButtonItem *insertImgBtn;
	BOOL isSending;
    UIActivityIndicatorView* activityIndicator;
	
	GetImage *getImage;
}
@property (nonatomic,retain)IBOutlet UITextView *textView;
@property (nonatomic,retain)IBOutlet UIImageView *imageView;
@property (nonatomic,retain)IBOutlet UIBarButtonItem *insertImgBtn;
@property (nonatomic,retain)IBOutlet UIActivityIndicatorView* activityIndicator;

- (IBAction)insertImage:(id)sender;

//callback
- (void)setImage:(UIImage*)image;

@end
