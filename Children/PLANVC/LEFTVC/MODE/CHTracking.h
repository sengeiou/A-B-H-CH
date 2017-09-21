//
//  CHTracking.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/15.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHPointAnnotation.h"

@interface CHTracking : NSObject<CAAnimationDelegate>
/*!
 @brief 初始化时需要提供的 mapView
 */
@property (nonatomic, strong) CHMKMapView *mapView;

/*!
 @brief 轨迹回放动画时间
 */
@property (nonatomic, assign) NSTimeInterval duration;

/*!
 @brief 边界差值
 */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/*!
 @brief 标注对应的annotation
 */
@property (nonatomic, strong, readonly) CHPointAnnotation *annotation;

/*!
 @brief 轨迹对应的overlay
 */
@property (nonatomic, strong, readonly) MKPolyline *polyline;
- (instancetype)initWithCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSUInteger)count;
- (void)execute;
- (void)clear;
@end
