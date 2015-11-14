//
//  HomeRecommendItem.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "HomeRecommendItem.h"

@implementation HomeRecommendItem

- (void)awakeFromNib {
    // Initialization code
    self.BackImageView.layer.cornerRadius = 5;
    self.BackImageView.layer.masksToBounds = YES;
}

- (void)showDataWithModel:(RecommandItemModel*)model {
    
    [self.BackImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImageURL, model.img]] placeholderImage:nil];
    
    self.name.text = model.name;
    
}


@end
