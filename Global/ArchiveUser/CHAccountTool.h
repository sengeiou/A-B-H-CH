//
//  CHAccountTool.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/17.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHUserInfo.h"
@interface CHAccountTool : NSObject
+ (void)saveUser:(CHUserInfo *)user;
+ (CHUserInfo *)user;
@end
