//
//  SceneDetailTicketModel.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "JSONModel.h"

@interface SceneDetailTicketModel : JSONModel

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *desc;

@end
