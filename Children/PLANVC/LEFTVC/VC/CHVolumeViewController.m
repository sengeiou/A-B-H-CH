//
//  CHVolumeViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/21.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHVolumeViewController.h"

@interface CHVolumeViewController ()
@property (nonatomic, strong) UISlider *fenceSlider;
@property (nonatomic, strong) CHButton *shakeBut, *ringBut;
@end

@implementation CHVolumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.fenceSlider setMaximumTrackImage:[UIImage imageNamed:@"icon_biaochi_1"] forState:UIControlStateNormal];
    [self.fenceSlider setMinimumTrackImage:[UIImage imageNamed:@"icon_biaochi_2"] forState:UIControlStateNormal];
    [self.fenceSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
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
   
    self.shakeBut = [CHButton createWithNorImage:[UIImage imageNamed:@"icon_kaung_n"] selectIma:[UIImage imageNamed:@"icom_xz"] touchBlock:^(CHButton *sender) {
        sender.selected = !sender.selected;
    }];
    [self.view addSubview:self.shakeBut];
    
    UIImageView *ringIma = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_sy"] backColor:nil];
    [self.view addSubview:ringIma];
    
    CHLabel *ringLab = [CHLabel createWithTit:CHLocalizedString(@"铃声", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
//    ringLab.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:ringLab];
    
    self.ringBut = [CHButton createWithNorImage:[UIImage imageNamed:@"icon_kaung_n"] selectIma:[UIImage imageNamed:@"icom_xz"] touchBlock:^(CHButton *sender) {
        sender.selected = !sender.selected;
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
        make.top.mas_equalTo(line0.mas_bottom).mas_offset(8);
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

- (void)sliderValueChanged:(UISlider *)slider{
    
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
