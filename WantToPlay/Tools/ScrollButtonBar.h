//
//  ScrollButtonBar.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^BlockType)(UIButton *button);

@interface ScrollButtonBar : UIScrollView

- (instancetype)initWithTitles:(NSArray *)titles viewFrame:(CGRect)frame handle:(BlockType)handle;

@end
