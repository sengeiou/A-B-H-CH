//
//  UINavigationController+CHNav.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHNavViewController;
@interface UINavigationController (CHNav)
@property (nonatomic, strong) UIColor *backIntClolr;
@property (nonatomic, strong) UIImage *backImage;
//@property (nonatomic, strong) UIImage *statusbarIma;
//@property (nonatomic, strong) UIImage *navigationbarIma;
- (void)setBackgroudImage:(UIImage *)image;
- (void)setStatusbarBackgroundColor:(UIColor *)color;
@end
