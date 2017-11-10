//
//  CHCallPhoneView.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/11/3.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^phoneCallBack)(NSString *phoneNum);

@interface CHCallPhoneView : UIView
- (instancetype)initWithcallBackBlock:(phoneCallBack)backBlock;
@end
