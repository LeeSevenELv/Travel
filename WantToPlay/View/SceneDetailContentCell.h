//
//  SceneDetailContentCell.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneDetailModel.h"

@interface SceneDetailContentCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UIButton *traffic;
- (IBAction)traffic:(UIButton *)sender;

@property (nonatomic, weak) UIViewController *VC;
- (void)showDataWithModel:(SceneDetailModel *)model withVC:(UIViewController *)VC;

@end
