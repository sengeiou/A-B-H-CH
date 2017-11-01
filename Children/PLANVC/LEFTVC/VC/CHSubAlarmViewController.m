//
//  CHSubAlarmViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/20.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHSubAlarmViewController.h"

@interface CHSubAlarmViewController ()
@property (nonatomic, strong) CHDatePickView *datePickView;
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) UISwitch *openSwitch;
@end

@implementation CHSubAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CHUserInfo *)user{
    if (!_user) {
        _user = [CHAccountTool user];
    }
    return _user;
}

//- (CHCmdClassDemo *)cmdDemo{
//    if (!_cmdDemo) {
//        _cmdDemo = [[CHCmdClassDemo alloc] init];
//        _cmdDemo.starTime = @"09:00";
//        _cmdDemo.week = @"12345";
//        _cmdDemo.open = @"1";
//    }
//    return _cmdDemo;
//}

- (void)createUI{
    @WeakObj(self)
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = CHLocalizedString(@"device_alarm_alarm", nil);
    _datePickView = [[CHDatePickView alloc] initWithAnimation:NO];
    _datePickView.confimView.hidden = YES;
    _datePickView.hourInt = [[[self.cmdDemo.starTime componentsSeparatedByString:@":"] firstObject] intValue];
    _datePickView.minInt = [[[self.cmdDemo.starTime componentsSeparatedByString:@":"] lastObject] intValue] + 60 * 30;
    [_datePickView didSelectPickView:^(NSString *dateStr) {
        selfWeak.cmdDemo.starTime = dateStr;
    }];
    [self.view addSubview:_datePickView];
    
    CHLabel *line0 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(0xb3e5fc, 1.0) textAlignment:0];
    [self.view addSubview:line0];
    
    UIView *baseView = [UIView new];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    CHLabel *weekLab = [CHLabel createWithTit:CHLocalizedString(@"device_alarm_repetition", nil) font:CHFontNormal(nil, 18) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [baseView addSubview:weekLab];
    
    CGFloat widthFloat = (CHMainScreen.size.width - 8 * 6 - 40)/7;
    UIImage *norIma = [UIImage CHimageWithColor:CHUIColorFromRGB(0xc9c9c9, 1.0) size:CGSizeMake(widthFloat, widthFloat)];
    UIImage *norRainIma = [UIImage drawWithSize:CGSizeMake(widthFloat, widthFloat) Radius:4 image:norIma];
    UIImage *lightIma = [UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) size:CGSizeMake(widthFloat, widthFloat)];
    UIImage *lightRainIma = [UIImage drawWithSize:CGSizeMake(widthFloat, widthFloat) Radius:4 image:lightIma];
    NSArray *weekTits = @[CHLocalizedString(@"device_class_mon", nil),CHLocalizedString(@"device_class_tue", nil),CHLocalizedString(@"device_class_wed", nil),CHLocalizedString(@"device_class_thu", nil),CHLocalizedString(@"device_class_fri", nil),CHLocalizedString(@"device_class_sat", nil),CHLocalizedString(@"device_class_sun", nil)];
    NSMutableArray *weekArr = [self weekSelectWithMode:self.cmdDemo];
    for (int i = 0; i < 7; i ++) {
        CHButton *weekBut = [CHButton createWithNorImage:norRainIma selectIma:lightRainIma touchBlock:^(CHButton *sender) {
            sender.selected = !sender.selected;
        }];
        weekBut.titleLabel.font = CHFontNormal(nil, 18);
        weekBut.titleLabel.textAlignment = NSTextAlignmentCenter;
        [weekBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [weekBut setTitle:weekTits[i] forState:UIControlStateNormal];
        weekBut.tag = 101 + i;
        weekBut.titleLabel.adjustsFontSizeToFitWidth = YES;
        weekBut.selected = [weekArr[i] intValue];
        [self.view addSubview:weekBut];
        
        [weekBut mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weekLab.mas_bottom).mas_offset(20);
            make.left.mas_equalTo(20 + (i * (widthFloat + 8)));
            make.width.mas_equalTo(widthFloat);
            make.height.mas_equalTo(widthFloat);
        }];
        [weekBut.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    CHLabel *line1 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(0xb3e5fc, 1.0) textAlignment:0];
    [self.view addSubview:line1];

    CHLabel *line2 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(0xb3e5fc, 1.0) textAlignment:0];
    [self.view addSubview:line2];
    
    CHLabel *openLab = [CHLabel createWithTit:CHLocalizedString(@"device_class_switch", nil) font:CHFontNormal(nil, 18) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [baseView addSubview:openLab];
    
    self.openSwitch = [UISwitch new];
    self.openSwitch.on = self.cmdDemo.open.intValue;
    self.openSwitch.onTintColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    [baseView addSubview:self.openSwitch];
    
   CHButton *_addBut = [CHButton createWithTit:CHLocalizedString(@"device_guar_save", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
       [selfWeak addAlarm];
    }];
    [baseView addSubview:_addBut];
    
    [_datePickView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(200 * WIDTHAdaptive);
    }];
    
    [line0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_datePickView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(16);
    }];
    
    [baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line0.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [weekLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
    }];
    
     CHButton *but = [self.view viewWithTag:101];
    [line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(but.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.openSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom).mas_offset(20);
        make.right.mas_equalTo(-30);
    }];
    
    [openLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.openSwitch.mas_centerY);
    }];
    
    [line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.openSwitch.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    
    [_addBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20 - HOME_INDICATOR_HEIGHT);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
    }];
}

