//
//  CHDefaultionfos.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CHFIRSTLUN @"CHFIRSTLUN" //首次打开
UIKIT_EXTERN NSString * const CHAPPTOKEN;
UIKIT_EXTERN NSString * const CHVOLUMEVALUE;

@interface CHDefaultionfos : NSObject
+ (void)CHputKey:(NSString *)key andValue:(NSObject *)value;
+ (void)CHputInt:(NSString *)key andValue:(int)value;
+ (id)CHgetValueforKey:(NSString *)key;
+ (int)CHgetIntValueforKey:(NSString *)key;
+ (void)CHremoveValueForKey:(NSString *)key;
@end
