//
//  SceneDetailModel.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "JSONModel.h"
#import "SceneDetailTicketModel.h"
#import "SceneDetailAddressModel.h"
#import "SceneDetailContactModel.h"
#import "SceneDetailOpeninghoursModel.h"
#import "SceneDetailTrafficInfoModel.h"


@interface SceneDetailModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *duration;
@property (nonatomic, copy) NSString<Optional> *fav;
@property (nonatomic, copy) NSString<Optional> *headImg;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *suggestTime;
@property (nonatomic) NSArray<Optional> *lngLatitude;
@property (nonatomic) SceneDetailTicketModel<Optional> *tickets;
@property (nonatomic) SceneDetailAddressModel<Optional> *address;
@property (nonatomic) SceneDetailContactModel<Optional> *contact;
@property (nonatomic) SceneDetailOpeninghoursModel<Optional> *openinghours;
@property (nonatomic) SceneDetailTrafficInfoModel<Optional> *trafficInfo;

@end
