//
//  CHPhotoView.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/23.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHPhotoView.h"

@interface CHPhotoView ()
{
    UIView *backView;
    UIPickerView *datePick;
}
@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *dayArray;

@property (nonatomic, copy) NSString *yearString;
@property (nonatomic, copy) NSString *monthString;
@property (nonatomic, copy) NSString *dayString;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *originSelectedDate; //设置初始选择日期
@end

@implementation CHPhotoView

+ (CHPhotoView *)initWithNomarSheet{
    CHPhotoView *view = [[CHPhotoView alloc] initWithFrame:CHMainScreen];
    return view;
}

- (void)createPhotoUIWithTouchPhoto:(ButTouchedBlock)photo touchAlum:(ButTouchedBlock)alum{
    
    self.backgroundColor = CHUIColorFromRGB(0x000000, 0.5);
    backView = [UIView new];
    [self addSubview:backView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tapGR];
    
    CGSize radi = CGSizeMake(8.0, 8.0);
    UIRectCorner cornes = UIRectCornerTopLeft | UIRectCornerTopRight;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CHMainScreen.size.width, self.frame.size.height/2.5 * WIDTHAdaptive) byRoundingCorners:cornes cornerRadii:radi];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = CHUIColorFromRGB(0xffffff, 1.0).CGColor;
    shapeLayer.path = path.CGPath;
    [backView.layer addSublayer:shapeLayer];
    
    CHButton *photoBut = [CHButton createWithTit:CHLocalizedString(@"拍照", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 16) backColor:CHUIColorFromRGB(0x03a9f4, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        photo(sender);
        [self tapAction];
    }];
    [backView addSubview:photoBut];
    
    CHButton *albumBut = [CHButton createWithTit:CHLocalizedString(@"从相册中选择", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 16) backColor:CHUIColorFromRGB(0x03a9f4, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        alum(sender);
        [self tapAction];
    }];
    [backView addSubview:albumBut];
    
    CHButton *cancelBut = [CHButton createWithTit:CHLocalizedString(@"取消", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 16) backColor:CHUIColorFromRGB(0x757575, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        [self tapAction];
    }];
    [backView addSubview:cancelBut];
    
    [backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.frame.size.height/2.5 * WIDTHAdaptive);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(self.frame.size.height/2.5 * WIDTHAdaptive);
    }];
    
    [photoBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 * WIDTHAdaptive);
        make.centerX.mas_equalTo(backView);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
        make.width.mas_equalTo(240 * WIDTHAdaptive);
    }];
    
    [albumBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(photoBut.mas_bottom).mas_offset(12);
        make.centerX.mas_equalTo(backView);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
        make.width.mas_equalTo(240 * WIDTHAdaptive);
    }];
    
    [cancelBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-16);
        make.centerX.mas_equalTo(backView);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
        make.width.mas_equalTo(240 * WIDTHAdaptive);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        backView.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height/2.5 * WIDTHAdaptive);
    }];
}

- (void)createBirthdayUIDidSelectConfirm:(ButTouchedBlock)confirm{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyyMM";
    self.backgroundColor = CHUIColorFromRGB(0x000000, 0.5);
    backView = [UIView new];
    [self addSubview:backView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tapGR];
    
    CGSize radi = CGSizeMake(8.0, 8.0);
    UIRectCorner cornes = UIRectCornerTopLeft | UIRectCornerTopRight;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CHMainScreen.size.width, self.frame.size.height/2.5 * WIDTHAdaptive) byRoundingCorners:cornes cornerRadii:radi];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = CHUIColorFromRGB(0xffffff, 1.0).CGColor;
    shapeLayer.path = path.CGPath;
    [backView.layer addSublayer:shapeLayer];
    
    CHButton *canBut = [CHButton createWithTit:CHLocalizedString(@"取消", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 16) backColor:CHUIColorFromRGB(0x757575, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        
    }];
    [backView addSubview:canBut];
    
    CHButton *confirmBut = [CHButton createWithTit:CHLocalizedString(@"确认", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 16) backColor:CHUIColorFromRGB(0x03a9f4, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        
    }];
    [backView addSubview:confirmBut];
    
    datePick = [UIPickerView new];
    datePick.delegate = self;
    datePick.dataSource = self;
    //    [datePick add]
    
    
    [backView addSubview:datePick];
    
    [backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.frame.size.height/2.5 * WIDTHAdaptive);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(self.frame.size.height/2.5 * WIDTHAdaptive);
    }];
    
    CGFloat butWidth = (CHMainScreen.size.width - 64)/2;
    [canBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-16);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(butWidth);
    }];
    
    [confirmBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-16);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(butWidth);
    }];
    
    [datePick mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(confirmBut.mas_top).mas_offset(-8);
    }];
    
    [self commonData];
    [UIView animateWithDuration:0.5 animations:^{
        backView.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height/2.5 * WIDTHAdaptive);
    }];
}

