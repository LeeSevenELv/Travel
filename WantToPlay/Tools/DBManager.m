//
//  DBManager.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"
#import "CollectScene.h"
@interface DBManager ()
{
    FMDatabase *_dataBase;
}
@end

@implementation DBManager

+ (instancetype)sharedManager {
    static DBManager *manager = nil;
    @synchronized (self) {
        if (manager == nil) {
            manager = [[DBManager alloc] init];
        }
    }
    return manager;
}

- (id)init {
    if (self = [super init]) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *dbPath = [documentPath stringByAppendingPathComponent:@"Data.db"];
        
        _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
        
        if ([_dataBase open]) {
            NSString *sql0 = @"create table if not exists weekly(sid varchar(128) primary key, name text, img text)"; // blob：存放二进制，data
            if ([_dataBase executeUpdate:sql0]) {
                NSLog(@"成功创建表格 weekly");
            }
            NSString *sql1 = @"create table if not exists scene(sid varchar(128) primary key, name text, img text)";
            if ([_dataBase executeUpdate:sql1]) {
                NSLog(@"成功创建表格 scene");
            }
        }
        [_dataBase close];
    }
    return self;
}

- (BOOL)addWeekly:(NSString *)sid name:(NSString *)name img:(NSString *)img {
    if (![_dataBase open]) {
        return NO;
    }
    NSString *sql = @"insert into weekly values(?,?,?)";
    
    BOOL success = [_dataBase executeUpdate:sql, sid, name, img];
    if (success) {
        NSLog(@"成功插入一条weekly数据");
    }
    [_dataBase close];
    return success;
}

- (BOOL)addScene:(NSString *)sid name:(NSString *)name img:(NSString *)img {
    if (![_dataBase open]) {
        return NO;
    }
    NSString *sql = @"insert into scene values(?,?,?)";
    
    BOOL success = [_dataBase executeUpdate:sql, sid, name, img];
    if (success) {
        NSLog(@"成功插入一条weekly数据");
    }
    [_dataBase close];
    return success;
}
- (BOOL)selectSceneById:(NSString *)sid {
    if ([_dataBase open] == NO) {
        return nil;
    }
    
    NSString *sql = @"select * from scene where sid=?";
    FMResultSet *set = [_dataBase executeQuery:sql, sid];
    BOOL have = set.next;
    [_dataBase close];
    return have;
}
- (BOOL)selectWeeklyById:(NSString *)sid {
    if ([_dataBase open] == NO) {
        return nil;
    }
    
    NSString *sql = @"select * from weekly where sid=?";
    FMResultSet *set = [_dataBase executeQuery:sql, sid];
    BOOL have = set.next;
    [_dataBase close];
    return have;
}
- (BOOL)deleteSceneById:(NSString *)sid {
    if ([_dataBase open] == NO) {
        return NO;
    }
    NSString *sql = @"delete from scene where sid=?";
    BOOL success = [_dataBase executeUpdate:sql, sid];
    [_dataBase close];
    if (success) NSLog(@"成功删除收藏");
    return success;
}
- (BOOL)deleteWeeklyById:(NSString *)sid {
    if ([_dataBase open] == NO) {
        return NO;
    }
    NSString *sql = @"delete from weekly where sid=?";
    BOOL success = [_dataBase executeUpdate:sql, sid];
    [_dataBase close];
    if (success) NSLog(@"成功删除收藏");
    return success;
}
- (NSMutableArray *)selectAllWeekly {
    if ([_dataBase open] == NO) {
        return nil;
    }
    NSString *sql = @"select * from weekly";
    FMResultSet *set = [_dataBase executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        CollectScene *model = [[CollectScene alloc] init];
        model.sid = [set stringForColumn:@"sid"];
        model.name = [set stringForColumn:@"name"];
        model.img  = [set stringForColumn:@"img"];
        [array addObject:model];
    }
    [_dataBase close];
    return array;
}
- (NSMutableArray *)selectAllScene {
    if ([_dataBase open] == NO) {
        return nil;
    }
    NSString *sql = @"select * from scene";
    FMResultSet *set = [_dataBase executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        CollectScene *model = [[CollectScene alloc] init];
        model.sid = [set stringForColumn:@"sid"];
        model.name = [set stringForColumn:@"name"];
        model.img  = [set stringForColumn:@"img"];
        [array addObject:model];
    }
    [_dataBase close];
    return array;
}


@end
