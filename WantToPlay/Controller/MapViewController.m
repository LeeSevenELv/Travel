//
//  MapViewController.m
//  WantToPlay
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()<MKMapViewDelegate>

@property (nonatomic) MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar lt_setBackgroundColor:kThemeColor];
    [self createMapView];
    [self createAnnoations];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}
- (void)createMapView {
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    CLLocationDegrees lon = [_lonlat[1] doubleValue];
    CLLocationDegrees lat = [_lonlat[0] doubleValue];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(lon, lat), MKCoordinateSpanMake(0.05, 0.05));
    [self.view addSubview:self.mapView];
    
}

- (void)createAnnoations {
    
    //先创建地图再创建大头针
    
    /*
     点标注:1.点标注视图(视图) 2.点标注数据(数据模型)
     //我们在地图上看到的是点标注视图 点标注的视图数据 在点标注中
     */
    //创建点标注数据(大头针数据)
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    //设置大头针的经纬度
    CLLocationDegrees lon = [_lonlat[1] doubleValue];
    CLLocationDegrees lat = [_lonlat[0] doubleValue];
    annotation.coordinate = CLLocationCoordinate2DMake(lon, lat);
    annotation.title = @"";
    annotation.subtitle = @"";
    //把大头针数据添加到地图上 增加 一个遵守 MKAnnotation的对象
    [self.mapView addAnnotation:annotation];
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
