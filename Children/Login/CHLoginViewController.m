//
//  CHLoginViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/21.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHLoginViewController.h"

@interface CHLoginViewController ()
{
    UILabel *codeLab;
    UILabel *countryLab;
    CHTextField *phoneLab;
    CHTextField *passFiled;
    CHButton *loginBut;
}
@end

@implementation CHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeMethod];
    [self createUI];
    //设置本地区号
    [self setTheLocalAreaCode];
}

- (void)initializeMethod{
    [CHNotifictionCenter addObserver:self selector:@selector(KeyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [CHNotifictionCenter addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    
}

- (void)viewDidDisappear:(BOOL)animated{
    //    [self.view endEditing:YES];
    //    self.view.transform = CGAffineTransformIdentity;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * headView = [UIImageView new];
    headView.image = [UIImage imageNamed:@"pic_dengluye"];
    [self.view addSubview:headView];
    
    UIImageView *logoIma = [UIImageView new];
    [logoIma setImage:[UIImage imageNamed:@"icon_quyu"]];
    [self.view addSubview:logoIma];
    
    countryLab = [UILabel new];
    [countryLab setText:CHLocalizedString(@"中国大陆", nil)];
    countryLab.font = CHFontNormal(nil, 16);
    [countryLab setTextColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0)];
    [self.view addSubview:countryLab];
    
    UIImageView *indexIma = [UIImageView new];
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
    
    if (_operationStype == 1) {
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
        if (_operationStype == 0) offset = 4.0f;
        if (_operationStype == 1) offset = -39.0f;
        
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
    if (_operationStype == 0) accountStr = CHLocalizedString(@"请输入手机号", nil);
    if (_operationStype == 1) accountStr = CHLocalizedString(@"请输入邮箱", nil);
    
    phoneLab = [CHTextField createWithPlace:accountStr text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor,1.0) font:CHFontNormal(nil,16)];
    
    if (_operationStype == 0) phoneLab.keyboardType = UIKeyboardTypeNumberPad;
    if (_operationStype == 1) phoneLab.keyboardType = UIKeyboardTypeEmailAddress;
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
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
    NSArray *imageArr = @[@[@"btu_facebook_n",@"btu_facebook_h"],@[@"btu_twitter_n",@"btu_twitter_h"]];
    if ([preferredLang isEqualToString:@"zh"]) {
        imageArr = @[@[@"btu_weixin_n",@"btu_weixin_h"],@[@"btu_qq_n",@"btu_qq_h"],@[@"btu_weibo_n",@"btu_weibo_h"]];
    }
    
    for (int i = 0; i < imageArr.count; i ++) {
        CHButton *but = [CHButton createWithNorImage:[UIImage imageNamed:[[imageArr objectAtIndex:i] objectAtIndex:0]] lightIma:[UIImage imageNamed:[[imageArr objectAtIndex:i] objectAtIndex:1]] touchBlock:^(CHButton *sender) {
            NSLog(@"第三方登录： %ld",(long)sender.tag);
        }];
        but.tag = 101 + i;
        [self.view addSubview:but];
        [but mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-2);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(-CHMainScreen.size.width/3 + CHMainScreen.size.width/3 * i );
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
        }];
    }
    
    CHLabel *thirdLab = [CHLabel createWithTit:CHLocalizedString(@"社交账号登录", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:NSTextAlignmentCenter];
    thirdLab.numberOfLines = 0;
    [self.view addSubview:thirdLab];
    [thirdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-50);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_lessThanOrEqualTo([NSNumber numberWithFloat:CHMainScreen.size.width/2.4]);
    }];
    
    UIImageView *thirdIma0 = [UIImageView itemWithImage:[UIImage imageNamed:@"View_shejiaoyuansu_zuo"] backColor:nil];
    [self.view addSubview:thirdIma0];
    [thirdIma0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(thirdLab.mas_centerY);
        make.right.mas_equalTo(thirdLab.mas_left).mas_offset(-10);
        make.left.mas_equalTo(4);
        make.height.mas_equalTo(2);
    }];
    
    UIImageView *thirdIma1 = [UIImageView itemWithImage:[UIImage imageNamed:@"View_shejiaoyuansu_you"] backColor:nil];
    [self.view addSubview:thirdIma1];
    [thirdIma1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(thirdLab.mas_centerY);
        make.right.mas_equalTo(-4);
        make.left.mas_equalTo(thirdLab.mas_right).mas_offset(10);
        make.height.mas_equalTo(2);
    }];
    
    NSArray *chLogin = @[_operationStype ? CHLocalizedString(@"手机登录", nil):CHLocalizedString(@"邮箱登录", nil),CHLocalizedString(@"找回密码", nil)];
    for (int j = 0; j < chLogin.count; j ++) {
        CHButton *but = [CHButton createAttributedString:chLogin[j] attributedDic:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSUnderlineColorAttributeName:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0),NSForegroundColorAttributeName:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0),NSFontAttributeName:CHFontNormal(nil, 14)} touchBlock:^(CHButton *sender) {
            NSLog(@"登录： %ld",(long)sender.tag);
            if (sender.tag == 111 && _operationStype == 0) {
                [self.view endEditing:YES];
                CHLoginViewController *meilVC = [[CHLoginViewController alloc] init];
                meilVC.operationStype = 1;
                [self.navigationController pushViewController:meilVC animated:YES];
            }
            if (sender.tag == 111 && _operationStype == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            if (sender.tag == 112) {
                self.navigationController.backImage = [UIImage imageNamed:@"btu_fanhui_w"];
                CHRegisViewController *findPass = [[CHRegisViewController alloc] init];
                findPass.operationStype = _operationStype ? 3:2;
                findPass.title = CHLocalizedString(@"找回密码", nil);
                [self.navigationController pushViewController:findPass animated:YES];
            }
        }];
        [self.view addSubview:but];
        but.titleLabel.numberOfLines = 0;
        but.titleLabel.textAlignment = NSTextAlignmentCenter;
        but.tag = 111 + j;
        [but mas_makeConstraints:^(MASConstraintMaker *make) {
            NSLog(@"%f CHMainScreen.size.width/3 + -CHMainScreen.size.width/3 * i  %f",-CHMainScreen.size.width/4,-CHMainScreen.size.width/2 + CHMainScreen.size.width/2 * j);
            make.bottom.mas_equalTo(thirdLab.mas_top).mas_offset(-20);
            make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(-CHMainScreen.size.width/4 + CHMainScreen.size.width/2 * j );
            make.width.mas_lessThanOrEqualTo(CHMainScreen.size.width/2.6);
        }];
        
        if (j == 1) {
            loginBut = [CHButton createWithTit:CHLocalizedString(@"登录", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
                [self.view endEditing:YES];
                NSMutableDictionary *requestDic = [[CHAFNWorking shareAFNworking] requestDic];
                [CHAFNWorking shareAFNworking].moreRequest = YES;
                [requestDic addEntriesFromDictionary:@{@"Name":phoneLab.text, @"Pass":passFiled.text,@"LoginType":@"0"}];
                [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_Login parameters:requestDic Mess:CHLocalizedString(@"正在登录...", nil) showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                    
                    if ([[result objectForKey:@"State"] intValue] == 1000) {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:CHLocalizedString(@"账号或密码不正确", nil)];
                    }
                    if ([[result objectForKey:@"State"] intValue] == 0) {
                        CHUserInfo *user = [[CHUserInfo alloc] init];
                        user.userId = [TypeConversionMode strongChangeString:[[result objectForKey:@"Item"] objectForKey:@"UserId"]];
                        user.userNa = [TypeConversionMode strongChangeString:[[result objectForKey:@"Item"] objectForKey:@"Username"]];
                        user.userPh = [TypeConversionMode strongChangeString:[[result objectForKey:@"Item"] objectForKey:@"LoginName"]];
                        user.userPs = passFiled.text;
                        user.userTo = [TypeConversionMode strongChangeString:[result objectForKey:@"AccessToken"]];
                        [[SDImageCache sharedImageCache] removeImageForKey:[TypeConversionMode strongChangeString:[[result objectForKey:@"Item"] objectForKey:@"Avatar"]] withCompletion:^{
                            
                            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[TypeConversionMode strongChangeString:[[result objectForKey:@"Item"] objectForKey:@"Avatar"]]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                
                            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                NSLog(@"%ld SDIMAGEDONE*** %@",(long)cacheType,image);//pho_touxiang
                                if (!image) {
                                    image = [UIImage imageNamed:@"pho_usetouxiang"];
                                }
                                user.userIm = [UIImageJPEGRepresentation(image, 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                                
                                NSMutableDictionary *deviceDic = [CHAFNWorking shareAFNworking].requestDic;
                                [deviceDic addEntriesFromDictionary:@{@"UserId": [TypeConversionMode strongChangeString:user.userId],
                                                                      @"GroupId": @"",
                                                                      @"MapType": @"",
                                                                      @"LastTime": [NSDate date].description,
                                                                      @"TimeOffset": [NSNumber numberWithInteger:[[NSTimeZone systemTimeZone] secondsFromGMT]/3600],
                                                                      @"Token": [TypeConversionMode strongChangeString:user.userTo]}];
                                [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_PersonDeviceList parameters:deviceDic Mess:nil showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
                                    
                                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                                    [MBProgressHUD hideHUD];
                                    [CHAFNWorking shareAFNworking].moreRequest = NO;
                                    if ([[result objectForKey:@"State"] intValue] == 0) {
                                        [CHDefaultionfos CHputKey:CHAPPTOKEN andValue:user.userTo];
                                    }
                                    if ([[result objectForKey:@"Items"] count] > 0) {
                                        [[FMDBConversionMode sharedCoreBlueTool] deleteAllDevice:user];
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
                                            userList.deviceIMEI = [TypeConversionMode strongChangeString:itemDit[@"SerialNumber"]];
                                            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[TypeConversionMode strongChangeString:itemDit[@"Avatar"]]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                                
                                            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                if (image) {
                                                    userList.deviceIm = [UIImageJPEGRepresentation(image, 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                                                }
                                                [[FMDBConversionMode sharedCoreBlueTool] insertDevice:userList];
                                                if (i == 0) {
                                                    [MBProgressHUD hideHUD];
                                                    [CHAccountTool saveUser:userList];
//                                                    CHKLTViewController *nav = [[CHKLTViewController alloc] initWithRootViewController:[[MainViewController alloc] init]];
//                                                    CHLeftViewController *leftVC = [[CHLeftViewController alloc] init];
//                                                    XLSlideMenu *slideMenu = [[XLSlideMenu alloc] initWithRootViewController:nav];
//                                                    slideMenu.leftViewController = leftVC;
                                                    
                                                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                                    
                                                    CHKLTViewController *nav = [[CHKLTViewController alloc] initWithRootViewController:[[MainViewController alloc] init]];
                                                    CHLeftViewController *leftVC = [[CHLeftViewController alloc] init];
                                                    app.leftSliderViewController = [[LeftSliderViewController alloc] initWithLeftView:leftVC andMainView:nav];
                                                    
                                                    [UIApplication sharedApplication].keyWindow.rootViewController = app.leftSliderViewController;
                                                   
                                                }
                                            }];
                                        }
                                    }
                                    else{
                                        [MBProgressHUD hideHUD];
                                        [CHAccountTool saveUser:user];
//                                        CHKLTViewController *nav = [[CHKLTViewController alloc] initWithRootViewController:[[MainViewController alloc] init]];
//                                        CHLeftViewController *leftVC = [[CHLeftViewController alloc] init];
//                                        XLSlideMenu *slideMenu = [[XLSlideMenu alloc] initWithRootViewController:nav];
//                                        slideMenu.leftViewController = leftVC;
//                                        [UIApplication sharedApplication].keyWindow.rootViewController = slideMenu;
                                        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                        
                                        CHKLTViewController *nav = [[CHKLTViewController alloc] initWithRootViewController:[[MainViewController alloc] init]];
                                        CHLeftViewController *leftVC = [[CHLeftViewController alloc] init];
                                        app.leftSliderViewController = [[LeftSliderViewController alloc] initWithLeftView:leftVC andMainView:nav];
                                        
                                        [UIApplication sharedApplication].keyWindow.rootViewController = app.leftSliderViewController;
                                    }
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                                    
                                }];
                            }];
                            
                        }];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                    
                }];
            }];
            loginBut.enabled = NO;
            [self.view addSubview:loginBut];
            
            [loginBut mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(but.mas_top).mas_equalTo(-16);
                make.left.mas_equalTo(self.view).mas_offset(30);
                make.right.mas_equalTo(self.view).mas_offset(-30);
                make.height.mas_equalTo(40);
            }];
        }
    }
    
    
}

- (void)setTheLocalAreaCode{
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
    CGFloat transY = KeyboardY * 1.36 - self.view.frame.size.height;
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

#pragma mark - SecondViewControllerDelegate的方法
- (void)setSecondData:(NSString *)code
{
    NSLog(@"the area data：%@,", code);
    codeLab.text = [NSString stringWithFormat:@"+%@",[[code componentsSeparatedByString:@","] lastObject]];
    countryLab.text = [[code componentsSeparatedByString:@","] firstObject];
}

static bool accInt;
static bool passInt;
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
    }
    if (passInt && accInt) {
        loginBut.enabled = YES;
    }
    else{
        loginBut.enabled = NO;
    }
    return YES;
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