- (void)layoutMarginsDidChange{
    NSLog(@"layoutMarginsDidChange");
}

- (void)layoutSubviews{
    NSLog(@"layoutSubviews");
}

- (void)commonData {
    
    // 获取当前月份有多少日
    NSDate *currentSelectedDate;
    if (self.originSelectedDate) {
        currentSelectedDate = self.originSelectedDate;
    } else {
        currentSelectedDate = [NSDate date];
    }
    
    NSInteger allDays = [self totaldaysInMonth:currentSelectedDate];
    for (int i = 1; i <= [[NSDate date] getDay]; i++) {
        NSString *strDay = [NSString stringWithFormat:@"%02i", i];
        [self.dayArray addObject:strDay];
    }
    //  更新年
    NSInteger currentYear = [currentSelectedDate getYear];
    NSString *strYear = [NSString stringWithFormat:@"%04li", currentYear];
    NSInteger indexYear = [self.yearArray indexOfObject:strYear];
    if (indexYear == NSNotFound) {
        indexYear = 0;
    }
    [datePick selectRow:indexYear inComponent:0 animated:YES];
    self.yearString = self.yearArray[indexYear];;
    
    //  更新月份
    NSInteger currentMonth = [currentSelectedDate getMonth];
    NSString *strMonth = [NSString stringWithFormat:@"%02li", currentMonth];
    NSInteger indexMonth = [self.monthArray indexOfObject:strMonth];
    if (indexMonth == NSNotFound) {
        indexMonth = 0;
    }
    [datePick selectRow:indexMonth inComponent:1 animated:YES];
    self.monthString = self.monthArray[indexMonth];
    
    //  更新日
    NSInteger currentDay = [currentSelectedDate getDay];
    NSString *strDay = [NSString stringWithFormat:@"%02li", currentDay];
    NSInteger indexDay = [self.dayArray indexOfObject:strDay];
    if (indexDay == NSNotFound) {
        indexDay = 0;
    }
    
    [datePick selectRow:indexDay inComponent:2 animated:YES];
    self.dayString = self.dayArray[indexDay];
    UILabel *yearlab = (UILabel *)[datePick viewForRow:indexYear forComponent:0];
    yearlab.textColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    UILabel *monlab = (UILabel *)[datePick viewForRow:indexMonth forComponent:1];
    monlab.textColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    UILabel *daylab = (UILabel *)[datePick viewForRow:indexDay forComponent:2];
    daylab.textColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
}

- (void)tapAction{
    //    [UIView animateWithDuration:0.3 animations:^{
    //        backView.transform = CGAffineTransformIdentity;
    //    } completion:^(BOOL finished) {
    [self removeFromSuperview];
    //    }];
}

- (NSMutableArray *)yearArray {
    if (!_yearArray) {
        _yearArray = [NSMutableArray array];
        NSInteger currentYear = [[NSDate date] getYear];
        for (int i = 1; i <= currentYear; i++) {
            NSString *year = [NSString stringWithFormat:@"%04i", i];
            [_yearArray addObject:year];
        }
    }
    return _yearArray;
}

- (NSMutableArray *)monthArray {
    
    if (!_monthArray) {
        _monthArray = [NSMutableArray array];
        NSInteger currentMonth = [[NSDate date] getMonth];
        for (int i = 1; i <= currentMonth; i++) {
            NSString *month = [NSString stringWithFormat:@"%02i", i];
            [_monthArray addObject:month];
        }
    }
    return _monthArray;
}

- (NSMutableArray *)dayArray {
    
    if (!_dayArray) {
        _dayArray = [NSMutableArray array];
    }
    return _dayArray;
}

- (id)safeObjectAtIndex:(NSUInteger)index array:(NSMutableArray *)array {
    
    id obj = nil;
    if (index < array.count) {
        obj = [array objectAtIndex:index];
    }
    return obj;
}

