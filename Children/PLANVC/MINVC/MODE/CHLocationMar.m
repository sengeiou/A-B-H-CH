//
//  CHLocationMar.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/27.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHLocationMar.h"

@implementation CHLocationMar
static id _instance;

+ (instancetype)shareLocation{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)commonInit{
    self.delegate = self;
    self.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
    //    _manager.distanceFilter = 30; //控制定位服务更新频率。单位是“米”
    [self requestAlwaysAuthorization];  //调用了这句,就会弹出允许框了.
    [self requestWhenInUseAuthorization];
    self.pausesLocationUpdatesAutomatically = NO; //该模式是抵抗ios在后台杀死程序设置，iOS会根据当前手机使用状况会自动关闭某些应用程序的后台刷新，该语句申明不能够被暂停，但是不一定iOS系统在性能不佳的情况下强制结束应用刷新kCLAuthorizationStatusAuthorizedAlways
    //        [CLLocationManager authorizationStatus] = kCLAuthorizationStatusAuthorizedAlways;
    self.distanceFilter = kCLDistanceFilterNone;  //不需要移动都可以刷新
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        self.allowsBackgroundLocationUpdates = YES;
    }
}
@end
