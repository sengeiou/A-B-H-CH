//
//  AppDelegate.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/11.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHNavViewController.h"
#import "CHRegAnLogViewController.h"
#import "MainViewController.h"
#import "XLSlideMenu.h"
#import "CHLeftViewController.h"
#import "CHBaseViewController.h"
#import "LeftSliderViewController.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import "RecordVoice.h"
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
//#endif

static NSString *appKey = @"2509dbedb83951eb9b2dc81b";
static NSString *channel = @"Publish channel";
static BOOL isProduction = YES;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong ,nonatomic) LeftSliderViewController * leftSliderViewController;

@end

