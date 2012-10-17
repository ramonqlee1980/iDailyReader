

#import <Foundation/Foundation.h>
#import "ApplicationCell.h"
#import "RatingView.h"

@interface IndividualSubviewsBasedApplicationCell : ApplicationCell
{
    IBOutlet UIImageView *iconView;
    IBOutlet UILabel *publisherLabel;
    IBOutlet UILabel *nameLabel;
    IBOutlet RatingView *ratingView;
    IBOutlet UILabel *numRatingsLabel;
    IBOutlet UILabel *priceLabel;
}

@end
