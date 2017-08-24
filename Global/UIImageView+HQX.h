//
//  UIImageView+HQX.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/15.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^ImageTouchedBlock)(UIImageView* sender ,UIGestureRecognizerState recognizerState);
@interface UIImageView (HQX)
/**
 创建
 
 @param image 图片
 @param backColor 背景色
 @return HXQImageView
 */
+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor;

/**
 创建(有弧度)
 
 @param image 图片
 @param backColor 背景色
 @param radius 弧度
 @return HXQImageView
 */
+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor Radius:(CGFloat)radius;

/**
 创建(有弧度，有边框)
 
 @param image 图片
 @param backColor 背景色
 @param radius 弧度
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @return HXQImageView
 */
+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor Radius:(CGFloat)radius BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor*) borderColor;




/**
 创建(有手势)
 
 @param image 图片
 @param backColor 背景色
 @param imageTouchedBlock 手势方法
 @param eventId 友盟埋点ID
 @return HXQImageView
 */
+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor imageTouchedBlock:(ImageTouchedBlock)imageTouchedBlock eventId:(NSString*)eventId;


/**
 创建(有手势，有弧度)
 
 @param image 图片
 @param backColor 背景色
 @param radius 弧度
 @param imageTouchedBlock 手势方法
 @param eventId 友盟埋点ID
 @return HXQImageView
 */
+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor Radius:(CGFloat)radius imageTouchedBlock:(ImageTouchedBlock)imageTouchedBlock eventId:(NSString*)eventId;


/**
 创建(有手势，有弧度，有边框)
 
 @param image 图片
 @param backColor 背景色
 @param radius 弧度
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @param imageTouchedBlock 手势方法
 @param eventId 友盟埋点ID
 @return HXQImageView
 */
+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor Radius:(CGFloat)radius BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor*) borderColor imageTouchedBlock:(ImageTouchedBlock)imageTouchedBlock eventId:(NSString*)eventId;
@end
