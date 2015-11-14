
//
//  define.h
//  PeripheralPlay
//
//  Created by qjt123 on 15/7/20.
//  Copyright (c) 2015年 qjt123. All rights reserved.
//

#ifndef PeripheralPlay_define_h
#define PeripheralPlay_define_h


#define kScreenSize [[UIScreen mainScreen] bounds].size
#define kThemeColor [UIColor colorWithRed:0 green:100/255.0 blue:100/255.0 alpha:1]


//图片统一接口
#define kImageURL @"http://pic.108tian.com/pic/"

//home界面
//进入
#define kHomeURL @"https://api.108tian.com/mobile/v2/Home?cityId=%@&uuid=e8ade540ea4949e73953d69d7a448e2320bc8e8b&timeStamp=1437199274771"

//刷新
#define kHomeRefreshURL @"https://api.108tian.com/mobile/v2/RecommendDetailList?uuid=e8ade540ea4949e73953d69d7a448e2320bc8e8b&cityId=%@&sid=6e1d969ec493a79c020ebb227e699c449cfe84f3&step=2&page=%ld"


#define kWeeklyDetailURL @"https://api.108tian.com/mobile/v2/WeeklyDetail?id=%@&sid=6e1d969ec493a79c020ebb227e699c449cfe84f3&uuid=e8ade540ea4949e73953d69d7a448e2320bc8e8b&timeStamp=1437470939337"

#define kSceneListURL @"https://api.108tian.com/mobile/v2/SceneList?page=%ld&cityId=%@&step=10&theme=%@&uuid=e8ade540ea4949e73953d69d7a448e2320bc8e8b"

#define kSceneDetailURL @"https://api.108tian.com/mobile/v2/SceneDetail?id=%@&sid=6e1d969ec493a79c020ebb227e699c449cfe84f3&uuid=e8ade540ea4949e73953d69d7a448e2320bc8e8b&timeStamp=1437555973102"


#define kScrollAdvURL @"https://api.108tian.com/mobile/v2/RecommendDetail?id=%@&sid=66043dd3d7561fe7b30a346b4c39aa858a13ebc9"


//第二个主界面
#define kThemeItemsURL @"https://api.108tian.com/mobile/v2/ThemeItems?type=scene&timeStamp=1437730625422"


//收藏的攻略，景点
#define kCollectWeeklyURL @"https://api.108tian.com/mobile/v2/WeeklyDetail?id=%@&sid=66043dd3d7561fe7b30a346b4c39aa858a13ebc9&uuid=e8ade540ea4949e73953d69d7a448e2320bc8e8b"
#define kCollectSceneURL @"https://api.108tian.com/mobile/v2/SceneDetail?id=%@&sid=66043dd3d7561fe7b30a346b4c39aa858a13ebc9&uuid=e8ade540ea4949e73953d69d7a448e2320bc8e8b"

//登录注册
#define kLoginURL @"http://api.kuaikanmanhua.com/v1/phone/signin"
#define k

#endif
