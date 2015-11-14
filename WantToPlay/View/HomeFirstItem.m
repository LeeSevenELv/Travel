//
//  HomeFirstItem.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "HomeFirstItem.h"
#import "HomeAdvModel.h"
#import "AdvListViewController.h"
#import "WeeklyDetailViewController.h"

@interface HomeFirstItem ()

@property (weak, nonatomic) IBOutlet ScrollAdv *scrollAdv;
@property (nonatomic) CGFloat advRatio;
@end

@implementation HomeFirstItem

- (void)awakeFromNib {
    // Initialization code
    self.advRatio = 132/375.0;
}

- (void)showDataWithModel:(HomeModel *)model controller:(UIViewController *)VC{
    self.VC = VC;
    if ([model isKindOfClass:[HomeModel class]]) {
        //添加主题按钮
        [self addThemeItemWithModel:model controller:VC];
        
        //准备scrollAdv的数据
        NSMutableArray *images = [NSMutableArray array];
        NSMutableArray *titles = [NSMutableArray array];
        for (NSInteger i = 0; i < model.indexBanner.count; i++) {
            NSString *url = [NSString stringWithFormat:@"%@%@", kImageURL, [model.indexBanner[i] img]];
            NSString *name = [model.indexBanner[i] name];
            [images addObject:url];
            [titles addObject:name];
        }
        NSArray *models = model.indexBanner;
        __weak typeof(self.VC) controller = self.VC;
        
        [self.scrollAdv showDataWithImages:images model:models titles:titles handle:^(id model) {
            HomeAdvModel *AdvModel = (HomeAdvModel *)model;
            if ([AdvModel.type isEqualToString:@"weekly"]) {
                AdvListViewController *advVC = [[AdvListViewController alloc] init];
                advVC.id = AdvModel.to;
                [controller.navigationController pushViewController:advVC animated:YES];
            } else {
                AdvListViewController *listVC = [[AdvListViewController alloc] init];
                listVC.id = AdvModel.to;
                [controller.navigationController pushViewController:listVC animated:YES];
            }
            NSLog(@"%@", AdvModel);
        }];
    }
}
- (void)addThemeItemWithModel:(HomeModel *)model controller:(UIViewController *)VC{
    NSArray *indexWhat = model.indexWhat;
    NSArray *images = @[@"home_climb_img", @"home_old_town_img", @"home_humanities_img", @"home_barbecue_img", @"home_summer_img", @"home_CS_img"];
    
    //计算布局
    CGFloat itemWith = 60;
    CGFloat itemHeight = 60;
    CGFloat lx = 20;
    CGFloat ty = self.frame.size.width*self.advRatio;
    CGFloat edge = (self.frame.size.height - ty - 2*itemHeight)/3.0;
    ty = ty + edge;
    CGFloat rx = self.frame.size.width - lx - itemWith;
    CGFloat cx = (self.frame.size.width - itemWith)/2.0;
    double xArray[3] = {lx, cx, rx};
    
    //清空原来的themeItem
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[ThemeItem class]]) {
            [view removeFromSuperview];
        }
    }
    
    //添加新的themeItem
    //原代码 for (NSInteger i = 0; i < model.indexWhat.count;
    for (NSInteger i = 0; i < 6; i++) { //原代码 i < model.indexWhat.count;
        ThemeItem *item = [[[NSBundle mainBundle] loadNibNamed:@"ThemeItem" owner:nil options:nil] lastObject];
        item.frame = CGRectMake(xArray[i%3], ty+(i/3)*(itemHeight+edge), itemWith, itemHeight);
        item.model = indexWhat[i];
        item.VC = VC;
        item.titleLabel.text = item.model.name;
        [item.button setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [self addSubview:item];
    }
}



@end
