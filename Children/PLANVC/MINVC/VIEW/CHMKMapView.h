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
#import "CHTrackingAnnotationView.h"
#import "CHPolyline.h"

@interface CHMKMapView : MKMapView<MKMapViewDelegate>
@property (nonatomic, strong) SMALocatiuonManager *locaMar;
@property (nonatomic, assign) NSUInteger zoomLevel;
@property (nonatomic, strong) NSMutableArray *polyliones;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;
+ (CHMKMapView *)createMapView;
- (void)addAnnotationsWithPoints:(NSMutableArray *)points;
- (void)addAnnotationsWithTrackPoints:(NSMutableArray *)points;
- (void)userDidSelectAnnotationView:(CHUserInfo *)selDevice;
- (void)tapMapCallBack:(void (^)(MKMapView *mapView))callBack;
- (void)longMapCallBack:(void (^)(MKMapView *mapView, CGPoint point))callBack;
- (void)didSelectMapAnnotationView:(void (^)(CHUserInfo *didDevice))callBack;
- (void)addSystemAnnotationWithPoints:(NSMutableArray *)points bespokeIma:(UIImage *)image;
- (void)addCircleWithCenterCoordinate:(CLLocationCoordinate2D)coor radius:(int)radius animation:(BOOL)animation;
- (void)addPolyOverLaysWithTarckModes:(NSArray *)modes;
- (MKAnnotationView *)viewForAnnotationSelect:(NSInteger)inter;
- (void)removeAnnotionsView;
- (void)removeOverlayView;
@end
