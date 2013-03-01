/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "GifView.h"

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(NSString *)imageURL didFinishWithImage:(NSData *)imageData
{
    self.image = [UIImage imageWithData:imageData];
    if (nil!=imageURL && [imageURL hasSuffix:@".gif"])
    {
        CGSize imageSize = self.image.size;
        CGFloat imageScale = fminf(CGRectGetWidth(self.bounds)/imageSize.width, CGRectGetHeight(self.bounds)/imageSize.height);
        CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
        CGRect imageFrame = CGRectMake(floorf(0.5f*(CGRectGetWidth(self.bounds)-scaledImageSize.width)), floorf(0.5f*(CGRectGetHeight(self.bounds)-scaledImageSize.height)), scaledImageSize.width, scaledImageSize.height);
        
        GifView *gifView = [[GifView alloc]initWithFrame:imageFrame data:imageData];
        
        gifView.userInteractionEnabled = NO;
        [self addSubview:gifView];
        [gifView release];
         
    }
    else
    {
        //remove possible gifview
        for (UIView* view in self.subviews) {
            if(nil!=view && [view isKindOfClass:[GifView class]])
            {
                [view removeFromSuperview];
            }
        }
    }
}

@end
