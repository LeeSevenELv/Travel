//
//  HomeViewController.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeFirstItem.h"
#import "RecommandDetailListModel.h"
#import "HomeSectionFooter.h"
#import "HomeSectionHeader.h"
#import "HomeRecommendItem.h"
#import "HomeModel.h"
#import "WeeklyDetailViewController.h"
#import "SelectCityViewController.h"
#import "CityModel.h"
#import <CoreLocation/CoreLocation.h>

#define PATH @"http://api.map.baidu.com/geocoder?output=json&location=%f,%f&key=dc40f705157725fc98f1fee6a15b6e60"

NSMutableArray *cityArray = nil;
NSMutableArray *cityIndexes = nil;
NSString *currentCityID = nil;
NSString *currentCity = nil;
NSMutableArray *resultCityModelArray = nil;
CLLocation *currentLocation = nil;

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *recommandArray;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic) BOOL isFirstLoad;

@property (nonatomic,strong) HomeSectionFooter *sectionFooterView;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentCity = @"北京";
    currentCityID = @"1";
    _isFirstLoad = YES;
    [self initUI];
    
    //监听选择城市通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCity:) name:@"updateCity" object:nil];
    
    [self initLocationManager];
    [self locateUserPositon];
}
- (void)locateUserPositon {
    [self showProgress];
    //先更新URL
    NSString *url = [NSString stringWithFormat:kHomeURL, currentCityID];
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //解析firstItem的数据，作为数组中第一个数据model
        HomeModel *model = [[HomeModel alloc] initWithDictionary:rootDict[@"data"] error:nil];
        [weakSelf.recommandArray replaceObjectAtIndex:0 withObject: model];
        
        //解析city数据
        [weakSelf readCityDataWithCitys:rootDict[@"data"][@"openCity"]];
        
        //定位一次
        static dispatch_once_t once = 0;
        dispatch_once(&once, ^{
            if ([CLLocationManager locationServicesEnabled]) {
                [_locationManager startUpdatingLocation];
            }else{
                NSLog(@"没有开启gps");
            }
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"af error!1");
    }];
}
- (void)initLocationManager {
    if (!_locationManager) {
        //实例化一个管理对象
        _locationManager = [[CLLocationManager alloc] init];
        //设置精度 精度越高越耗电
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        //精度大小 1m
        _locationManager.distanceFilter = 1;
        
        /*
         iOS之后 需要设置配置文件
         
         1.在info.plist中添加  Privacy - Location Usage 和NSLocationAlwaysUsageDescription 空键
         2.在代码中  [_manager requestAlwaysAuthorization];
         //ios8特有，申请用户授权使用地理位置信息
         
         */
        CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
        //判断版本
        if (version >= 8.0) {
            //申请用户授权使用地理位置信息
            [_locationManager requestAlwaysAuthorization];
        }
        //如果要 获取定位的位置 那么需要设置代理
        _locationManager.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar lt_setBackgroundColor:kThemeColor];
}
- (void)initUI {
    self.recommandArray = [[NSMutableArray alloc] initWithObjects:@"firstItem", nil];
    [self addLeftRightBarButtonItem];
    [self initCollectionView];
}

