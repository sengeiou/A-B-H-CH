//
//  CHPolyline.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/16.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHPolyline.h"

@implementation CHPolyline

-(MKMapRect)boundingMapRect{
    MKMapPoint origin;
    origin.x = 187413395.90200892;
    origin.y = 68232832.391458735;
    MKMapSize size = MKMapSizeWorld;
    size.width =67108864;
    size.height = 67108864.000000015;
    MKMapRect boundingMapRect = (MKMapRect) {origin, size};
    
    return boundingMapRect;
}
@end
