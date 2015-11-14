//
//  SceneDetailTrafficInfoModel.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "JSONModel.h"

@interface SceneDetailTrafficInfoModel : JSONModel

@property (nonatomic, copy) NSString *coordinate;
@property (nonatomic, copy) NSString *busLines;
@property (nonatomic, copy) NSString *carLines;

@end
