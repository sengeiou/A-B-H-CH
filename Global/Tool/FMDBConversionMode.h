//
//  FMDBConversionMode.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/21.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface FMDBConversionMode : NSObject
@property (nonatomic, strong) FMDatabaseQueue *queue;
+ (instancetype)sharedCoreBlueTool;
/**
 删除该账号下的设备

 @param userInfo 登录的账号信息
 */
- (void)deleteAllDevice:(CHUserInfo *)userInfo;

- (void)updateDevice:(CHUserInfo *)deviceInfo;

- (void)deleteDevice:(CHUserInfo *)userInfo;

- (void)insertDevice:(CHUserInfo *)deviceInfo;

- (NSMutableArray <CHUserInfo *>*)searchDevice:(CHUserInfo *)user;

- (void)insertChatData:(NSMutableArray <CHVideoMode *>*) chatList;

- (CHVideoMode *)selectChatDataWithMode:(CHVideoMode *)mode;

- (void)updateChatDataWithMode:(CHVideoMode *)mode;
@end
