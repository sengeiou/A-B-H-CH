//
//  CHTrackingAnnotationView.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/15.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CHTrackHeadVeiw.h"

@interface CHTrackingAnnotationView : MKAnnotationView
@property (nonatomic, strong) CHTrackHeadVeiw *trackView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIColor *headColor;
- (void)setText:(NSString *)text;
@end
