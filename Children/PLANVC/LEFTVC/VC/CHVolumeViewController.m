//
//  CHVolumeViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/21.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHVolumeViewController.h"

@interface CHVolumeViewController ()
{
    NSString *mess;
}
@property (nonatomic, strong) UISlider *fenceSlider;
@property (nonatomic, strong) CHButton *shakeBut, *ringBut;
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) CHCommandMode *volumeMode;
@property (nonatomic, strong) CHCommandMode *muteMode;
@property (nonatomic, strong) CHCommandMode *vibrationMode;
@end

@implementation CHVolumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeMethod];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CHUserInfo *)user{
    if (!_user) {
        _user = [CHAccountTool user];
    }
    return _user;
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = CHLocalizedString(@"声音和震动", nil);
    UIImageView *volumeIma = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_sbyl"] backColor:nil];
    [self.view addSubview:volumeIma];
    
    CHLabel *volumeLab = [CHLabel createWithTit:CHLocalizedString(@"手表音量", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:volumeLab];
    
    UIImageView *volumeIma1 = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_zd"] backColor:nil];
    [self.view addSubview:volumeIma1];
    
    self.fenceSlider = [[UISlider alloc] init];
    [self.fenceSlider setThumbImage:[UIImage imageNamed:@"icon_ydan"] forState:UIControlStateNormal];
    [self.fenceSlider setThumbImage:[UIImage imageNamed:@"icon_ydan"] forState:UIControlStateHighlighted];
    [self.fenceSlider setMaximumTrackImage:[UIImage imageNamed:@"shoubiaoyingliang_1"] forState:UIControlStateNormal];
    [self.fenceSlider setMinimumTrackImage:[UIImage imageNamed:@"shoubiaoyingliang_2"] forState:UIControlStateNormal];
    [self.fenceSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
    
    [self.view addSubview:self.fenceSlider];
    
    UIImageView *volumeIma2 = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_sy"] backColor:nil];
    [self.view addSubview:volumeIma2];
    
    CHLabel *line0 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(0xb3e5fc, 1.0) textAlignment:0];
    [self.view addSubview:line0];
    
    UIImageView *patternIma = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_ms"] backColor:nil];
    [self.view addSubview:patternIma];
    
    CHLabel *patternLab = [CHLabel createWithTit:CHLocalizedString(@"模式", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:patternLab];
    
    UIImageView *shakeIma = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_zd"] backColor:nil];
    [self.view addSubview:shakeIma];
    
    CHLabel *shakeLab = [CHLabel createWithTit:CHLocalizedString(@"振动", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    //    shakeLab.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:shakeLab];
    @WeakObj(self)
    self.shakeBut = [CHButton createWithNorImage:[UIImage imageNamed:@"icon_kaung_n"] selectIma:[UIImage imageNamed:@"icom_xz"] touchBlock:^(CHButton *sender) {
        sender.selected = !sender.selected;
        mess = @"";
        [selfWeak setCmdWithParams:sender.selected ? @"5":@"0" code:VIBRATION_SWITCH finish:^(BOOL success){
            selfWeak.vibrationMode.CmdValue = sender.selected ? @"5":@"0";
        }];
    }];
    [self.view addSubview:self.shakeBut];
    
    UIImageView *ringIma = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_sy"] backColor:nil];
    [self.view addSubview:ringIma];
    
    CHLabel *ringLab = [CHLabel createWithTit:CHLocalizedString(@"铃声", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    //    ringLab.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:ringLab];
    
    self.ringBut = [CHButton createWithNorImage:[UIImage imageNamed:@"icon_kaung_n"] selectIma:[UIImage imageNamed:@"icom_xz"] touchBlock:^(CHButton *sender) {
        sender.selected = !sender.selected;
        mess = @"";
        [selfWeak setCmdWithParams:[NSString stringWithFormat:@"%d",sender.selected] code:SOUND_SWITCH finish:^(BOOL success){
            selfWeak.muteMode.CmdValue = [NSString stringWithFormat:@"%d",sender.selected];
        }];
    }];
    [self.view addSubview:self.ringBut];
    
    CHLabel *line1 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(0xb3e5fc, 1.0) textAlignment:0];
    [self.view addSubview:line1];
    
    [volumeIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(36);
        make.left.mas_equalTo(16);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    [volumeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(volumeIma.mas_right).mas_offset(16);
        make.centerY.mas_equalTo(volumeIma.mas_centerY);
    }];
    
    [volumeIma1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(volumeIma.mas_bottom).mas_offset(30);
        make.left.mas_equalTo(volumeIma.mas_right).mas_offset(0);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(22);
    }];
    
    [volumeIma2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(volumeIma1.mas_centerY);
        make.right.mas_equalTo(-35);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(22);
    }];
    
    [self.fenceSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(volumeIma1.mas_centerY);
        make.left.mas_equalTo(volumeIma1.mas_right).mas_offset(9);
        make.right.mas_equalTo(volumeIma2.mas_left).mas_offset(-9);
    }];
    
    [line0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(volumeIma1.mas_bottom).mas_offset(30);
        make.left.mas_offset(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
    
    [patternIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line0.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(16);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    [patternLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(patternIma.mas_right).mas_offset(16);
        make.centerY.mas_equalTo(patternIma.mas_centerY);
    }];
    
    [shakeIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(patternIma.mas_bottom).mas_equalTo(20);
        make.left.mas_equalTo(patternIma.mas_right).mas_offset(0);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(22);
    }];
    
    [shakeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(shakeIma.mas_centerY);
        make.left.mas_equalTo(shakeIma.mas_right).mas_offset(8);
        make.width.mas_lessThanOrEqualTo(CHMainScreen.size.width/2);
    }];
    
    [_shakeBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(shakeIma.mas_centerY);
        make.left.mas_equalTo(shakeLab.mas_right).mas_offset(8);
        make.width.mas_lessThanOrEqualTo(31);
        make.height.mas_lessThanOrEqualTo(25);
    }];
    
    [ringIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(shakeIma.mas_bottom).mas_equalTo(20);
        make.left.mas_equalTo(patternIma.mas_right).mas_offset(0);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(22);
    }];
    
    [ringLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ringIma.mas_centerY);
        make.left.mas_equalTo(ringIma.mas_right).mas_offset(8);
        make.width.mas_lessThanOrEqualTo(CHMainScreen.size.width/2);
    }];
    
    [_ringBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ringIma.mas_centerY);
        make.left.mas_equalTo(ringLab.mas_right).mas_offset(8);
        make.width.mas_lessThanOrEqualTo(31);
        make.height.mas_lessThanOrEqualTo(25);
    }];
    
    //    [_ringBut mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.mas_equalTo(shakeIma.mas_centerY);
    //        make.right.mas_equalTo(line0.mas_right);
    //        make.width.mas_lessThanOrEqualTo(31);
    //        make.height.mas_lessThanOrEqualTo(25);
    //    }];
    //
    //    [ringLab mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.mas_equalTo(shakeIma.mas_centerY);
    //        make.right.mas_equalTo(_ringBut.mas_left).mas_offset(-8);
    //        make.width.mas_lessThanOrEqualTo(CHMainScreen.size.width/2);
    //    }];
    //
    //    [ringIma mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.mas_equalTo(shakeIma.mas_centerY);
    //        make.right.mas_equalTo(ringLab.mas_left).mas_offset(-8);
    //        make.width.mas_equalTo(25);
    //        make.height.mas_equalTo(22);
    //    }];
    
    [line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ringIma.mas_bottom).mas_offset(30);
        make.left.mas_offset(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
}

