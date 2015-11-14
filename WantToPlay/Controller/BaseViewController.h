//
//  BaseViewController.h
//  WantToPlay
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) AFHTTPRequestOperationManager *manager;
@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) BOOL isLoadMore;
@property (nonatomic) NSInteger currentPage;

@end
