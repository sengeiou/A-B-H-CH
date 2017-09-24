//
//  CHPutInViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CHUserInfo.h"
@class CHUserInfo;
@interface CHPutInViewController : UIViewController<UITextViewDelegate>
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) CHUserInfo *user;
@end
