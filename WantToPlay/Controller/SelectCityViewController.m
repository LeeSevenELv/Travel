//
//  SelectCityViewController.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "SelectCityViewController.h"
#import "CityModel.h"


extern NSMutableArray *cityArray;
extern NSMutableArray *cityIndexes;
extern NSString *currentCityID;
extern NSString *currentCity;
extern NSMutableArray *resultCityModelArray;
@interface SelectCityViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *sourceArray;
@property (nonatomic) NSArray *sourceIndexArray;
@property (nonatomic) NSMutableArray *indexArray;
@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _sourceArray = [NSMutableArray arrayWithArray:cityArray];
    _sourceIndexArray = [NSArray arrayWithArray:cityIndexes];
    
    self.dataArray = [NSMutableArray arrayWithArray:cityArray];
    self.indexArray = [NSMutableArray arrayWithArray:cityIndexes];
    
    [self initUI];
}
- (void)initUI {
    [self createTableView];
    [self createNavLeftBarbutton];
}
- (void)createNavLeftBarbutton {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(back:)];
}
- (void)back:(id)sender {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)createTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:_tableView];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    searchBar.placeholder = @"请输入城市名称";
    searchBar.delegate = self;
    [searchBar setShowsCancelButton:YES animated:YES];
    self.navigationItem.titleView = searchBar;
}
- (NSMutableArray *)sourceArray {
    if (_sourceArray == nil) {
        _sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
}
#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    CityModel *model = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = model.name;
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.indexArray[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (NSArray *)tableViewAtIndexes:(NSIndexSet *)indexes {
    return nil;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArray;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CityModel *model = self.dataArray[indexPath.section][indexPath.row];
    currentCityID = [model.id stringValue];
    currentCity = model.name;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCity" object:nil];
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    //animation.duration = 0.3;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - <UISearcharBarDelegate>
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //显示 cancel 按钮
    //[searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    //隐藏cancel 按钮
    //[searchBar setShowsCancelButton:NO animated:YES];
    return YES;//可以结束编辑模式
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";//清空内容
    //收键盘
    [searchBar resignFirstResponder];
    self.dataArray = [NSMutableArray arrayWithArray:_sourceArray];
    self.indexArray = [NSMutableArray arrayWithArray:_sourceIndexArray];
    [self.tableView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    for (CityModel *model in resultCityModelArray) {
        if ([searchBar.text isEqualToString:model.name]) {
            self.dataArray = [NSMutableArray arrayWithObject:@[model]];
            self.indexArray = [NSMutableArray arrayWithObject:[[NSString alloc]init]];
            [self.tableView reloadData];
            [searchBar resignFirstResponder];
            return;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
