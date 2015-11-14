//
//  SceneDetailViewController.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "SceneDetailViewController.h"
#import "SceneDetailDescCell.h"
#import "SceneDetailContentCell.h"
#import "ScenenDetailFeatureCell.h"
#import "SceneDetailTipCell.h"
#import "SceneDetailModel.h"
#import "CExpandHeader.h"
#import "UINavigationBar+BackgroundColor.h"
#import "DBManager.h"
#import "SceneDetailHeaderInfoView.h"

#define k2TColor [UIColor orangeColor]
#define kContentFontSize 16.0

@interface SceneDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSString *url;
@property (nonatomic) SceneDetailModel *sceneDetailModel;
@property (nonatomic) NSArray *viewArrays;
@property (nonatomic) CGFloat featureHeight;
@property (nonatomic) CGFloat addressHeight;
@property (nonatomic) NSMutableArray *resultArray;

@property (nonatomic) CExpandHeader *header;
@property (nonatomic) UIImageView *imageView;

@property (nonatomic) UIButton *favButton;
@property (nonatomic) NSInteger fav;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;

@end

@implementation SceneDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
    [self initUI];
    
    [self createURL];
    [self loadDataWithURL:self.url isRefresh:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)createRightBarButton {
    _favButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _favButton.frame = CGRectMake(0, 0, 40, 40);
    [_favButton setBackgroundImage:[UIImage imageNamed:@"redfavimg"] forState:UIControlStateSelected];
    [_favButton setBackgroundImage:[UIImage imageNamed:@"whitefavimg"] forState:UIControlStateNormal];
    _favButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_favButton setTitleEdgeInsets:UIEdgeInsetsMake(18, 0, 0, 0)];
    
    if ([[DBManager sharedManager] selectSceneById:_id]) {
        _favButton.selected = YES;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_favButton];
}
- (void)initUI {
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:0 green:185/255.0 blue:160/255.0 alpha:0]];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) collectionViewLayout:layout];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.view.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SceneDetailDescCell" bundle:nil] forCellWithReuseIdentifier:@"SceneDetailDescCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SceneDetailContentCell" bundle:nil] forCellWithReuseIdentifier:@"SceneDetailContentCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ScenenDetailFeatureCell" bundle:nil] forCellWithReuseIdentifier:@"ScenenDetailFeatureCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SceneDetailTipCell" bundle:nil] forCellWithReuseIdentifier:@"SceneDetailTipCell"];
    [self.view addSubview:self.collectionView];
    
    //添加tableView的头视图
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.width*0.6)];
    _imageView.image = [UIImage imageNamed:@"header"];
    _header = [CExpandHeader expandWithScrollView:self.collectionView expandView:_imageView];
    
    [self createRightBarButton];
}
- (void)addHeaderInfoView {
    SceneDetailHeaderInfoView *view = [[[NSBundle mainBundle] loadNibNamed:@"SceneDetailHeaderInfoView" owner:nil options:nil] lastObject];
    view.frame = CGRectMake(0, -58, self.collectionView.frame.size.width, 58);
    [view showDataWithModel:_sceneDetailModel];
    [self.collectionView addSubview:view];
}
- (void)addTitleTofavButtonWithFav:(NSInteger)fav {
    [_favButton setTitle:[NSString stringWithFormat:@"%ld", fav] forState:UIControlStateNormal];
    [_favButton setTitle:[NSString stringWithFormat:@"%ld", fav+1] forState:UIControlStateSelected];
    [_favButton addTarget:self action:@selector(fav:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)fav:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        [[DBManager sharedManager] deleteSceneById:_id];
        return;
    }
    button.selected = YES;
    [[DBManager sharedManager] addScene:_id name:_name img:_img];
}
#pragma mark - 网络数据下载解析
- (void)createURL {
    self.url = [NSString stringWithFormat:kCollectSceneURL, self.id];
}
- (void)loadDataWithURL:(NSString *)url isRefresh:(BOOL)isRefresh {
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict = root[@"data"];
        self.sceneDetailModel = [[SceneDetailModel alloc] initWithDictionary:dict error:nil];
        
        //数据库用数据
        _img = _sceneDetailModel.headImg;
        _name = _sceneDetailModel.name;
        _fav = [_sceneDetailModel.fav integerValue];
        [self addTitleTofavButtonWithFav:_fav];
        
        //添加collectionView的头视图
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImageURL, self.sceneDetailModel.headImg]] placeholderImage:[UIImage imageNamed:@"header"]];
        
        [self readTWHPWithDict:dict[@"details"]];
        [self addHeaderInfoView];
        
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"af error7!");
    }];
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            return CGSizeMake(kScreenSize.width, 37);
        }
        case 1:
        {
            NSString *str = [NSString stringWithFormat:@"%@",  self.sceneDetailModel.address.detail];
            self.addressHeight = [LeeHelper textHeightFromTextString:str width:kScreenSize.width-10-123 fontSize:15];
            if (self.addressHeight<20) {
                self.addressHeight = 20;
            }
            return CGSizeMake(kScreenSize.width, 127-20+self.addressHeight);
        }
        case 2:
        {
            return CGSizeMake(kScreenSize.width, 231);
        }
        case 3:
        {
            if (self.featureHeight<26) {
                self.featureHeight = 26;
            }
            return CGSizeMake(kScreenSize.width, 74-26+self.featureHeight);
        }
    }
    return CGSizeZero;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            SceneDetailDescCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SceneDetailDescCell" forIndexPath:indexPath];
            if (self.sceneDetailModel) {
                [cell showDataWithTitle:self.sceneDetailModel.tickets.price];
            }
            return cell;
        }
        case 1:
        {
            SceneDetailContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SceneDetailContentCell" forIndexPath:indexPath];
            [cell showDataWithModel:self.sceneDetailModel withVC:self];
            return cell;
        }
        case 2:
        {
            SceneDetailTipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SceneDetailTipCell" forIndexPath:indexPath];
            NSString *openninghour = [NSString stringWithFormat:@"旺季：%@  淡季：%@", self.sceneDetailModel.openinghours.peakSeason, self.sceneDetailModel.openinghours.lowSeason];
            [cell showDataWithTicket:self.sceneDetailModel.tickets.desc open:openninghour suggest:self.sceneDetailModel.suggestTime duration:self.sceneDetailModel.duration];
            return cell;
        }
        case 3:
        {
            ScenenDetailFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScenenDetailFeatureCell" forIndexPath:indexPath];
            for(UIView *view in cell.myContentView.subviews)
            {
                [view removeFromSuperview];
            }
            for (UIView *view in self.viewArrays) {
                [cell.myContentView addSubview:view];
            }
            return cell;
        }
    }
    return nil;
}
#pragma mark 图文混排解析方法
- (void)readTWHPWithDict:(NSDictionary *)dict {
    NSArray *array = dict[@"paragraph"];
    if (array.count == 0) {
        [self makeTWHPWithArray:self.resultArray];
        return;
    }
    NSDictionary *dict0 = array[0];
    NSArray *body = dict0[@"body"];
    self.resultArray = [NSMutableArray arrayWithObject:dict0[@"subtitle"]];
    
    for (NSDictionary *dic in body) {
        NSString *str = nil;
        if ([[dic allKeys] containsObject:@"img"]) {
            str = [NSString stringWithFormat:@"%@%@", kImageURL, dic[@"img"][@"url"]];
        } else {
            str = dic[@"text"];
        }
        [self.resultArray addObject:str];
    }
    [self makeTWHPWithArray:self.resultArray];
}
- (void)makeTWHPWithArray:(NSArray *)array {
    double ped = 5;
    double contentHeight = 0+ped;
    double width = self.view.bounds.size.width - 10;
    double imageHeight = width*3.0/5.0;
    NSMutableArray *viewArray = [NSMutableArray array];
    
    
    CGFloat labelHeight = [LeeHelper textHeightFromTextString:array[0] width:width fontSize:kContentFontSize];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ped, contentHeight + labelHeight/6.0, 4, 14)];
    view.backgroundColor = k2TColor;
    view.layer.cornerRadius = 2;
    [viewArray addObject:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, contentHeight, width, labelHeight)];
    label.text = array[0];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:kContentFontSize];
    label.textColor = k2TColor;
    [viewArray addObject:label];
    contentHeight += labelHeight + ped;
    
    for (NSInteger i = 1; i < array.count; i++) {
        NSString *str = array[i];
        if ((str.length>6&&[[str substringToIndex:7] isEqualToString:@"http://"])) {
            ;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, contentHeight, width-10, imageHeight)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
            [viewArray addObject:imageView];
            contentHeight += imageHeight+ped;
        } else if ([LeeHelper IsChinese:str]) {
            CGFloat labelHeight = [LeeHelper textHeightFromTextString:str width:width fontSize:kContentFontSize];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, contentHeight, width-10, labelHeight)];
            label.text = str;
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:kContentFontSize];
            [viewArray addObject:label];
            contentHeight += labelHeight + ped;
        }
        else if ([str containsString:@"TIPS"]) {
            CGFloat labelHeight = [LeeHelper textHeightFromTextString:str width:width fontSize:kContentFontSize];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ped, contentHeight + labelHeight/6.0, 4, 14)];
            view.backgroundColor = k2TColor;
            view.layer.cornerRadius = 2;
            [viewArray addObject:view];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, contentHeight, width, labelHeight)];
            label.text = str;
            label.numberOfLines = 0;
            label.font = [UIFont boldSystemFontOfSize:kContentFontSize];
            label.textColor = k2TColor;
            [viewArray addObject:label];
            contentHeight += labelHeight + ped;
        }
    }
    self.viewArrays = viewArray;
    self.featureHeight = contentHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= -100) {
        double rator = (200-fabs(scrollView.contentOffset.y))/100;
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:0 green:185/255.0 blue:160/255.0 alpha:rator]];
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
