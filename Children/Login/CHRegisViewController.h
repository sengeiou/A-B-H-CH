//
//  CHRegisViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/14.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+HQX.h"
#import "CHTextField+HQX.h"
#import "CHLabel+HQX.h"
#import "CHButton+HQX.h"
#import "SectionsViewController.h"
#import "CHBingViewController.h"

@interface CHRegisViewController : UIViewController<SecondViewControllerDelegate,UITextFieldDelegate>
@property (nonatomic, assign) int operationStype; //0 手机注册； 1 邮箱注册； 2 手机修改密码； 3 邮箱修改密码
@end
