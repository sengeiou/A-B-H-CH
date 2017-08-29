//
//  UIBarButtonItem+CHITEM.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void(^touchItemBlock)(UIBarButtonItem *item);
@interface UIBarButtonItem (CHITEM)
+ (UIBarButtonItem *)backItemWithIma:(UIImage *)image target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)CHitemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon frame:(CGRect)frame  target:(id)target action:(SEL)action transfrom:(int)rotation;
+ (UIBarButtonItem *)CHItemWithTit:(NSString *)tit textColor:(UIColor *)tcolor textFont:(UIFont *)tfont touchCallBack:(touchItemBlock)touchItem;
+ (UIBarButtonItem *)CHItemWithBackIma:(UIImage *)backIma Radius:(CGFloat)radius touchCallBack:(touchItemBlock)touchItem;
+ (UIBarButtonItem *)CHItemWithNorIma:(UIImage *)norIma highIma:(UIImage *)highIma touchCallBack:(touchItemBlock)touchItem;
@end