- (NSMutableArray *)weekSelectWithMode:(CHCmdClassDemo *)mode{
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    NSString *weekStr = mode.week;
    if ([weekStr containsString:@"1"]) {
        [arr replaceObjectAtIndex:0 withObject:@"1"];
    }
    if ([weekStr containsString:@"2"]) {
        [arr replaceObjectAtIndex:1 withObject:@"1"];
    }
    if ([weekStr containsString:@"3"]) {
        [arr replaceObjectAtIndex:2 withObject:@"1"];
    }
    if ([weekStr containsString:@"4"]) {
        [arr replaceObjectAtIndex:3 withObject:@"1"];
    }
    if ([weekStr containsString:@"5"]) {
        [arr replaceObjectAtIndex:4 withObject:@"1"];
    }
    if ([weekStr containsString:@"6"]) {
        [arr replaceObjectAtIndex:5 withObject:@"1"];
    }
    if ([weekStr containsString:@"7"]) {
        [arr replaceObjectAtIndex:6 withObject:@"1"];
    }
    return arr;
}

- (void )requestWeekCmd{
    NSString *weekStr = @"";
    for (int i = 0; i < 7; i ++) {
        CHButton *but = [self.view viewWithTag:101 + i];
        if (but.selected) {
            weekStr = [weekStr stringByAppendingString:[NSString stringWithFormat:@"%d",i + 1]];
        }
    }
    self.cmdDemo.week = weekStr;
}

- (void)addAlarm{
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    self.cmdDemo.open = [NSString stringWithFormat:@"%d",self.openSwitch.on];
    [self requestWeekCmd];
    NSString *params = [self arrangeAlarmList];
    [dic addEntriesFromDictionary:@{@"DeviceId":self.user.deviceId,
                                    @"DeviceModel": self.user.deviceMo,
                                    @"CmdCode": ALARM_CLOCK,
                                    @"Params": params,
                                    @"UserId": self.user.userId}];
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_SendCommand parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        if ([result[@"State"] intValue] == 0) {
         [MBProgressHUD showSuccess:CHLocalizedString(@"aler_saveSuss", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (selfWeak.delegate && [selfWeak.delegate respondsToSelector:@selector(viewWillPop)]) {
                    [selfWeak.delegate viewWillPop];
                }
                [selfWeak.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {

    }];
}

- (NSString *)arrangeAlarmList{
    NSMutableArray <CHCmdClassDemo *>* cmdList;
    NSArray *superNavs = [self.navigationController childViewControllers];
    for (UIViewController *nav in superNavs) {
        if ([nav isKindOfClass:[CHAlarmViewController class]]) {
            cmdList = [(CHAlarmViewController *)nav commandList];
            break;
        }
    }
//    NSString *alarmListStr = [NSString stringWithFormat:@"1,%lu",(unsigned long)cmdList.count];
    NSString *alarmListStr = @"1";
    for (int i = 0; i < cmdList.count; i ++) {
        alarmListStr = [alarmListStr stringByAppendingString:[NSString stringWithFormat:@",%@,%@,%@",cmdList[i].starTime,cmdList[i].week,cmdList[i].open]];
    }
    return alarmListStr;
}

- (void)dealloc{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
