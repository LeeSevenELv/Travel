//
//  TabBarViewController.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "GiftViewController.h"
#import "MineViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    
//    NSArray *vcNames = @[@"HomeViewController", @"GiftViewController class", @"MineViewController class"];
//    NSArray *titleArr = @[@"首页", @"精品", @"我的"];
//    NSArray *imageArr = @[@"home",@"choiceness",@"mine"];
//    NSArray *selecrImageArr = @[@"home_h",@"choiceness_h",@"mine_h"];
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < vcNames.count; i++) {
//        Class cls = NSClassFromString(vcNames[i]);
//        UIViewController *vc = [[cls alloc] init];
//        vc.title = titleArr[i];
//        vc.view.backgroundColor = [UIColor lightGrayColor];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//        nav.navigationBar.barTintColor = kThemeColor;
//        nav.navigationBar.tintColor = [UIColor whiteColor];
////        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:titleArr[i] image:imageArr[i] selectedImage:selecrImageArr[i]];
//        [array addObject:nav];
//    }
//    self.viewControllers = array;
    
    self.tabBar.tintColor = kThemeColor;
    
    NSArray *VCArr = @[@"HomeViewController", @"GiftViewController", @"MineViewController"];
    NSArray *titleArr = @[@"首页", @"精品", @"我的"];
    NSMutableArray *subArr = [NSMutableArray array];
    
    //首页
    Class VCclass = NSClassFromString(VCArr[0]);
    UIViewController *controller = [[VCclass alloc] init];
    controller.title = titleArr[0];
    controller.view.backgroundColor = [UIColor lightGrayColor];
    UINavigationController *niv = [[UINavigationController alloc] initWithRootViewController:controller];
    
    //导航条染色
    niv.navigationBar.barTintColor = kThemeColor;
    niv.navigationBar.tintColor = [UIColor whiteColor];
    [niv.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    niv.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:[UIImage imageNamed:@"home"] selectedImage:[UIImage imageNamed:@"home_h"]];
    [subArr addObject:niv];
    
    
    //精品
    VCclass = NSClassFromString(VCArr[1]);
    controller = [[VCclass alloc] init];
    controller.title = titleArr[1];
    //controller.view.backgroundColor = [UIColor lightGrayColor];
    niv = [[UINavigationController alloc] initWithRootViewController:controller];
    
    //导航条染色
    niv.navigationBar.barTintColor = kThemeColor;
    niv.navigationBar.tintColor = [UIColor whiteColor];
    [niv.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    niv.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"精品" image:[UIImage imageNamed:@"choiceness"] selectedImage:[UIImage imageNamed:@"choiceness_h"]];
    [subArr addObject:niv];
    
    //用户
    VCclass = NSClassFromString(VCArr[2]);
    controller = [[VCclass alloc] init];
    controller.title = titleArr[2];
    niv = [[UINavigationController alloc] initWithRootViewController:controller];
    
    //导航条染色
    niv.navigationBar.barTintColor = kThemeColor;
    niv.navigationBar.tintColor = [UIColor whiteColor];
    [niv.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    niv.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"mine"] selectedImage:[UIImage imageNamed:@"mine_h"]];
    [subArr addObject:niv];
    
    self.viewControllers = subArr;
    self.tabBar.contentMode = UIViewContentModeScaleToFill;
}




@end
