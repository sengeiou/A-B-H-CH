//
//  CHMKMapView.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/25.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHMKMapView.h"
#define MERCATOR_RADIUS 85445659.44705395

typedef void(^didAnnotionViewBlock)(CHUserInfo *didDevice);
typedef void(^tapMap)(MKMapView *mapView);
typedef void(^LongPressMap)(MKMapView *mapView, CGPoint point);

@interface CHMKMapView ()
{
    NSUInteger _zoomLevel;
    didAnnotionViewBlock block;
    tapMap tapBlock;
    LongPressMap longBlock;
}
@property (nonatomic, strong) UIImage *bespokeIma;
@property (nonatomic, assign) BOOL olyerAnimation;
@property (nonatomic, assign) BOOL firstLun;
@end

@implementation CHMKMapView
static int firstLoad;

+ (CHMKMapView *)createMapView{
    CHMKMapView *mapView = [[CHMKMapView alloc] init];
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
    firstLoad = 0;
    _firstLun = YES;
    self.rotateEnabled = NO;
    self.delegate = self;
    
    //    self.userTrackingMode = MKUserTrackingModeFollow;
    self.polyliones = [NSMutableArray array];
    self.mapAnnotations = [NSMutableArray array];
    self.locaMar = [SMALocatiuonManager sharedCoreBlueTool];
    [self setCenterCoordinate:CLLocationCoordinate2DMake(39.9163854444,116.3971424103) animated:NO];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMap:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lpgrClick:)];
    [self addGestureRecognizer:lpgr];
    //    _zoomLevel = 15;
    
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

- (void)addAnnotationsWithTrackPoints:(NSMutableArray *)points{
    for (int i = 0; i < points.count; i ++) {
        CHHistoryInfo *location = points[i];
        CHPointAnnotation *point = [[CHPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake(location.Lat, location.Lng);
        if (i == 0) {
            point.annoTionImage = [UIImage imageNamed:@"icon_dinwei_qd"];
            point.textStr = CHLocalizedString(@"起点", nil);
            point.headColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
        }
        if (i == points.count - 1) {
            point.annoTionImage = [UIImage imageNamed:@"icon_dinwei_zd"];
            point.textStr = CHLocalizedString(@"终点", nil);
            point.headColor = CHUIColorFromRGB(0xff0000, 1.0);
        }
        [_mapAnnotations addObject:point];
    }

    [self addAnnotations:_mapAnnotations];
}

- (void)addSystemAnnotationWithPoints:(NSMutableArray *)points bespokeIma:(UIImage *)image{
    _bespokeIma = image;
    for (int i = 0; i < points.count; i ++) {
        CHUserInfo *location = points[i];
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = location.deviceCoor;
        [_mapAnnotations addObject:point];
    }
    [self addAnnotations:_mapAnnotations];
}

- (void)addCircleWithCenterCoordinate:(CLLocationCoordinate2D)coor radius:(int)radius animation:(BOOL)animation{
    _olyerAnimation = animation;
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:coor radius:radius];
    [_polyliones addObject:circle];
    [self addOverlays:_polyliones];
}

- (void)addPolyOverLaysWithTarckModes:(NSArray *)modes{
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(modes.count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < modes.count; i ++) {
        CHHistoryInfo *mode = modes[i];
        coords[i].latitude = mode.Lat;
        coords[i].longitude = mode.Lng;
    }
    MKPolyline *poly = [MKPolyline polylineWithCoordinates:coords count:modes.count];
    MKMapRect zoomRect =  [self mapRectThatFits:poly.boundingMapRect edgePadding:UIEdgeInsetsMake(60 * WIDTHAdaptive, 20, 12, 20)];
//    [self setVisibleMapRect:zoomRect animated:NO];
    [_polyliones addObject:poly];
    [self addOverlays:_polyliones];
    free(coords);
    [self updateMapviewVisibleRegionWithPoints:[modes mutableCopy]];
}

//配置地图轨迹所有的点，计算地图显示轨迹区域
- (void)updateMapviewVisibleRegionWithPoints:(NSMutableArray *)points{
    
    MKMapRect zoomRect = MKMapRectNull;
    for (int i = 0; i < points.count; i ++) {//若坐标量少于2个，会引起地图出现一片红色区域，原因不明
        CLLocationCoordinate2D code;
        CHHistoryInfo *mode = points[i];
        code.latitude = mode.Lat;
        code.longitude = mode.Lng;
        MKMapPoint annotationPoint = MKMapPointForCoordinate(code);
        MKMapRect rect1 = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = rect1;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, rect1);
        }
        //        }
    }
    zoomRect = [self mapRectThatFits:zoomRect];
    [self setVisibleMapRect:zoomRect animated:NO];
    
    int zoomlevel = [self getZoomLevel:self];
    //由于计算出区域刚好覆盖显示区域，所以需要进行调整
    [self setCenterCoordinate:self.centerCoordinate zoomLevel:zoomlevel > 2 ? (zoomlevel - 1) : zoomlevel animated:YES];
}

