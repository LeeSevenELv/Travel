//
//  ProgressHUD.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "ProgressHUD.h"
#import <objc/runtime.h>

@implementation ProgressHUD

+ (instancetype)progressWithTitle:(NSString *)title Frame:(CGRect)frame {
    ProgressHUD *progress = [[ProgressHUD alloc] initWithFrame:frame];
    progress.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-50)/2, (frame.size.height-50)/2, 50, 50)];
    imageView.image = [UIImage imageNamed:@"compass_spinner"];
    [progress addSubview:imageView];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    animation.duration = 2;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    [imageView.layer addAnimation:animation forKey:@"transform.rotation.z"];
    return progress;
}


@end
