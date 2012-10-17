//
//  CDetailData.h
//  AdvancedTableViewCells
//
//  Created by ramonqlee on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CDetailData : NSObject {
    
    NSString *name; 
    NSString *description; 
    UIImage *picture;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) UIImage *picture;

@end
