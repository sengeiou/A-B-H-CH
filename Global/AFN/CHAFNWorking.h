//
//  CHAFNWorking.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/16.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, REQUESTURL) {
    REQUESTURL_CheckUser = 1,             //检查是否已注册
    REQUESTURL_SendSMS ,                  //获取验证码
    REQUESTURL_Register ,                 //注册
    REQUESTURL_PersonDeviceList ,         //设备列表
    REQUESTURL_Login,                     //登录
    REQUESTURL_ChangePasswordNeedSMSCode, //重置密码
    REQUESTURL_CheckDevice,               //查找设备
    REQUESTURL_AddDeviceAndUserGroup,     //添加设备
//    REQUESTURL_HasOverTime_NoneGrab,    //已超时,未被抢单
//    REQUESTURL_HasOverTime_NoCommit      //抢到的单已超时,未提交
};



@interface CHAFNWorking : NSObject
@property (nonatomic, strong) AFHTTPSessionManager * _Nullable sessionMgr;
@property (nonatomic, strong) NSMutableDictionary * _Nonnull requestDic;
@property (nonatomic, strong) NSString * _Nullable GetOrderStatus;
+ (instancetype _Nullable )shareAFNworking;
- (void)CHAFNPostRequestUrl:(REQUESTURL)url parameters:(NSMutableDictionary *_Nullable)par Mess:(NSString *_Nullable)messtr showError:(BOOL)show progress:(void (^_Nullable)(NSProgress * _Nonnull uploadProgress))Progress success:(void (^_Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable result))success failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;
@end
