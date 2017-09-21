//
//  CHJBWViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHFenceTableViewCell.h"
#import "CHFenceInfoMode.h"
#import "CHFenceViewController.h"

@interface CHJBWViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CHUserInfo *user;
@end
