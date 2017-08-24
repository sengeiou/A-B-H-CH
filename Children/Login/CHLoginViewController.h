//
//  CHLoginViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/21.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHRegisViewController.h"

@interface CHLoginViewController : UIViewController<SecondViewControllerDelegate,UITextFieldDelegate>
@property (nonatomic, assign) int operationStype; //0 手机登录； 1 邮箱登录
@end
