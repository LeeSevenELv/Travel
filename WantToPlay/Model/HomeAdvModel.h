//
//  HomeAdvModel.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "JSONModel.h"
@protocol HomeAdvModel
@end
@interface HomeAdvModel : JSONModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *type;
@end
