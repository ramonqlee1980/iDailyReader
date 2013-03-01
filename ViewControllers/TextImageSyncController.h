//
//  TextImageSyncController.h
//  com.idreems.mrh
//
//  Created by ramonqlee on 2/3/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import "CollectionViewController.h"

@interface TextImageSyncController : CollectionViewController
{
    NSString* resourceUrl;
    NSString* resourceName;
}
@property(nonatomic,retain) NSString* resourceUrl;
@property(nonatomic,retain) NSString* resourceName;
@end
