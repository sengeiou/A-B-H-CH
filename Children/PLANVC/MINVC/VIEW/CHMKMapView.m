//
//  CHMKMapView.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/25.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHMKMapView.h"
#define MERCATOR_RADIUS 85445659.44705395

@interface CHMKMapView ()
{
    NSUInteger _zoomLevel;
}
@property (nonatomic, strong) NSMutableArray *polyliones;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;
@property (nonatomic, assign) BOOL firstLun;
@end

@implementation CHMKMapView

+ (CHMKMapView *)createMapView{
    CHMKMapView *mapView = [CHMKMapView new];
    [mapView commonInit];
    return mapView;
}

- (void)setZoomLevel:(NSUInteger)zoomLevel{
    if (zoomLevel > 18 || zoomLevel < 3) {
        return;
    }
    [self setCenterCoordinate:self.centerCoordinate zoomLevel:zoomLevel animated:YES];
    _zoomLevel = zoomLevel;
    NSLog(@"setZoomLevel %lu  ** %f  ** %f",(unsigned long)zoomLevel,self.centerCoordinate.latitude,self.centerCoordinate.longitude);
}

- (NSUInteger)zoomLevel{
//    _zoomLevel = [self getZoomLevel:self];
     NSLog(@"getZoomLevel %f",[self getZoomLevel:self]);
    return _zoomLevel;
}

- (void)commonInit{
    _firstLun = YES;
    self.rotateEnabled = NO;
    self.delegate = self;
    
//    self.userTrackingMode = MKUserTrackingModeFollow;
    self.polyliones = [NSMutableArray array];
    self.mapAnnotations = [NSMutableArray array];
    self.locaMar = [SMALocatiuonManager sharedCoreBlueTool];
    [self setCenterCoordinate:CLLocationCoordinate2DMake(39.9163854444,116.3971424103) animated:NO];
    _zoomLevel = 15;
    [self setCenterCoordinate:CLLocationCoordinate2DMake(39.9163854444,116.3971424103) zoomLevel:_zoomLevel animated:YES];
//    self.zoomLevel = 12;
//    [self setCenterCoordinate:self.centerCoordinate zoomLevel:self.zoomLevel animated:NO];
}

- (void)removeOverlayView{
    [self removeOverlays:_polyliones];
    [_polyliones removeAllObjects];
}

- (void)removeAnnotionsView{
    [self removeAnnotations:_mapAnnotations];
    [_mapAnnotations removeAllObjects];
}

- (float)getZoomLevel:(MKMapView*)_mapView {//不能百分百准
    return 20 - round(log2(_mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * self.bounds.size.width)));
}

- (void)addAnnotationsWithPoints:(NSMutableArray *)points{
//    _imageIndex = 0;
    for (int i = 0; i < points.count; i ++) {
        CHUserInfo *location = points[i];
        CHPointAnnotion *point = [[CHPointAnnotion alloc] init];
        point.coordinate = location.deviceCoor;
        point.annotationUser = location;
        [_mapAnnotations addObject:point];
    }
//    [self reloadInputViews]
    [self addAnnotations:_mapAnnotations];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSLog(@"didUpdateUserLocation %@",userLocation.location);
    if (self.userLocation.location && self.showsUserLocation && _firstLun) {
        _firstLun = NO;
        if (_zoomLevel == 0) {
            _zoomLevel = [self getZoomLevel:self];
        }
        [self setCenterCoordinate:self.userLocation.location.coordinate zoomLevel:_zoomLevel animated:YES];
        MKAnnotationView *view = [self viewForAnnotation:self.userLocation];
//        view.enabled = NO;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        NSLog(@"[self viewForAnnotation:self.userLocation] %@",[self viewForAnnotation:self.userLocation]);
        return nil;
    }
    if (([annotation isKindOfClass:[CHPointAnnotion class]])) {
        static NSString *ID = @"anno";
//               MKAnnotationView *annoView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
//         if (annoView == nil) {
//         annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
//         //        annoView.centerOffset = CGPointMake(0, -10); // 设置大头针的偏移
//         }
//         annoView.image = [UIImage imageNamed:@"icon_weixuandingwei"];
//         annoView.backgroundColor = [UIColor greenColor];
        
        CHAnnotationView *annoView = (CHAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        if (annoView == nil) {
            annoView = [[CHAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
            //   annoView.centerOffset = CGPointMake(0, -10); // 设置大头针的偏移
        }
        if ([[CHAccountTool user].deviceId isEqualToString:[(CHPointAnnotion *)annotation annotationUser].deviceId]) {
//            annoView.selected = YES;
        }
        [annoView setLabTit:[(CHPointAnnotion *)annotation annotationUser].deviceNa];
        [annoView didSelectAnnotaton:^(id<MKAnnotation> annotation) {
            NSLog(@"didSelectAnnotaton %@",annotation);
        }];
        //    MKPointAnnotation
        return annoView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    for (MKAnnotationView *view in views) {
        if (![view isKindOfClass:NSClassFromString(@"MKModernUserLocationView")]) {
            CHAnnotationView *annoView = (CHAnnotationView *)view;
//            CHPointAnnotion *annotation = annoView.annotation;
            if ([[CHAccountTool user].deviceId isEqualToString:[(CHPointAnnotion *)annoView.annotation annotationUser].deviceId]) {
                annoView.selected = YES;
            }
        }
    }
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    NSLog(@"mapViewDidFinishLoadingMap = %f %@",[self getZoomLevel:self],self.userLocation.location);
    if (self.userLocation.location && self.showsUserLocation && _firstLun) {
         _firstLun = NO;
        if (_zoomLevel == 0) {
            _zoomLevel = [self getZoomLevel:self];
        }
        [self setCenterCoordinate:self.userLocation.location.coordinate zoomLevel:_zoomLevel animated:YES];
        MKAnnotationView *view = [self viewForAnnotation:self.userLocation];
//        view.enabled = NO;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
//    if (![view isKindOfClass:[CHAnnotationView class]]) {
//        view.selected = NO;
//    }
    NSLog(@"didSelectAnnotaton %@  ** %d",view,view.selected);
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState{
    NSLog(@"didChangeDragState rgi io = %f",[self getZoomLevel:self]);
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"regionDidChangeAnimated rgi io = %f",[self getZoomLevel:self]);
    if (!_firstLun) {
        _zoomLevel = [self getZoomLevel:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
