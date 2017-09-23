//
//  CHRequestInfoMode.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/23.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHRequestInfoMode : NSObject
@property (nonatomic, assign) NSInteger DeviceId;
@property (nonatomic, assign) NSInteger UserId;
@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, assign) NSInteger RequestId;
@property (nonatomic, assign) NSInteger Status;
@property (nonatomic, copy) NSString *Created;
@property (nonatomic, copy) NSString *Info;
@property (nonatomic, copy) NSString *Nickname;
@property (nonatomic, copy) NSString *Avatar;
@end
