//
//  CHPhotoView.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/23.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^pickViewBlock)(CHButton* sender,NSString *date);

@interface CHPhotoView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, copy) NSString *yearString;
@property (nonatomic, copy) NSString *monthString;
@property (nonatomic, copy) NSString *dayString;

+ (CHPhotoView *)initWithNomarSheet;
- (void)createPhotoUIWithTouchPhoto:(ButTouchedBlock)photo touchAlum:(ButTouchedBlock)alum;
- (void)createBirthdayUIWithOriginDate:(NSDate *)date DidSelectConfirm:(pickViewBlock)confirm;
- (void)createPickDatas:(NSArray *)datas OriginIndex:(NSString *)origin DidSelectConfirm:(pickViewBlock)confirm;
@end
