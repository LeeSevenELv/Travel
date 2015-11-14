//
//  UserModel.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "JSONModel.h"

@interface UserModel : JSONModel
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *nickname;
@end
