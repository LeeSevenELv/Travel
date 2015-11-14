//
//  AdCell.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommandItemModel.h"

@interface AdCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headimageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

- (void)showDataWithModel:(RecommandItemModel *)model;

@end
