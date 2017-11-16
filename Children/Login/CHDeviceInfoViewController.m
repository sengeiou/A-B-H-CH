//
//  CHDeviceInfoViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHDeviceInfoViewController.h"

@interface CHDeviceInfoViewController ()
{
    NSArray *titArr;
    CHButton *gailBut;
    CHButton *mainBut;
    UIImagePickerController *picker;
    NSDateFormatter *formatter;
}
@property (nonatomic, strong) NSMutableArray *heightArrs;
@property (nonatomic, strong) NSMutableArray *widthArrs;
@property (nonatomic, strong) NSMutableDictionary *userInfoDic;
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) CHButton *headBut;
@end

@implementation CHDeviceInfoViewController
@synthesize user,tabView,headBut;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *)userInfoDic{
    if (!_userInfoDic) {
        _userInfoDic = [NSMutableDictionary dictionary];
    }
    return _userInfoDic;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}

- (void)requestUserInfo{
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"UserId":self.user.userId}];
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_UserInfo parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        selfWeak.userInfoDic = [result[@"UserInfo"] mutableCopy];
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[TypeConversionMode strongChangeString:selfWeak.userInfoDic[@"Avatar"]]]  options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (!image) {
                image = [UIImage imageNamed:@"pho_usetouxiang"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [headBut setImage:[UIImage mergeMainIma:image subIma:[UIImage imageNamed:@"icon_xiangji"] callBackSize:CGSizeMake((CHMainScreen.size.width * WIDTHAdaptive)/3.5, (CHMainScreen.size.width * WIDTHAdaptive)/3.5)] forState:UIControlStateNormal];
            });
        }];
        [selfWeak.tabView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (void)initializeMethod{
    if (_setUser) {
        titArr = @[CHLocalizedString(@"device_account", nil),CHLocalizedString(@"deviee_nick", nil),CHLocalizedString(@"device_guar_phone", nil),CHLocalizedString(@"device_email", nil)];
        [self requestUserInfo];
        return;
    }
    titArr = @[CHLocalizedString(@"deviee_nick", nil),CHLocalizedString(@"device_birthday", nil),CHLocalizedString(@"device_heigh", nil),CHLocalizedString(@"device_weith", nil),CHLocalizedString(@"device_guar_phone", nil),CHLocalizedString(@"IMEI", nil)];
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *norDate = [NSDate dateWithYear:[[NSDate date] getYear] - 6 month:6 day:1];
    if (!user.deviceHe) {
        user.deviceHe = @"115";
    }
    if (!user.deviceNa) {
        user.deviceNa = CHLocalizedString(@"chat_baby",nil);
    }
    if (!user.deviceWi) {
        user.deviceWi = @"20";
    }
    if (!user.deviceGe) {
        user.deviceGe = @"1";
    }
    if (!user.deviceBi) {
        user.deviceBi = [formatter stringFromDate:norDate];
    }
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headView = [UIView new];
    headView.backgroundColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    [self.view addSubview:headView];
    __block UIImagePickerControllerSourceType sourceType ;
    
    UIImage *headIma = [UIImage imageNamed:@"pho_usetouxiang"];
   
    if (!_setUser) {
        NSData *imaData = [[NSData alloc] initWithBase64EncodedString:[TypeConversionMode strongChangeString:self.user.deviceIm] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        headIma = [UIImage imageWithData:imaData];
        if (!headIma) {
            headIma = [UIImage imageNamed:@"pho_usetouxiang"];
        }
    }
//    [headBut setImage:[UIImage mergeMainIma:deviceIma subIma:[UIImage imageNamed:@"icon_xiangji"] callBackSize:CGSizeMake((CHMainScreen.size.width * WIDTHAdaptive)/3.5, (CHMainScreen.size.width * WIDTHAdaptive)/3.5)] forState:UIControlStateNormal];
    headBut = [CHButton createWithImage:[UIImage mergeMainIma:headIma subIma:[UIImage imageNamed:@"icon_xiangji"] callBackSize:CGSizeMake((CHMainScreen.size.width * WIDTHAdaptive)/3.5, (CHMainScreen.size.width * WIDTHAdaptive)/3.5)] Radius:(CHMainScreen.size.width * WIDTHAdaptive)/7 touchBlock:^(CHButton *sender) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        CHPhotoView *photoView = [CHPhotoView initWithNomarSheet];
        [photoView createPhotoUIWithTouchPhoto:^(CHButton *sender) {
            NSLog(@"点击相机");
            sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                if (!picker) {
                    picker = [[UIImagePickerController alloc] init];//初始化
                    picker.delegate = self;
                    picker.allowsEditing = YES;//设置可编辑
                }
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:^{
                    
                }];
            }
            else{
                [MBProgressHUD showError:CHLocalizedString(@"aler_photoErro", nil)];
            }
        } touchAlum:^(CHButton *sender) {
            NSLog(@"点击相册");
            //    @StrongObject(picker)
            //    UIImagePickerController *_pick = (UIImagePickerController *)strongOjb;
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
                if (!picker) {
                    picker = [[UIImagePickerController alloc] init];//初始化
                    picker.delegate = self;
                    picker.view.backgroundColor = [UIColor whiteColor];
                    picker.allowsEditing = YES;//设置可编辑
                }
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:^{
                    
                }];
            }
            else{
                [MBProgressHUD showError:CHLocalizedString(@"aler_albumErro", nil)];
            }
        }];
        [app.window addSubview:photoView];
    }];
    [headView addSubview:headBut];
    
    mainBut = [CHButton createWithTit:CHLocalizedString(@"device_main", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 16) backImaColor:CHUIColorFromRGB(0xb3e5fc, 1.0) Radius:16 touchBlock:^(CHButton *sender) {
        sender.selected = YES;
        user.deviceGe = @"1";
        gailBut.selected = NO;
    }];
    [mainBut setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(0x0288d1, 1.0) size:CHMainScreen.size] forState:UIControlStateSelected];
    [mainBut setImage:[UIImage imageNamed:@"icon_nan"] forState:UIControlStateNormal];
    [mainBut setTitleColor:CHUIColorFromRGB(0xffffff, 1.0) forState:UIControlStateSelected];
    [mainBut setTitleColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) forState:UIControlStateNormal];
    [headView addSubview:mainBut];
    
    gailBut = [CHButton createWithTit:CHLocalizedString(@"device_lady", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 16) backImaColor:CHUIColorFromRGB(0xb3e5fc, 1.0) Radius:16 touchBlock:^(CHButton *sender) {
        sender.selected = YES;
        mainBut.selected = NO;
        user.deviceGe = @"2";
    }];
    [gailBut setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(0xff23cf, 1.0) size:CHMainScreen.size] forState:UIControlStateSelected];
    [gailBut setImage:[UIImage imageNamed:@"icon_nv"] forState:UIControlStateNormal];
    [gailBut setTitleColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) forState:UIControlStateNormal];
    [gailBut setTitleColor:CHUIColorFromRGB(0xffffff, 1.0) forState:UIControlStateSelected];
    if (user.deviceGe.intValue == 2) {
        gailBut.selected = YES;
        mainBut.selected = NO;
    }
    else{
        mainBut.selected = YES;
        gailBut.selected = NO;
    }
    [headView addSubview:gailBut];
    
    if (_setUser) {
        self.title = CHLocalizedString(@"user_userInfo", nil);
        gailBut.hidden = YES;
        mainBut.hidden = YES;
        if (user.userIm && ![[user userIm] isEqualToString:@""]) {
            NSData *imaData = [[NSData alloc] initWithBase64EncodedString:user.userIm options:NSDataBase64DecodingIgnoreUnknownCharacters];
            headIma = [UIImage imageWithData:imaData];
            if (!headIma) {
                headIma = [UIImage imageNamed:@"pho_usetouxiang"];
            }
        }
    }
    else{
        self.title = CHLocalizedString(@"device_bind_data", nil);
        if (user.deviceIm && ![[user deviceIm] isEqualToString:@""]) {
            NSData *imaData = [[NSData alloc] initWithBase64EncodedString:user.deviceIm options:NSDataBase64DecodingIgnoreUnknownCharacters];
            headIma = [UIImage imageWithData:imaData];
            if (!headIma) {
                headIma = [UIImage imageNamed:@"pho_touxiang"];
            }
        }
    }
    
    CHButton *confimBut = [CHButton createWithTit:CHLocalizedString(@"aler_confirm", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 18) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0f touchBlock:^(CHButton *sender) {
        if (_setUser) {
            NSMutableDictionary *saveDic = [CHAFNWorking shareAFNworking].requestDic;
            [saveDic addEntriesFromDictionary:@{@"UserId": [TypeConversionMode strongChangeString:user.userId],
                                                @"Username": [TypeConversionMode strongChangeString:user.userNa],
                                                @"Email": [TypeConversionMode strongChangeString:self.userInfoDic[@"Email"]],
                                                @"Address": @"",
                                                @"Avatar": [TypeConversionMode strongChangeString:user.userIm],
                                                @"CellPhone": [TypeConversionMode strongChangeString:self.userInfoDic[@"CellPhone"]],
                                                @"Sim": @"",
                                                @"Gender": @0,
                                                @"Birthday": @"",
                                                @"Weight": @0,
                                                @"Height": @0,
                                                @"Steps": @0,
                                                @"Distance": @0,
                                                @"SportTime": @0,
                                                @"Calorie": @0}];
            @WeakObj(self)
            [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_EditUserInfo parameters:saveDic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                if ([[result objectForKey:@"State"] intValue] == 0) {
                    [MBProgressHUD showSuccess:CHLocalizedString(@"aler_saveSuss", nil)];
                    [CHAccountTool saveUser:user];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [selfWeak.navigationController popViewControllerAnimated:YES];
                    });
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                
            }];
            return ;
        }
        if (!user.devicePh) {
            [MBProgressHUD showError:CHLocalizedString(@"login_inputPhone", nil)];
            return ;
        }
        
        NSMutableDictionary *saveDic = [CHAFNWorking shareAFNworking].requestDic;
        [saveDic addEntriesFromDictionary:@{@"Item":@{@"Birthday": [TypeConversionMode strongChangeString:user.deviceBi],
                                                      @"DeviceID": [TypeConversionMode strongChangeString:user.deviceId],
                                                      @"Gender": [TypeConversionMode strongChangeString:user.deviceGe],
                                                      @"Grade": @"",
                                                      @"Height": [TypeConversionMode strongChangeString:user.deviceHe],
                                                      @"Nickname": [TypeConversionMode strongChangeString:user.deviceNa],
                                                      @"UpdateTime": @"",
                                                      @"Weight": [TypeConversionMode strongChangeString:user.deviceWi],
                                                      @"Avatar": [TypeConversionMode strongChangeString:user.deviceIm],
                                                      @"UserId": [TypeConversionMode strongChangeString:user.userId],
                                                      @"Sim": [TypeConversionMode strongChangeString:user.devicePh],
                                                      @"Age": @"",
                                                      @"BloodType": @"",
                                                      @"CellPhone": @"",
                                                      @"CellPhone2": @"",
                                                      @"Address": @"",
                                                      @"Breed": @"",
                                                      @"IDnumber": @"",
                                                      @"Remark": @"",
                                                      @"MarkerColor": @""}}];
        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_SavePersonProfile parameters:saveDic Mess:CHLocalizedString(@"", nil) showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
            if ([[result objectForKey:@"State"] intValue] == 0) {
                [MBProgressHUD showSuccess:CHLocalizedString(@"aler_saveSuss", nil)];
                [CHAccountTool saveUser:user];
                [[FMDBConversionMode sharedCoreBlueTool] deleteDevice:user];
                [[FMDBConversionMode sharedCoreBlueTool] insertDevice:user];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    NSArray *superNavs = [self.navigationController childViewControllers];
                    for (UIViewController *nav in superNavs) {
                        if ([nav isKindOfClass:[MainViewController class]]) {
//                            cmdList = [(CHAlarmViewController *)nav commandList];
                            [[NSNotificationCenter defaultCenter]  removeObserver:nav];
                            break;
                        }
                    }
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    CHKLTViewController *nav = [[CHKLTViewController alloc] initWithRootViewController:[[MainViewController alloc] init]];
                    CHLeftViewController *leftVC = [[CHLeftViewController alloc] init];
                    app.leftSliderViewController = [[LeftSliderViewController alloc] initWithLeftView:leftVC andMainView:nav];
                    [UIApplication sharedApplication].keyWindow.rootViewController = app.leftSliderViewController;
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            
        }];
    }];
    [self.view addSubview:confimBut];
    
    tabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    if ([tabView respondsToSelector:@selector(setSeparatorColor:)]) {
        tabView.separatorColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    }
    tabView.dataSource = self;
    tabView.delegate = self;
    tabView.tableFooterView = [UIView new];
    [self.view addSubview:tabView];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(170 * WIDTHAdaptive);
    }];
    
    [headBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.centerX.mas_equalTo(headView);
        make.size.mas_equalTo(CGSizeMake((CHMainScreen.size.width * WIDTHAdaptive)/3.5, (CHMainScreen.size.width * WIDTHAdaptive)/3.5));
    }];
    
    CGRect MainSize = [CHCalculatedMode CHCalculatedWithStr:mainBut.titleLabel.text size:CGSizeMake(CHMainScreen.size.width/2-20, 32) attributes:@{NSFontAttributeName:CHFontBold(nil, 15)}];
    CGRect GailSize = [CHCalculatedMode CHCalculatedWithStr:gailBut.titleLabel.text size:CGSizeMake(CHMainScreen.size.width/2-20, 32) attributes:@{NSFontAttributeName:CHFontBold(nil, 15)}];
    CGFloat offset = MAX(MainSize.size.width, GailSize.size.width) + 70;
    
    [mainBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.centerX.mas_equalTo(headView.mas_centerX).mas_offset(-offset/2 - 20);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(offset);
    }];
    [mainBut layoutButtonWithEdgeInsetsStyle:buttonddgeinsetsstyleleft space:10];
    
    [gailBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.centerX.mas_equalTo(headView.mas_centerX).mas_offset(offset/2 + 20);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(offset);
    }];
    [gailBut layoutButtonWithEdgeInsetsStyle:buttonddgeinsetsstyleleft space:10];
    
    [confimBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20 - HOME_INDICATOR_HEIGHT);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(40);
    }];
    
    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(confimBut.mas_top).mas_offset(-40);
        make.right.mas_equalTo(0);
    }];
}

