//
//  ProgressHUD.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressHUD : UIView
+ (instancetype)progressWithTitle:(NSString *)title Frame:(CGRect)frame;
- (void)startAnimation;
@end
