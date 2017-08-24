//
//  CHPhotoView.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/23.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHPhotoView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
+ (CHPhotoView *)initWithNomarSheet;
- (void)createPhotoUIWithTouchPhoto:(ButTouchedBlock)photo touchAlum:(ButTouchedBlock)alum;
- (void)createBirthdayUIDidSelectConfirm:(ButTouchedBlock)confirm;
@end
