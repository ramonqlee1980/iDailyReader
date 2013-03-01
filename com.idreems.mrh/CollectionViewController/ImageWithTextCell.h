//
//  ImageWithTextCell.h
//  com.idreems.mrh
//
//  Created by ramonqlee on 2/3/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import "PSCollectionViewCell.h"
#define kPlaceholderImage @"loadingImage_50x118.png"

@class ResponseJson;
@interface ImageWithTextCell : PSCollectionViewCell
{
    ResponseJson* response;
    UIImageView* centerimageView;
    UILabel* label;
    UIImageView* footerView;
    UIImageView* imageView;
    UIButton* shareButton;
}
@property(nonatomic,retain)ResponseJson* response;
@property(nonatomic,assign)UIImageView* centerimageView;
@property(nonatomic,assign)UILabel* label;
@property(nonatomic,assign)UIImageView* imageView;
@property(nonatomic,assign)UIImageView* footerView;
@property(nonatomic,assign)UIButton* shareButton;

+(CGSize)measureCell:(ResponseJson*)status width:(CGFloat)width;
@end
