//
//  AppDelegate.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/11.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()
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
//          UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
        CHLeftViewController *leftVC = [[CHLeftViewController alloc] init];
//        XLSlideMenu *slideMenu = [[XLSlideMenu alloc] initWithRootViewController:nav];
//        slideMenu.leftViewController = leftVC;
//         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:slideMenu];
//        self.window.rootViewController = slideMenu;
        
//        CHKLTViewController *nav = [[CHKLTViewController alloc] initWithRootViewController:[[CHRegAnLogViewController alloc] init]];
//        self.window.rootViewController = nav;
        
//        CSLeftSlideControllerOne *leftSliderViewController = [[CSLeftSlideControllerOne alloc] initWithLeftViewController:leftVC MainViewController:nav];
         self.leftSliderViewController = [[LeftSliderViewController alloc] initWithLeftView:leftVC andMainView:nav];
        //        self.window.rootViewController = [[CHBaseViewController alloc] init];; eftSliderViewController =<LeftSliderViewController: 0x145e28950>
        NSLog(@"leftSliderViewController =%@",self.leftSliderViewController);
        self.window.rootViewController = self.leftSliderViewController;
    }
    else{
        CHKLTViewController *nav = [[CHKLTViewController alloc] initWithRootViewController:[[CHRegAnLogViewController alloc] init]];
        self.window.rootViewController = nav;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
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


@end
