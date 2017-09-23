//
//  CHCalculatedMode.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHCalculatedMode : NSObject
+ (CGRect)CHCalculatedWithStr:(NSString *)string size:(CGSize) size attributes:(NSDictionary *)arrDic;
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)validateEmail:(NSString*)email;
+ (BOOL)isPureNumandCharacters:(NSString *)string;
@end
