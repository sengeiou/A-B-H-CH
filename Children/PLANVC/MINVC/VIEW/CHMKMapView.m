//
//  CHMKMapView.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/25.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHMKMapView.h"

@interface CHMKMapView ()
@property (nonatomic, strong) NSMutableArray *polyliones;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;
@end

@implementation CHMKMapView

+ (CHMKMapView *)createMapView{
    CHMKMapView *mapView = [CHMKMapView new];
    [mapView commonInit];
    return mapView;
}

- (void)commonInit{
    self.rotateEnabled = NO;
    self.delegate = self;
    self.userTrackingMode = MKUserTrackingModeFollow;
    self.polyliones = [NSMutableArray array];
    self.mapAnnotations = [NSMutableArray array];
    self.locaMar = [SMALocatiuonManager sharedCoreBlueTool];

}

- (void)removeOverlayView{
    [self removeOverlays:_polyliones];
    [_polyliones removeAllObjects];
}

- (void)removeAnnotionsView{
    [self removeAnnotations:_mapAnnotations];
    [_mapAnnotations removeAllObjects];
}

- (void)addAnnotationsWithPoints:(NSMutableArray *)points{
//    _imageIndex = 0;
    for (int i = 0; i < points.count; i ++) {
        NSDictionary *locationDic = points[i];
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D code;
        code.latitude = [locationDic[@"LATITUDE"] doubleValue];
        code.longitude = [locationDic[@"LONGITUDE"] doubleValue];
        point.coordinate = code;
        [_mapAnnotations addObject:point];
    }
//    [self reloadInputViews]
    [self addAnnotations:_mapAnnotations];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    NSLog(@"didUpdateUserLocation %@",userLocation);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
     static NSString *ID = @"anno";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        annoView.centerOffset = CGPointMake(0, -10); // 设置大头针的偏移

    }
//    MKPointAnnotation
    annoView.backgroundColor = [UIColor greenColor];
    return annoView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
