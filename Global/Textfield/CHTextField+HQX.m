//
//  CHTextField+HQX.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/15.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHTextField+HQX.h"

@implementation CHTextField (HQX)

+ (CHTextField *)createWithPlace:(NSString *)place text:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font{
    CHTextField *textfield = [CHTextField new];
    textfield.text = text ? text:@"";
    textfield.placeholder = place ? place:@"";
    textfield.textColor = color ? color:[UIColor whiteColor];
    textfield.font = font ? font:[UIFont systemFontOfSize:17];
    return textfield;
}
@end
