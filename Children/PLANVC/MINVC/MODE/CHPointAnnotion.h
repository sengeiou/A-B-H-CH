//
//  CHPointAnnotion.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/30.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CHPointAnnotion : MKPointAnnotation
@property (nonatomic, copy) CHUserInfo *annotationUser;
@end
