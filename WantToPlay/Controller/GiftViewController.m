//
//  GiftViewController.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "GiftViewController.h"
#import "SceneModel.h"
#import "SceneListCell.h"
#import "SceneDetailViewController.h"
#import "ScrollButtonBar.h"
#import "ProgressHUD.h"

extern NSString *currentCityID;
extern NSMutableArray *themeItems;

@interface GiftViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) ProgressHUD *progressHUD;
@property (nonatomic) UIButton *backToTopButton;

@end

@implementation GiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCity:) name:@"updateCity" object:nil];
    _progressHUD = [ProgressHUD progressWithTitle:@"" Frame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64)];
    
    [self initUI];
    [self loadThemesData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar lt_setBackgroundColor:kThemeColor];
}

- (void)initUI {
    [self initCollectionView];
    [self initBackToTopButton];
}
- (void)initBackToTopButton {
    _backToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backToTopButton setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    [_backToTopButton setTitle:@"ss" forState:UIControlStateNormal];
    [_backToTopButton addTarget:self action:@selector(backToTop) forControlEvents:UIControlEventTouchUpInside];
    _backToTopButton.frame = CGRectMake(kScreenSize.width-45, kScreenSize.height-94, 40, 40);
    _backToTopButton.hidden = YES;
    [self.view addSubview:_backToTopButton];
}
- (void)backToTop {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}
- (void)initCollectionView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+40, kScreenSize.width, kScreenSize.height-104-49) collectionViewLayout:layout];
    self.view.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SceneListCell" bundle:nil] forCellWithReuseIdentifier:@"SceneListCell"];
    [self.view addSubview:self.collectionView];
    
    [self creatRefreshUI];
    [self createLoadMoreUI];
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
    }
}
#pragma mark - 网络数据下载、解析
- (void)loadThemesData {
    //__weak typeof(self) weakSelf = self;
    [self.manager GET:kThemeItemsURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self readData:responseObject];
        NSLog(@"%ld", (long)[NSThread isMainThread]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"af error3");
    }];
}
- (void)loadDataIsRefresh:(BOOL)isRefresh {
    if (isRefresh) {
        [self showmyProgress];
    }
    
    [self createURL];
    
    [self.manager GET:self.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = root[@"data"][@"list"];
        if (isRefresh) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dict in array) {
            SceneModel *model = [[SceneModel alloc] initWithDictionary:dict error:nil];
            [self.dataArray addObject:model];
        };
        
        [self.collectionView reloadData];
        self.collectionView.scrollsToTop = YES;
        
        if (isRefresh && self.dataArray.count>0) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        
        [self endRefreshing];
        [self dismissProgress];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"af error2!");
        [self dismissProgress];
    }];
}
- (void)readData:(NSData *)responseObject {
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
    NSArray *array = root[@"data"];
    themeItems = [NSMutableArray array];
    
    NSMutableArray *VCClassArray = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *themeIdArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [VCClassArray addObject:[UIViewController class]];
        [titles addObject:dict[@"name"]];
        [themeIdArray addObject:dict[@"_id"]];
    }
    [themeItems addObjectsFromArray:@[VCClassArray, titles, themeIdArray]];
    self.id = themeItems[2][0];
    
    __weak typeof(self) weakSelf = self;
    ScrollButtonBar *bar = [[ScrollButtonBar alloc] initWithTitles:titles viewFrame:CGRectMake(0, 64, kScreenSize.width, 40) handle:^(UIButton *button) {
        NSString *btnTitle = [button currentTitle];
        NSArray *titles = themeItems[1];
        for (NSInteger i = 0; i < titles.count; i++) {
            if ([btnTitle isEqualToString:titles[i]]) {
                weakSelf.id = themeItems[2][i];
                [weakSelf loadDataIsRefresh:YES];
            }
        }
    }];
    bar.scrollsToTop = NO;
    //防止重复添加
    bar.tag = 100;
    if ([self.view viewWithTag:100]) [[self.view viewWithTag:100] removeFromSuperview];
    [self.view addSubview:bar];
    
    [self loadDataIsRefresh:YES];
}
- (void)createURL {
    self.url = [NSString stringWithFormat:kSceneListURL, self.currentPage, currentCityID, self.id];
}
- (void)showmyProgress {
    [self.view addSubview:_progressHUD];
}
- (void)dismissProgress {
    [_progressHUD removeFromSuperview];
}
- (void)updateCity:(NSNotification *)notification {
    [self loadThemesData];
}
#pragma mark - 刷新 加载更多
- (void)creatRefreshUI {
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        _backToTopButton.hidden = scrollView.contentOffset.y > 100 ? NO : YES;
    }
}
@end
