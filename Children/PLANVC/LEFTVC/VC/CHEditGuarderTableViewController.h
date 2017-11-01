//
//  CHEditGuarderTableViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/9.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHAdressMode.h"

typedef void(^updatePopViewBlock)(id itemMode, BOOL deleMode);

@interface CHEditGuarderTableViewController : UITableViewController<UITextFieldDelegate>
@property (nonatomic, strong) CHGuarderItemMode *itemMode;
@property (nonatomic, strong) CHAdressMode *adressMode;
@property (nonatomic, strong) NSMutableArray *adressArrs;
@property (nonatomic, assign) BOOL isAdmin;

- (void)popViewUpdateUI:(updatePopViewBlock)callBack;
@end
