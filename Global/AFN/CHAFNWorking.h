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
    REQUESTURL_RegisterNeedSMSCode ,      //注册
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
    REQUESTURL_UInviteUser,               //邀请用户
    REQUESTURL_GeofenceList,              //查询安全圈列表
    REQUESTURL_CreateGeofence,            //创建安全圈
    REQUESTURL_EditGeofence,              //编辑安全圈信息
    REQUESTURL_DeleteGeofence,            //删除安全圈信息
    REQUESTURL_MonthHistoryDays,          //查询指定月份那些天存在轨迹数据
    REQUESTURL_History,                   //查询手表历史定位数据
    REQUESTURL_ExcdeptionListWhitoutCode, //获取报警信息列表
    REQUESTURL_CommandList,               //获取设备指令集合
    REQUESTURL_EditUserInfo,              //编辑登录app的用户信息
    REQUESTURL_RequestList,               //绑定申请的消息列表
    REQUESTURL_Process,                   //处理分享请求
    REQUESTURL_ChangePassword,            //修改密码
    REQUESTURL_VoiceUpload,               //语音聊天提交服务器
    REQUESTURL_VoiceFileListByTime,       //通过用户获取语音聊天记录
    REQUESTURL_FindPassword,              //找回密码
    REQUESTURL_UserInfo,                  //获取用户信息
    REQUESTURL_GetVoice,                  //获取单个语音信息
};

@interface CHAFNWorking : NSObject
@property (nonatomic, strong) AFHTTPSessionManager * _Nullable sessionMgr;
@property (nonatomic, strong) NSMutableDictionary * _Nonnull requestDic;
@property (nonatomic, strong) NSString * _Nullable GetOrderStatus;
@property (nonatomic, assign) BOOL moreRequest;
@property (nonatomic, assign) BOOL requestMess;
+ (instancetype _Nullable )shareAFNworking;
- (void)CHAFNPostRequestUrl:(REQUESTURL)url parameters:(NSMutableDictionary *_Nullable)par Mess:(NSString *_Nullable)messtr showError:(BOOL)show progress:(void (^_Nullable)(NSProgress * _Nonnull uploadProgress))Progress success:(void (^_Nullable)(NSURLSessionDataTask * _Nonnull task, id _Nullable result))success failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;
@end
