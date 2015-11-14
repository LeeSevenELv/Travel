//
//  SceneLisrtViewController.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "SceneLisrtViewController.h"
#import "SceneModel.h"
#import "SceneListCell.h"
#import "SceneDetailViewController.h"
#import <CoreLocation/CoreLocation.h>

extern CLLocation *currentLocation;
extern NSMutableArray *themeItems;
extern NSString *currentCityID;
@interface SceneLisrtViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSString *url;

@end

@implementation SceneLisrtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self loadDataIsRefresh:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:kThemeColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    [self.view setNeedsDisplay];
}
- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SceneListCell" bundle:nil] forCellWithReuseIdentifier:@"SceneListCell"];
    [self.view addSubview:self.collectionView];
    
    [self creatRefreshUI];
    [self createLoadMoreUI];
}



#pragma mark - 网络数据下载、解析
- (void)loadDataIsRefresh:(BOOL)isRefresh {
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleNone];
    
    [self createURL];
    [self.manager GET:self.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = root[@"data"][@"list"];
        
        if (isRefresh) {
            [self.dataArray removeAllObjects];
            [MMProgressHUD showWithTitle:@"" status:@""];
        }
        for (NSDictionary *dict in array) {
            SceneModel *model = [[SceneModel alloc] initWithDictionary:dict error:nil];
            [self.dataArray addObject:model];
        };
        [self.collectionView reloadData];
        [self endRefreshing];
        [MMProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"af error8!");
        [MMProgressHUD dismiss];
    }];
}
- (void)createURL {
    //精品界面复用此界面时，需自己提供self.id
    //if (!self.id) self.id = themeItems[2][0];
    
    self.url = [NSString stringWithFormat:kSceneListURL, self.currentPage, currentCityID, self.id];
}
- (void)requestIdFromThemeItems {
    if (self.title==nil) {
        NSArray *titles = (NSArray *)themeItems[1];
        NSArray *idArray = (NSArray *)themeItems[2];
        for (NSInteger i = 0; i < titles.count; i++) {
            if ([self.title isEqualToString:titles[i]]) {
                self.id = idArray[i];
            }
        }
        NSLog(@"%@", self.id);
    }
}
#pragma mark - 刷新 加载更多
- (void)creatRefreshUI {
    //增加下拉刷新
    
    //下面使用block 如果内部对self 进行操作 会存在 两个强引用 这样两个对象都不会释放导致内存泄露 (或者死锁就是两个对象不释放)
    //只要出现了循环引用 必须一强一弱 这样用完之后才会释放
    //arc 用 __weak  mrc __block
    
    __weak typeof (self) weakSelf = self;//弱引用
    
    [self.collectionView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //重新下载数据
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;//标记正在刷新
        weakSelf.currentPage = 0;
        
        [weakSelf loadDataIsRefresh:YES];
    }];
}
- (void)createLoadMoreUI {
    __weak typeof (self) weakSelf = self;//弱引用
    //上拉加载更多
    [self.collectionView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //重新下载数据
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;//标记正在刷新
        weakSelf.currentPage ++;//页码加1
        [weakSelf loadDataIsRefresh:NO];
    }];
}
- (void)endRefreshing {
    if (self.isRefreshing) {
        self.isRefreshing = NO;//标记刷新结束
        //正在刷新 就结束刷新
        [self.collectionView headerEndRefreshingWithResult:JHRefreshResultNone];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.collectionView footerEndRefreshing];
    }
}
#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenSize.width-10, (kScreenSize.width-10)*250/375.0);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 0, 5, 0);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SceneListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SceneListCell" forIndexPath:indexPath];
    SceneModel *model = self.dataArray[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SceneModel *model = self.dataArray[indexPath.row];
    SceneDetailViewController *controller = [[SceneDetailViewController alloc] init];
    controller.id = model.id;
    
    [self.navigationController pushViewController:controller animated:YES];
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
