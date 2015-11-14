//
//  SceneDetailDescCell.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "SceneDetailDescCell.h"

@implementation SceneDetailDescCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)showDataWithTitle:(NSString *)price {
    
    //价格判定
    if (price.doubleValue == 0) {
        self.price.text = @"免费";
    } else if (price.doubleValue < 0) {
        self.price.text = @"暂无";
    } else {
        self.price.text = [NSString stringWithFormat:@"￥%@", price];
    }
}
    

@end
