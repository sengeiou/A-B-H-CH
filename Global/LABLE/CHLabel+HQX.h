//
//  CHLabel+HQX.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/15.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHLabel.h"

@interface CHLabel (HQX)

/**
 创建aduw

 @param text 文字
 @param font 字体
 @param color 字体颜色
 @param backColor 背景颜色
 @param alignement 字体排版
 @return CHLabel
 */
+ (CHLabel *)createWithTit:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color backColor:(UIColor *)backColor textAlignment:(NSTextAlignment)alignement;
@end
