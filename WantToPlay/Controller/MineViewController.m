//
//  MineViewController.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MineViewController.h"
#import "CollectViewController.h"
//#import "UserModel.h"
//#import "LoginViewController.h"

//extern UserModel *currentUser;

@interface MineViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    NSArray *_titles;
}
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic) UIImageView *imageView;
//@property (nonatomic) UIImageView *userHeaderView;
//@property (nonatomic) UILabel *nameLabel;
//@property (nonatomic) UIButton *button;


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray arrayWithArray:@[@[@"我的攻略", @"我的景点"], @[@"清除缓存", @"联系我们"]]];
    [self createUI];
}


- (void)createUI {
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame: CGRectMake(0, 100, 100, 100)];
    [button setTitle:@"登陆" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setFrame: CGRectMake(kScreenSize.width - 100, 100, 100, 100)];
    [button1 setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:button1];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 300) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"setting"];
    [self.tableView reloadData];
    [self.view addSubview:self.tableView];
    
  
    
}


#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        CollectViewController *controller = [[CollectViewController alloc] init];
        controller.title = indexPath.row ? @"我的景点" : @"我的攻略";
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        NSString *title = [NSString stringWithFormat:@"删除缓存文件:%.5fM",[self getCachesSize]];
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
}

#pragma mark - 获取缓存大小
- (double)getCachesSize {
    //NSLog(@"%@", NSHomeDirectory());
    double sdSize = [[SDImageCache sharedImageCache] getSize];
    double totalSize = sdSize/1024/1024;//转化为M
    return totalSize;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        //删除sd的
        //清除内存中的图片缓存
        [[SDImageCache sharedImageCache] clearMemory];
        //清除磁盘上的图片缓存
        [[SDImageCache sharedImageCache] clearDisk];
    }
}


@end
