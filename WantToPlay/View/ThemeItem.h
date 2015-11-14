//
//  ThemeItem.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeThemeModel.h"
@interface ThemeItem : UIView
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)button:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) HomeThemeModel *model;
@property (nonatomic, weak) UIViewController *VC;
@end
