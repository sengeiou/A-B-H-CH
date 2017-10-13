//
//  CHClassViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/18.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHClassViewController.h"

@interface CHClassViewController ()
@property (nonatomic, strong) CHButton *morStarBut, *morEndBut, *aftStarBut, *aftEndBut;
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) NSMutableArray <CHCmdClassDemo *>* commandList;
@property (nonatomic, strong) CHCommandMode *commandMode;
@property (nonatomic, strong) CHCmdClassDemo *aftMode;
@property (nonatomic, strong) CHCmdClassDemo *morMode;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UISwitch *openSwitch;
@end

@implementation CHClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"DeviceId":self.user.deviceId}];
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_CommandList parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        //        selfWeak.commandList = result[@"Items"];
        for (NSDictionary *dic in result[@"Items"]) {
            if ([dic[@"Code"] intValue] == 117) {
                selfWeak.commandMode = [CHCommandMode mj_objectWithKeyValues:dic];
                [selfWeak conversionCMDMode];
                break;
            }
        }
        [selfWeak createUI];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [selfWeak createUI];
    }];
}

- (CHUserInfo *)user{
    if (!_user) {
        _user = [CHAccountTool user];
    }
    return _user;
}

- (CHCmdClassDemo *)morMode{
    if (!_morMode) {
        _morMode = [[CHCmdClassDemo alloc] init];
        _morMode.starTime = @"09:00";
        _morMode.stopTime = @"11:30";
        _morMode.week = @"12345";
        _morMode.open = @"1";
    }
    return _morMode;
}

- (CHCmdClassDemo *)aftMode{
    if (!_aftMode) {
        _aftMode = [[CHCmdClassDemo alloc] init];
        _aftMode.starTime = @"14:00";
        _aftMode.stopTime = @"17:30";
        _aftMode.week = @"12345";
        _aftMode.open = @"1";
    }
    return _aftMode;
}

- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"HH:mm";
        _dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    }
    return _dateFormatter;
}

- (void)conversionCMDMode{
    if (self.commandMode) {
        NSArray *cmdValues = [self.commandMode.CmdValue componentsSeparatedByString:@","];
        if (cmdValues.count <= 0) return;
        if (cmdValues[0]) {
            self.morMode.open = cmdValues[0];
            self.aftMode.open = cmdValues[0];
        }
        if (cmdValues.count <= 1) return;
        if (cmdValues[1]) {
            self.morMode.week = cmdValues[1];
            self.aftMode.week = cmdValues[1];
        }
        if (cmdValues.count <= 2) return;
        if (cmdValues[2]) {
            self.morMode.starTime = cmdValues[2];
        }
        if (cmdValues.count <= 3) return;
        if (cmdValues[3]) {
            self.morMode.stopTime = cmdValues[3];
        }
        if (cmdValues.count <= 5) return;
        if (cmdValues[5]) {
            self.aftMode.starTime = cmdValues[5];
        }
        if (cmdValues.count <= 6) return;
        if (cmdValues[6]) {
            self.aftMode.stopTime = cmdValues[6];
        }
    }
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
    self.morMode.week = weekStr;
    self.aftMode.week = weekStr;
}

