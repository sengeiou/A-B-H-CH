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
@end

@implementation CHSubAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = CHLocalizedString(@"闹钟", nil);
    _datePickView = [[CHDatePickView alloc] initWithAnimation:NO];
    [self.view addSubview:_datePickView];
    
    CHLabel *line0 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(0xb3e5fc, 1.0) textAlignment:0];
    [self.view addSubview:line0];
    
    UIView *baseView = [UIView new];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    CHLabel *weekLab = [CHLabel createWithTit:CHLocalizedString(@"重复", nil) font:CHFontNormal(nil, 18) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [baseView addSubview:weekLab];
    
    CGFloat widthFloat = (CHMainScreen.size.width - 8 * 6 - 40)/7;
    UIImage *norIma = [UIImage CHimageWithColor:CHUIColorFromRGB(0xc9c9c9, 1.0) size:CGSizeMake(widthFloat, widthFloat)];
    UIImage *norRainIma = [UIImage drawWithSize:CGSizeMake(widthFloat, widthFloat) Radius:4 image:norIma];
    UIImage *lightIma = [UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) size:CGSizeMake(widthFloat, widthFloat)];
    UIImage *lightRainIma = [UIImage drawWithSize:CGSizeMake(widthFloat, widthFloat) Radius:4 image:lightIma];
    NSArray *weekTits = @[CHLocalizedString(@"一", nil),CHLocalizedString(@"二", nil),CHLocalizedString(@"三", nil),CHLocalizedString(@"四", nil),CHLocalizedString(@"五", nil),CHLocalizedString(@"六", nil),CHLocalizedString(@"日", nil)];
//    NSMutableArray *weekArr = [self weekSelectWithMode:self.morMode];
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
//        weekBut.selected = [weekArr[i] intValue];
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
    
    CHLabel *openLab = [CHLabel createWithTit:CHLocalizedString(@"开关", nil) font:CHFontNormal(nil, 18) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [baseView addSubview:openLab];
    
    
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
