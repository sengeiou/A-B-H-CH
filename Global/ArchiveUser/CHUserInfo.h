//
//  CHUserInfo.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/17.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHGeoCodingMode.h"

@interface CHUserInfo : NSObject<NSCoding>
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userPh;
@property (nonatomic, copy) NSString *userPs;
@property (nonatomic, copy) NSString *userNa;
@property (nonatomic, copy) NSString *userIm;
@property (nonatomic, copy) NSString *userTo;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *devicePh;
@property (nonatomic, copy) NSString *deviceNa;
@property (nonatomic, copy) NSString *deviceIm;
@property (nonatomic, copy) NSString *deviceBi;
@property (nonatomic, copy) NSString *deviceHe;
@property (nonatomic, copy) NSString *deviceWi;
@property (nonatomic, copy) NSString *deviceGe;
@property (nonatomic, copy) NSString *deviceIMEI;
@property (nonatomic, copy) NSString *deviceTy;
@property (nonatomic, copy) NSString *deviceMo;
@property (nonatomic, copy) NSString *relatoin;

@property (nonatomic, assign) CLLocationCoordinate2D deviceCoor;
@property (nonatomic, strong) CHGeoCodingMode *GeoCoding;

@end
