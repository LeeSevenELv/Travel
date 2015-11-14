//
//  ScrollAdv.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HandleType)(id model);

@interface ScrollAdv : UIView

@property (nonatomic, copy) HandleType handle;
@property (nonatomic) CGFloat pageControlHeight;

//- (void)startAutoScroll:(BOOL)start timeInterval:(NSTimeInterval) interval;

- (void)showDataWithImages:(NSMutableArray *)images model:(NSArray *)models titles:(NSArray *)titles handle:(HandleType)handle;

@end
