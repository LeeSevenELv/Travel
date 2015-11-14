//
//  SceneDetailTipCell.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "SceneDetailTipCell.h"

@implementation SceneDetailTipCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)showDataWithTicket:(NSString *)ticket open:(NSString *)openhour suggest:(NSString *)suggest duration:(NSString *)duration {
    
    self.ticket.text = ticket;
    self.openningHourLabel.text = openhour;
    self.durationLabel.text = duration;
    self.suggetLabel.text = suggest;
    
}

@end