- (void)userDidSelectAnnotationView:(CHUserInfo *)selDevice{
    for (CHPointAnnotion*annotion in self.mapAnnotations) {
        CHAnnotationView *annoView = (CHAnnotationView *)[self viewForAnnotation:annotion];
        if ([[CHAccountTool user].deviceId isEqualToString:[(CHPointAnnotion *)annoView.annotation annotationUser].deviceId]) {
            annoView.annSelect = YES;
        }
        else{
            annoView.annSelect = NO;
        }
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSLog(@"didUpdateUserLocation %@",userLocation.location);
    if (self.userLocation.location && self.showsUserLocation && _firstLun) {
        _firstLun = NO;
        if (_zoomLevel == 0) {
            _zoomLevel = [self getZoomLevel:self];
        }
        [self setCenterCoordinate:self.userLocation.location.coordinate zoomLevel:_zoomLevel animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        NSLog(@"[self viewForAnnotation:self.userLocation] %@",[self viewForAnnotation:self.userLocation]);
        return nil;
    }
    if (([annotation isKindOfClass:[CHPointAnnotion class]])) {
        static NSString *ID = @"anno";
        CHAnnotationView *annoView = (CHAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        if (annoView == nil) {
            annoView = [[CHAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
            annoView.enabled = NO;
            //   annoView.centerOffset = CGPointMake(0, -10); // 设置大头针的偏移
        }
        if ([[CHAccountTool user].deviceId isEqualToString:[(CHPointAnnotion *)annotation annotationUser].deviceId]) {
            //   annoView.selected = YES;
        }

        [annoView setLabTit:[(CHPointAnnotion *)annotation annotationUser].deviceNa];
        [annoView didSelectAnnotaton:^(id<MKAnnotation> tapAnnotation) {
            if (block) {
                block(((CHPointAnnotion *)tapAnnotation).annotationUser);
            }
            NSLog(@"**********didSelectAnnotaton %@",tapAnnotation);
            for (CHPointAnnotion*annotion in self.mapAnnotations) {
                CHAnnotationView *subAnnoView = (CHAnnotationView *)[self viewForAnnotation:annotion];
                if ([((CHPointAnnotion *)tapAnnotation).annotationUser.deviceId isEqualToString:[(CHPointAnnotion *)subAnnoView.annotation annotationUser].deviceId]) {
                    subAnnoView.annSelect = YES;
                }
                else{
                    subAnnoView.annSelect = NO;
                }
            }
        }];
        return annoView;
    }
    if ([annotation isMemberOfClass:[CHPointAnnotation class]]) {
        static NSString *trackID = @"TACKANNO";
        CHTrackingAnnotationView *actionView = (CHTrackingAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:trackID];
        if (actionView == nil) {
            actionView = [[CHTrackingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:trackID];
        }
        if ([(CHPointAnnotation *)annotation textStr]) {
            [actionView setText:[(CHPointAnnotation *)annotation textStr]];
            actionView.imageView.image = [(CHPointAnnotation *)annotation annoTionImage];
            actionView.headColor = [(CHPointAnnotation *)annotation headColor];
            actionView.backgroundColor = CHUIColorFromRGB(0xff0000, 0.0);
            actionView.layer.masksToBounds = NO;
            actionView.layer.cornerRadius = 0;
        }
        else{
            actionView.bounds = CGRectMake(0, 0, 6, 6);
            actionView.backgroundColor = CHUIColorFromRGB(0xff0000, 1.0);
            actionView.layer.masksToBounds = YES;
            actionView.layer.cornerRadius = 3;
        }
        actionView.hidden = NO;
        return actionView;
    }
    
    if ([annotation isMemberOfClass:[MKPointAnnotation class]]) {
        static NSString *SYSID = @"systemanno";
        MKAnnotationView *annoView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:SYSID];
        if (annoView == nil) {
            annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:SYSID];
            annoView.centerOffset = CGPointMake(0, -_bespokeIma.size.height/2); // 设置大头针的偏移
        }
        annoView.image = _bespokeIma;
        return annoView;
    }
    return nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isMemberOfClass:[MKCircle class]]) {
        MKCircleRenderer *render = [[MKCircleRenderer alloc] initWithCircle:(MKCircle  *)overlay];
        render.fillColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
        render.alpha = 0.3;
        return render;
    }
//    if ([overlay isMemberOfClass:[CHPolyline class]]) {
    if ([overlay isMemberOfClass:[MKPolyline class]]) {
//        MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithPolyline:(CHPolyline *)overlay];
        MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
        render.strokeColor = CHUIColorFromRGB(0xff0000, 1.0);
        render.lineWidth = 3.0;
        return render;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    for (MKAnnotationView *view in views) {
        if ([view isKindOfClass:NSClassFromString(@"CHAnnotationView")]) {
            CHAnnotationView *annoView = (CHAnnotationView *)view;
            annoView.annSelect = NO;
            if ([[CHAccountTool user].deviceId isEqualToString:[(CHPointAnnotion *)annoView.annotation annotationUser].deviceId]) {
                annoView.annSelect = YES;
                NSLog(@"*******************************annoView %@",annoView);
            }
        }
    }
}

- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray<MKOverlayRenderer *> *)renderers{
    MKCircle *circle = (MKCircle *)renderers.firstObject.overlay;
    if (_olyerAnimation) {
        [self setVisibleMapRect:circle.boundingMapRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:NO];
        _olyerAnimation = NO;
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
    }
    if (_firstLun) {
        if (firstLoad == 0) {
        firstLoad ++;
        [self setCenterCoordinate:CLLocationCoordinate2DMake(39.9163854444,116.3971424103) zoomLevel:_zoomLevel animated:NO];
//             _zoomLevel = zoomLevel;
            _firstLun = NO;
        }
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    NSLog(@"didSelectAnnotaton %@  ** %d",view,view.selected);
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"didDeselectAnnotationView %@  ** %d",view,view.selected);
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

- (void)tapMap:(UITapGestureRecognizer *)tapGesture{
    NSLog(@"tapMap");
    if (tapBlock) {
        tapBlock(self);
    }
}

- (void)lpgrClick:(UILongPressGestureRecognizer *)lpgr{
    if(lpgr.state == UIGestureRecognizerStateBegan){
        if (longBlock) {
            longBlock(self,[lpgr locationInView:self]);
        }
    }
}

- (MKAnnotationView *)viewForAnnotationSelect:(NSInteger)inter{
    for (CHPointAnnotation*annotion in self.mapAnnotations) {
        CHTrackingAnnotationView *subAnnoView = (CHTrackingAnnotationView *)[self viewForAnnotation:annotion];
        NSLog(@"MKAnnotationView %@",subAnnoView);
        NSLog(@"MKAnnotationView %f *** %f",annotion.coordinate.latitude,annotion.coordinate.longitude);
    }
    return [self viewForAnnotation:[self.mapAnnotations objectAtIndex:inter]];
}

- (void)longMapCallBack:(void (^)(MKMapView *mapView, CGPoint point))callBack{
    longBlock = callBack;
}

- (void)tapMapCallBack:(void (^)(MKMapView *mapView))callBack{
    tapBlock = callBack;
}

- (void)didSelectMapAnnotationView:(void (^)(CHUserInfo *didDevice))callBack{
    block = callBack;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
