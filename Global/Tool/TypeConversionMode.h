//
//  TypeConversionMode.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/21.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TypeConversionMode : NSObject
+ (NSString *)strongChangeString:(id)data;
+ (BOOL)checkFaceLocalizeable:(NSString *)str withHome:(BOOL)home;
+ (BOOL)checkHomeFaceLocalizeable:(NSString *)str;
@end
