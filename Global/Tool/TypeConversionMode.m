//
//  TypeConversionMode.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/21.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "TypeConversionMode.h"

@implementation TypeConversionMode

+ (NSString *)strongChangeString:(id)data{
    if ([data isEqual:[NSNull null]]) {
        return @"";
    }
    if ([data isKindOfClass:[NSNull class]]) {
        return @"";
    }if (!data) {
        return @"";
    }
    if ([data isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",data];
    }
    return (NSString *)data;
}
@end
