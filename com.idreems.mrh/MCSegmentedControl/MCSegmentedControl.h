//
//  MCSegmentedControl.h
//
//  Created by Matteo Caldari on 21/05/2010.
//  Copyright 2010 Matteo Caldari. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MCSegmentedControl : UISegmentedControl {

	NSMutableArray *items;
	
	UIFont  *font;
	UIColor *selectedItemColor;
	UIColor *unselectedItemColor;
	
}

/**
 * Font for the segments with title
 * Default is sysyem bold 18points
 */
@property (nonatomic, retain) UIFont  *font;

/**
 * Color of the item in the selected segment
 * Applied to text and images
 */
@property (nonatomic, retain) UIColor *selectedItemColor;

/**
 * Color of the items not in the selected segment
 * Applied to text and images
 */
@property (nonatomic, retain) UIColor *unselectedItemColor;

@end
