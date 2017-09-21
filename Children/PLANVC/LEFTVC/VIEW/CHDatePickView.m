//
//  CHDatePickView.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/18.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHDatePickView.h"

typedef void(^selDateBlock)(NSString *selDate);
typedef void(^selConfimBlock)(NSString *selDate);

@interface CHDatePickView ()
@property (nonatomic, strong) NSMutableArray *hourArr;
@property (nonatomic, strong) NSMutableArray *minArr;
@property (nonatomic, copy) selDateBlock block;
@property (nonatomic, copy) selConfimBlock conBlock;
@end

@implementation CHDatePickView

- (id)initWithAnimation:(BOOL)animation{
    self = [super init];
    if (self) {
        [self createUI:animation];
    }
    return self;
}

- (NSMutableArray *)hourArr{
    if (!_hourArr) {
        _hourArr = [NSMutableArray array];
        for (int i = 0; i < 24; i ++) {
            [_hourArr addObject:[NSString stringWithFormat:@"%@%d",i<10?@"0":@"",i]];
        }
    }
    return _hourArr;
}

- (NSMutableArray *)minArr{
    if (!_minArr) {
        _minArr = [NSMutableArray array];
        NSMutableArray *oneMinArr = [NSMutableArray array];
        for (int i = 0; i < 60; i ++) {
            [oneMinArr addObject:[NSString stringWithFormat:@"%@%d",i<10?@"0":@"",i]];
        }
        for (int j = 0; j < 60; j ++) {
            [_minArr addObjectsFromArray:oneMinArr];
        }
    }
    return _minArr;
}

- (void)setHourInt:(NSInteger)hourInt{
    _hourInt = hourInt;
    [self.datePickView selectRow:_hourInt inComponent:0 animated:YES];
}

- (void)setMinInt:(NSInteger)minInt{
    _minInt = minInt;
    [self.datePickView selectRow:_minInt inComponent:2 animated:YES];
}

- (void)setMaximum:(NSInteger)maximum{
    _maximum = maximum;
    [self.hourArr removeObjectsInRange:NSMakeRange(maximum, self.hourArr.count - maximum)];
    [self.datePickView reloadComponent:0];
}

- (void)setMinimum:(NSInteger)minimum{
    _minimum = minimum;
    [self.hourArr removeObjectsInRange:NSMakeRange(0, minimum)];
    [self.datePickView reloadComponent:0];
}

- (void)createUI:(BOOL)animation{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    
    self.datePickView = [[UIPickerView alloc] init];
    self.datePickView.delegate = self;
    self.datePickView.dataSource = self;
    self.datePickView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.datePickView];
    
    self.confimView = [UIView new];
    self.confimView.backgroundColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    [self addSubview:self.confimView];
    
    @WeakObj(self);
    CHButton *confimBut = [CHButton createWithTit:CHLocalizedString(@"确定", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 18) backColor:nil touchBlock:^(CHButton *sender) {
        if (self.conBlock) {
            self.conBlock([NSString stringWithFormat:@"%@:%@",self.hourArr[_hourInt],self.minArr[_minInt]]);
        }
        [selfWeak removeFromSuperview];
    }];
    [self.confimView addSubview:confimBut];

    
    [self.datePickView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).mas_offset(50 * WIDTHAdaptive);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(200 * WIDTHAdaptive);
    }];
    
    [self.confimView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.datePickView.mas_top);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50 *WIDTHAdaptive);
    }];
    
    [confimBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(0);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    [self showPick:animation];
}

- (void)tap{
    [self removeFromSuperview];
}

- (void)showPick:(BOOL)animation{
    [UIView animateWithDuration:animation ? 0.5:0 animations:^{
        [self.datePickView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_bottom).mas_offset(-200 * WIDTHAdaptive);
        }];
        [self layoutIfNeeded];
    }];

}

- (void)didSelectPickView:(void (^)(NSString *))callBack{
    self.block = callBack;
}

- (void)didConfimBut:(void(^)(NSString *dateStr))callBack{
    self.conBlock = callBack;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) return self.hourArr.count;
    if (component == 2) return self.minArr.count;
    return 1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 0) return (CHMainScreen.size.width - 20)/2;
    if (component == 2) return (CHMainScreen.size.width - 20)/2;
    return 20;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
        }
    }
    UILabel *labView = (UILabel *)view;
    if (component == 0) {
        if (!labView) {
            labView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (CHMainScreen.size.width - 20)/2, 44)];
        }
        labView.text = self.hourArr[row];
    }
    if (component == 2) {
        if (!labView) {
            labView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (CHMainScreen.size.width - 20)/2, 44)];
        }
        labView.text = self.minArr[row];
    }
    if (component == 1) {
        if (!labView) {
            labView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
        }
        labView.text = @":";
    }
    labView.font = CHFontNormal(nil, 20);
    labView.textAlignment = NSTextAlignmentCenter;
    labView.textColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    return labView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.hourInt = row;
    }
    if (component == 2) {
        self.minInt = row;
    }
    if (self.block) {
        self.block([NSString stringWithFormat:@"%@:%@",self.hourArr[_hourInt],self.minArr[_minInt]]);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
