//
//  MainViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/24.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<LeftSliderDelegate>
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) NSMutableArray *deviceLists;
@property (nonatomic, assign) CLLocationCoordinate2D deviceCoor;
@property (nonatomic, strong) AppDelegate *app;
@property (nonatomic, strong) CHAFNWorking *afnRequest;
@property (nonatomic, strong) NSTimer *searchTimer;
@property (nonatomic, strong) CHButton *leftBut;
//@property (nonatomic, strong) UIImageView *leftIma;
@property (nonatomic, assign)  BOOL foundDevice;;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //接收抽屉点击事件的HomePage0Push通知
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(pushViewControllerFromLeftView:) name:@"HomePagePush" object:nil];
   
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:YES animated: YES];
     [self initializeMethod];
}

- (void)viewDidAppear:(BOOL)animated{
    [self setPanIsOpen:YES];
}

- (NSMutableArray *)deviceLists{
    if (!_deviceLists) {
        _deviceLists = [NSMutableArray array];
    }
    return _deviceLists;
}

- (void)initializeMethod{
//    self.deviceLists = [[FMDBConversionMode sharedCoreBlueTool] searchDevice:self.user];
    self.afnRequest = [CHAFNWorking shareAFNworking];
    //    self.deviceLists = [[FMDBConversionMode sharedCoreBlueTool] searchDevice:self.user];
    self.app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.app.leftSliderViewController.leftDelegate = self;
    [self updateDeviceListWithRequestTimes:1];
    
//    [self clearDevice];
//    [self updateUI];
}

//static int request;
- (void)requestUserDeviceList{
    NSMutableDictionary *comDic = _afnRequest.requestDic;
    [comDic addEntriesFromDictionary:@{@"DeviceId": self.user.deviceId,
                                       @"DeviceModel": self.user.deviceMo,
                                       @"CmdCode": LOCATION_REAL_TIME,
                                       @"Params": @"",
                                       @"UserId": self.user.userId}];
    _afnRequest.moreRequest = YES;
    @WeakObj(self)
    [_afnRequest CHAFNPostRequestUrl:REQUESTURL_SendCommand parameters:comDic Mess:CHLocalizedString(@"正在加载中，请稍后", nil) showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        @StrongObj(self)
        if ([[result objectForKey:@"State"] intValue] == 0) {
            //            [self updateDeviceListWithRequestTimes:30];
            //            request = 3;
            if (self.searchTimer) {
                [self.searchTimer invalidate];
                self.searchTimer = nil;
            }
            self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDeviceListWithRequestTimes:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.searchTimer forMode:NSRunLoopCommonModes];
        }
        else{
            self.afnRequest.moreRequest = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (void)updateDeviceListWithRequestTimes:(int)time{
    
    NSMutableDictionary *dic = _afnRequest.requestDic;
    [dic addEntriesFromDictionary:@{@"UserId": [TypeConversionMode strongChangeString:self.user.userId],
                                    @"GroupId": @"",
                                    @"MapType": @"",
                                    @"LastTime": [NSDate date].description,
                                    @"TimeOffset": [NSNumber numberWithInteger:[[NSTimeZone systemTimeZone] secondsFromGMT]/3600]}];
    @WeakObj(self)
    [_afnRequest CHAFNPostRequestUrl:REQUESTURL_PersonDeviceList parameters:dic Mess:nil showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        @StrongObj(self)
        [[FMDBConversionMode sharedCoreBlueTool] deleteAllDevice:self.user];
        self.foundDevice = NO;
        if ([[result objectForKey:@"Items"] count] == 0) {
            [self clearDevice];
            [self updateUI];
        }
        [self.deviceLists removeAllObjects];
        for (int i = 0; i < [[result objectForKey:@"Items"] count]; i ++) {
            NSDictionary *itemDit = [[result objectForKey:@"Items"] objectAtIndex:i];
            CHUserInfo *userList = [[CHUserInfo alloc] init];
            
            if (!self.foundDevice && i == ([[result objectForKey:@"Items"] count] - 1)) {
                NSDictionary *itemDit0 = [[result objectForKey:@"Items"] objectAtIndex:0];
                self.user.deviceId = [TypeConversionMode strongChangeString:itemDit0[@"Id"]];
                self.user.devicePh = [TypeConversionMode strongChangeString:itemDit0[@"Sim"]];
                self.user.deviceNa = [TypeConversionMode strongChangeString:itemDit0[@"NickName"]];
                self.user.deviceBa = [TypeConversionMode strongChangeString:itemDit0[@"Battery"]];
                self.user.deviceMo = [TypeConversionMode strongChangeString:itemDit0[@"Model"]];
                self.user.deviceIMEI = [TypeConversionMode strongChangeString:itemDit0[@"SerialNumber"]];
                self.user.deviceCoor = CLLocationCoordinate2DMake([itemDit0[@"Latitude"] floatValue], [itemDit0[@"Longitude"] floatValue]);
            }
            
            if ([self.user.deviceId isEqualToString:[TypeConversionMode strongChangeString:itemDit[@"Id"]]]) {
                userList = self.user;
                NSLog(@"CLLocationCoordinate2DIsValid(_deviceCoor)  %d",CLLocationCoordinate2DIsValid(_deviceCoor));
                self.deviceCoor = CLLocationCoordinate2DMake([itemDit[@"Latitude"] floatValue], [itemDit[@"Longitude"] floatValue]);
                self.foundDevice = YES;
            }
            
            userList.userId = self.user.userId;
            userList.deviceId = [TypeConversionMode strongChangeString:itemDit[@"Id"]];
            userList.devicePh = [TypeConversionMode strongChangeString:itemDit[@"Sim"]];
            userList.deviceNa = [TypeConversionMode strongChangeString:itemDit[@"NickName"]];
            userList.deviceMo = [TypeConversionMode strongChangeString:itemDit[@"Model"]];
            userList.deviceBa = [TypeConversionMode strongChangeString:itemDit[@"Battery"]];
            userList.deviceIMEI = [TypeConversionMode strongChangeString:itemDit[@"SerialNumber"]];
            userList.deviceCoor = CLLocationCoordinate2DMake([itemDit[@"Latitude"] floatValue], [itemDit[@"Longitude"] floatValue]);
            
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[TypeConversionMode strongChangeString:itemDit[@"Avatar"]]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (!image) {
                    image = [UIImage imageNamed:@"pho_touxiang"];
                }
                userList.deviceIm = [UIImageJPEGRepresentation(image, 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                [[FMDBConversionMode sharedCoreBlueTool] insertDevice:userList];
                if ([self.user.deviceId isEqualToString:[TypeConversionMode strongChangeString:itemDit[@"Id"]]]) {
                    [CHAccountTool saveUser:userList];
                    [self.deviceLists insertObject:userList atIndex:0];
                }
                else{
                    [self.deviceLists addObject:userList];
                }
                if (self.foundDevice) {
                    if (self.deviceLists.count > 0) {
                        for (CHUserInfo *user in self.deviceLists) {
                            [self getRegoCoding:user];
                        }
                    }
                    else{
                        [MBProgressHUD hideHUD];
                    }
                }
            }];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
//        [self clearDevice];
//        [self updateUI];
        if (error.code != 999) {
            //            request = 0;
            //            for (NSURLSessionDataTask *tasks in self.afnRequest.sessionMgr.tasks) {
            //                if (tasks != task) {
            //                    [tasks cancel];
            //                }
            //            }
        }
    }];
    //    request --;
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self updateDeviceListWithRequestTimes:request];
    //    });
}

- (void)getRegoCoding:(CHUserInfo *)user{
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SMALocatiuonManager sharedCoreBlueTool] regeoCoding:user.deviceCoor callBack:^(CHGeoCodingMode *geo) {
            if (geo) {
                user.GeoCoding = geo;
            }
            if (user == [selfWeak.deviceLists lastObject]) {
                [MBProgressHUD hideHUD];
                [selfWeak updateUI];
            }
        }];
    });
}

