//
//  HomeThemeModel.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "JSONModel.h"
@protocol HomeThemeModel
@end
@interface HomeThemeModel : JSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;

@end
