//
//  GetPhoto.h
//  AllInOne
//
//  Created by liuyuning on 11-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetImage : NSObject<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	
	UIViewController *parentViewController;
	UIImagePickerControllerSourceType sourceType;
}
@property(nonatomic,retain)UIViewController *parentViewController;

-(void)selectImage;

@end
