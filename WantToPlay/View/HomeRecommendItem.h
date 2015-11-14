//
//  HomeRecommendItem.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommandDetailListModel.h"

@interface HomeRecommendItem : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *BackImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;

- (void)showDataWithModel:(RecommandItemModel *)model;
@end
