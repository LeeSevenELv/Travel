//
//  WeeklyDetailViewController.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "BaseViewController.h"
#import "RecommandItemModel.h"

@interface WeeklyDetailViewController : BaseViewController

@property (nonatomic, copy) NSString *id;
@property (nonatomic) RecommandItemModel *model;
@end
