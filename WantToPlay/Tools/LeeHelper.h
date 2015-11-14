//
//  LeeHelper.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeeHelper : NSObject

+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;
//获取iOS版本号
+ (double)getCurrentIOS;
+ (BOOL)IsChinese:(NSString *)str;

@end
