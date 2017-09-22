//
//  CHDefaultionfos.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHDefaultionfos.h"
NSString * const CHAPPTOKEN = @"CHAPPTOKEN";
NSString * const CHVOLUMEVALUE = @"CHVOLUMEVALUE";

@implementation CHDefaultionfos
+ (void)CHputKey:(NSString *)key andValue:(NSObject *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (void)CHputInt:(NSString *)key andValue:(int)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}


+ (id)CHgetValueforKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id result = [defaults objectForKey:key];
    if(!result){
        result = nil;
    }
    return result;
}

+ (int)CHgetIntValueforKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int result = (int)[defaults integerForKey:key];
    return result;
}

+ (void)CHremoveValueForKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
}
@end
