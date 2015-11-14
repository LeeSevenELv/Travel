//
//  SceneModel.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "JSONModel.h"

@interface SceneModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *id;
@property (nonatomic, copy) NSString<Optional> *price;
@property (nonatomic, copy) NSString<Optional> *district;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic) NSInteger fav;
@property (nonatomic, copy) NSString<Optional> *headImg;
@property (nonatomic) NSArray<Optional> *lngLatitude;

@end
