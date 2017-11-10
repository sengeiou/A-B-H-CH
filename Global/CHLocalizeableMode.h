//
//  CHLocalizeableMode.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHLocalizeableMode : NSObject
+ (instancetype)shareLocalizable;
+ (NSString *)CHlocalizedStringDic:(NSString *)translation_key comment:(NSString *)comment;
+ (NSString *)CHlocalizedStringKey:(NSString *)translation_key comment:(NSString *)comment,...;
+ (NSString *)appendBaseUrlWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
@end