- (void)updateCurrentAllDaysWithDate:(NSDate *)currentDate inComponent:(NSInteger)component{ // 更新选中的年、月份时的日期
    //    if (currentDate.timeIntervalSince1970 > [NSDate date].timeIntervalSince1970) {
    //        currentDate = [NSDate date];
    //        self.originSelectedDate = currentDate;
    //        [self commonData];
    //        return;
    //    }
    
    NSInteger currentYear = [currentDate getYear];
    NSInteger currentMonth = [currentDate getMonth];
    NSInteger currentDay = self.dayString.integerValue;
    
    if (component == 0) {//今年
        NSString *strMonth = [NSString stringWithFormat:@"%02li", currentMonth];
        NSInteger indexMonth = [self.monthArray indexOfObject:strMonth];
        if (currentYear == [[NSDate date] getYear]) {
            if (indexMonth > ([[NSDate date] getMonth] - 1)) {
                indexMonth = [[NSDate date] getMonth] - 1;
            }
            
            [self.monthArray removeAllObjects];
            for (int i = 1; i <= [[NSDate date] getMonth]; i++) {
                NSString *strDay = [NSString stringWithFormat:@"%02i", i];
                [self.monthArray addObject:strDay];
            }
        }
        else{
            [self.monthArray removeAllObjects];
            for (int i = 1; i <= 12; i++) {
                NSString *strDay = [NSString stringWithFormat:@"%02i", i];
                [self.monthArray addObject:strDay];
            }
        }
        [datePick reloadComponent:1];
        
        [datePick selectRow:indexMonth inComponent:1 animated:YES];
        self.monthString = self.monthArray[indexMonth];
        UILabel *monlab = (UILabel *)[datePick viewForRow:indexMonth forComponent:1];
        monlab.textColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    }
    //    if (component == 1) {
    [self.dayArray removeAllObjects];
    NSInteger allDays = [self totaldaysInMonth:currentDate];
    if (currentMonth == [[NSDate date] getMonth] && currentYear == [[NSDate date] getYear]) {
        for (int i = 1; i <= (allDays >= [[NSDate date] getDay] ? [[NSDate date] getDay]:allDays); i++) {
            NSString *strDay = [NSString stringWithFormat:@"%02i", i];
            [self.dayArray addObject:strDay];
        }
        [datePick reloadComponent:2];
        
        NSString *strDay = [NSString stringWithFormat:@"%02li", currentDay];
        NSInteger indexDay = [self.dayArray indexOfObject:strDay];
        if (indexDay > ([[NSDate date] getDay] - 1)) {
            indexDay = ([[NSDate date] getDay] - 1);
        }
        [datePick selectRow:indexDay inComponent:2 animated:YES];
        self.dayString = self.dayArray[indexDay];
        
        UILabel *monlab = (UILabel *)[datePick viewForRow:indexDay forComponent:2];
        monlab.textColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    }
    else{
        for (int i = 1; i <= allDays; i++) {
            NSString *strDay = [NSString stringWithFormat:@"%02i", i];
            [self.dayArray addObject:strDay];
        }
        [datePick reloadComponent:2];
        
        NSInteger indexDay = [self.dayArray indexOfObject:self.dayString];
        if (indexDay == NSNotFound) {
            indexDay = (self.dayArray.count - 1) > 0 ? (self.dayArray.count - 1) : 0;
        }
        [datePick selectRow:indexDay inComponent:2 animated:YES];
        self.dayString = self.dayArray[indexDay];
        UILabel *daylab = (UILabel *)[datePick viewForRow:indexDay forComponent:2];
        daylab.textColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    }
    //    }
}

- (NSInteger)totaldaysInMonth:(NSDate *)date { // 计算出当月有多少天
    
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return self.yearArray.count;
    } else if (component == 1) {
        return self.monthArray.count;
    } else {
        return self.dayArray.count;
    }
}
//
//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return nil;
//}

- (UILabel *)getPickViewCellWithString:(NSString *)string {
    
    UILabel *cell = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CHMainScreen.size.width / 3, 50.f)];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textColor = CHUIColorFromRGB(CHMediumBlackColor, 1.0);
    cell.textAlignment = NSTextAlignmentCenter;
    cell.font = CHFontNormal(nil, 18);
    cell.text = string;
    return cell;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50 * WIDTHAdaptive;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
        }
    }
    if (component == 0) {
        return [self getPickViewCellWithString:[self safeObjectAtIndex:row array:self.yearArray]];
    } else if (component == 1) {
        return [self getPickViewCellWithString:[self safeObjectAtIndex:row array:self.monthArray]];
    } else {
        return [self getPickViewCellWithString:[self safeObjectAtIndex:row array:self.dayArray]];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UILabel *lab = (UILabel *)[pickerView viewForRow:row forComponent:component];
    lab.textColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    if (component == 0) {
        self.yearString = [self safeObjectAtIndex:row array:self.yearArray];
    } else if (component == 1) {
        self.monthString = [self safeObjectAtIndex:row array:self.monthArray];
    } else {
        self.dayString = [self safeObjectAtIndex:row array:self.dayArray];
    }
    
//    if (component != 2) {
        NSString *strDate = [NSString stringWithFormat:@"%@%@", self.yearString, self.monthString];
        [self updateCurrentAllDaysWithDate:[self.dateFormatter dateFromString:strDate] inComponent:component];
//    }
    NSString *dateString = [NSString stringWithFormat:@"%@年%@月%@日",self.yearString, self.monthString, self.dayString];
    NSLog(@"dateString  %@",dateString);
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
