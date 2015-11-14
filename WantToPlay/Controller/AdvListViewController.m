//
//  AdvListViewController.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "AdvListViewController.h"
#import "RecommandItemModel.h"
#import "AdCell.h"
#import "WeeklyDetailViewController.h"

@interface AdvListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSString *url;

@end

@implementation AdvListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self loadDataIsRefresh:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:kThemeColor];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"AdCell" bundle:nil] forCellWithReuseIdentifier:@"AdCell"];
    [self.view addSubview:self.collectionView];
}



#pragma mark - 网络数据下载、解析
- (void)loadDataIsRefresh:(BOOL)isRefresh {
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleNone];
    [MMProgressHUD showWithTitle:@"" status:@""];
    
    [self createURL];
    [self.manager GET:self.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = root[@"data"][@"items"];
        NSLog(@"%@", array);
        if (array.count!=0) {
            for (NSDictionary *dict in array) {
                RecommandItemModel *model = [[RecommandItemModel alloc] initWithDictionary:dict error:nil];
                [self.dataArray addObject:model];
            }
        }
        
        [self.collectionView reloadData];
        [MMProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"af error4!");
        [MMProgressHUD dismiss];
    }];
}
- (void)createURL {
    self.url = [NSString stringWithFormat:kScrollAdvURL, self.id];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommandItemModel *model = [self.dataArray objectAtIndex:indexPath.row];
    CGFloat labelHeight = [LeeHelper textHeightFromTextString:model.desc width:kScreenSize.width-116 fontSize:15];
    if (labelHeight < 20) {
        labelHeight = 20;
    }
    return CGSizeMake(kScreenSize.width, (kScreenSize.width)*254/375.0 - 20 + labelHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 0, 5, 0);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AdCell" forIndexPath:indexPath];
    RecommandItemModel *model = self.dataArray[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommandItemModel *model = self.dataArray[indexPath.row];
    WeeklyDetailViewController *controller = [[WeeklyDetailViewController alloc] init];
    controller.id = model.recommend.id;
    [self.navigationController pushViewController:controller animated:YES];
}
    @end
