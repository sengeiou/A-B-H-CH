//
//  CHFenceInfoMode.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHFenceInfoMode : NSObject<NSCopying,NSMutableCopying>
@property (nonatomic, assign) NSInteger FenceId;
@property (nonatomic, assign) NSInteger DeviceId;
@property (nonatomic, strong) NSString *FenceName;
@property (nonatomic, assign) CGFloat Latitude;
@property (nonatomic, assign) CGFloat Longitude;
@property (nonatomic, assign) CGFloat Radius;
@property (nonatomic, assign) NSInteger FenceType;
@property (nonatomic, assign) NSInteger AlarmType;
@property (nonatomic, assign) NSInteger IsDeviceFence;
@property (nonatomic, assign) NSInteger AlarmModel;
@property (nonatomic, assign) NSInteger DeviceFenceNo;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, strong) NSArray *IMEIList;
@property (nonatomic, strong) NSArray *Points;
@property (nonatomic, strong) NSString *Address;
@property (nonatomic, assign) BOOL InUse;
@property (nonatomic, assign) NSString *StartTime;
@property (nonatomic, assign) NSString *EndTime;
@end
