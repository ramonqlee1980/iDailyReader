//
//  MCSegmentedControl.m
//
//  Created by Matteo Caldari on 21/05/2010.
//  Copyright 2010 Matteo Caldari. All rights reserved.
//

#import "MCSegmentedControl.h"

#define kCornerRadius  10.0f

@interface MCSegmentedControl (Private)
@property (nonatomic, retain, readwrite) NSMutableArray *items;
- (BOOL)mustCustomize;
@end


@implementation MCSegmentedControl

#pragma mark -
#pragma mark Object life cycle

- (void)awakeFromNib {
	NSMutableArray *ar = [NSMutableArray arrayWithCapacity:self.numberOfSegments];

	for (int i = 0; i < self.numberOfSegments; i++) {
		NSString *aTitle = [self titleForSegmentAtIndex:i];
		if (aTitle) {
			[ar addObject:aTitle];
		} else {
			UIImage *anImage = [self imageForSegmentAtIndex:i];
			if (anImage) {
				[ar addObject:anImage];
			}
		}
	}
	
	self.items = ar;
	[self setNeedsDisplay];
}

- (id)initWithItems:(NSArray *)array {
	if (self = [super initWithItems:array]) {
		NSMutableArray *mutableArray = [array mutableCopy];
		self.items = mutableArray;
		[mutableArray release];
	}
	
	return self;
}

- (void)dealloc {
	self.items               = nil;
	self.font                = nil;
	self.selectedItemColor   = nil;
	self.unselectedItemColor = nil;
	
    [super dealloc];
}

- (BOOL)mustCustomize {
	return self.segmentedControlStyle == UISegmentedControlStyleBordered
		|| self.segmentedControlStyle == UISegmentedControlStylePlain;
}

#pragma mark -
#pragma mark Custom accessors

- (UIFont *)font {
	if (font == nil) {
		self.font = [UIFont systemFontOfSize:15.0f];
	}
	return font;
}

- (void)setFont:(UIFont *)aFont {
	if (font != aFont) {
		[font release];
		font = [aFont retain];
		
		[self setNeedsDisplay];
	}
}

- (UIColor *)selectedItemColor {
	if (selectedItemColor == nil) {
		self.selectedItemColor = [UIColor whiteColor];
	}
	return selectedItemColor;
}

- (void)setSelectedItemColor:(UIColor *)aColor {
	if (aColor != selectedItemColor) {
		[selectedItemColor release];
		selectedItemColor = [aColor retain];
		
		[self setNeedsDisplay];
	}
}

- (UIColor *)unselectedItemColor {
	if (unselectedItemColor == nil) {
		self.unselectedItemColor = [UIColor grayColor];
	}
	return unselectedItemColor;
}

- (void)setUnselectedItemColor:(UIColor *)aColor {
	if (aColor != unselectedItemColor) {
		[unselectedItemColor release];
		unselectedItemColor = [aColor retain];
		
		[self setNeedsDisplay];
	}
}

- (NSMutableArray *)items {
	return items;
}

- (void)setItems:(NSMutableArray *)array {
	if (items != array) {
		[items release];
		items = [array retain];
	}
}

#pragma mark -
#pragma mark Overridden UISegmentedControl methods

- (NSUInteger)numberOfSegments {
	if (!self.items || ![self mustCustomize]) {
		return [super numberOfSegments];
	} else {
		return self.items.count;
	}
}

