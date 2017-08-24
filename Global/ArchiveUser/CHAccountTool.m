//
//  CHAccountTool.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/17.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHAccountTool.h"

@implementation CHAccountTool
#define CHAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CHUser.data"]

+ (void)saveUser:(CHUserInfo *)user{
    [NSKeyedArchiver archiveRootObject:user toFile:CHAccountFile];
}

+ (CHUserInfo *)user{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:CHAccountFile];
}
@end
