//
//  CHCommandMode.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/20.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHCommandMode : NSObject
@property (nonatomic, strong) NSString *Code;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *CmdValue;
@property (nonatomic, assign) NSInteger SMSType;
@property (nonatomic, strong) NSString *SMSContent;
@end
