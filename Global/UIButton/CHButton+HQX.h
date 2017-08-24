//
//  CHButton+HQX.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/15.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHButton.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, ButtonEdgeInsetsStyle){
    buttonddgeinsetsstyletop = 0, // image在上，label在下
    buttonddgeinsetsstyleleft = 1, // image在左，label在右
    buttonddgeinsetsstyletopbottom  = 2, // image在下，label在上
    buttonddgeinsetsstyletopright = 3, // image在右，label在左
};

typedef void (^ButTouchedBlock)(CHButton* sender);
@interface CHButton (HQX)

/**
 创建

 @param tit 按钮文字
 @param color 文字颜色
 @param font 文字大小
 @param backColor 背景颜色
 @param butTouchedBlack 点击事件回调
 @return CHButton
 */
+ (CHButton *)createWithTit:(NSString *)tit titColor:(UIColor *)color textFont:(UIFont *)font backColor:(UIColor *)backColor touchBlock:(ButTouchedBlock)butTouchedBlack;

/**
 创建CHButton（背景颜色、圆角）

 @param tit 按钮文字
 @param color 文字颜色
 @param font 文字大小
 @param backColor 背景颜色
 @param radius 圆角
 @param butTouchedBlack 点击事件回调
 @return CHButton
 */
+ (CHButton *)createWithTit:(NSString *)tit titColor:(UIColor *)color textFont:(UIFont *)font backColor:(UIColor *)backColor Radius:(CGFloat)radius touchBlock:(ButTouchedBlock)butTouchedBlack;

/**
 创建只含背景图片CHButton（圆角，设置enabled = NO 时候颜色会变淡）

 @param tit 按钮文字
 @param color 文字颜色
 @param font 文字大小
 @param backColor 背景图片颜色
 @param radius 圆角
 @param butTouchedBlack 点击事件回调
 @return CHButton
 */
+ (CHButton *)createWithTit:(NSString *)tit titColor:(UIColor *)color textFont:(UIFont *)font backImaColor:(UIColor *)backColor Radius:(CGFloat)radius touchBlock:(ButTouchedBlock)butTouchedBlack;

/**
 创建只含图片CHButton

 @param norIma 默认图片
 @param liIma 触摸状态下图片
 @param butTouchedBlack 事件回调
 @return CHButton
 */
+ (CHButton *)createWithNorImage:(UIImage *)norIma lightIma:(UIImage *)liIma touchBlock:(ButTouchedBlock)butTouchedBlack;

/**
 创建富文本CHButton

 @param Text 文字
 @param dic 富文本字典
 @param butTouchedBlack 事件回调
 @return CHButton
 */
+ (CHButton *)createAttributedString:(NSString *)Text attributedDic:(NSDictionary *)dic touchBlock:(ButTouchedBlock)butTouchedBlack;

+ (CHButton *)createWithImage:(UIImage *)iamge Radius:(CGFloat)radius touchBlock:(ButTouchedBlock)butTouchedBlack;

- (void)drawRadius:(CGFloat)radius;
- (void)layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style space:(CGFloat)space;

@end