- (void)drawRect:(CGRect)rect {
	
	// Only the bordered and plain style are customized
	if (![self mustCustomize]) {
		[super drawRect:rect];
		return;
	}

	
	for (UIView *subView in self.subviews) {
		[subView removeFromSuperview];
	}
	
	// TODO: support for segment custom width
	CGSize itemSize = CGSizeMake(round(rect.size.width / self.numberOfSegments), rect.size.height);
	
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGContextSaveGState(c);
	
	
	// Rect with radius, will be used to clip the entire view
	CGFloat minx = CGRectGetMinX(rect) + 1, midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
	CGFloat miny = CGRectGetMinY(rect) + 1, midy = CGRectGetMidY(rect) , maxy = CGRectGetMaxY(rect) ;
	
	
	// Path are drawn starting from the middle of a pixel, in order to avoid an antialiased line
	CGContextMoveToPoint(c, minx - .5, midy - .5);
	CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, kCornerRadius);
	CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, kCornerRadius);
	CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, kCornerRadius);
	CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, kCornerRadius);
	CGContextClosePath(c);
	
	CGContextClip(c);
	
	
	// Background gradient for non selected items
	CGFloat components[8] = { 
		255/255.0, 255/255.0, 255/255.0, 1.0, 
		200/255.0, 200/255.0, 200/255.0, 1.0
	};
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, NULL, 2);
	CGContextDrawLinearGradient(c, gradient, CGPointZero, CGPointMake(0, rect.size.height), kCGGradientDrawsBeforeStartLocation);
	CFRelease(gradient);
	
	for (int i = 0; i < self.numberOfSegments; i++) {
		id item = [self.items objectAtIndex:i];
		BOOL isLeftItem  = i == 0;
		BOOL isRightItem = i == self.numberOfSegments -1;
		
		CGRect itemBgRect = CGRectMake(i * itemSize.width, 
									   0.0f,
									   itemSize.width,
									   rect.size.height);
		
		if (i == self.selectedSegmentIndex) {
			
			// -- Selected item --
			
			// Background gradient is composed of two gradients, one on the top, another rounded on the bottom
			
			CGContextSaveGState(c);
			CGContextClipToRect(c, itemBgRect);
			
			float factor  = 1.22f; // multiplier applied to the first color of the gradient to obtain the second
			float mfactor = 1.25f; // multiplier applied to the color of the first gradient to obtain the bottom gradient
			
			int red = 55, green = 111, blue = 214; // default blue color
			
			if (self.tintColor != nil) {
				const CGFloat *components = CGColorGetComponents(self.tintColor.CGColor);
				size_t numberOfComponents = CGColorGetNumberOfComponents(self.tintColor.CGColor);
				
				if (numberOfComponents == 2) {
					red = green = blue = components[0] * 255;
				} else if (numberOfComponents == 4) {
					red   = components[0] * 255;
					green = components[1] * 255;
					blue  = components[2] * 255;
				}
			}
			
			
			// Top gradient
			
			CGFloat top_components[16] = { 
				red / 255.0f,         green / 255.0f,         blue/255.0f          , 1.0f,
				(red*mfactor)/255.0f, (green*mfactor)/255.0f, (blue*mfactor)/255.0f, 1.0f
			};
			
			CGFloat top_locations[2] = {
				0.0f, .75f
			};
			
			CGGradientRef top_gradient = CGGradientCreateWithColorComponents(colorSpace, top_components, top_locations, 2);
			CGContextDrawLinearGradient(c, 
										top_gradient, 
										itemBgRect.origin, 
										CGPointMake(itemBgRect.origin.x, 
													itemBgRect.size.height), 
										kCGGradientDrawsBeforeStartLocation);
			CFRelease(top_gradient);
			CGContextRestoreGState(c);
			
			
			// Bottom gradient
			// It's clipped in a rect with the left corners rounded if segment is the first,
			// right corners rounded if segment is the last, no rounded corners for the segments inbetween
		
			CGRect bottomGradientRect = CGRectMake(itemBgRect.origin.x, 
												   itemBgRect.origin.y + round(itemBgRect.size.height / 2), 
												   itemBgRect.size.width, 
												   round(itemBgRect.size.height / 2));
			
			CGFloat gradient_minx = CGRectGetMinX(bottomGradientRect) + 1;
			CGFloat gradient_midx = CGRectGetMidX(bottomGradientRect);
			CGFloat gradient_maxx = CGRectGetMaxX(bottomGradientRect);
			CGFloat gradient_miny = CGRectGetMinY(bottomGradientRect) + 1;
			CGFloat gradient_midy = CGRectGetMidY(bottomGradientRect);
			CGFloat gradient_maxy = CGRectGetMaxY(bottomGradientRect);
			
			
			CGContextSaveGState(c);
			if (isLeftItem) {
				CGContextMoveToPoint(c, gradient_minx - .5f, gradient_midy - .5f);
			} else {
				CGContextMoveToPoint(c, gradient_minx - .5f, gradient_miny - .5f);
			}
			
			CGContextAddArcToPoint(c, gradient_minx - .5f, gradient_miny - .5f, gradient_midx - .5f, gradient_miny - .5f, kCornerRadius);
			
			if (isRightItem) {
				CGContextAddArcToPoint(c, gradient_maxx - .5f, gradient_miny - .5f, gradient_maxx - .5f, gradient_midy - .5f, kCornerRadius);
				CGContextAddArcToPoint(c, gradient_maxx - .5f, gradient_maxy - .5f, gradient_midx - .5f, gradient_maxy - .5f, kCornerRadius);
			} else {
				CGContextAddLineToPoint(c, gradient_maxx, gradient_miny);
				CGContextAddLineToPoint(c, gradient_maxx, gradient_maxy);
			}
			
			if (isLeftItem) {
				CGContextAddArcToPoint(c, gradient_minx - .5f, gradient_maxy - .5f, gradient_minx - .5f, gradient_midy - .5f, kCornerRadius);
			} else {
				CGContextAddLineToPoint(c, gradient_minx, gradient_maxy);
			}
			
			CGContextClosePath(c);
			
			
			CGContextClip(c);
			CGFloat bottom_components[16] = {
				(red*factor)        /255.0f, (green*factor)        /255.0f, (blue*factor)/255.0f,         1.0f,
				(red*factor*mfactor)/255.0f, (green*factor*mfactor)/255.0f, (blue*factor*mfactor)/255.0f, 1.0f
			};
			
			CGFloat bottom_locations[2] = {
				0.0f, 1.0f
			};
			
			CGGradientRef bottom_gradient = CGGradientCreateWithColorComponents(colorSpace, bottom_components, bottom_locations, 2);
			CGContextDrawLinearGradient(c, 
										bottom_gradient, 
										bottomGradientRect.origin, 
										CGPointMake(bottomGradientRect.origin.x, 
													bottomGradientRect.origin.y + bottomGradientRect.size.height), 
										kCGGradientDrawsBeforeStartLocation);
			CFRelease(bottom_gradient);
			CGContextRestoreGState(c);
			
			
			
			// Inner shadow
			
			int blendMode = kCGBlendModeDarken;
			
			// Right and left inner shadow 
			CGContextSaveGState(c);
			CGContextSetBlendMode(c, blendMode);
			CGContextClipToRect(c, itemBgRect);
			
			CGFloat inner_shadow_components[16] = {
				0.0f, 0.0f, 0.0f, isLeftItem ? 0.0f : .25f,
				0.0f, 0.0f, 0.0f, 0.0f,
				0.0f, 0.0f, 0.0f, 0.0f,
				0.0f, 0.0f, 0.0f, isRightItem ? 0.0f : .25f
			};
			
			
			CGFloat locations[4] = {
				0.0f, .05f, .95f, 1.0f
			};
			CGGradientRef inner_shadow_gradient = CGGradientCreateWithColorComponents(colorSpace, inner_shadow_components, locations, 4);
			CGContextDrawLinearGradient(c, 
										inner_shadow_gradient, 
										itemBgRect.origin, 
										CGPointMake(itemBgRect.origin.x + itemBgRect.size.width, 
													itemBgRect.origin.y), 
										kCGGradientDrawsAfterEndLocation);
			CFRelease(inner_shadow_gradient);
			CGContextRestoreGState(c);
			
			// Top inner shadow 
			CGContextSaveGState(c);
			CGContextSetBlendMode(c, blendMode);
			CGContextClipToRect(c, itemBgRect);
			CGFloat top_inner_shadow_components[8] = { 
				0.0f, 0.0f, 0.0f, 0.25f,
				0.0f, 0.0f, 0.0f, 0.0f
			};
			CGFloat top_inner_shadow_locations[2] = {
				0.0f, .10f
			};
			CGGradientRef top_inner_shadow_gradient = CGGradientCreateWithColorComponents(colorSpace, top_inner_shadow_components, top_inner_shadow_locations, 2);
			CGContextDrawLinearGradient(c, 
										top_inner_shadow_gradient, 
										itemBgRect.origin, 
										CGPointMake(itemBgRect.origin.x, 
													itemBgRect.size.height), 
										kCGGradientDrawsAfterEndLocation);
			CFRelease(top_inner_shadow_gradient);
			CGContextRestoreGState(c);
			
		}
		
		if ([item isKindOfClass:[UIImage class]]) {
			
			CGImageRef imageRef = [(UIImage *)item CGImage];
			
			CGRect imageRect = CGRectMake(round(i * itemSize.width + (itemSize.width - CGImageGetWidth(imageRef)) / 2), 
										  round((itemSize.height - CGImageGetHeight(imageRef)) / 2),
										  CGImageGetWidth(imageRef),
										  CGImageGetHeight(imageRef));
			
			
			if (i == self.selectedSegmentIndex) {
				
				CGContextSaveGState(c);
				CGContextTranslateCTM(c, 0, rect.size.height);  
				CGContextScaleCTM(c, 1.0, -1.0);  
				
				CGContextRestoreGState(c);
				
				CGContextSaveGState(c);
				CGContextTranslateCTM(c, 0, rect.size.height);  
				CGContextScaleCTM(c, 1.0, -1.0);  
				
				CGContextClipToMask(c, imageRect, imageRef);
				CGContextSetFillColorWithColor(c, [self.selectedItemColor CGColor]);
				
				CGContextFillRect(c, imageRect);
				CGContextRestoreGState(c);
			} 
			else {
				
				// 1px shadow
				CGContextSaveGState(c);
				CGContextTranslateCTM(c, 0, itemBgRect.size.height);  
				CGContextScaleCTM(c, 1.0, -1.0);  
				
				CGContextClipToMask(c, CGRectOffset(imageRect, 0, -1), imageRef);
				CGContextSetFillColorWithColor(c, [[UIColor whiteColor] CGColor]);
				CGContextFillRect(c, CGRectOffset(imageRect, 0, -1));
				CGContextRestoreGState(c);
				
				// Image drawn as a mask
				CGContextSaveGState(c);
				CGContextTranslateCTM(c, 0, itemBgRect.size.height);  
				CGContextScaleCTM(c, 1.0, -1.0);  
				
				CGContextClipToMask(c, imageRect, imageRef);
				CGContextSetFillColorWithColor(c, [self.unselectedItemColor CGColor]);
				CGContextFillRect(c, imageRect);
				CGContextRestoreGState(c);
			}
			
		}
		else if ([item isKindOfClass:[NSString class]]) {
			
			NSString *string = (NSString *)[items objectAtIndex:i];
			CGSize stringSize = [string sizeWithFont:self.font];
			CGRect stringRect = CGRectMake(i * itemSize.width + (itemSize.width - stringSize.width) / 2, 
										   (itemSize.height - stringSize.height) / 2,// + kTopPadding,
										   stringSize.width,
										   stringSize.height);
			
			if (self.selectedSegmentIndex == i) {
				[[UIColor colorWithWhite:0.0f alpha:.2f] setFill];
				[string drawInRect:CGRectOffset(stringRect, 0.0f, -1.0f) withFont:self.font];
				[self.selectedItemColor setFill];	
				[self.selectedItemColor setStroke];	
				[string drawInRect:stringRect withFont:self.font];
			} else {
				[[UIColor whiteColor] setFill];			
				[string drawInRect:CGRectOffset(stringRect, 0.0f, 1.0f) withFont:self.font];
				[self.unselectedItemColor setFill];
				[string drawInRect:stringRect withFont:self.font];
			}
		}
		
		// Separator
		if (i > 0 && i - 1 != self.selectedSegmentIndex && i != self.selectedSegmentIndex) {
			CGContextSaveGState(c);
			
			CGContextMoveToPoint(c, itemBgRect.origin.x + .5, itemBgRect.origin.y);
			CGContextAddLineToPoint(c, itemBgRect.origin.x + .5, itemBgRect.size.height);
			
			CGContextSetLineWidth(c, .5f);
			CGContextSetStrokeColorWithColor(c, [UIColor colorWithWhite:120/255.0 alpha:1.0].CGColor);
			CGContextStrokePath(c);
			
			CGContextRestoreGState(c);
		}
		
	}
	
	CGContextRestoreGState(c);
	
	if (self.segmentedControlStyle ==  UISegmentedControlStyleBordered) {
		CGContextMoveToPoint(c, minx - .5, midy - .5);
		CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, kCornerRadius);
		CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, kCornerRadius);
		CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, kCornerRadius);
		CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, kCornerRadius);
		CGContextClosePath(c);
		
		CGContextSetStrokeColorWithColor(c,[UIColor blackColor].CGColor);
		CGContextSetLineWidth(c, 1.0f);
		CGContextStrokePath(c);
	} else {
		CGContextSaveGState(c);
		
		CGRect bottomHalfRect = CGRectMake(0, 
										   rect.size.height - kCornerRadius + 7,
										   rect.size.width,
										   kCornerRadius);
		CGContextClearRect(c, CGRectMake(0, 
										 rect.size.height - 1,
										 rect.size.width,
										 1));
		CGContextClipToRect(c, bottomHalfRect);
		
		CGContextMoveToPoint(c, minx + .5, midy - .5);
		CGContextAddArcToPoint(c, minx + .5, miny - .5, midx - .5, miny - .5, kCornerRadius);
		CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, kCornerRadius);
		CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, kCornerRadius);
		CGContextAddArcToPoint(c, minx + .5, maxy - .5, minx - .5, midy - .5, kCornerRadius);
		CGContextClosePath(c);
		
		CGContextSetBlendMode(c, kCGBlendModeLighten);
		CGContextSetStrokeColorWithColor(c,[UIColor colorWithWhite:255/255.0 alpha:1.0].CGColor);
		CGContextSetLineWidth(c, .5f);
		CGContextStrokePath(c);
		
		CGContextRestoreGState(c);
		midy--, maxy--;
		CGContextMoveToPoint(c, minx - .5, midy - .5);
		CGContextAddArcToPoint(c, minx - .5, miny - .5, midx - .5, miny - .5, kCornerRadius);
		CGContextAddArcToPoint(c, maxx - .5, miny - .5, maxx - .5, midy - .5, kCornerRadius);
		CGContextAddArcToPoint(c, maxx - .5, maxy - .5, midx - .5, maxy - .5, kCornerRadius);
		CGContextAddArcToPoint(c, minx - .5, maxy - .5, minx - .5, midy - .5, kCornerRadius);
		CGContextClosePath(c);
		
		CGContextSetBlendMode(c, kCGBlendModeMultiply);
		CGContextSetStrokeColorWithColor(c,[UIColor colorWithWhite:30/255.0 alpha:.9].CGColor);
		CGContextSetLineWidth(c, .5f);
		CGContextStrokePath(c);
	}

	
	CFRelease(colorSpace);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (![self mustCustomize]) {
		[super touchesBegan:touches withEvent:event];
	} else {
		CGPoint point = [[touches anyObject] locationInView:self];
		int itemIndex = floor(self.numberOfSegments * point.x / self.bounds.size.width);
		self.selectedSegmentIndex = itemIndex;
		
		[self setNeedsDisplay];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

- (void)setSegmentedControlStyle:(UISegmentedControlStyle)aStyle {
	[super setSegmentedControlStyle:aStyle];
	if ([self mustCustomize]) {
		[self setNeedsDisplay];
	}
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment {
	
	if (![self mustCustomize]) {
		[super setTitle:title forSegmentAtIndex:segment];
	} else {
		[self.items replaceObjectAtIndex:segment withObject:title];
		[self setNeedsDisplay];
	}
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment {
	if (![self mustCustomize]) {
		[super setImage:image forSegmentAtIndex:segment];
	} else {
		[self.items replaceObjectAtIndex:segment withObject:image];
		[self setNeedsDisplay];
	}
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated {
	if (![self mustCustomize]) {
		[super insertSegmentWithTitle:title atIndex:segment animated:animated];
	} else {
		if (segment < 0 || segment >= self.numberOfSegments) return;
		[super insertSegmentWithTitle:title atIndex:segment animated:animated];
		[self.items insertObject:title atIndex:segment];
		[self setNeedsDisplay];
	}
}

- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)segment animated:(BOOL)animated {
	if (![self mustCustomize]) {
		[super insertSegmentWithImage:image atIndex:segment animated:animated];
	} else {
		if (segment < 0 || segment >= self.numberOfSegments) return;
		[super insertSegmentWithImage:image atIndex:segment animated:animated];
		[self.items insertObject:image atIndex:segment];
		[self setNeedsDisplay];
	}
}

- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated {
	if (![self mustCustomize]) {
		[super removeSegmentAtIndex:segment animated:animated];
	} else {
		if (segment < 0 || segment >= self.numberOfSegments) return;
		[self.items removeObjectAtIndex:segment];
		[self setNeedsDisplay];
	}
}


@end