- (void)initCollectionView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.minimumLineSpacing = 5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64-49) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeFirstItem" bundle:nil] forCellWithReuseIdentifier:@"HomeFirstItem"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeRecommendItem" bundle:nil] forCellWithReuseIdentifier:@"HomeRecommendItem"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeSectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeSectionHeader"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeSectionFooter" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeSectionFooter"];
    [self.view addSubview:self.collectionView];
    
    [self creatRefreshUI];
}
- (void)addLeftRightBarButtonItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"城市" style:UIBarButtonItemStylePlain target:self action:@selector(city:)];
    
}
- (void)showProgress {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.image = [UIImage imageNamed:@"compass_spinner"];
    imageView.layer.cornerRadius = 15;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    animation.duration = 2;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    [imageView.layer addAnimation:animation forKey:@"transform.rotation.z"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
}
- (void)dismissProgress {
    self.navigationItem.rightBarButtonItem = nil;
}
- (void)city:(UIBarButtonItem *)item {
    SelectCityViewController *controller = [[SelectCityViewController alloc] init];
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)updateCity:(NSNotification *)notification {
    self.navigationItem.leftBarButtonItem.title = currentCity;
    
    [self loadHeaderDataIsRefresh:YES];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - 网络数据下载、解析
- (void)loadHeaderDataIsRefresh:(BOOL)isRefresh {
    [self showProgress];
    //先更新URL
    NSString *url = [NSString stringWithFormat:kHomeURL, currentCityID];
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //解析firstItem的数据，作为数组中第一个数据model
        HomeModel *model = [[HomeModel alloc] initWithDictionary:rootDict[@"data"] error:nil];
        [weakSelf.recommandArray replaceObjectAtIndex:0 withObject: model];
        
        //解析city数据
        [weakSelf readCityDataWithCitys:rootDict[@"data"][@"openCity"]];
        
        [self loadDataIsRefresh:isRefresh];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"af error!");
        [weakSelf endRefreshing];
    }];
}
- (void)loadDataIsRefresh:(BOOL)isRefresh {
    NSString *url = [NSString stringWithFormat:kHomeRefreshURL, currentCityID, self.currentPage];
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *listArray = rootDict[@"data"][@"list"];
        _totalPage = [rootDict[@"data"][@"number"] integerValue];
        //推荐列表数据
        if (isRefresh) {
            [self.recommandArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, self.recommandArray.count-1)]];
            _sectionFooterView.contentLabel.text = @"正在加载更多";
        }
        
        for (NSInteger i = 0; i < listArray.count; i++) {
            RecommandDetailListModel *model = [[RecommandDetailListModel alloc] initWithDictionary:listArray[i] error:nil];
            [weakSelf.recommandArray addObject:model];
        }
        
        [weakSelf.collectionView reloadData];
        
        [weakSelf endRefreshing];
        if (_isFirstLoad) {
            _isFirstLoad = NO;
        }
        [self dismissProgress];
        [weakSelf endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"af error!");
        [weakSelf endRefreshing];
        [self dismissProgress];
    }];
}
- (void)readCityDataWithCitys:(NSDictionary *)dict {
    //解析数据生成CityModel数组
    NSArray *allKeys = [dict allKeys];
    resultCityModelArray = [NSMutableArray array];
    for (NSString *province in allKeys) {
        NSArray *pcitys = [dict valueForKey:province];
        for (NSMutableDictionary *city in pcitys) {
            //NSLog(@"%@", city);
            [city setValue:province forKey:@"province"];
            CityModel *model = [[CityModel alloc] init];
            [model setValuesForKeysWithDictionary:city];
            [resultCityModelArray addObject:model];
        }
    }
    
    //遍历CityModel数组，解析并填充至全局变量 cityIndexes、cityArray中
    cityIndexes = [NSMutableArray array];
    cityArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 26; i++) {
        NSMutableArray *array = [NSMutableArray array];
        
        for (CityModel *model in resultCityModelArray) {
            NSString *str = [model city];
            if ([[str substringToIndex:1] isEqualToString:[NSString stringWithFormat:@"%c", (char)(i+'a')]]) {
                char tmp = 'A' + i;
                NSString *index = [NSString stringWithFormat:@"%c", tmp];
                if (![cityIndexes containsObject:index]) {
                    [cityIndexes addObject:index];
                }
                [array addObject:model];
            }
        }
        if (array.count > 0) {
            [cityArray addObject:array];
        }
    }
}

