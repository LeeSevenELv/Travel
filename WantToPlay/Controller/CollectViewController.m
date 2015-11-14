//
//  CollectViewController.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/13.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "CollectViewController.h"

@interface CollectViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self loadDataFromDB];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:kThemeColor];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectCell" bundle:nil] forCellReuseIdentifier:@"CollectCell"];
    self.tableView.tableFooterView = nil;
    [self.view addSubview:self.tableView];
}
- (void)loadDataFromDB {
//    self.dataArray = [self.title isEqualToString:@"我的攻略"] ? [[DBManager sharedManager] selectAllWeekly] : [[DBManager sharedManager] selectAllScene];
    if ([self.title isEqualToString:@"我的攻略"]) {
        self.dataArray = [[DBManager sharedManager] selectAllScene];
    }else {
        self.dataArray = [[DBManager sharedManager] selectAllWeekly];
    }
}
#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kScreenSize.width-10)*205/365.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectCell" forIndexPath:indexPath];
    CollectScene *model = self.dataArray[indexPath.row];
    cell.name.text = model.name;
    cell.mask.text = [self.title isEqualToString:@"我的攻略"] ? @"我的攻略" : @"我的景点";
    NSString *url = [NSString stringWithFormat:@"%@%@", kImageURL, model.img];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:url]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CollectScene *model = self.dataArray[indexPath.row];
    
    if ([self.title isEqualToString:@"我的攻略"]) {
        WeeklyDetailViewController *controller = [[WeeklyDetailViewController alloc] init];
        controller.id = model.sid;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        SceneDetailViewController *controller = [[SceneDetailViewController alloc] init];
        controller.id = model.sid;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectScene *model = self.dataArray[indexPath.row];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    
    if ([self.title isEqualToString:@"我的攻略"]) {
        [[DBManager sharedManager] deleteWeeklyById:model.sid];
    } else {
        [[DBManager sharedManager] deleteSceneById:model.sid];
    }
    
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
    [tableView reloadData];
}
@end