- (void)createUI{
    self.title = CHLocalizedString(@"上课禁用", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    CHLabel *switchLab = [CHLabel createWithTit:CHLocalizedString(@"开关", nil) font:CHFontNormal(nil, 18) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:switchLab];
    
    self.openSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.openSwitch.onTintColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    self.openSwitch.on = self.morMode.open.intValue;
    [self.view addSubview:self.openSwitch];
    
    CHLabel *line0 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line0];
    CHLabel *mornLab = [CHLabel createWithTit:CHLocalizedString(@"上午", nil) font:CHFontNormal(nil, 18) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:mornLab];
    mornLab.numberOfLines = 0;
    @WeakObj(self)
    _morEndBut = [CHButton createWithTit:self.morMode.stopTime titColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textFont:CHFontNormal(nil, 24) backColor:nil Radius:8.0f touchBlock:^(CHButton *sender) {
        [selfWeak showDatePick:sender maximum:12 minimum:0];
    }];
    _morEndBut.layer.borderColor = CHUIColorFromRGB(0xc9c9c9, 1.0).CGColor;
    _morEndBut.layer.borderWidth = 1.0;
    [self.view addSubview:_morEndBut];
    _morStarBut = [CHButton createWithTit:self.morMode.starTime titColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textFont:CHFontNormal(nil, 24) backColor:nil Radius:8.0f touchBlock:^(CHButton *sender) {
        [selfWeak showDatePick:sender maximum:12 minimum:0];
    }];
    _morStarBut.layer.borderColor = CHUIColorFromRGB(0xc9c9c9, 1.0).CGColor;
    _morStarBut.layer.borderWidth = 1.0;
    [self.view addSubview:_morStarBut];
    CHLabel *line1 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line1];
    
    CHLabel *afterLab = [CHLabel createWithTit:CHLocalizedString(@"下午", nil) font:CHFontNormal(nil, 18) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    afterLab.numberOfLines = 0;
    [self.view addSubview:afterLab];
    _aftEndBut = [CHButton createWithTit:self.aftMode.stopTime titColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textFont:CHFontNormal(nil, 24) backColor:nil Radius:8.0f touchBlock:^(CHButton *sender) {
        [selfWeak showDatePick:sender maximum:0 minimum:12];
    }];
    _aftEndBut.layer.borderColor = CHUIColorFromRGB(0xc9c9c9, 1.0).CGColor;
    _aftEndBut.layer.borderWidth = 1.0;
    [self.view addSubview:_aftEndBut];
    _aftStarBut = [CHButton createWithTit:self.aftMode.starTime titColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textFont:CHFontNormal(nil, 24) backColor:nil Radius:8.0f touchBlock:^(CHButton *sender) {
        [selfWeak showDatePick:sender maximum:0 minimum:12];
    }];
    _aftStarBut.layer.borderColor = CHUIColorFromRGB(0xc9c9c9, 1.0).CGColor;
    _aftStarBut.layer.borderWidth = 1.0;
    [self.view addSubview:_aftStarBut];
    CHLabel *line2 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line2];
    
    CHLabel *weekLab = [CHLabel createWithTit:CHLocalizedString(@"星期", nil) font:CHFontNormal(nil, 18) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:weekLab];
    
    CGFloat widthFloat = (CHMainScreen.size.width - 8 * 6 - 40)/7;
    UIImage *norIma = [UIImage CHimageWithColor:CHUIColorFromRGB(0xc9c9c9, 1.0) size:CGSizeMake(widthFloat, widthFloat)];
    UIImage *norRainIma = [UIImage drawWithSize:CGSizeMake(widthFloat, widthFloat) Radius:4 image:norIma];
    UIImage *lightIma = [UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) size:CGSizeMake(widthFloat, widthFloat)];
    UIImage *lightRainIma = [UIImage drawWithSize:CGSizeMake(widthFloat, widthFloat) Radius:4 image:lightIma];
    NSArray *weekTits = @[CHLocalizedString(@"一", nil),CHLocalizedString(@"二", nil),CHLocalizedString(@"三", nil),CHLocalizedString(@"四", nil),CHLocalizedString(@"五", nil),CHLocalizedString(@"六", nil),CHLocalizedString(@"日", nil)];
    NSMutableArray *weekArr = [self weekSelectWithMode:self.morMode];
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
    
    CHLabel *line3 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line3];
    
    CHButton *saveBut = [CHButton createWithTit:CHLocalizedString(@"保存", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 18) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0f touchBlock:^(CHButton *sender) {
        [selfWeak saveClass];
    }];
    [self.view addSubview:saveBut];
    
    [self.openSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    [switchLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.openSwitch.mas_centerY);
        make.right.mas_equalTo(-80);
    }];
    
    [line0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(switchLab.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    
    [_morEndBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line0.mas_bottom).mas_offset(13);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50 * WIDTHAdaptive);
    }];
    
    [_morStarBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line0.mas_bottom).mas_offset(13);
        make.right.mas_equalTo(_morEndBut.mas_left).mas_offset(-32);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50 * WIDTHAdaptive);
    }];
    
    [mornLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(_morStarBut.mas_centerY);
        make.right.mas_equalTo(_morStarBut.mas_left).mas_offset(-8);
    }];
    
    [line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_morStarBut.mas_bottom).mas_offset(13);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    
    [_aftEndBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom).mas_offset(13);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50 * WIDTHAdaptive);
    }];
    
    [_aftStarBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom).mas_offset(13);
        make.right.mas_equalTo(_aftEndBut.mas_left).mas_offset(-32);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50 * WIDTHAdaptive);
    }];
    
    [afterLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(_aftStarBut.mas_centerY);
        make.right.mas_equalTo(_aftStarBut.mas_left).mas_offset(-8);
    }];
    
    [line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_aftStarBut.mas_bottom).mas_offset(13);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    
    [weekLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom).mas_offset(16);
        make.left.mas_equalTo(20);
    }];
    
    CHButton *but = [self.view viewWithTag:101];
    
    [line3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(but.mas_bottom).mas_offset(16);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    
    [saveBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
    }];
}

