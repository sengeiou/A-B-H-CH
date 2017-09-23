//
//  CHRequestTableViewCell.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/23.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHRequestTableViewCell : UITableViewCell
@property (nonatomic, strong) CHRequestInfoMode *infoMode;
- (void)requestDispose:(void(^)(BOOL agree))callBack;
@end
