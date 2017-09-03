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
#import "CHAnnotationView.h"
#import "CHPointAnnotion.h"
#import "MKMapView+ZoomLevel.h"

@interface CHMKMapView : MKMapView<MKMapViewDelegate>
@property (nonatomic, strong) SMALocatiuonManager *locaMar;
@property (nonatomic, assign) NSUInteger zoomLevel;
+ (CHMKMapView *)createMapView;
- (void)addAnnotationsWithPoints:(NSMutableArray *)points;
@end