//右滑打开抽屉手势
-(void)setPanIsOpen:(BOOL)isOpen{
    AppDelegate * appDelagate = (AppDelegate *)[UIApplication sharedApplication].delegate ;
    [appDelagate.leftSliderViewController setPanEnabled:isOpen];
    [((CHKLTViewController *)self.navigationController).panGestureRec setEnabled:isOpen];
}

//当主页消失的时候关闭手势
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setPanIsOpen:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (CHUserInfo *)user{
    if (!_user) {
        _user = [CHAccountTool user];
    }
    return _user;
}

- (void)createUI{
     [self clearDevice];
    @WeakObj(self)
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backImage = [UIImageView itemWithImage:[UIImage imageNamed:@"bk_shouyebeijing"] backColor:nil];
    backImage.userInteractionEnabled = YES;
    [self.view addSubview:backImage];
    UIImage *deviceIma = [UIImage imageNamed:@"pho_morentouxiang"];
    NSLog(@"[CHAccountTool user].userId %@",[CHAccountTool user].userId);
    
    if (self.user.deviceId) {
        if (self.user.deviceIm && ![[self.user deviceIm] isEqualToString:@""]) {
            NSData *imaData = [[NSData alloc] initWithBase64EncodedString:self.user.deviceIm options:NSDataBase64DecodingIgnoreUnknownCharacters];
            deviceIma = [UIImage imageWithData:imaData];
            if (!deviceIma) {
                deviceIma = [UIImage imageNamed:@"pho_touxiang"];
            }
        }
    }
    
    self.leftBut = [CHButton createWithImage:deviceIma Radius:25 touchBlock:^(CHButton *sender) {
        [selfWeak.app.leftSliderViewController openLeftView];
        
    }];
    //    leftBut.backgroundColor = [UIColor greenColor];
    [backImage addSubview:self.leftBut];
    
    UIImageView *leftIma = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cebian"]];
    [backImage addSubview:leftIma];
    
    CHButton *rightBut = [CHButton createWithNorImage:[UIImage imageNamed:@"icon_caidan_n"] lightIma:[UIImage imageNamed:@"icon_caidan_h"] touchBlock:^(CHButton *sender) {
        
    }];
    [backImage addSubview:rightBut];
    
    CHButton *phoneBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_dianhua"] Radius:0 touchBlock:^(CHButton *sender) {
        @StrongObj(self)
        CHPhoneCellView *cellView = [[CHPhoneCellView alloc] initWithDevices:self.deviceLists callBackBlock:^(CHUserInfo *device) {
            NSLog(@"device %@",device.devicePh);
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",device.devicePh]];
            [[UIApplication sharedApplication] openURL:url];
        }];
        
        [self.app.window addSubview:cellView];
        
    }];
    [backImage addSubview:phoneBut];
    
    CHLabel *phoneLab = [CHLabel createWithTit:CHLocalizedString(@"电话", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(0x010101, 1.0) backColor:nil textAlignment:0];
    [backImage addSubview:phoneLab];
    
    
    CHButton *locaBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_dinwei"] Radius:0 touchBlock:^(CHButton *sender) {
        //        UINavigationController *nav = (UINavigationController *)self.xl_sldeMenu.rootViewController;
        //                [nav pushViewController:newVc animated:false];
        //关闭抽屉
        @StrongObj(self)
        AppDelegate * appDelegate  =(AppDelegate *) [UIApplication sharedApplication].delegate;
        [appDelegate.leftSliderViewController closeLeftView];
        NSLog(@"appDelegate.leftSliderViewController %@",appDelegate.leftSliderViewController);
        self.navigationController.backImage = [UIImage imageNamed:@"btu_fanhui_w"];
        
        [self.navigationController pushViewController:[[CHLocaViewController alloc] init] animated:YES];
    }];
    [backImage addSubview:locaBut];
    
    CHLabel *locaLab = [CHLabel createWithTit:CHLocalizedString(@"定位", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(0x010101, 1.0) backColor:nil textAlignment:0];
    [backImage addSubview:locaLab];
    
    CHButton *chatBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_weiliao"] Radius:0 touchBlock:^(CHButton *sender) {
        
    }];
    [backImage addSubview:chatBut];
    
    CHLabel *chatLab = [CHLabel createWithTit:CHLocalizedString(@"微聊", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(0x010101, 1.0) backColor:nil textAlignment:0];
    [backImage addSubview:chatLab];
    
    [backImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.leftBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(28);
        make.left.mas_equalTo(18);
        //        make.center.mas_equalTo(backImage);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    [leftIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftBut.mas_right).mas_offset(4);
        make.centerY.mas_equalTo(self.leftBut.mas_centerY);
        make.width.mas_equalTo(3.5);
        make.height.mas_equalTo(17);
    }];
    
    [rightBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.leftBut.mas_centerY);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    [phoneBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rightBut.mas_bottom).mas_offset(36);
        make.centerX.mas_equalTo(backImage);
        make.width.mas_equalTo(107);
        make.height.mas_equalTo(115);
    }];
    
    [phoneBut sizeToFit];
    [phoneLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(phoneBut.mas_top).mas_offset(-1);
        make.centerX.mas_equalTo(phoneBut.mas_centerX).mas_offset(-phoneBut.frame.size.width/5);
    }];
    
    [locaBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneBut.mas_bottom).mas_offset(-1);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(107);
        make.height.mas_equalTo(115);
    }];
    
    [locaBut sizeToFit];
    [locaLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(locaBut.mas_top).mas_offset(-1);
        make.centerX.mas_equalTo(locaBut.mas_centerX).mas_offset(locaLab.frame.size.width/5);
        make.width.mas_lessThanOrEqualTo(locaBut.frame.size.width);
    }];
    
    [chatBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneBut.mas_bottom).mas_offset(-1);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(107);
        make.height.mas_equalTo(115);
    }];
    
    [chatBut sizeToFit];
    [chatLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(chatBut.mas_top).mas_offset(-1);
        make.centerX.mas_equalTo(chatBut.mas_centerX).mas_offset(chatBut.frame.size.width/5);
        make.width.mas_lessThanOrEqualTo(chatBut.frame.size.width);
    }];
}

