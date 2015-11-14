//
//  WeeklyDetailViewController.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "WeeklyDetailViewController.h"
#import "WeeklyDetailDescCell.h"
#import "WeeklyDetailContentCell.h"
#import "CExpandHeader.h"
#import "DBManager.h"
#import "SceneDetailHeaderInfoView.h"

#define k2TColor [UIColor orangeColor]
#define kContentFontSize 16.0
@interface WeeklyDetailViewController ()
<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) CGFloat contentHeight;

@property (nonatomic) CExpandHeader *header;
@property (nonatomic) UIImageView *imageView;

@property (nonatomic) UIButton *favButton;
@property (nonatomic) NSInteger fav;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *name;


@end

@implementation WeeklyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.dataArray addObject:@"?"];
    
    [self initUI];
}
- (void)initUI {
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:0 green:185/255.0 blue:160/255.0 alpha:0]];
    [self createTableView];
    [self createRightBarButton];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self loadDataFromNet];
}
- (void)createRightBarButton {
    _favButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _favButton.frame = CGRectMake(0, 0, 40, 40);
    [_favButton setBackgroundImage:[UIImage imageNamed:@"redfavimg"] forState:UIControlStateSelected];
    [_favButton setBackgroundImage:[UIImage imageNamed:@"whitefavimg"] forState:UIControlStateNormal];
    _favButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_favButton setTitleEdgeInsets:UIEdgeInsetsMake(18, 0, 0, 0)];
    
    if ([[DBManager sharedManager] selectWeeklyById:self.id]) {
        _favButton.selected = YES;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_favButton];
}
- (void)fav:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        [[DBManager sharedManager] deleteWeeklyById:_id];
        return;
    }
    button.selected = YES;
    [[DBManager sharedManager] addWeekly:_id name:_name img:_img];
}
- (void)createTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"WeeklyDetailDescCell" bundle:nil] forCellReuseIdentifier:@"WeeklyDetailDescCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WeeklyDetailContentCell" bundle:nil] forCellReuseIdentifier:@"WeeklyDetailContentCell"];
    [self.view addSubview:self.tableView];
    
    //添加tableView的头视图
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.width*0.6)];
    _imageView.image = [UIImage imageNamed:@"header"];
    _header = [CExpandHeader expandWithScrollView:self.tableView expandView:_imageView];
    
    
}
- (void)addHeaderInfoViewWithName:(NSString *)name subTitle:(NSString *)subTitle {
    SceneDetailHeaderInfoView *view = [[[NSBundle mainBundle] loadNibNamed:@"SceneDetailHeaderInfoView" owner:nil options:nil] lastObject];
    view.frame = CGRectMake(0, -58, self.tableView.frame.size.width, 58);
    [view showDataWithName:name subTitle:subTitle];
    [self.tableView addSubview:view];
}
- (void)addTitleTofavButtonWithFav:(NSInteger)fav {
    [_favButton setTitle:[NSString stringWithFormat:@"%ld", fav] forState:UIControlStateNormal];
    [_favButton setTitle:[NSString stringWithFormat:@"%ld", fav+1] forState:UIControlStateSelected];
    [_favButton addTarget:self action:@selector(fav:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 网络数据下载、解析
- (void)loadDataFromNet {
    
    NSString *murl = [NSString stringWithFormat:kCollectWeeklyURL, self.id];
    
    [self.manager GET:murl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        [self addHeaderInfoViewWithName:root[@"data"][@"name"] subTitle:root[@"data"][@"label"]];
        
        //第一行的model加入dataArray
        NSString *lead = root[@"data"][@"lead"];
        [self.dataArray replaceObjectAtIndex:0 withObject:lead];
        
        NSString *htmlStr = root[@"data"][@"content"];
        if (htmlStr != nil) {
            [self clipStr:htmlStr];
        }
        
        //数据库用数据
        _img = root[@"data"][@"headImg"];
        _name = root[@"data"][@"name"];
        _fav = [root[@"data"][@"fav"] integerValue];
        [self addTitleTofavButtonWithFav:_fav];
        
        //添加tableView的头视图
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kImageURL, _img]] placeholderImage:[UIImage imageNamed:@"header"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"AF error6!");
    }];
}

- (void)clipStr:(NSString *)htmlStr {
    
    NSMutableArray *resultArray = [NSMutableArray array];
    NSArray *array = [htmlStr componentsSeparatedByString:@"\""];
    for (NSInteger i = 0; i < array.count; i++) {
        NSArray *strArray = [array[i] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        for (NSString *str in strArray) {
            if ([LeeHelper IsChinese:str]||(str.length>6&&[[str substringToIndex:7] isEqualToString:@"http://"])||[str containsString:@"TIPS"]) {
                [resultArray addObject:str];
            }
        }
    }
    
    [self makeTWHPWithArray:resultArray];
}

- (void)makeTWHPWithArray:(NSArray *)array {
    double ped = 5;
    double contentHeight = 0+ped;
    double width = self.view.bounds.size.width - 10;
    double imageHeight = width*3.3/5.0;
    NSMutableArray *viewArray = [NSMutableArray array];
    
    //第一行
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
    
    //第二行及以后所有行
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
        } else if ([str containsString:@"TIPS"]) {
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
    
    [self.dataArray addObject:viewArray];
    self.contentHeight = contentHeight;
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WeeklyDetailDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeeklyDetailDescCell" forIndexPath:indexPath];
        cell.desc.text = self.dataArray[0];
        return cell;
    } else {
        WeeklyDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeeklyDetailContentCell" forIndexPath:indexPath];
        if (self.dataArray.count == 2) {
            for(UIView *view in cell.myContentView.subviews)
            {
                [view removeFromSuperview];
            }
            for (UIView *view in self.dataArray[1]) {
                [cell.myContentView addSubview:view];
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            CGFloat height = [LeeHelper textHeightFromTextString:self.dataArray[indexPath.row] width:kScreenSize.width-10 fontSize:17.0];
            if (height <= 26) height = 26;
            return height + 82-26;
        }
        case 1:
        {
            if (self.contentHeight <= 30) self.contentHeight = 30;
            return 52 + self.contentHeight;
        }
    }
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y <= -100) {
        double rator = (200-fabs(scrollView.contentOffset.y))/100;
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:0 green:185/255.0 blue:160/255.0 alpha:rator]];
    }
}

@end
