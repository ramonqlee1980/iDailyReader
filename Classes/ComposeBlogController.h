//
//  ComposeBlogController.h
//  HappyLife
//
//  Created by ramonqlee on 3/16/13.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ComposeBlogController : BaseViewController<UITextViewDelegate>
{
    UITextView *bodyTextView;
    UITextView *titleTextView;
    UIActivityIndicatorView* activityIndicator;

}

@property (nonatomic,retain)IBOutlet UITextView *bodyTextView;
@property (nonatomic,retain)IBOutlet UITextView *titleTextView;
@property (nonatomic,retain)IBOutlet UIActivityIndicatorView* activityIndicator;
@end
