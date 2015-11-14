//
//  ThemeItem.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "ThemeItem.h"
#import "SceneLisrtViewController.h"

@implementation ThemeItem

- (IBAction)button:(id)sender {
    if (self.model) {
        SceneLisrtViewController *controller = [[SceneLisrtViewController alloc] init];
        controller.id = self.model.id;
        controller.title = self.model.name;
        [self.VC.navigationController pushViewController:controller animated:YES];
    }

    
}
@end
