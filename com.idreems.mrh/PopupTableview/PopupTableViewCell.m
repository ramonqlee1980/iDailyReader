
#import "PopupTableViewCell.h"

@implementation PopupTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectOffset(self.imageView.frame, 6, 0);
    self.textLabel.frame = CGRectOffset(self.textLabel.frame, 6, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
