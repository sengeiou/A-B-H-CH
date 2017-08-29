//
//  CHLocationMar.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/27.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CHLocationMar : CLLocationManager<CLLocationManagerDelegate>
+ (instancetype)shareLocation;
- (void)commonInit;
@end
