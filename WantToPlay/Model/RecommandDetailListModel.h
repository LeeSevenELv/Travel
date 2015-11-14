//
//  RecommandDetailListModel.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "JSONModel.h"
#import "RecommandItemModel.h"
@interface RecommandDetailListModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *subtitle;
@property (nonatomic, copy) NSString<Optional> *fav;
@property (nonatomic) NSArray<RecommandItemModel, Optional> *items;

@end