#pragma mark - 刷新 加载更多
- (void)creatRefreshUI {
    //增加下拉刷新
    
    __weak typeof (self) weakSelf = self;
    
    [self.collectionView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //重新下载数据
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;//标记正在刷新
        weakSelf.currentPage = 0;
        
        [weakSelf loadHeaderDataIsRefresh:YES];
    }];
}
- (void)createLoadMoreUI {
    __weak typeof (self) weakSelf = self;//弱引用
    //上拉加载更多
    [self.collectionView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //重新下载数据
        if (weakSelf.isLoadMore) {
            return;
        }
        weakSelf.isLoadMore = YES;//标记正在刷新
        weakSelf.currentPage ++;//页码加1
        [weakSelf loadHeaderDataIsRefresh:NO];
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
    if (section == 0) {
        return 1;
    }
    return [[((RecommandDetailListModel *)self.recommandArray[section]) items] count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.recommandArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeFirstItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeFirstItem" forIndexPath:indexPath];
        [cell showDataWithModel:self.recommandArray[0] controller:self];
        return cell;
    } else {
        HomeRecommendItem * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeRecommendItem" forIndexPath:indexPath];
        RecommandItemModel *model = [self.recommandArray[indexPath.section] items][indexPath.row];
        [cell showDataWithModel:model];
        return cell;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HomeSectionHeader *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeSectionHeader" forIndexPath:indexPath];
        [view showDataWithModel:self.recommandArray[indexPath.section]];
        return view;
    } else {
        _sectionFooterView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HomeSectionFooter" forIndexPath:indexPath];
        return _sectionFooterView;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? CGSizeMake(kScreenSize.width, kScreenSize.width*300/375.0) : CGSizeMake(kScreenSize.width-10, 190);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGSizeZero : CGSizeMake(self.view.bounds.size.width, 64);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return section == self.recommandArray.count-1? CGSizeMake(self.view.bounds.size.width, 30) : CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        WeeklyDetailViewController *controller = [[WeeklyDetailViewController alloc] init];
        RecommandItemModel *model = [self.recommandArray[indexPath.section] items][indexPath.row];
        controller.id = [[model recommend] id];
        controller.model = model;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - <CLLocationManagerDelegate>
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    static int have = 0;
    have++;
    
    if (locations.count && have==1) {
        //数组中只有一个元素
        CLLocation *location = [locations lastObject];
        //CLLocationCoordinate2D是一个结构体 内部存放的是经纬度
        CLLocationCoordinate2D coordinate = location.coordinate;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *url = [NSString stringWithFormat:PATH,coordinate.latitude, coordinate.longitude];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            //下载完成
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            NSMutableString *str = [NSMutableString stringWithString:result[@"addressComponent"][@"city"]];
            [str replaceCharactersInRange:NSMakeRange(str.length - 1, 1) withString:@""];
            
            
            for (CityModel *model in resultCityModelArray) {
                if ([str isEqualToString:model.name]) {
                    have = YES;
                    currentCity = model.name;
                    currentCityID = [model.id stringValue];
                    currentLocation = location;
                    break;
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCity" object:nil];
            [_locationManager stopUpdatingLocation];
        });
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败");
    [self loadDataIsRefresh:YES];
}

#pragma mark - <UIScrollView>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (2*(self.currentPage+1) > _totalPage) {
        _sectionFooterView.contentLabel.text = @"没有了";
    }
    
    if (scrollView != self.collectionView || _isFirstLoad == YES || 2*(self.currentPage+1) > _totalPage) return;
    //NSLog(@"%lf 内容高%lf", scrollView.contentOffset.y, scrollView.contentSize.height);
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height - 20) {
        //NSLog(@"到底了");
        __weak typeof (self) weakSelf = self;//弱引用
        if (weakSelf.isLoadMore) {
            return;
        }
        weakSelf.isLoadMore = YES;//标记正在刷新
        weakSelf.currentPage ++;//页码加1
        [weakSelf loadHeaderDataIsRefresh:NO];
    }
}



@end
