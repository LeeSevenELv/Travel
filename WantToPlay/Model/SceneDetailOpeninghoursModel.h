//
//  SceneDetailOpeninghoursModel.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "JSONModel.h"

@interface SceneDetailOpeninghoursModel : JSONModel

@property (nonatomic, copy) NSString *peakSeason;
@property (nonatomic, copy) NSString *lowSeason;

@end
