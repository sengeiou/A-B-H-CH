//
//  CHUserInfo.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/17.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHUserInfo.h"

@implementation CHUserInfo
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _userId = [aDecoder decodeObjectForKey:@"_userId"];
        _userPh = [aDecoder decodeObjectForKey:@"_userPh"];
        _userPs = [aDecoder decodeObjectForKey:@"_userPs"];
        _userNa = [aDecoder decodeObjectForKey:@"_userNa"];
        _userIm = [aDecoder decodeObjectForKey:@"_userIm"];
        _userTo = [aDecoder decodeObjectForKey:@"_userTo"];
        _deviceId = [aDecoder decodeObjectForKey:@"_deviceId"];
        _devicePh = [aDecoder decodeObjectForKey:@"_devicePh"];
        _deviceNa = [aDecoder decodeObjectForKey:@"_deviceNa"];
        _deviceIm = [aDecoder decodeObjectForKey:@"_deviceIm"];
        _deviceBi = [aDecoder decodeObjectForKey:@"_deviceBi"];
        _deviceHe = [aDecoder decodeObjectForKey:@"_deviceHe"];
        _deviceWi = [aDecoder decodeObjectForKey:@"_deviceWi"];
        _deviceGe = [aDecoder decodeObjectForKey:@"_deviceGe"];
        _deviceIMEI = [aDecoder decodeObjectForKey:@"_deviceIMEI"];
        _deviceTy = [aDecoder decodeObjectForKey:@"_deviceTy"];
        _deviceMo = [aDecoder decodeObjectForKey:@"_deviceMo"];
        _relatoin = [aDecoder decodeObjectForKey:@"_relatoin"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_userId forKey:@"_userId"];
    [aCoder encodeObject:_userPh forKey:@"_userPh"];
    [aCoder encodeObject:_userPs forKey:@"_userPs"];
    [aCoder encodeObject:_userNa forKey:@"_userNa"];
    [aCoder encodeObject:_userIm forKey:@"_userIm"];
    [aCoder encodeObject:_userTo forKey:@"_userTo"];
    [aCoder encodeObject:_deviceId forKey:@"_deviceId"];
    [aCoder encodeObject:_devicePh forKey:@"_devicePh"];
    [aCoder encodeObject:_deviceNa forKey:@"_deviceNa"];
    [aCoder encodeObject:_deviceIm forKey:@"_deviceIm"];
    [aCoder encodeObject:_deviceBi forKey:@"_deviceBi"];
    [aCoder encodeObject:_deviceHe forKey:@"_deviceHe"];
    [aCoder encodeObject:_deviceWi forKey:@"_deviceWi"];
    [aCoder encodeObject:_deviceGe forKey:@"_deviceGe"];
    [aCoder encodeObject:_deviceIMEI forKey:@"_deviceIMEI"];
    [aCoder encodeObject:_deviceTy forKey:@"_deviceTy"];
    [aCoder encodeObject:_deviceMo forKey:@"_deviceMo"];
    [aCoder encodeObject:_relatoin forKey:@"_relatoin"];
}
@end
