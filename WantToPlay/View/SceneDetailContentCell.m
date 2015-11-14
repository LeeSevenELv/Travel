//
//  SceneDetailContentCell.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "SceneDetailContentCell.h"
#import "MapViewController.h"

@interface SceneDetailContentCell ()
@property (nonatomic) SceneDetailModel *model;
@end

@implementation SceneDetailContentCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.addressLabel addGestureRecognizer:tap];
}
- (void)tap:(UITapGestureRecognizer *)tap {
    NSLog(@"%@", _model.lngLatitude);
    MapViewController *mapVC = [[MapViewController alloc] init];
    mapVC.lonlat = _model.lngLatitude;
    [self.VC.navigationController pushViewController:mapVC animated:YES];
}

- (void)showDataWithModel:(SceneDetailModel *)model withVC:(UIViewController *)VC{
    self.model = model;
    self.VC = VC;
    self.addressLabel.text = model.address.detail;
    [self.contactButton setTitle:model.contact.phone forState:UIControlStateNormal];
    
}

- (IBAction)traffic:(UIButton *)sender {
    
}
@end
