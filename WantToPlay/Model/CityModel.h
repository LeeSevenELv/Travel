//
//  CityModel.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSNumber *id;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *province;
@property (nonatomic) BOOL isHot;

@end
