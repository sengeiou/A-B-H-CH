//
//  CHGuarderCell.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/9.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHGuarderCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) CHLabel *titLab, *phoneLab, *adminLab, *syncLab;
@property (nonatomic, assign) BOOL isAdmin;
@end
