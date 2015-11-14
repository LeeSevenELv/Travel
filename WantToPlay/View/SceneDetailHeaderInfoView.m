//
//  SceneDetailHeaderInfoView.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "SceneDetailHeaderInfoView.h"
#import <CoreLocation/CoreLocation.h>
extern CLLocation *currentLocation;

@implementation SceneDetailHeaderInfoView

- (void)showDataWithModel:(SceneDetailModel *)model {
    
    self.nameLabel.text = model.name;
    if (currentLocation) {
        double lon = [model.lngLatitude[0] doubleValue];
        double lat = [model.lngLatitude[1] doubleValue];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        double distance = [location distanceFromLocation:currentLocation];
        
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", distance/1000];
    } else {
        self.distanceLabel.text = [NSString stringWithFormat:@" ? km"];
    }
}
- (void)showDataWithName:(NSString *)name subTitle:(NSString *)subTitle {
    self.nameLabel.text = name;
    self.distanceLabel.text = subTitle;
    CGRect frame = self.markImageView.frame;
    frame.size.width = 13;
    frame.size.height = 13;
    self.markImageView.frame = frame;
    self.markImageView.image = [UIImage imageNamed:@"home_label.png"];
}





@end
