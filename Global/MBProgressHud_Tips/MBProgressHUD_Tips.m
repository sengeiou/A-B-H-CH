//
//  MBProgressHUD_Tips.m
//  BuyInsurance
//
//  Created by No9527 on 15/2/3.
//  Copyright (c) 2015年 No9527. All rights reserved.
//

#import "MBProgressHUD_Tips.h"

@implementation MBProgressHUD (Tips)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
	if (view == nil) view = [[UIApplication sharedApplication].windows firstObject];
	// 快速显示一个提示信息
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.backgroundColor = [UIColor blackColor];
	hud.label.text = text;
    hud.label.numberOfLines = 0;
//    hud.label.textColor = [UIColor whiteColor];
    hud.contentColor = [UIColor whiteColor];
	// 设置图片
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
	// 再设置模式
	hud.mode = MBProgressHUDModeCustomView;
	
	// 隐藏时候从父控件中移除
	hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
	// 1秒之后再消失
//	[hud hide:YES afterDelay:1];
    [hud hideAnimated:YES afterDelay:1.0];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
	[self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
	[self show:success icon:@"success.png" view:view];
}

+ (void)showTips:(NSString *)tips toView:(UIView *)view
{
    [self show:tips icon:@"" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
	if (view == nil) view = [[UIApplication sharedApplication].windows firstObject];
	// 快速显示一个提示信息
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.contentColor = [UIColor whiteColor];//改变菊花及文字颜色；单独设置菊花颜色无效
	hud.label.text = message;
    hud.label.numberOfLines = 0;
	// 隐藏时候从父控件中移除
	hud.removeFromSuperViewOnHide = YES;
	// YES代表需要蒙版效果
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    
    hud.label.textColor = [UIColor whiteColor];//如果菊花和文字颜色需要不一致，需要另行设置字体颜色
	bool dimBackground = YES;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = dimBackground ? [UIColor colorWithWhite:0.f alpha:.2f] : [UIColor clearColor];
	return hud;
}

+ (void)showSuccess:(NSString *)success
{
	[self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
	[self showError:error toView:nil];
}

+ (void)showTips:(NSString *)tips
{
    [self showTips:tips toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
	return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows firstObject];
	[self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
	[self hideHUDForView:nil];
}

@end
