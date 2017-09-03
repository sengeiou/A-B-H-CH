//
//  UIImage+IMAGE.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, GradientType)  {
    topToBottom = 0,//从上到下
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
};
@interface UIImage (IMAGE)

+ (UIImage *)CHimageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)CHbuttonImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType size:(CGSize )size;
+ (UIImage *)mergeMainIma:(UIImage *)maIma subIma:(UIImage *)subIma callBackSize:(CGSize)size;
+ (UIImage*)image:(UIImage*)image  fortargetSize: (CGSize)targetSize;
+ (UIImage *)drawDeviceImageWithSize:(CGSize )size title:(NSString *)title;
+ (UIImage *)drawWithSize:(CGSize )size Radius:(CGFloat)radius image:(UIImage *)ima;
@end
