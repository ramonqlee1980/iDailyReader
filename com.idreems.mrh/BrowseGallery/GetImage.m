//
//  GetPhoto.m
//  AllInOne
//
//  Created by liuyuning on 11-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GetImage.h"
@implementation GetImage
@synthesize parentViewController;

-(void)dealloc{
	[parentViewController release];parentViewController = nil;
	[super dealloc];
}

-(void)selectImage{
	
	if (!parentViewController) {
		NSLog(@"error parentViewController is nil");
		return;
	}
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{	
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取  消" destructiveButtonTitle:@"浏览本地图片库" otherButtonTitles:@"拍摄新照片",nil];
		actionSheet.destructiveButtonIndex = -1;
		//[actionSheet showInView:parentViewController.view];//取消按钮不响应
		[actionSheet showFromToolbar:parentViewController.navigationController.toolbar];
		[actionSheet release];
	}
	else {
		[self actionSheet:nil clickedButtonAtIndex:0];
	}
}

#pragma mark -
#pragma mark actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex > 1)//2 cancel
		return;
	
	if (0 == buttonIndex) {
		NSLog(@"图片库");	
		sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	else if (1 == buttonIndex) {
		NSLog(@"新拍摄");
		sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	
	if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
		
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.delegate = self;
		imagePickerController.mediaTypes = [NSArray arrayWithObject:@"public.image"];
		imagePickerController.sourceType = sourceType;   
		imagePickerController.allowsEditing = YES;
		imagePickerController.navigationBar.barStyle = UIBarStyleBlack;
		
		[parentViewController presentModalViewController:imagePickerController animated:YES];
		[imagePickerController release];		
	}	
}


#pragma mark -
#pragma mark imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	NSLog(@"info:%@",[info description]);
	
	//图片对象
	if ([mediaType isEqualToString:@"public.image"])
	{
		UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];//编辑后的照片
		if(!image)image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//原始照片
		
		//save to PhotosAlbum
		if (sourceType == UIImagePickerControllerSourceTypeCamera) {
			UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
		}
		if (parentViewController && [parentViewController respondsToSelector:@selector(setImage:)]) {
			[parentViewController performSelector:@selector(setImage:) withObject:image];
		}
	}
	[picker dismissModalViewControllerAnimated:NO];
}

@end
