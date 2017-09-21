//
//  CHMessageListInfoMode.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/18.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHMessageListInfoMode : NSObject
@property (nonatomic, copy) NSString *Avatar;
@property (nonatomic, copy) NSString *Message;
@property (nonatomic, copy) NSString *Nickname;
@property (nonatomic, copy) NSString *DeviceName;
@property (nonatomic, copy) NSString *ModelName;
@property (nonatomic, assign) NSInteger ExceptionID;
@property (nonatomic, copy) NSString *SerialNumber;
@property (nonatomic, assign) NSInteger DeviceID;
@property (nonatomic, assign) NSInteger GeoFenceID;
@property (nonatomic, assign) NSInteger NotificationType;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, assign) NSInteger Deleted;
@property (nonatomic, copy) NSString *GeoName;
@property (nonatomic, assign) CGFloat Lat;
@property (nonatomic, assign) CGFloat Lng;
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *DeviceDate;
@property (nonatomic, assign) CGFloat OLat;
@property (nonatomic, assign) CGFloat OLng;
@property (nonatomic, assign) NSInteger FenceNo;
@property (nonatomic, copy) NSString *ExceptionName;

@end
