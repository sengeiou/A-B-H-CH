//
//  CHAFNWorking.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/16.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHAFNWorking.h"

static NSString *prfixStr = @"http://openapi.5gcity.com/";

@interface CHAFNWorking ()

@end

@implementation CHAFNWorking
static id _instace;

+ (instancetype)shareAFNworking{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
        [_instace initilize];
    });
    return _instace;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instace;
}


- (NSMutableDictionary *)requestDic{
    //    if (!_requestDic) {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
    _requestDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[CHDefaultionfos CHgetValueforKey:CHAPPTOKEN] ? [CHDefaultionfos CHgetValueforKey:CHAPPTOKEN]:@"",@"Token",@"87",@"AppId",preferredLang,@"Language", nil];
    //    }
    return _requestDic;
}

- (void)initilize{
    _sessionMgr = [AFHTTPSessionManager manager];
    _sessionMgr.requestSerializer = [AFJSONRequestSerializer serializer];
    _sessionMgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json",@"text/json", nil];
    [_sessionMgr.requestSerializer setValue:@"EF3F9B98-E528-47B2-B0D0-B849D6A3209A" forHTTPHeaderField:@"key"];
    [_sessionMgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [_sessionMgr.requestSerializer setTimeoutInterval:60.0];
}

- (void)CHAFNPostRequestUrl:(REQUESTURL)url parameters:(NSMutableDictionary *)par Mess:(NSString *)messtr showError:(BOOL)show progress:(void (^)(NSProgress * _Nonnull uploadProgress))Progress success:(void (^)(NSURLSessionDataTask * _Nonnull task, id _Nullable result))success failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure{
    @WeakObj(self)
    if (show && messtr) {
        [MBProgressHUD showMessage:messtr];
    }
    [_sessionMgr POST:[prfixStr stringByAppendingString:GetOrderStatus(url)] parameters:par progress:^(NSProgress * _Nonnull uploadProgress) {
        Progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"\nresponseObject***********************\n%@\nrequesturl: %@\n********************",responseObject,[prfixStr stringByAppendingString:GetOrderStatus(url)]);
        if (show && !_moreRequest) {
            [MBProgressHUD hideHUD];
        }
        selfWeak.requestMess = [selfWeak showMessAgeWithResponse:responseObject];
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"\error***********************\n%@\nrequesturl: %@\n********************",error,[prfixStr stringByAppendingString:GetOrderStatus(url)]);
        if (error && error.code == -999) {
            failure(task,nil);
        }
        else{
            _moreRequest = NO;
            failure(task,error);
            if (show) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:error.localizedDescription];
            }
        }
    }];
    
}

NSString * GetOrderStatus(REQUESTURL status) {
    switch (status) {
        case REQUESTURL_CheckUser:
            return @"api/User/CheckUser";
        case REQUESTURL_SendSMS:
            return @"api/User/SendSMSCodeByYunPian";
        case REQUESTURL_Register:
            /*"api/User/Register" 测试注册  正式注册 api/User/RegisterNeedSMSCode*/
            //            return @"api/User/RegisterNeedSMSCode";
            return @"api/User/Register";
        case REQUESTURL_RegisterNeedSMSCode:
            return @"api/User/RegisterNeedSMSCode";
        case REQUESTURL_PersonDeviceList:
            return @"api/Device/PersonDeviceList";
        case REQUESTURL_Login:
            return @"api/User/Login";
        case REQUESTURL_ChangePasswordNeedSMSCode:
            return @"api/User/ChangePasswordNeedSMSCode";
        case REQUESTURL_CheckDevice:
            return @"api/Device/CheckDevice";
        case REQUESTURL_AddDeviceAndUserGroup:
            return @"api/Device/AddDeviceAndUserGroup";
        case REQUESTURL_SavePersonProfile:
            return @"api/Person/SavePersonProfile";
        case REQUESTURL_SendCommand:
            return @"api/Command/SendCommand";
        case REQUESTURL_PersonTracking:
            return @"api/Device/PersonTracking";
        case REQUESTURL_ShareList:
            return @"api/AuthShare/ShareList";
        case REQUESTURL_RemoveShare:
            return @"api/AuthShare/RemoveShare";
        case REQUESTURL_ChangeMasterUser:
            return @"api/User/ChangeMasterUser";
        case REQUESTURL_UpdateRelationName:
            return @"api/AuthShare/UpdateRelationName";
        case REQUESTURL_UInviteUser:
            return @"api/User/InviteUser";
        case REQUESTURL_GeofenceList:
            return @"api/Geofence/GeofenceList";
        case REQUESTURL_CreateGeofence:
            return @"api/Geofence/CreateGeofence";
        case REQUESTURL_EditGeofence:
            return @"api/Geofence/EditGeofence";
        case REQUESTURL_DeleteGeofence:
            return @"api/Geofence/DeleteGeofence";
        case REQUESTURL_MonthHistoryDays:
            return @"api/Location/MonthHistoryDays";
        case REQUESTURL_History:
            return @"api/Location/History";
        case REQUESTURL_ExcdeptionListWhitoutCode:
            return @"api/ExceptionMessage/ExcdeptionListWhitoutCode";
        case REQUESTURL_CommandList:
            return @"api/Command/CommandList";
        case REQUESTURL_EditUserInfo:
            return @"api/User/EditUserInfo";
        case REQUESTURL_RequestList:
            return @"api/AuthShare/RequestList";
        case REQUESTURL_Process:
            return @"api/AuthShare/Process";
        case REQUESTURL_ChangePassword:
            return @"api/User/ChangePassword";
        case REQUESTURL_VoiceUpload:
            return @"api/Files/VoiceUpload";
        case REQUESTURL_VoiceFileListByTime:
            return @"api/Files/VoiceFileListByTime";
        case REQUESTURL_FindPassword:
            return @"api/User/FindPassword";
        case REQUESTURL_UserInfo:
            return @"api/User/UserInfo";
        case REQUESTURL_GetVoice:
            return @"api/Files/GetVoice";
        default:
            return @"";
    }
}

- (BOOL)showMessAgeWithResponse:(id _Nullable)responseObject{
    if (responseObject && [[responseObject objectForKey:@"State"] intValue] != 0 && [[responseObject objectForKey:@"State"] intValue] != 1107 && [[responseObject objectForKey:@"State"] intValue] != 1500 && [[responseObject objectForKey:@"State"] intValue] != 1501) {
        if (![[responseObject objectForKey:@"Message"] isEqual:[NSNull null]] && [responseObject objectForKey:@"Message"] != nil && [responseObject objectForKey:@"Message"] && ![[responseObject objectForKey:@"Message"] isEqualToString:@""]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:[responseObject objectForKey:@"Message"]];
            return YES;
        }
        else{
            return NO;
        }
    }
    return YES;
}
@end
