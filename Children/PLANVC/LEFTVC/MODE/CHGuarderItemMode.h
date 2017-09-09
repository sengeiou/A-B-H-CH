//
//  CHGuarderItemMode.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/9.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHGuarderItemMode : NSObject
@property (nonatomic, strong) NSString *Nickname;
@property (nonatomic, assign) NSInteger UserId;
@property (nonatomic, assign) NSInteger UserGroupId;
@property (nonatomic, assign) NSInteger DeviceId;
@property (nonatomic, strong) NSString *GroupName;
@property (nonatomic, strong) NSString *Username;
@property (nonatomic, strong) NSString *DeviceName;
@property (nonatomic, strong) NSString *SerialNumber;
@property (nonatomic, strong) NSString *Avatar;
@property (nonatomic, assign) BOOL IsAdmin;
@property (nonatomic, strong) NSString *Phone;
@property (nonatomic, strong) NSString *RelationName;
@property (nonatomic, strong) NSString *RelationPhone;
@property (nonatomic, strong) NSString *LoginName;
@property (nonatomic, assign) BOOL IsDefault;
@property (nonatomic, assign) BOOL IsSos;
@end
