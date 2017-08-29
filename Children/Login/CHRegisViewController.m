//
//  CHRegisViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/14.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHRegisViewController.h"

@interface CHRegisViewController ()
{
    UIImageView *indexIma;
    UILabel *codeLab;
    UILabel *countryLab;
    CHTextField *phoneLab;
    CHTextField *passFiled;
    CHTextField *authFiled;
    NSTimer *timer;
    CHButton *authBut;
    CHButton *resignBut;
}
@end

@implementation CHRegisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeMethod];
    [self createUI];
    //设置本地区号
    [self setTheLocalAreaCode];
    //    [MBProgressHUD showMessage:@"1231"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController setBackgroudImage:[UIImage new]];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [self.navigationController setBackgroudImage:[UIImage new]];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}
- (void)initializeMethod{
    [CHNotifictionCenter addObserver:self selector:@selector(KeyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [CHNotifictionCenter addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * headView = [UIImageView new];
    headView.image = [UIImage imageNamed: _operationStype < 2 ? @"pic_zhuce":@"pic_zhaohuimima"];
    [self.view addSubview:headView];
    
    UIImageView *logoIma = [UIImageView new];
    [logoIma setImage:[UIImage imageNamed:@"icon_quyu"]];
    [self.view addSubview:logoIma];
    
    countryLab = [UILabel new];
    [countryLab setText:CHLocalizedString(@"中国大陆", nil)];
    countryLab.font = CHFontNormal(nil, 16);
    [countryLab setTextColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0)];
    [self.view addSubview:countryLab];
    
    indexIma = [UIImageView new];
    indexIma.image = [UIImage imageNamed:@"btu_xuanzhe_n"];
    [self.view addSubview:indexIma];
    
    codeLab = [UILabel new];
    codeLab.text = CHLocalizedString(@"+86", nil);
    codeLab.textAlignment = NSTextAlignmentRight;
    codeLab.font = CHFontNormal(nil, 16);
    [self.view addSubview:codeLab];
    
    UILabel *lineLab0 = [UILabel new];
    lineLab0.backgroundColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    [self.view addSubview:lineLab0];
    
    if (_operationStype == 1 || _operationStype == 3) {
        countryLab.alpha = 0;
        codeLab.alpha = 0;
        indexIma.alpha = 0;
        lineLab0.alpha = 0;
        logoIma.alpha = 0;
    }
    
    CHButton *codeBut = [CHButton createWithTit:nil titColor:nil textFont:nil backColor:nil touchBlock:^(CHButton *sender) {
        SectionsViewController* country = [[SectionsViewController alloc] init];
        country.delegate = self;
        [self presentViewController:country animated:YES completion:^{
            
        }];
    }];
    [self.view addSubview:codeBut];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(240 * WIDTHAdaptive);
    }];
    
    [logoIma mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat offset = 0.0f;
        if (_operationStype == 0 || _operationStype == 2) offset = 4.0;
        if (_operationStype == 1 || _operationStype == 3) offset = -39.0f;
        
        make.top.mas_equalTo(headView.mas_bottom).mas_offset(offset);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(23);
    }];
    
    [indexIma mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.centerY.mas_equalTo(logoIma);
        make.size.mas_equalTo(CGSizeMake(5, 10));
    }];
    
    [codeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(indexIma.mas_right).mas_offset(-16);
        make.height.mas_equalTo(42);
        make.centerY.mas_equalTo(logoIma);
    }];
    [codeLab setContentHuggingPriority:UILayoutPriorityRequired
                               forAxis:UILayoutConstraintAxisHorizontal];
    
    [countryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logoIma.mas_right).mas_offset(16);
        make.right.mas_equalTo(codeLab.mas_left).mas_offset(-10);
        make.height.mas_equalTo(42);
        make.centerY.mas_equalTo(logoIma);
    }];
    
    [lineLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(countryLab.mas_bottom).mas_offset(-2);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(1);
    }];
    
    [codeBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logoIma.mas_left);
        make.top.mas_equalTo(countryLab.mas_top);
        make.bottom.mas_equalTo(lineLab0.mas_top);
        make.right.mas_equalTo(indexIma.mas_right);
    }];
    
    
    UIImageView *phoneIma = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_haoma"] backColor:nil];
    NSString *accountStr = @"";
    if (_operationStype == 0 || _operationStype == 2) accountStr = CHLocalizedString(@"请输入手机号", nil);
    if (_operationStype == 1 || _operationStype == 3) accountStr = CHLocalizedString(@"请输入邮箱", nil);
    
    phoneLab = [CHTextField createWithPlace:accountStr text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor,1.0) font:CHFontNormal(nil,16)];
    
    if (_operationStype == 0 || _operationStype == 2) phoneLab.keyboardType = UIKeyboardTypeNumberPad;
    if (_operationStype == 1 || _operationStype == 3) phoneLab.keyboardType = UIKeyboardTypeEmailAddress;
    phoneLab.delegate = self;
    CHLabel *lineLab1 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    
    [self.view addSubview:phoneIma];
    [self.view addSubview:phoneLab];
    [self.view addSubview:lineLab1];
    
    [phoneIma mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineLab0.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(logoIma.mas_left);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(23);
    }];
    
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneIma.mas_right).mas_offset(16);
        make.height.mas_equalTo(42);
        make.centerY.mas_equalTo(phoneIma.mas_centerY);
        make.right.mas_equalTo(self.view).offset(-20);
    }];
    
    [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneLab.mas_bottom).mas_offset(-2);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *phoneIma1 = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_mima"] backColor:nil];
    passFiled = [CHTextField createWithPlace:CHLocalizedString(@"请输入密码", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor,1.0) font:CHFontNormal(nil,16)];
    passFiled.secureTextEntry = YES;
    passFiled.delegate = self;
    CHButton *eyeBut = [CHButton createWithTit:nil titColor:nil textFont:nil backColor:nil touchBlock:^(CHButton *sender) {
        sender.selected = !sender.selected;
        passFiled.secureTextEntry = !sender.selected;
    }];
    [eyeBut setImage:[UIImage imageNamed:@"btu_xianshi"] forState:UIControlStateNormal];
    [eyeBut setImage:[UIImage imageNamed:@"btu_yincang"] forState:UIControlStateSelected];
    eyeBut.frame = CGRectMake(0, 0, 30, 40);
    passFiled.rightView = eyeBut;
    passFiled.rightViewMode = UITextFieldViewModeAlways;
    
    CHLabel *lineLab2 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    
    [self.view addSubview:phoneIma1];
    [self.view addSubview:passFiled];
    [self.view addSubview:lineLab2];
    
    [phoneIma1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineLab1.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(logoIma.mas_left);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(23);
    }];
    
    
    [passFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneIma1.mas_right).mas_offset(16);
        make.height.mas_equalTo(42);
        make.centerY.mas_equalTo(phoneIma1.mas_centerY);
        make.right.mas_equalTo(self.view).offset(-20);
    }];
    
    [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passFiled.mas_bottom).mas_offset(-2);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *phoneIma2 = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_yanzhengma"] backColor:nil];
    authFiled = [CHTextField createWithPlace:CHLocalizedString(@"请输入验证码", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor,1.0) font:CHFontNormal(nil,16)];
    authFiled.delegate = self;
    authBut = [CHButton createWithTit:CHLocalizedString(@"获取验证码", nil) titColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textFont:CHFontNormal(nil,16) backColor:nil touchBlock:^(CHButton *sender) {
        sender.selected = !sender.selected;
        if (!phoneLab.text || [phoneLab.text isEqualToString:@""]) {
            if (_operationStype == 0 || _operationStype == 2) [MBProgressHUD showError:CHLocalizedString(@"请输入手机号", nil)];
            if (_operationStype == 1 || _operationStype == 3) [MBProgressHUD showError:CHLocalizedString(@"请输入邮箱", nil)];
            return ;
        }
        
        [self.view endEditing:YES];
        NSMutableDictionary *dic = [[CHAFNWorking shareAFNworking] requestDic];//[NSString stringWithFormat:@"%@%@",[codeLab.text stringByReplacingOccurrencesOfString:@"+" withString:@"00"],phoneLab.text]
        [dic addEntriesFromDictionary:@{@"LoginName":phoneLab.text}];
        
        if (_operationStype == 2) {
            NSMutableDictionary *resignDic = [[CHAFNWorking shareAFNworking] requestDic];
            [resignDic addEntriesFromDictionary:@{@"Phone":phoneLab.text,@"VildateSence":@"1"}];
            [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_SendSMS parameters:resignDic Mess:CHLocalizedString(@"正在发送...", nil)  showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                if ([[result objectForKey:@"State"] intValue] == 0) {
                    authBut.enabled = NO;
                    [MBProgressHUD showSuccess:CHLocalizedString(@"发送成功!", nil)];
                    [sender setTitle:@"60S" forState:UIControlStateNormal];
                    if (timer) {
                        [timer invalidate];
                        timer = nil;
                    }
                    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeOut) userInfo:nil repeats:YES];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                
            }];
            return;
        }
        
        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_CheckUser parameters:dic Mess:CHLocalizedString(@"正在发送...", nil) showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
            if ([[result objectForKey:@"State"] intValue] == 0 || _operationStype == 2) {
                NSMutableDictionary *resignDic = [[CHAFNWorking shareAFNworking] requestDic];
                [resignDic addEntriesFromDictionary:@{@"Phone":phoneLab.text,@"VildateSence":@"1"}];
                [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_SendSMS parameters:resignDic Mess:nil  showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                    if ([[result objectForKey:@"State"] intValue] == 0) {
                        [MBProgressHUD hideHUD];
                        authBut.enabled = NO;
                        [MBProgressHUD showSuccess:CHLocalizedString(@"发送成功!", nil)];
                        [sender setTitle:@"60S" forState:UIControlStateNormal];
                        if (timer) {
                            [timer invalidate];
                            timer = nil;
                        }
                        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeOut) userInfo:nil repeats:YES];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                    
                }];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            
        }];
    }];
    authFiled.keyboardType = UIKeyboardTypeNumberPad;
    authBut.frame = CGRectMake(0, 0, 100, 40);
    authFiled.rightView = authBut;
    authBut.titleLabel.numberOfLines = 2;
    authBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    authBut.titleLabel.font = CHFontNormal(nil, 11);
    authFiled.rightViewMode = UITextFieldViewModeAlways;
    CHLabel *lineLab3 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    
    [self.view addSubview:phoneIma2];
    [self.view addSubview:authFiled];
    [self.view addSubview:lineLab3];
    
    [phoneIma2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineLab2.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(logoIma.mas_left);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(23);
    }];
    
    [authFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneIma2.mas_right).mas_offset(16);
        make.height.mas_equalTo(42);
        make.centerY.mas_equalTo(phoneIma2.mas_centerY);
        make.right.mas_equalTo(self.view).offset(-20);
    }];
    
    [lineLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(authFiled.mas_bottom).mas_offset(-2);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(1);
    }];
    
    NSString *mailStr = @"";
    if (_operationStype == 0) mailStr = CHLocalizedString(@"邮箱注册", nil);
    if (_operationStype == 1) mailStr = CHLocalizedString(@"手机号注册", nil);
    CHButton *mailBut = [CHButton createWithTit:mailStr titColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textFont:CHFontNormal(nil, 16) backColor:nil touchBlock:^(CHButton *sender) {
        if (_operationStype == 0) {
            CHRegisViewController *emailResignVC = [[CHRegisViewController alloc] init];
            emailResignVC.operationStype = 1;
            [self.navigationController pushViewController:emailResignVC animated:YES];
        }
        else if (_operationStype == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [mailBut setImage:[UIImage imageNamed:@"icon_qiehuan_n"] forState:UIControlStateNormal];
    [mailBut setImage:[UIImage imageNamed:@"btu_xuanzhe_p"] forState:UIControlStateHighlighted];
    if (_operationStype >= 2) {
        mailBut.hidden = YES;
    }
    [self.view addSubview:mailBut];
    
    
    CHButton *protoBut = [CHButton createWithTit:nil titColor:nil textFont:nil backColor:nil touchBlock:^(CHButton *sender) {
        
    }];
    [self.view addSubview:protoBut];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];//,NSParagraphStyleAttributeName:paragraphStyle
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:CHLocalizedString(@"点击注册即表示您同意", nil) attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:CHFontNormal(nil, 12)}];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:CHLocalizedString(@"用户服务协议", nil) attributes:@{NSForegroundColorAttributeName:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0),NSFontAttributeName:CHFontNormal(nil, 12),NSUnderlineStyleAttributeName:@1}];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] init];
    
    [attributed appendAttributedString:str1];
    [attributed appendAttributedString:str2];
    protoBut.titleLabel.numberOfLines = 2;
    protoBut.titleLabel.textAlignment = NSTextAlignmentCenter;
    [protoBut setAttributedTitle:attributed forState:UIControlStateNormal];
    if (_operationStype >= 2) {
        protoBut.hidden = YES;
    }
    
    NSString *resStr = CHLocalizedString(@"注册", nil);
    if (_operationStype >= 2) {
        resStr = CHLocalizedString(@"确认重置", nil);
    }
    
    resignBut = [CHButton createWithTit:resStr titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        [self.view endEditing:YES];
        
        NSMutableDictionary *resignDic = [CHAFNWorking shareAFNworking].requestDic;
        NSString *mess = @"";
        if (_operationStype == 0) {
            mess = CHLocalizedString(@"正在注册...", nil);
            
            [resignDic addEntriesFromDictionary:@{@"LoginName":phoneLab.text,@"Username":phoneLab.text,@"Email":@"",@"Password":passFiled.text,@"SerialNumber":@"",@"Contact":phoneLab.text,@"ContactPhone":phoneLab.text,@"ThirdName":@"",@"ThirdID":@"",@"ThirdType":@"",@"ThirdImg":@"",@"SMSCode":authFiled.text}];
            [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_Register parameters:resignDic Mess:mess showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                [self resignSuccess:result];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                
            }];
        }
        else if(_operationStype == 1){
            
        }else if(_operationStype == 2){
            mess = CHLocalizedString(@"正在确认重置...", nil);
            [resignDic addEntriesFromDictionary:@{@"LoginName":phoneLab.text,@"NewPass":passFiled.text,@"SMSCode":authFiled.text}];
            [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_ChangePasswordNeedSMSCode parameters:resignDic Mess:mess showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                if ([[result objectForKey:@"State"] intValue] == 0) {
                    [MBProgressHUD showSuccess:CHLocalizedString(@"修改成功!", nil)];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                
            }];
        }else if(_operationStype == 3){
            
        }
        
    }];
    resignBut.enabled = NO;
    [self.view addSubview:resignBut];
    
    [mailBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_equalTo(-16);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(42);
    }];
    [mailBut layoutButtonWithEdgeInsetsStyle:buttonddgeinsetsstyletopright space:8.0];
    
    [protoBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(mailBut.mas_top).mas_equalTo(-16);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [resignBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(protoBut.mas_top).mas_equalTo(-4);
        make.left.mas_equalTo(self.view).mas_offset(30);
        make.right.mas_equalTo(self.view).mas_offset(-30);
        make.height.mas_equalTo(40);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)setTheLocalAreaCode
{
    NSLocale *locale = [NSLocale currentLocale];
    
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    NSString* tt=[locale objectForKey:NSLocaleCountryCode];
    NSString* defaultCode=[dictCodes objectForKey:tt];
    codeLab.text = [NSString stringWithFormat:@"+%@",defaultCode];
    countryLab.text = [locale displayNameForKey:NSLocaleCountryCode value:tt];
}

- (void)KeyboardWillChange:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    CGRect KeyboardFrame = [dict[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat KeyboardY = KeyboardFrame.origin.y;
    NSLog(@"KeyboardWillChange %f",KeyboardY);
    //获取动画时间
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGFloat transY = KeyboardY * 1.35 - self.view.frame.size.height;
    NSLog(@"%f KeyboardWillChange %f",KeyboardY,transY);
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

- (void)timeOut{
    [authBut setTitle:[NSString stringWithFormat:@"%dS",[authBut.titleLabel.text stringByReplacingOccurrencesOfString:@"S" withString:@""].intValue - 1] forState:UIControlStateNormal];
    if ([authBut.titleLabel.text stringByReplacingOccurrencesOfString:@"S" withString:@""].intValue == 0) {
        [authBut setTitle:CHLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
        authBut.enabled = YES;
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
    }
}

- (void)resignSuccess:(id)result{
    if ([[result objectForKey:@"State"] intValue] == 0) {
        CHUserInfo *user = [[CHUserInfo alloc] init];
        user.userId = [NSString stringWithFormat:@"%d",[[[result objectForKey:@"User"] objectForKey:@"UserId"] intValue]];
        user.userPh = phoneLab.text;
        user.userPs = passFiled.text;
        user.userTo = [result objectForKey:@"AccessToken"];
        [CHDefaultionfos CHputKey:CHAPPTOKEN andValue:user.userTo];
        [CHAccountTool saveUser:user];
        NSMutableDictionary *personDic = [CHAFNWorking shareAFNworking].requestDic;
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        
        [personDic addEntriesFromDictionary:@{@"UserId": user.userId,
                                              @"GroupId": @"",
                                              @"MapType": @"",
                                              @"LastTime": [NSDate date].description,
                                              @"TimeOffset": [NSNumber numberWithInteger:[zone secondsFromGMT]/3600],
                                              @"Token": user.userTo}];
        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_PersonDeviceList parameters:personDic Mess:nil showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
            if ([[result objectForKey:@"Items"] count] > 0) {
                [[FMDBConversionMode sharedCoreBlueTool] deleteDevice:user];
                for (int i = 0; i < [[result objectForKey:@"Items"] count]; i ++) {
                    NSDictionary *itemDit = [[result objectForKey:@"Items"] objectAtIndex:i];
                    CHUserInfo *userList = [[CHUserInfo alloc] init];
                    if (i == 0) {
                        userList = user;
                    }
                    userList.userId = user.userId;
                    userList.deviceId = [TypeConversionMode strongChangeString:itemDit[@"Id"]];
                    userList.devicePh = [TypeConversionMode strongChangeString:itemDit[@"Sim"]];
                    userList.deviceNa = [TypeConversionMode strongChangeString:itemDit[@"NickName"]];
                    userList.deviceMo = [TypeConversionMode strongChangeString:itemDit[@"Model"]];
                    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[TypeConversionMode strongChangeString:itemDit[@"Avatar"]]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        
                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                        if (!image) {
                            image = [UIImage imageNamed:@"pho_touxiang"];
                        }
                        userList.deviceIm = [UIImageJPEGRepresentation(image, 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                        [[FMDBConversionMode sharedCoreBlueTool] insertDevice:userList];
                        if (i == 0) {
                            [CHAccountTool saveUser:userList];
                        }
                    }];
                }
            }
            else{
                [CHAccountTool saveUser:user];
                CHUserInfo *us = [CHAccountTool user];
                self.navigationController.backImage = [UIImage imageNamed:@"btu_fanhui_w"];
                CHBingViewController *binVC = [[CHBingViewController alloc] init];
                [self.navigationController pushViewController:binVC animated:YES];
                return ;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            
        }];
    }
}
#pragma mark - SecondViewControllerDelegate的方法
- (void)setSecondData:(NSString *)code{
    NSLog(@"the area data：%@,", code);
    codeLab.text = [NSString stringWithFormat:@"+%@",[[code componentsSeparatedByString:@","] lastObject]];
    countryLab.text = [[code componentsSeparatedByString:@","] firstObject];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (phoneLab == textField) [passFiled becomeFirstResponder];
    if (passFiled == textField) [authFiled becomeFirstResponder];
    return YES;
}

static bool accInt;
static bool passInt;
static bool codeInt;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == phoneLab) {
        if (aString.length > 0) {
            accInt = YES;
        }
        else{
            accInt = NO;
        }
    } else if (textField == passFiled) {
        if (aString.length > 0) {
            passInt = YES;
        }
        else{
            passInt = NO;
        }
    }else if (textField == authFiled) {
        if (aString.length > 0) {
            codeInt = YES;
        }
        else{
            codeInt = NO;
        }
    }
    if (passInt && accInt && codeInt) {
        resignBut.enabled = YES;
    }
    else{
        resignBut.enabled = NO;
    }
    return YES;
}
@end
