//
//  CHGuarderViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/9.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGuarderCell.h"
#import "CHGuarderItemMode.h"
#import "CHEditGuarderTableViewController.h"
#import "CHSAddGuarderViewController.h"
#import "CHAdressMode.h"

@interface CHGuarderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray <CHAdressMode *>*adressArrs;
@property (nonatomic, assign) BOOL addressBook;

- (void)initializeMetod;
@end
