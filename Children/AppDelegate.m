//
//  AppDelegate.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/11.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //修改状态栏文字颜色（plist View controller-based status bar appearance 设置NO）
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if (![CHDefaultionfos CHgetValueforKey:CHFIRSTLUN]) {
        self.window.rootViewController = [[ViewController alloc] init];
    }
    //    CHNavViewController *nav = [[CHNavViewController alloc] initWithRootViewController:[[CHRegAnLogViewController alloc] init]];
    else if ([CHAccountTool user].userId && ![[CHAccountTool user].userId isEqualToString:@""]) {
        CHKLTViewController *nav = [[CHKLTViewController alloc] initWithRootViewController:[[MainViewController alloc] init]];
        CHLeftViewController *leftVC = [[CHLeftViewController alloc] init];
         self.leftSliderViewController = [[LeftSliderViewController alloc] initWithLeftView:leftVC andMainView:nav];
        NSLog(@"leftSliderViewController =%@",self.leftSliderViewController);
        self.window.rootViewController = self.leftSliderViewController;
    }
    else{
        CHKLTViewController *nav = [[CHKLTViewController alloc] initWithRootViewController:[[CHRegAnLogViewController alloc] init]];
        self.window.rootViewController = nav;
    }
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:advertisingId];
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
//            if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//              NSSet<UNNotificationCategory *> *categories;
//              entity.categories = categories;
//            }
//            else {
//              NSSet<UIUserNotificationCategory *> *categories;
//              entity.categories = categories;
//            }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    RecordVoice *code = [[RecordVoice alloc] init];
    [code recordVioce:@""];
    [code cancleVoice];
    [self.window makeKeyAndVisible];
    
//    Byte byte[2];//= 0x12c
//    byte[0] = 0x01;
//    byte[1] = 0x2c;
//    int losByte = byte[1] << 8;
    
    unsigned long num1 = strtoul([@"30" UTF8String],0,16);
    unsigned long num2 = strtoul([@"30" UTF8String],0,16);
    unsigned long num3 = strtoul([@"33" UTF8String],0,16);
    unsigned long num4 = strtoul([@"2E" UTF8String],0,16);
    unsigned long num5 = strtoul([@"36" UTF8String],0,16);
    unsigned long num6 = strtoul([@"35" UTF8String],0,16);
    unsigned long num7 = strtoul([@"02" UTF8String],0,16);
    unsigned long num8 = strtoul([@"05" UTF8String],0,16);
    unsigned long num9 = strtoul([@"0D" UTF8String],0,16);
    unsigned long num10 = strtoul([@"0A" UTF8String],0,16);
    // 进制相加
    Byte A = {0};
    A = num1 + num2 + num3 + num4 + num5 + num6 + num7 + num8 + num9 + num10;
    NSString *string = [NSString stringWithFormat:@"%0X",A];
    Byte b = (44 & 0xff);
    short s = 378;
    Byte buf[2];
    buf[0] = (Byte)((s >> 8)&0xff);
    buf[1] = (Byte)((s >> 0)&0xff);
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
//        [rootViewController addNotificationCount];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        if ([userInfo[@"DataType"] intValue] == 3 && [userInfo[@"Status"] intValue] == 1) {
            NSDictionary *apsDic = userInfo[@"aps"];
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:[TypeConversionMode strongChangeString:apsDic[@"alert"]] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *conFimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_agree", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dealRequestNotic:YES requestId:userInfo[@"RequestID"]];
            }];
            UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_disagree", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dealRequestNotic:NO requestId:userInfo[@"RequestID"]];
            }];
            [aler addAction:cancelAct];
            [aler addAction:conFimAct];
            [self.window.rootViewController presentViewController:aler animated:YES completion:^{
            }];
            completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
        }else if ([userInfo[@"DataType"] intValue] == 3 && [userInfo[@"Status"] intValue] != 1) {
            NSDictionary *apsDic = userInfo[@"aps"];
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:[TypeConversionMode strongChangeString:apsDic[@"alert"]] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *conFimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //                [self dealRequestNotic:YES requestId:userInfo[@"RequestID"]];
            }];
            UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_disagree", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dealRequestNotic:NO requestId:userInfo[@"RequestID"]];
            }];
//            [aler addAction:cancelAct];
            [aler addAction:conFimAct];
            [self.window.rootViewController presentViewController:aler animated:YES completion:^{
            }];
        }
//       [rootViewController addNotificationCount];
         if ([userInfo[@"DataType"] intValue] == 2) {
              [CHNotifictionCenter postNotificationName:@"VIDEONOTIFICATION" object:nil userInfo:@{@"VIDEO":userInfo}];
             completionHandler(UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
         }
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    }
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        if ([userInfo[@"DataType"] intValue] == 3 && [userInfo[@"Status"] intValue] == 1) {
            NSDictionary *apsDic = userInfo[@"aps"];
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:[TypeConversionMode strongChangeString:apsDic[@"alert"]] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *conFimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_agree", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dealRequestNotic:YES requestId:userInfo[@"RequestID"]];
            }];
            UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_disagree", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dealRequestNotic:NO requestId:userInfo[@"RequestID"]];
            }];
            [aler addAction:cancelAct];
            [aler addAction:conFimAct];
            [self.window.rootViewController presentViewController:aler animated:YES completion:^{
            }];
        }
        else if ([userInfo[@"DataType"] intValue] == 3 && [userInfo[@"Status"] intValue] != 1) {
            NSDictionary *apsDic = userInfo[@"aps"];
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:[TypeConversionMode strongChangeString:apsDic[@"alert"]] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *conFimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self dealRequestNotic:YES requestId:userInfo[@"RequestID"]];
            }];
            UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_disagree", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dealRequestNotic:NO requestId:userInfo[@"RequestID"]];
            }];
//            [aler addAction:cancelAct];
            [aler addAction:conFimAct];
            [self.window.rootViewController presentViewController:aler animated:YES completion:^{
            }];
        }
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        if ([userInfo[@"DataType"] intValue] == 2) {
            [CHNotifictionCenter postNotificationName:@"VIDEONOTIFICATION" object:nil userInfo:@{@"VIDEO":userInfo}];
        }
//        [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}

- (void)dealRequestNotic:(BOOL)agree requestId:(NSString *)requestID{
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"RequestId": requestID,
                                    @"TypeId": agree ? @"1":@"2"}];
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_Process parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        if ([result[@"State"] intValue] == 0) {
            [MBProgressHUD showSuccess:CHLocalizedString(@"aler_processed", nil)];
        }
        else{
            [MBProgressHUD showError:CHLocalizedString(@"aler_dealFailure", nil)];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

@end
