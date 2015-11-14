//
//  HomeSectionHeader.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommandDetailListModel.h"

@interface HomeSectionHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;


- (void)showDataWithModel :(RecommandDetailListModel *)model;

@end