- (void)requestDivice{
    if (!self.user.deviceId || [self.user.deviceId isEqualToString:@""]) {
         [CHNotifictionCenter postNotificationName:@"UPDATELEFTVC" object:nil userInfo:@{@"DEVICELIST":self.deviceLists,@"USER":self.user}];
        return;
    }
    @WeakObj(self)
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"UserId": self.user.userId,
                                    @"DeviceId": self.user.deviceId,
                                    @"TimeOffset": [NSNumber numberWithInteger:[[NSTimeZone systemTimeZone] secondsFromGMT]/3600],
                                    @"MapType": @""}];
    
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_PersonTracking parameters:dic Mess:nil showError:NO progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        @StrongObj(self)
        NSDictionary *itemDit = [[result objectForKey:@"Items"] objectAtIndex:0];
        self.user.deviceMo = [TypeConversionMode strongChangeString:itemDit[@"Model"]];
        self.user.deviceId = [TypeConversionMode strongChangeString:itemDit[@"Id"]];
        self.user.devicePh = [TypeConversionMode strongChangeString:itemDit[@"Sim"]];
        self.user.deviceNa = [TypeConversionMode strongChangeString:itemDit[@"NickName"]];
        self.user.deviceBa = [TypeConversionMode strongChangeString:itemDit[@"Battery"]];
        self.user.deviceMo = [TypeConversionMode strongChangeString:itemDit[@"Model"]];
        self.user.deviceIMEI = [TypeConversionMode strongChangeString:itemDit[@"SerialNumber"]];
        self.user.deviceCoor = CLLocationCoordinate2DMake([itemDit[@"Latitude"] floatValue], [itemDit[@"Longitude"] floatValue]);
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[TypeConversionMode strongChangeString:itemDit[@"Avatar"]]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (!image) {
                image = [UIImage imageNamed:@"pho_touxiang"];
            }
            self.user.deviceIm = [UIImageJPEGRepresentation(image, 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [[FMDBConversionMode sharedCoreBlueTool] updateDevice:self.user];
            [CHAccountTool saveUser:self.user];
            [self updateUI];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
    }];
}

