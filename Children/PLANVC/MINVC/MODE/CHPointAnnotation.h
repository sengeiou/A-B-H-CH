//
//  CHPointAnnotation.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/29.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CHPointAnnotation : MKPointAnnotation
@property (nonatomic, strong) CHUserInfo *poinUser;
@end
