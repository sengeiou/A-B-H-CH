//
//  CHFenceInfoMode.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHFenceInfoMode.h"

@implementation CHFenceInfoMode
- (id)copyWithZone:(NSZone *)zone{
    CHFenceInfoMode *copy = [[[super class] allocWithZone:zone] init];
    copy.FenceId = _FenceId;
    copy.DeviceId = _DeviceId;
    copy.FenceName = _FenceName;
    copy.Latitude = _Latitude;
    copy.Longitude = _Longitude;
    copy.Radius = _Radius;
    copy.FenceType = _FenceType;
    copy.AlarmType = _AlarmType;
    copy.IsDeviceFence = _IsDeviceFence;
    copy.AlarmModel = _AlarmModel;
    copy.DeviceFenceNo = _DeviceFenceNo;
    copy.Description = _Description;
    copy.IMEIList = _IMEIList;
    copy.Points = _Points;
    copy.Address = _Address;
    copy.InUse = _InUse;
    copy.StartTime = _StartTime;
    copy.EndTime = _EndTime;
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    CHFenceInfoMode *copy = [CHFenceInfoMode allocWithZone:zone];
    copy.FenceId = _FenceId;
    copy.DeviceId = _DeviceId;
    copy.FenceName = _FenceName;
    copy.Latitude = _Latitude;
    copy.Longitude = _Longitude;
    copy.Radius = _Radius;
    copy.FenceType = _FenceType;
    copy.AlarmType = _AlarmType;
    copy.IsDeviceFence = _IsDeviceFence;
    copy.AlarmModel = _AlarmModel;
    copy.DeviceFenceNo = _DeviceFenceNo;
    copy.Description = _Description;
    copy.IMEIList = _IMEIList;
    copy.Points = _Points;
    copy.Address = _Address;
    copy.InUse = _InUse;
    copy.StartTime = _StartTime;
    copy.EndTime = _EndTime;
    return copy;
}
@end