- (void)updateUI{
    UIImage *deviceIma = [UIImage imageNamed:@"pho_morentouxiang"];
    NSLog(@"[CHAccountTool user].userId %@",[CHAccountTool user].userId);
    if (self.user.deviceId) {
        if (self.user.deviceIm && ![[self.user deviceIm] isEqualToString:@""]) {
            NSData *imaData = [[NSData alloc] initWithBase64EncodedString:self.user.deviceIm options:NSDataBase64DecodingIgnoreUnknownCharacters];
            deviceIma = [UIImage imageWithData:imaData];
            if (!deviceIma) {
                deviceIma = [UIImage imageNamed:@"pho_touxiang"];
            }
        }
    }
    [self.leftBut setBackgroundImage:deviceIma forState:UIControlStateNormal];
    [CHNotifictionCenter postNotificationName:@"UPDATELEFTVC" object:nil userInfo:@{@"DEVICELIST":self.deviceLists,@"USER":self.user}];
}

- (void)clearDevice{
    CHUserInfo *device = [[CHUserInfo alloc] init];
    device.userId = self.user.userId;
    device.userPh = self.user.userPh;
    device.userPs = self.user.userPs;
    device.userNa = self.user.userNa;
    device.userIm = self.user.userIm;
    device.userTo = self.user.userTo;
    self.user = device;
    [CHAccountTool saveUser:self.user];
}

- (void)leftViewWillDisApplear{
    NSLog(@"leftViewWillDisApplear");
     [self updateDeviceListWithRequestTimes:1];
}

- (void)leftViewWillApplear{
     if (!self.user.deviceId || [self.user.deviceId isEqualToString:@""]) {
         [self updateDeviceListWithRequestTimes:1];
     }else{
      [self requestDivice];
     }
//   [CHNotifictionCenter postNotificationName:@"UPDATELEFTVC" object:nil userInfo:@{@"DEVICELIST":self.deviceLists,@"USER":self.user}];
     NSLog(@"leftViewWillApplear");
}

#pragma mark -- 抽屉界面转跳
-(void)pushViewControllerFromLeftView:(NSNotification *) notification{
    NSLog(@"******************pushViewControllerFromLeftView");
    NSDictionary * dict  = notification.userInfo;
    UIViewController * pushViewController = [dict objectForKey:@"pushViewController"];
    self.hidesBottomBarWhenPushed = YES;
    
    //关闭抽屉
    AppDelegate * appDelegate  =(AppDelegate *) [UIApplication sharedApplication].delegate;
    [appDelegate.leftSliderViewController closeLeftView];
    if ([pushViewController isKindOfClass:[CHJBWViewController class]]) {
        ((CHJBWViewController *)pushViewController).user = self.user;
    }
    [self.navigationController pushViewController:pushViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HomePagePush" object:nil];
}

-(void)dealloc{
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
