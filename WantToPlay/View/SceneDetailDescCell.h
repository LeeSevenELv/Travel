//
//  SceneDetailDescCell.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneDetailDescCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *price;
- (void)showDataWithTitle:(NSString *)price;

@end
