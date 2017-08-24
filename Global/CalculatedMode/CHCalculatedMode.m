//
//  CHCalculatedMode.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHCalculatedMode.h"

@implementation CHCalculatedMode

+ (CGRect)CHCalculatedWithStr:(NSString *)string size:(CGSize) size attributes:(NSDictionary *)arrDic{
    CGRect rect = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:arrDic context:nil];
    return rect;
}
@end
