//
//  RecommandItemModel.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "JSONModel.h"
#import "RecommandModel.h"
@protocol RecommandItemModel <NSObject>
@end
@interface RecommandItemModel : JSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic) RecommandModel *recommend;
@end
