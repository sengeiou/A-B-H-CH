//
//  CHAlarmViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/20.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHAlarmTableViewCell.h"
#import "CHSubAlarmViewController.h"

@interface CHAlarmViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,VCwillPopViewDelegate>
@property (nonatomic, strong) NSMutableArray <CHCmdClassDemo *>* commandList;
@end
