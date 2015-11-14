//
//  HomeModel.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "JSONModel.h"
#import "HomeThemeModel.h"
#import "HomeAdvModel.h"
@interface HomeModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *cityId;
@property (nonatomic, copy) NSString<Optional> *cityName;
//@property (nonatomic) NSArray *openCity;
@property (nonatomic) NSArray<HomeThemeModel, Optional> *indexWhat;
@property (nonatomic) NSArray<HomeAdvModel, Optional> *indexBanner;

@end
