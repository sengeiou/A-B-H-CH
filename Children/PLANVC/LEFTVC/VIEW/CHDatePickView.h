//
//  CHDatePickView.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/18.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHDatePickView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *datePickView;
@property (nonatomic, strong) UIView *confimView;
@property (nonatomic, assign) NSInteger hourInt, minInt;
@property (nonatomic, assign) NSInteger minimum,maximum;
- (id)initWithAnimation:(BOOL)animation;
- (void)didSelectPickView:(void(^)(NSString *dateStr))callBack;
- (void)didConfimBut:(void(^)(NSString *dateStr))callBack;
@end
