//
//  CHChangePassViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/23.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHChangePassViewController.h"

@interface CHChangePassViewController ()
{
     bool passInt1;
     bool passInt2;
     bool passInt3;
}
@property (nonatomic, strong) CHTextField *passFiled, *passFiled1, *passFiled2;
@property (nonatomic, strong) CHButton *changeBut;
@property (nonatomic, strong) CHUserInfo *user;
@end

@implementation CHChangePassViewController
@synthesize passFiled,passFiled1,passFiled2;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setBackgroudImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (CHUserInfo *)user{
    if (!_user) {
        _user = [CHAccountTool user];
    }
    return _user;
}

- (void)initializeMethod{
    [CHNotifictionCenter addObserver:self selector:@selector(KeyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [CHNotifictionCenter addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createUI{
    @WeakObj(self)
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = CHLocalizedString(@"修改密码", nil);
    UIImageView * headView = [UIImageView new];
    headView.image = [UIImage imageNamed:@"pic_zhaohuimima"];
    [self.view addSubview:headView];
    
    UIImageView *phoneIma = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_mima"] backColor:nil];
    passFiled = [CHTextField createWithPlace:CHLocalizedString(@"请输入原始密码", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor,1.0) font:CHFontNormal(nil,16)];
    passFiled.secureTextEntry = YES;
    passFiled.delegate = self;
    CHButton *eyeBut = [CHButton createWithTit:nil titColor:nil textFont:nil backColor:nil touchBlock:^(CHButton *sender) {
        sender.selected = !sender.selected;
        selfWeak.passFiled.secureTextEntry = !sender.selected;
    }];
    [eyeBut setImage:[UIImage imageNamed:@"btu_xianshi"] forState:UIControlStateNormal];
    [eyeBut setImage:[UIImage imageNamed:@"btu_yincang"] forState:UIControlStateSelected];
    eyeBut.frame = CGRectMake(0, 0, 30, 40);
    passFiled.rightView = eyeBut;
    passFiled.rightViewMode = UITextFieldViewModeAlways;
    
    CHLabel *lineLab = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    
    [self.view addSubview:phoneIma];
    [self.view addSubview:passFiled];
    [self.view addSubview:lineLab];
    
    UIImageView *phoneIma1 = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_mima_bl"] backColor:nil];
    passFiled1 = [CHTextField createWithPlace:CHLocalizedString(@"请输入新的密码", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor,1.0) font:CHFontNormal(nil,16)];
    passFiled1.secureTextEntry = YES;
    passFiled1.delegate = self;
    CHButton *eyeBut1 = [CHButton createWithTit:nil titColor:nil textFont:nil backColor:nil touchBlock:^(CHButton *sender) {
        sender.selected = !sender.selected;
       selfWeak.passFiled1.secureTextEntry = !sender.selected;
    }];
    [eyeBut1 setImage:[UIImage imageNamed:@"btu_xianshi"] forState:UIControlStateNormal];
    [eyeBut1 setImage:[UIImage imageNamed:@"btu_yincang"] forState:UIControlStateSelected];
    eyeBut1.frame = CGRectMake(0, 0, 30, 40);
    passFiled1.rightView = eyeBut1;
    passFiled1.rightViewMode = UITextFieldViewModeAlways;
    
    CHLabel *lineLab1 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    
    [self.view addSubview:phoneIma1];
    [self.view addSubview:passFiled1];
    [self.view addSubview:lineLab1];
    
    UIImageView *phoneIma2 = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_mima_bl"] backColor:nil];
    passFiled2 = [CHTextField createWithPlace:CHLocalizedString(@"请再次输入新的密码", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor,1.0) font:CHFontNormal(nil,16)];
    passFiled2.secureTextEntry = YES;
    passFiled2.delegate = self;
    CHButton *eyeBut2 = [CHButton createWithTit:nil titColor:nil textFont:nil backColor:nil touchBlock:^(CHButton *sender) {
        sender.selected = !sender.selected;
       selfWeak.passFiled2.secureTextEntry = !sender.selected;
    }];
    [eyeBut2 setImage:[UIImage imageNamed:@"btu_xianshi"] forState:UIControlStateNormal];
    [eyeBut2 setImage:[UIImage imageNamed:@"btu_yincang"] forState:UIControlStateSelected];
    eyeBut2.frame = CGRectMake(0, 0, 30, 40);
    passFiled2.rightView = eyeBut2;
    passFiled2.rightViewMode = UITextFieldViewModeAlways;
    
    CHLabel *lineLab2 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    
    [self.view addSubview:phoneIma2];
    [self.view addSubview:passFiled2];
    [self.view addSubview:lineLab2];
    
    CHButton *ResetBut = [CHButton createWithTit:CHLocalizedString(@"忘记密码", nil) titColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textFont:CHFontNormal(nil, 14) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 0) Radius:8.0 touchBlock:^(CHButton *sender) {
         [selfWeak.view endEditing:YES];
        CHRegisViewController *findPass = [[CHRegisViewController alloc] init];
        findPass.title = CHLocalizedString(@"找回密码", nil);
        findPass.operationStype = [CHCalculatedMode isValidateEmail:passFiled2.text] ? 3:2;
        [selfWeak.navigationController pushViewController:findPass animated:YES];
    }];
    [ResetBut setAttributedTitle:[[NSAttributedString alloc] initWithString:CHLocalizedString(@"忘记密码?", nil) attributes:@{NSFontAttributeName:CHFontNormal(nil, 14),NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]}] forState:UIControlStateNormal];
    [self.view addSubview:ResetBut];
    
    self.changeBut = [CHButton createWithTit:CHLocalizedString(@"确认修改", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
          [selfWeak.view endEditing:YES];
        if (![selfWeak.passFiled.text isEqualToString:selfWeak.user.userPs]) {
            [MBProgressHUD showError:CHLocalizedString(@"旧密码不正确", nil)];
            return ;
        }
        if (![selfWeak.passFiled1.text isEqualToString:selfWeak.passFiled2.text]) {
            [MBProgressHUD showError:CHLocalizedString(@"两次密码不一致", nil)];
            return ;
        }
        NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
        [dic addEntriesFromDictionary:@{@"LoginType": @0,
                                        @"Id":selfWeak.user.userId,
                                        @"OldPass": selfWeak.user.userPs,
                                        @"NewPass": selfWeak.passFiled1.text,
                                        @"SMSCode": @""}];
        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_ChangePassword parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
             if ([result[@"State"] intValue] == 0) {
                 [MBProgressHUD showSuccess:CHLocalizedString(@"修改成功", nil)];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [selfWeak.navigationController popViewControllerAnimated:YES];
                 });
             }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            
        }];
    }];
    self.changeBut.enabled = NO;
    [self.view addSubview:self.changeBut];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(240 * WIDTHAdaptive);
    }];
    
    [phoneIma mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(23);
    }];
    
    [passFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneIma.mas_right).mas_offset(16);
        make.height.mas_equalTo(42);
        make.centerY.mas_equalTo(phoneIma.mas_centerY);
        make.right.mas_equalTo(self.view).offset(-20);
    }];
    
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passFiled.mas_bottom).mas_offset(-2);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(1);
    }];
    
    [phoneIma1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineLab.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(23);
    }];
    
    [passFiled1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneIma1.mas_right).mas_offset(16);
        make.height.mas_equalTo(42);
        make.centerY.mas_equalTo(phoneIma1.mas_centerY);
        make.right.mas_equalTo(self.view).offset(-20);
    }];
    
    [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passFiled1.mas_bottom).mas_offset(-2);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(1);
    }];
    
    [phoneIma2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineLab1.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(23);
    }];
    
    [passFiled2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneIma2.mas_right).mas_offset(16);
        make.height.mas_equalTo(42);
        make.centerY.mas_equalTo(phoneIma2.mas_centerY);
        make.right.mas_equalTo(self.view).offset(-20);
    }];
    
    [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passFiled2.mas_bottom).mas_offset(-2);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(1);
    }];
    
    [ResetBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(24);
    }];
    
    [self.changeBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(ResetBut.mas_top).mas_equalTo(-12);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(44 * 1);
    }];
}

- (void)KeyboardWillChange:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    CGRect KeyboardFrame = [dict[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat KeyboardY = KeyboardFrame.origin.y;
    //获取动画时间
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGFloat transY = KeyboardY * 1.35 - self.view.frame.size.height;
    //动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transY);
    }];
}

- (void)KeyboardWillHide:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (passFiled == textField) [passFiled1 becomeFirstResponder];
    if (passFiled1 == textField) [passFiled2 becomeFirstResponder];
    if (passFiled2 == textField) [passFiled2 resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (passFiled == textField) {
        if (aString.length > 0) {
            passInt1 = YES;
        }
        else{
            passInt1 = NO;
        }
    }
    if (passFiled1 == textField) {
        if (aString.length > 0) {
            passInt2 = YES;
        }
        else{
            passInt2 = NO;
        }
    }
    if (passFiled2 == textField) {
        if (aString.length > 0) {
            passInt3 = YES;
        }
        else{
            passInt3 = NO;
        }
    }
    if (passInt1 && passInt2 && passInt3) {
        self.changeBut.enabled = YES;
    }
    else{
        self.changeBut.enabled = NO;
    }
    return YES;
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
