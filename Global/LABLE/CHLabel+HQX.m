//
//  CHLabel+HQX.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/15.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHLabel+HQX.h"

@implementation CHLabel (HQX)

+ (CHLabel *)createWithTit:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color backColor:(UIColor *)backColor textAlignment:(NSTextAlignment)alignement{
    CHLabel *label = [CHLabel new];
    label.backgroundColor = backColor ? backColor:[UIColor clearColor];
    label.textColor = color ? color:[UIColor whiteColor];
    label.text = text ? text:@"";
    label.font = font;
    label.textAlignment = alignement;
    return label;
}


@end
