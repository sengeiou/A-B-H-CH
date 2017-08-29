//
//  CHPhoneCellView.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/25.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didSelectCellBlock)(CHUserInfo *device);

@interface CHPhoneCellView : UIView<UITableViewDelegate,UITableViewDataSource>
- (instancetype)initWithDevices:(NSMutableArray *)deviceList callBackBlock:(didSelectCellBlock)backBlock;
@end
