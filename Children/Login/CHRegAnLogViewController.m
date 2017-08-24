//
//  CHRegAnLogViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHRegAnLogViewController.h"

@interface CHRegAnLogViewController ()

@end

@implementation CHRegAnLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    UIImageView *backgrounView = [UIImageView new];
    backgrounView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:backgrounView];
    [backgrounView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    
    UIButton *loginBut = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBut.titleLabel.font = CHFontNormal(nil, 23);
    [self.view addSubview:loginBut];
    loginBut.backgroundColor = CHUIColorFromRGB(0xffffff, 0.8);
    [loginBut setTitleColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) forState:UIControlStateNormal];
    [loginBut setTitle:CHLocalizedString(@"login_login", nil) forState:UIControlStateNormal];
    loginBut.layer.masksToBounds = YES;
    loginBut.layer.cornerRadius = 5.0f;
    loginBut.layer.borderWidth = 1.0f;
    loginBut.tag = 1001;
    loginBut.layer.borderColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0).CGColor;
    [loginBut addTarget:self action:@selector(didSelectBut:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat butWidth = (CHMainScreen.size.width - 56)/2;
    [loginBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-40);
        make.width.mas_equalTo(butWidth);
        make.left.mas_equalTo(20);
    }];
    
    UIButton *resignBut = [UIButton buttonWithType:UIButtonTypeCustom];
    resignBut.titleLabel.font = CHFontNormal(nil, 23);
    [self.view addSubview:resignBut];
    resignBut.backgroundColor = CHUIColorFromRGB(0xffffff, 0.8);
    [resignBut setTitleColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) forState:UIControlStateNormal];
    [resignBut setTitle:CHLocalizedString(@"login_regis", nil) forState:UIControlStateNormal];
    resignBut.layer.masksToBounds = YES;
    resignBut.layer.cornerRadius = 5.0f;
    resignBut.layer.borderWidth = 1.0f;
    resignBut.tag = 1002;
    resignBut.layer.borderColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0).CGColor;
    [resignBut addTarget:self action:@selector(didSelectBut:) forControlEvents:UIControlEventTouchUpInside];
    [resignBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loginBut.mas_top);
        make.width.mas_equalTo(butWidth);
        make.right.mas_equalTo(-20);
    }];
    
}

- (void)didSelectBut:(UIButton *)sender{
    switch (sender.tag) {
        case 1001:
            self.navigationController.backImage = [UIImage imageNamed:@"btu_fanhui_n"];
            [self.navigationController pushViewController:[[CHLoginViewController alloc] init] animated:YES];
            break;
        case 1002:
            self.navigationController.backImage = [UIImage imageNamed:@"btu_fanhui_n"];
            [self.navigationController pushViewController:[[CHRegisViewController alloc] init] animated:YES];
            break;
        default:
            break;
    }

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
