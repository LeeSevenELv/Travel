//
//  RecommandModel.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "JSONModel.h"

@interface RecommandModel : JSONModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic) NSInteger fav;
//@property (nonatomic) BOOL isFav;
@property (nonatomic, copy) NSString *type;

@end