- (NSMutableArray *)heightArrs{
    if (!_heightArrs) {
        _heightArrs = [NSMutableArray array];
        NSMutableArray *unArr = [NSMutableArray array];
        for (int i = 0; i < 231 ; i ++) {
            [unArr addObject:[NSString stringWithFormat:@"%d",i + 30]];
        }
        for (int i = 0; i < 60; i ++) {
            [_heightArrs addObjectsFromArray:unArr];
        }
    }
    return _heightArrs;
}

- (NSMutableArray *)widthArrs{
    if (!_widthArrs) {
        _widthArrs = [NSMutableArray array];
        NSMutableArray *unArr = [NSMutableArray array];
        for (int i = 0; i < 161 ; i ++) {
            [unArr addObject:[NSString stringWithFormat:@"%d",i + 10]];
        }
        for (int i = 0; i < 60; i ++) {
            [_widthArrs addObjectsFromArray:unArr];
        }
    }
    return _widthArrs;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndex = @"INFOCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndex];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndex];
        cell.textLabel.font = CHFontNormal(nil, 16);
        cell.detailTextLabel.font = CHFontNormal(nil, 16);
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == titArr.count - 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (!_setUser) {
            //            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.textColor = CHUIColorFromRGB(CHMediumBlackColor, 1.0);
        }
    }
    
    if (_setUser) {
        if (indexPath.row == 0) {
            //        cell.detailTextLabel.textColor = CHUIColorFromRGB(CHMediumBlackColor, 1.0);
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            //            view.backgroundColor = [UIColor greenColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = view;
        }
        else{
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.textColor = CHUIColorFromRGB(CHMediumBlackColor, 1.0);
        }
    }
    cell.textLabel.text = [titArr objectAtIndex:indexPath.row];
    if (indexPath.row == 0) cell.detailTextLabel.text = _setUser ? user.userPh : user.deviceNa;
    if (indexPath.row == 1) cell.detailTextLabel.text = _setUser ? user.userNa : user.deviceBi;
    if (indexPath.row == 2) cell.detailTextLabel.text = _setUser ? [TypeConversionMode strongChangeString:self.userInfoDic[@"CellPhone"]] : [NSString stringWithFormat:@"%d%@",user.deviceHe.intValue,CHLocalizedString(@"device_cm", nil)];
    if (indexPath.row == 3) cell.detailTextLabel.text = _setUser ? [TypeConversionMode strongChangeString:self.userInfoDic[@"Email"]] : [NSString stringWithFormat:@"%d%@",user.deviceWi.intValue,CHLocalizedString(@"device_kilo", nil)];
    if (indexPath.row == 4) cell.detailTextLabel.text = user.devicePh ? user.devicePh:CHLocalizedString(@"", nil);
    if (indexPath.row == 5) cell.detailTextLabel.text = user.deviceIMEI ? user.deviceIMEI:CHLocalizedString(@"", nil);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (_setUser) {
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
            NSString *alerTit = CHLocalizedString(@"deviee_nick", nil);
            if (indexPath.row == 2) {
                alerTit = CHLocalizedString(@"device_guar_deleSus", nil);
            }
            if (indexPath.row == 3) {
                alerTit = CHLocalizedString(@"device_email", nil);
            }
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:CHLocalizedString(@"deviee_nick", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
            [aler addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.keyboardType = UIKeyboardTypeDefault;
                if (indexPath.row == 2) {
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                }
                if (indexPath.row == 3) {
                    textField.keyboardType = UIKeyboardTypeEmailAddress;
                }
            }];
            UIAlertAction *conFimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *nickField = (UITextField *)aler.textFields[0];
                
                if (indexPath.row == 1) {
                    user.userNa = nickField.text;
                }
                if (indexPath.row == 2) {
                    [self.userInfoDic setValue:nickField.text forKey:@"CellPhone"];
                }
                if (indexPath.row == 3) {
                    if (![CHCalculatedMode validateEmail:nickField.text]) {
                        [MBProgressHUD showError:CHLocalizedString(@"aler_inputEmail", nil)];
                        return ;
                    }
                    [self.userInfoDic setValue:nickField.text forKey:@"Email"];
                }
                cell.detailTextLabel.text = nickField.text;
            }];
            UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_cnacel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [aler addAction:cancelAct];
            [aler addAction:conFimAct];
            [self presentViewController:aler animated:YES completion:^{
                
            }];
        }
    }else{
        if (indexPath.row == 0 ) {
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:CHLocalizedString(@"deviee_nick", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
            [aler addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                
            }];
            UIAlertAction *conFimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *nickField = (UITextField *)aler.textFields[0];
                user.deviceNa = nickField.text;
                cell.detailTextLabel.text = nickField.text;
            }];
            UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_cnacel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [aler addAction:cancelAct];
            [aler addAction:conFimAct];
            [self presentViewController:aler animated:YES completion:^{
                
            }];
        }
        if (indexPath.row == 1) {
            CHPhotoView *PickView = [CHPhotoView initWithNomarSheet];
            NSDate *date = [formatter dateFromString:user.deviceBi];
            [PickView createBirthdayUIWithOriginDate:date DidSelectConfirm:^(CHButton *sender, NSString *date) {
                user.deviceBi = date;
                cell.detailTextLabel.text = date;
            }];
            [app.window addSubview:PickView];
        }
        if (indexPath.row == 2){
            CHPhotoView *PickView = [CHPhotoView initWithNomarSheet];
            [PickView createPickDatas:@[self.heightArrs,@[CHLocalizedString(@"device_cm", nil)]] OriginIndex:user.deviceHe DidSelectConfirm:^(CHButton *sender, NSString *date) {
                user.deviceHe = date;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",date,CHLocalizedString(@"device_cm", nil)];
            }];
            [app.window addSubview:PickView];
        }
        if (indexPath.row == 3){
            CHPhotoView *PickView = [CHPhotoView initWithNomarSheet];
            [PickView createPickDatas:@[self.widthArrs,@[CHLocalizedString(@"device_kilo", nil)]] OriginIndex:user.deviceWi DidSelectConfirm:^(CHButton *sender, NSString *date) {
                user.deviceWi = date;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",date,CHLocalizedString(@"device_kilo", nil)];
            }];
            [app.window addSubview:PickView];
        }
        if(indexPath.row == 4){
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:CHLocalizedString(@"device_guar_phone", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
            [aler addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            UIAlertAction *conFimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *nickField = (UITextField *)aler.textFields[0];
                user.devicePh = nickField.text;
                cell.detailTextLabel.text = nickField.text;
            }];
            UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_cnacel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [aler addAction:cancelAct];
            [aler addAction:conFimAct];
            [self presentViewController:aler animated:YES completion:^{
                
            }];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    __block UIImage* image;
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",user.deviceId]];
        image = [UIImage image:image fortargetSize:CGSizeMake(200, 200)];
        NSLog(@"rgerh==%lu",UIImageJPEGRepresentation(image, 1).length);
        BOOL result = [UIImageJPEGRepresentation(image, 1) writeToFile: filePath  atomically:YES];
        if(result) {
            NSLog(@"上传成功");
        }else{
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (_setUser) {
            user.userIm = [UIImageJPEGRepresentation(image, 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }else{
            user.deviceIm = [UIImageJPEGRepresentation(image, 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }
        [headBut setImage:[UIImage mergeMainIma:image subIma:[UIImage imageNamed:@"icon_xiangji"] callBackSize:CGSizeMake((CHMainScreen.size.width * WIDTHAdaptive)/3.5, (CHMainScreen.size.width * WIDTHAdaptive)/3.5)] forState:UIControlStateNormal];
    }];
}

- (void)dealloc{
    NSLog(@"dealloc");
     [[NSNotificationCenter defaultCenter] removeObserver:self];
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
