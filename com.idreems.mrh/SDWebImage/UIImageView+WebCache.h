/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * changeHistory
 * 1. gif supported by Ramonqlee 2013-1-23
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"

@interface UIImageView (WebCache) <SDWebImageManagerDelegate>

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)cancelCurrentImageLoad;

@end
