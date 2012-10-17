//
//  InScrollViewLayer.m
//  FlipViewTest
//
//  Created by Mac Pro on 6/6/12.
//  Copyright (c) 2012 Dawn(use for learn,base on CAShowcase demo). All rights reserved.
//

#import "InScrollViewLayer.h"

@implementation InScrollViewLayer
@synthesize image;
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}
- (void)dealloc
{
    [image release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
		//image = nil;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
   // self.backgroundColor = [UIColor redColor].CGColor;
	UIGraphicsPushContext(ctx);
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10.0];	
	CGContextSaveGState(ctx);
	CGContextAddPath(ctx, path.CGPath);
	CGContextClip(ctx);
	[image drawInRect:self.bounds];
	CGContextRestoreGState(ctx);
	UIGraphicsPopContext();
}
- (void)setImage:(UIImage *)inImage
{
	id tmp = image;
	image = [inImage retain];
	[tmp release];
	[self setNeedsDisplay];
}

- (UIImage *)image
{
	return image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
