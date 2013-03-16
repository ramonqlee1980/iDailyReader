#import "ImageViewController.h"
#import "MDCParallaxView.h"
#import "SDWebImageManager.h"
#import "ThemeManager.h"

#define kPlaceholderImage @"placeholder.png"
#define kTextFontSize 18.0f

@interface ImageViewController () <UIScrollViewDelegate>
{
    NSUInteger imageWidth;
    NSUInteger imageHeight;
}
@end


@implementation ImageViewController
@synthesize text,imageUrl,placeholderImageUrl;

#pragma mark - UIViewController Overrides
-(NSString*)removeHtmlTags:(NSString*)txt
{
    if(txt)
    {
        NSString* pattern = @"&[a-zA-Z]*;";
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSMutableString *ret = [[NSMutableString alloc]initWithString:txt];
        [regex replaceMatchesInString:ret options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, txt.length) withTemplate:@""];
        return ret;
    }
    return txt;
}
-(void)initWithData:(NSString*)txt imageUrl:(NSString*)url placeHolderImageUrl:(NSString*)ph imageWidth:(NSUInteger)width imageHeight:(NSUInteger)height
{
    self.text = [self removeHtmlTags:txt];
    self.imageUrl = url;
    self.placeholderImageUrl = ph;
    imageHeight = height;
    imageWidth = width;
}

-(void)viewWillDisappear:(BOOL)animated
{
    //self.tabBarController.tabBar.hidden = NO;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Back",@"") style: UIBarButtonItemStyleBordered target: self action: @selector(back)];
    newBackButton.tintColor = TintColor;
    [[self navigationItem] setLeftBarButtonItem:newBackButton];
    [newBackButton release];
    
    UIImageView *backgroundImageView = nil;
    if(self.imageUrl && self.imageUrl.length>0)
    {
        //self.tabBarController.tabBar.hidden = YES;
        NSData* imageData = [[SDWebImageManager sharedManager]imageWithURL:[NSURL URLWithString:self.placeholderImageUrl]];
        
        UIImage* placeHolderImage = [UIImage imageWithData:imageData];
        
        UIImage *backgroundImage = placeHolderImage?placeHolderImage:[UIImage imageNamed:kPlaceholderImage];
        
        //adjust width
        CGFloat scale = (CGFloat)kDeviceWidth/imageWidth;
        CGRect backgroundRect = CGRectMake(0, 0,imageWidth*scale, imageHeight*scale);
        //height still exceed
        if(backgroundRect.size.height>KDeviceHeight/2)
        {
            scale = (CGFloat)KDeviceHeight/(backgroundRect.size.height*2);
            backgroundRect.size.height *= scale;
            backgroundRect.size.width  *= scale;
        }
        
        backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundRect];
        //    backgroundImageView.image = backgroundImage;
        if([backgroundImageView respondsToSelector:@selector(setImageWithURL:placeholderImage:)])
        {
            [backgroundImageView performSelector:@selector(setImageWithURL:placeholderImage:) withObject:[NSURL URLWithString:self.imageUrl] withObject:backgroundImage];            
        }
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    CGRect textRect = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
    UITextView *textView = [[UITextView alloc] initWithFrame:textRect];
    textView.text = self.text;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.font = [UIFont systemFontOfSize:kTextFontSize];
    textView.textColor = [UIColor darkTextColor];
    textView.editable = NO;
    
    MDCParallaxView *parallaxView = [[MDCParallaxView alloc] initWithBackgroundView:backgroundImageView
                                                                     foregroundView:textView];
    parallaxView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    parallaxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    parallaxView.backgroundHeight = backgroundImageView?250.0f:0.0f;
    parallaxView.scrollViewDelegate = self;
    [self.view addSubview:parallaxView];
}


#pragma mark - UIScrollViewDelegate Protocol Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

@end