- (void)initializeMethod{
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"DeviceId":self.user.deviceId}];
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_CommandList parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        int foundAll = 0;
        for (NSDictionary *dic in result[@"Items"]) {
            if ([dic[@"Code"] intValue] == [SOUND_SIZE intValue]) {
                selfWeak.volumeMode = [CHCommandMode mj_objectWithKeyValues:dic];
                foundAll ++;
                if (foundAll == 3) {
                    break;
                }
            }
            if ([dic[@"Code"] intValue] == [SOUND_SWITCH intValue]) {
                selfWeak.muteMode = [CHCommandMode mj_objectWithKeyValues:dic];
                foundAll ++;
                if (foundAll == 3) {
                    break;
                }
            }
            if ([dic[@"Code"] intValue] == [VIBRATION_SWITCH intValue]) {
                selfWeak.vibrationMode = [CHCommandMode mj_objectWithKeyValues:dic];
                foundAll ++;
                if (foundAll == 3) {
                    break;
                }
            }
        }
        [selfWeak updateUI:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [selfWeak updateUI:NO];
    }];
}

- (void)updateUI:(BOOL)success{
    self.fenceSlider.enabled = success;
    self.ringBut.enabled = success;
    self.shakeBut.enabled = success;
    if (success) {
        NSNumber *saveValue = [CHDefaultionfos CHgetValueforKey:CHVOLUMEVALUE];
        NSString *valueStr = [NSString stringWithFormat:@"%.0f",saveValue.floatValue * 3];
        if ([valueStr isEqualToString:self.volumeMode.CmdValue]) {
            self.fenceSlider.value = saveValue.floatValue;
        }
        else{
            if (!self.volumeMode.CmdValue ||[self.volumeMode.CmdValue isEqualToString:@""]) {
                self.fenceSlider.value = 1.0;
            }
            else{
                self.fenceSlider.value = self.volumeMode.CmdValue.floatValue/3;
            }
        }
        self.ringBut.selected = self.muteMode.CmdValue.intValue;
        if (!self.muteMode.CmdValue ||[self.muteMode.CmdValue isEqualToString:@""]) {
            self.ringBut.selected = YES;
        }
        self.shakeBut.selected = self.vibrationMode.CmdValue.intValue;
    }
}

