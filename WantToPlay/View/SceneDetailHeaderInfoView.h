//
//  SceneDetailHeaderInfoView.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneDetailModel.h"

@interface SceneDetailHeaderInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

/**用于scene*/
- (void)showDataWithModel:(SceneDetailModel *)model;

/**用于weekly*/
- (void)showDataWithName:(NSString *)name subTitle:(NSString *)subTitle;

@end
