//
//  UINavigationController+CHNav.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "UINavigationController+CHNav.h"
#import "CHNavViewController.h"
#import <objc/runtime.h>
static char const *const backColor = "backColor";
static char const *const backImageKey = "backImage";
@implementation UINavigationController (CHNav)

- (void)setBackIntClolr:(UIColor *)backIntClolr{
    objc_setAssociatedObject(self, backColor, backIntClolr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)backIntClolr{
    return objc_getAssociatedObject(self, backColor);
}

- (void)setBackImage:(UIImage *)backImage{
    objc_setAssociatedObject(self, backImageKey, backImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)backImage{
    return objc_getAssociatedObject(self, backImageKey);
}

- (void)setBackgroudImage:(UIImage *)image{
//    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    [UINavigationBar appearance].shadowImage = [UIImage new];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
}

- (void)setStatusbarBackgroundColor:(UIColor *)color{
    NSLog(@"STATUS_BAR_HEIGHT %f",STATUS_BAR_HEIGHT);
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0,-STATUS_BAR_HEIGHT, CHMainScreen.size.width, STATUS_BAR_HEIGHT)];
    statusBarView.backgroundColor = color;
    [self.navigationBar addSubview:statusBarView];
}
@end
