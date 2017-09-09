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
    REQUESTURL_SavePersonProfile,         //保存手表属性信息
    REQUESTURL_SendCommand,               //发送指令至设备
    REQUESTURL_PersonTracking,            //个人设备单个获取详细信息
    REQUESTURL_ShareList,                 //查询设备监护人列表
    REQUESTURL_RemoveShare,               //解除绑定
    REQUESTURL_ChangeMasterUser,          //更换设备主控用户
    REQUESTURL_UpdateRelationName,        //更新监护人的关系名称
};

@interface CHAFNWorking : NSObject
@property (nonatomic, strong) AFHTTPSessionManager * _Nullable sessionMgr;
@property (nonatomic, strong) NSMutableDictionary * _Nonnull requestDic;
@property (nonatomic, strong) NSString * _Nullable GetOrderStatus;
@property (nonatomic, assign) BOOL moreRequest;
+ (instancetype _Nullable )shareAFNworking;
- (void)CHAFNPostRequestUrl:(REQUESTURL)url parameters:(NSMutableDictionary *_Nullable)par Mess:(NSString *_Nullable)messtr showError:(BOOL)show progress:(void (^_Nullable)(NSProgress * _Nonnull uploadProgress))Progress success:(void (^_Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable result))success failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;
@end
