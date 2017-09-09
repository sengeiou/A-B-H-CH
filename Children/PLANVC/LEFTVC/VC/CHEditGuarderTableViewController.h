//
//  CHEditGuarderTableViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/9.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^updatePopViewBlock)(CHGuarderItemMode *itemMode);

@interface CHEditGuarderTableViewController : UITableViewController
@property (nonatomic, strong) CHGuarderItemMode *itemMode;
@property (nonatomic, assign) BOOL isAdmin;

- (void)popViewUpdateUI:(updatePopViewBlock)callBack;
@end
