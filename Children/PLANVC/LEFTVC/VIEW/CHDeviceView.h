//
//  CHDeviceView.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/1.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHDeviceView : UIView
@property (nonatomic, copy) CHUserInfo *user;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *lable;
+ (CHDeviceView *)createView;
- (void)updateView:(float)proportion;
@end
