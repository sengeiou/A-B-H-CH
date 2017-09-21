//
//  CHFenceTableViewCell.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHFenceInfoMode.h"

@interface CHFenceTableViewCell : UITableViewCell
@property (nonatomic, strong) CHLabel *titLab, *fenceLab, *adressLab;
@property (nonatomic, strong) UIImageView *headIma;
@property (nonatomic, strong) CHFenceInfoMode *fenceMode;

@end
