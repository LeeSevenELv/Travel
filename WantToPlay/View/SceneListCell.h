//
//  SceneListCell.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneModel.h"

@interface SceneListCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headimg;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *name;

- (void)showDataWithModel:(SceneModel *)model;

@end
