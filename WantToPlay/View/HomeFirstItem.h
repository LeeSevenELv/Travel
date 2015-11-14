//
//  HomeFirstItem.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeItem.h"
#import "HomeModel.h"
#import "ScrollAdv.h"
@interface HomeFirstItem : UICollectionViewCell

@property (nonatomic, weak) UIViewController *VC;
- (void)showDataWithModel:(HomeModel *)model controller:(UIViewController *)VC;

@end
