//
//  HomeSectionHeader.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "HomeSectionHeader.h"

@implementation HomeSectionHeader

- (void)awakeFromNib {
    // Initialization code
}

- (void)showDataWithModel:(RecommandDetailListModel *)model {
    
    self.title.text = [NSString stringWithFormat:@"「%@」", model.name];
    self.subTitle.text = model.subtitle;
}

@end
