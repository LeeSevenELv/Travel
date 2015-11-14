//
//  AdCell.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "AdCell.h"

@implementation AdCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)showDataWithModel:(RecommandItemModel *)model {
    
    self.nameLabel.text = model.name;
    self.descLabel.text = model.desc;
    NSString *url = [NSString stringWithFormat:@"%@%@", kImageURL, model.img];
    [self.headimageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"header"]];
    
}

@end