- (void)showDatePick:(CHButton *)sender maximum:(NSInteger)max minimum:(NSInteger)min{
    CHDatePickView *pickView = [[CHDatePickView alloc] initWithAnimation:YES];
    @WeakObj(self);
    [pickView didConfimBut:^(NSString *dateStr) {
        NSLog(@"didSelectPickView %@",dateStr);
        if (sender == selfWeak.aftStarBut) {
            NSDate *EndDate = [self.dateFormatter dateFromString:_aftEndBut.titleLabel.text];
            NSDate *StarDate = [self.dateFormatter dateFromString:dateStr];
            NSTimeInterval interval = [EndDate timeIntervalSinceDate:StarDate];
            if (interval <= 0) {
                [MBProgressHUD showError:CHLocalizedString(@"开始时间必须小于结束时间", nil)];
                return ;
            }
            else{
                selfWeak.aftMode.starTime = dateStr;
                [sender setTitle:dateStr forState:UIControlStateNormal];
            }
        }
        if (sender == selfWeak.aftEndBut) {
            NSDate *StarDate = [self.dateFormatter dateFromString:_aftStarBut.titleLabel.text];
            NSDate *EndDate = [self.dateFormatter dateFromString:dateStr];
            NSTimeInterval interval = [EndDate timeIntervalSinceDate:StarDate];
            if (interval <= 0) {
                [MBProgressHUD showError:CHLocalizedString(@"开始时间必须小于结束时间", nil)];
                return ;
            }
            else{
                selfWeak.aftMode.stopTime = dateStr;
                [sender setTitle:dateStr forState:UIControlStateNormal];
            }
        }
        if (sender == selfWeak.morStarBut) {
            NSDate *EndDate = [self.dateFormatter dateFromString:_morEndBut.titleLabel.text];
            NSDate *StarDate = [self.dateFormatter dateFromString:dateStr];
            NSTimeInterval interval = [EndDate timeIntervalSinceDate:StarDate];
            if (interval <= 0) {
                [MBProgressHUD showError:CHLocalizedString(@"开始时间必须小于结束时间", nil)];
                return ;
            }
            else{
                selfWeak.morMode.starTime = dateStr;
                [sender setTitle:dateStr forState:UIControlStateNormal];
            }
        }
        if (sender == selfWeak.morEndBut) {
            NSDate *StarDate = [self.dateFormatter dateFromString:_morStarBut.titleLabel.text];
            NSDate *EndDate = [self.dateFormatter dateFromString:dateStr];
            NSTimeInterval interval = [EndDate timeIntervalSinceDate:StarDate];
            if (interval <= 0) {
                [MBProgressHUD showError:CHLocalizedString(@"开始时间必须小于结束时间", nil)];
                return ;
            }
            else{
                selfWeak.morMode.stopTime = dateStr;
                [sender setTitle:dateStr forState:UIControlStateNormal];
            }
        }
    }];
    [self.view addSubview:pickView];
    [pickView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    if (max > 0) {
        pickView.maximum = max;
        pickView.hourInt = [[[sender.titleLabel.text componentsSeparatedByString:@":"] firstObject] intValue];
    }
    if (min > 0) {
        pickView.minimum = min;
        pickView.hourInt = [[[sender.titleLabel.text componentsSeparatedByString:@":"] firstObject] intValue] - min;
    }
    
    pickView.minInt = [[[sender.titleLabel.text componentsSeparatedByString:@":"] lastObject] intValue] + 60 * 30;
}

- (void)saveClass{
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [self requestWeekCmd];
    [dic addEntriesFromDictionary:@{@"DeviceId":self.user.deviceId,
                                    @"DeviceModel": self.user.deviceMo,
                                    @"CmdCode": LESSONS_TIME,
                                    @"Params": [NSString stringWithFormat:@"%d,%@,%@,%@,%@,%@,%@",self.openSwitch.on,self.morMode.week,self.morMode.starTime,self.morMode.stopTime,self.aftMode.week,self.aftMode.starTime,self.aftMode.stopTime],
                                    @"UserId": self.user.userId}];
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_SendCommand parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        if ([result[@"State"] intValue] == 0) {
            [MBProgressHUD showSuccess:CHLocalizedString(@"保存成功", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [selfWeak.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (void)dealloc{
    NSLog(@"dealloc");
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