- (void)sliderValueChanged1:(UISlider *)slider{
    NSLog(@"sliderValueChanged1111111111111111111111111111111111111111111");
}

- (void)sliderValueChanged2:(UISlider *)slider{
    NSLog(@"sliderValueChanged2222222222222222222222222222222222222222");
}

- (void)sliderValueChanged3:(UISlider *)slider{
    NSLog(@"sliderValueChanged133333333333333333333333333333333333333333");
}

- (void)sliderValueChanged4:(UISlider *)slider{
    NSLog(@"sliderValueChanged14444444444444444444444444444444444444444444");
}
- (void)sliderValueChanged5:(UISlider *)slider{
    NSLog(@"sliderValueChanged15555555555555555555555555555555555555555555");
}
- (void)sliderValueChanged6:(UISlider *)slider{
    NSLog(@"sliderValueChanged166666666666666666666666666666");
}
- (void)sliderValueChanged7:(UISlider *)slider{
    NSLog(@"sliderValueChanged17777777777777777777777777777777");
}
- (void)sliderValueChanged8:(UISlider *)slider{
    NSLog(@"sliderValueChanged188888888888888888888888888888888");
}
//- (void)sliderValueChanged1:(UISlider *)slider{
//
//}
//- (void)sliderValueChanged1:(UISlider *)slider{
//
//}

- (void)sliderValueChanged:(UISlider *)slider{
    [CHDefaultionfos CHputKey:CHVOLUMEVALUE andValue:[NSNumber numberWithFloat:slider.value]];
    NSString *params = [NSString stringWithFormat:@"%.0f",slider.value * 3];
    NSLog(@"ffffffffff %@",params);
    __block int requestInt = 0;
    __block int requestFin = 1;
    @WeakObj(self)
    mess = @"";
    if (slider.value <= 0) {
        requestFin = 2;
        [CHAFNWorking shareAFNworking].moreRequest = YES;
        [self setCmdWithParams:@"5" code:VIBRATION_SWITCH finish:^(BOOL success){
            requestInt ++;
            if (requestInt == 2) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    if (success) {
                        selfWeak.vibrationMode.CmdValue = @"5";
                        [MBProgressHUD showSuccess:CHLocalizedString(@"设置成功", nil)];
                    }
                    [CHAFNWorking shareAFNworking].moreRequest = NO;
                    [selfWeak updateUI:YES];
                });
            }
        }];
        mess = nil;
    }
    [self setCmdWithParams:params code:SOUND_SIZE finish:^(BOOL success){
        requestInt ++;
        if (requestInt == 2) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                if (success) {
                    [MBProgressHUD showSuccess:CHLocalizedString(@"设置成功", nil)];
                    selfWeak.volumeMode.CmdValue = params;
                }
                [CHAFNWorking shareAFNworking].moreRequest = NO;
                [selfWeak updateUI:YES];
            });
        }
    }];
}

- (void)setCmdWithParams:(NSString *)params code:(NSString *)code finish:(void(^)(BOOL success))callBack{
    
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"DeviceId":self.user.deviceId,
                                    @"DeviceModel": self.user.deviceMo,
                                    @"CmdCode": code,
                                    @"Params": params,
                                    @"UserId": self.user.userId}];
    //    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_SendCommand parameters:dic Mess:mess showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        if ([result[@"State"] intValue] == 0) {
            if (mess) {
                [MBProgressHUD showSuccess:CHLocalizedString(@"设置成功", nil)];
            }
        }
        callBack(YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        callBack(NO);
    }];
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
