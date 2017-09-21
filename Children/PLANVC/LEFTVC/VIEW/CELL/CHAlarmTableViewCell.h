//
//  CHAlarmTableViewCell.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/20.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHAlarmTableViewCell : UITableViewCell
@property (nonatomic, strong) CHCmdClassDemo *demo;
- (void)selectSwitchCallBack:(void(^)(UISwitch *oSwitch))callBack;
@end
