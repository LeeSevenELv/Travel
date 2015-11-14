//
//  SceneDetailTipCell.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneDetailTipCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *ticket;
@property (weak, nonatomic) IBOutlet UILabel *openningHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *suggetLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

- (void)showDataWithTicket:(NSString *)ticket open:(NSString *)openhour suggest:(NSString *)suggest duration:(NSString *)duration;

@end
