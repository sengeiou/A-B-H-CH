//
//  CHMKMapView.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/25.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SMALocatiuonManager.h"

@interface CHMKMapView : MKMapView<MKMapViewDelegate>
@property (nonatomic, strong) SMALocatiuonManager *locaMar;
+ (CHMKMapView *)createMapView;
@end
