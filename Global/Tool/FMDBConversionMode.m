//
//  FMDBConversionMode.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/21.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "FMDBConversionMode.h"

@implementation FMDBConversionMode
{
    NSString *filename;
}
static id _instace;
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)sharedCoreBlueTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone{
    return _instace;
}

//懒加载
- (FMDatabaseQueue *)queue{
    if(!_queue)
    {
        _queue= [self createDataBase];
    }
    return _queue;
}

- (FMDatabaseQueue *)createDataBase{
     filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CHwatch.sqlite"];
    // 1.创建数据库队列
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filename];
    // 2.创表
    if (!_queue) {
        [queue inDatabase:^(FMDatabase *db) {
            BOOL result;
            result = [db executeUpdate:@"create table if not exists tb_deviceList (userId varchar(50),deviceId varchar(50),devicePh archar(50),deviceNa varchar(50),deviceIm varchar(50),deviceBi varchar(50),deviceHe varchar(50),deviceWi varchar(50),deviceGe varchar(50),deviceIMEI varchar(50),relatoin varchar(50))"];
            NSLog(@"创表 %d",result);
        }];
    }
    return queue;
}

- (void)deleteDevice:(CHUserInfo *)userInfo{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL result;
        result = [db executeUpdate:@"delete from tb_deviceList where deviceId=?",userInfo.userId];
        NSLog(@"删除该账号下所有设备数据 %d",result);
    }];
}

- (void)insertDevice:(CHUserInfo *)deviceInfo{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL result;
        result = [db executeUpdate:@"insert into tb_deviceList (userId,deviceId,devicePh,deviceNa,deviceIm,deviceBi,deviceHe,deviceWi,deviceGe,deviceIMEI,relatoin) values(?,?,?,?,?,?,?,?,?,?)",[TypeConversionMode strongChangeString:deviceInfo.userId],[TypeConversionMode strongChangeString:deviceInfo.deviceId],[TypeConversionMode strongChangeString:deviceInfo.devicePh],[TypeConversionMode strongChangeString:deviceInfo.deviceNa],[TypeConversionMode strongChangeString:deviceInfo.deviceIm],[TypeConversionMode strongChangeString:deviceInfo.deviceBi],[TypeConversionMode strongChangeString:deviceInfo.deviceHe],[TypeConversionMode strongChangeString:deviceInfo.deviceWi],[TypeConversionMode strongChangeString:deviceInfo.deviceGe],[TypeConversionMode strongChangeString:deviceInfo.deviceIMEI],[TypeConversionMode strongChangeString:deviceInfo.relatoin]];
        NSLog(@"插入设备数据 %d",result);
    }];
}
@end
