//
//  HistoricalImageController.h
//  com.idreems.mrh
//
//  Created by ramonqlee on 1/1/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import "WaterFlowController.h"
#import "PopupTableView.h"

@interface HistoricalImageController : WaterFlowController<PopupTableViewDelegate>
@property (retain, nonatomic) NSArray *options;
@end
