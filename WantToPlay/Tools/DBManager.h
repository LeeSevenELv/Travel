//
//  DBManager.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+ (instancetype)sharedManager;
- (BOOL)addWeekly:(NSString *)sid name:(NSString *)name img:(NSString *)img;
- (BOOL)addScene:(NSString *)sid name:(NSString *)name img:(NSString *)img;
- (BOOL)selectSceneById:(NSString *)sid;
- (BOOL)selectWeeklyById:(NSString *)sid;
- (BOOL)deleteSceneById:(NSString *)sid;
- (BOOL)deleteWeeklyById:(NSString *)sid;
- (NSMutableArray *)selectAllWeekly;
- (NSMutableArray *)selectAllScene;

@end
