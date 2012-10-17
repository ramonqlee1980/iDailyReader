//
//  SinaStatusUpload.h
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/23/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

//对应sina的v2版本API statuses/upload
//上传图片并发布一条新微博



#import "../MSSinaWeiboPackage.h"

@interface MSSinaStatusUpload : MSSinaWeiboPackage
{
@private
    NSString* picPath;
}
@end
