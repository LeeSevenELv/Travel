//
//  SceneListCell.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "SceneListCell.h"
#import <CoreLocation/CoreLocation.h>

extern CLLocation *currentLocation;

@implementation SceneListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)showDataWithModel:(SceneModel *)model {
    
    self.name.text = model.name;
    
    //价格判定
    if (model.price.doubleValue == 0) {
        self.price.text = @"免费";
    } else if (model.price.doubleValue < 0) {
        self.price.text = @"暂无";
    } else {
        self.price.text = [NSString stringWithFormat:@"￥%@", model.price];
    }
    
    //定位计算距离
    if (currentLocation) {
        double lon = [model.lngLatitude[0] doubleValue];
        double lat = [model.lngLatitude[1] doubleValue];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        double distance = [location distanceFromLocation:currentLocation];
        
        self.address.text = [NSString stringWithFormat:@"%@ %.2fkm", model.district, distance/1000];
    } else {
        self.address.text = [NSString stringWithFormat:@"%@ ? km", model.district];
    }
    
    
    NSMutableString *str = [NSMutableString stringWithString:kImageURL];
    [str appendString:[NSString stringWithFormat:@"%@", model.headImg]];
    NSURL *url = [NSURL URLWithString:str];
    [self.headimg sd_setImageWithURL:url];
    
}


@end
