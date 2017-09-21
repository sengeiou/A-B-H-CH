//
//  CHSubAlarmViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/20.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHDatePickView.h"
#import "CHCmdClassDemo.h"

@protocol VCwillPopViewDelegate <NSObject>
- (void)viewWillPop;
@end

@interface CHSubAlarmViewController : UIViewController
@property (nonatomic, weak) id<VCwillPopViewDelegate> delegate;
@property (nonatomic, strong) CHCmdClassDemo *cmdDemo;
@end
