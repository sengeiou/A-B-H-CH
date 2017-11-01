//
//  CHLocaViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/25.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHLocaViewController.h"

@interface CHLocaViewController ()

//@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CHMKMapView *mapView;
@property (nonatomic, strong) CHAFNWorking *afnRequest;

@property (nonatomic, assign) CLLocationCoordinate2D deviceCoor;
@property (nonatomic, strong) NSMutableArray <CHUserInfo *> *devices;
@property (nonatomic, strong) SMALocatiuonManager *locationMar;
@property (nonatomic, strong) CHLocationInfoView *infoView;
@property (nonatomic, strong) NSTimer *searchTimer;
@property (nonatomic, assign)  BOOL foundDevice;
@property (nonatomic, strong) NSString *CellPhone;
//@property (nonatomic, strong) NSString *CellPhone;
@property (nonatomic, strong) CHButton *moniBut;
@property (nonatomic, assign) int geocodeNum;
@end
@implementation CHLocaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.afnRequest.moreRequest = NO;
//    [CHAccountTool saveUser:_oldUser];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 0.0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 0.0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static int request;

- (void)initializeMethod{
//    _oldUser = [CHAccountTool user];
//    _user = [CHAccountTool user];
    _afnRequest = [CHAFNWorking shareAFNworking];
    _devices = [NSMutableArray array];
    _deviceCoor = CLLocationCoordinate2DMake(MAXFLOAT, MAXFLOAT);
    if (_user.deviceCoor.latitude != 0 && _user.deviceCoor.latitude != 0) {
        _deviceCoor = _user.deviceCoor;
    }
    
    _locationMar = [SMALocatiuonManager sharedCoreBlueTool];
    if (!_user.deviceMo || [_user.deviceMo isEqualToString:@""]) {
        return;
    }
    [self requestUserDeviceList];
}

- (void)requestUserInfo{
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"UserId":self.user.userId}];
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_UserInfo parameters:dic Mess:nil showError:NO progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        NSMutableDictionary *userInfoDic = [result[@"UserInfo"] mutableCopy];
        selfWeak.CellPhone = userInfoDic[@"CellPhone"];
        selfWeak.moniBut.hidden = YES;
        BOOL bl = [CHCalculatedMode isPureNumandCharacters:selfWeak.CellPhone];
        if (selfWeak.CellPhone && ![selfWeak.CellPhone isEqualToString:@""]) {
            selfWeak.moniBut.hidden = NO;
        }
//        [selfWeak.tabView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (void)requestUserDeviceList{
    NSMutableDictionary *comDic = _afnRequest.requestDic;
    [comDic addEntriesFromDictionary:@{@"DeviceId": _user.deviceId,
                                       @"DeviceModel": _user.deviceMo,
                                       @"CmdCode": LOCATION_REAL_TIME,
                                       @"Params": @"",
                                       @"UserId": _user.userId}];
    _afnRequest.moreRequest = YES;
    @WeakObj(self)
    [_afnRequest CHAFNPostRequestUrl:REQUESTURL_SendCommand parameters:comDic Mess:CHLocalizedString(@"location_reload", nil) showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        @StrongObj(self)
        if ([[result objectForKey:@"State"] intValue] == 0) {
            //            [self updateDeviceListWithRequestTimes:30];
            request = 30;
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
     [self requestUserInfo];
}

- (void)viewDidAppear:(BOOL)animated{
   [super viewDidAppear:animated];
//   self.mapView.zoomLevel = 15;
}

- (NSString *)removeHTML2:(NSString *)html{
    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    for (int i = 0; i < [components count]; i ++ ) {
        if ([[components objectAtIndex:i] length] > 10) {
            [componentsToKeep addObject:[components objectAtIndex:i]];
        }
    }
    NSString *plainText = [componentsToKeep componentsJoinedByString:@""];
    return plainText;
}

- (void)createUI{
    self.title = CHLocalizedString(@"firstLun_loca", nil);
    self.mapView = [CHMKMapView createMapView];
    self.mapView.showsUserLocation = YES;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.9163854444,116.3971424103) animated:NO];
     @WeakObj(self)
    [self.mapView didSelectMapAnnotationView:^(CHUserInfo *didDevice) {
        @StrongObj(self)
        if (self.user == didDevice) {
            return ;
        }
        self.user = didDevice;
//        [CHAccountTool saveUser:self.user];
        self.infoView.selectDevice = self.user;
        [self.infoView setDevices:self.devices];
        self.infoView.locaLab.text = (self.user.GeoCoding.FormattedAddress && ![self.user.GeoCoding.FormattedAddress isEqualToString:@""]) ? self.user.GeoCoding.FormattedAddress:CHLocalizedString(@"location_none", nil);
    }];
    [self.view addSubview:self.mapView];
   
    _moniBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_jianting"] Radius:0 touchBlock:^(CHButton *sender) {
//    NSLog(@"moniBut  %f  %f",self.mapView.centerCoordinate.latitude,self.mapView.centerCoordinate.latitude);
        [selfWeak setMonitor];
    }];
    _moniBut.hidden = YES;
    [self.view addSubview:_moniBut];

    
    CHButton *addBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_fangda"] Radius:0 touchBlock:^(CHButton *sender) {
        @StrongObj(self)
        self.mapView.zoomLevel = self.mapView.zoomLevel + 1;
    }];
    [self.view addSubview:addBut];

    CHButton *reduBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_suofang"] Radius:0 touchBlock:^(CHButton *sender) {
        @StrongObj(self)
         self.mapView.zoomLevel = self.mapView.zoomLevel - 1;
        NSLog(@"self.mapView.zoomLeve %lu",(unsigned long)self.mapView.zoomLevel);
    }];
    [self.view addSubview:reduBut];

    CHButton *useLocaBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_huidaodinwei"] Radius:0 touchBlock:^(CHButton *sender) {
        @StrongObj(self)
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        NSLog(@"moniBut  %f  %f",self.mapView.userLocation.location.coordinate.latitude,self.mapView.userLocation.location.coordinate.latitude);
    }];
    [self.view addSubview:useLocaBut];
    
    self.infoView = [[CHLocationInfoView alloc] initWithShowView:YES];
    [self.infoView didUpdateLogo:^(CHButton *sender) {
         [selfWeak requestUserDeviceList];
    }];
    [self.view addSubview:self.infoView];
    
    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [_moniBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];

    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(160 * WIDTHAdaptive + HOME_INDICATOR_HEIGHT);
    }];

    [reduBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.infoView.mas_top).mas_offset(-12 - HOME_INDICATOR_HEIGHT);
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];

    [addBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(reduBut.mas_top).mas_offset(1);
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];

    [useLocaBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.infoView.mas_top).mas_offset(-12 - HOME_INDICATOR_HEIGHT);
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    
    UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 30, 40)];
    ima.image = [UIImage drawDeviceImageWithSize:ima.size title:CHLocalizedString(@"chat_baby", nil)];
//    ima.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:ima];
}


- (void)updateDeviceListWithRequestTimes:(int)time{
//    request = time;
    NSLog(@"request %d",request);
    if (request <= 0){
        if (_searchTimer) {
            [_searchTimer invalidate];
            _searchTimer = nil;
        }
        for (NSURLSessionDataTask *task in _afnRequest.sessionMgr.tasks) {
            [task cancel];
        }
        if (_devices.count > 0 && !self.foundDevice && request == 0) {
            self.geocodeNum = 0;
            for (CHUserInfo *user in self.devices) {
                if ([self.user.deviceId isEqualToString:user.deviceId]) {
                    NSInteger inter = [self.devices indexOfObject:user];
                    [self.devices exchangeObjectAtIndex:0 withObjectAtIndex:inter];
                    break;
                }
            }
            for (CHUserInfo *user in _devices) {
                [self getRegoCoding:user];
            }
        }
        else{
            [MBProgressHUD hideHUD];
            self.afnRequest.moreRequest = NO;
        }
        return;
    }
    NSMutableDictionary *dic = _afnRequest.requestDic;
    [dic addEntriesFromDictionary:@{@"UserId": [TypeConversionMode strongChangeString:_user.userId],
                                          @"GroupId": @"",
                                          @"MapType": @"",
                                          @"LastTime": [NSDate date].description,
                                          @"TimeOffset": [NSNumber numberWithInteger:[[NSTimeZone systemTimeZone] secondsFromGMT]/3600]}];
    @WeakObj(self)

    [_afnRequest CHAFNPostRequestUrl:REQUESTURL_PersonDeviceList parameters:dic Mess:nil showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        @StrongObj(self)

        [[FMDBConversionMode sharedCoreBlueTool] deleteAllDevice:_user];
         self.foundDevice = NO;
         BOOL haveUser = NO;
        if ([[result objectForKey:@"Items"] count] > 0) {
            [self.devices removeAllObjects];
        }
        for (int i = 0; i < [[result objectForKey:@"Items"] count]; i ++) {
            NSDictionary *itemDit = [[result objectForKey:@"Items"] objectAtIndex:i];
            CHUserInfo *userList = [[CHUserInfo alloc] init];
            
            if ([self.user.deviceId isEqualToString:[TypeConversionMode strongChangeString:itemDit[@"Id"]]]) {
                userList = self.user;
                haveUser = YES;
                NSLog(@"CLLocationCoordinate2DIsValid(_deviceCoor)  %d",CLLocationCoordinate2DIsValid(_deviceCoor));
                NSLog(@" Latitude  %f  %f",[itemDit[@"Latitude"] floatValue],[itemDit[@"Longitude"] floatValue]);
                if (!CLLocationCoordinate2DIsValid(self.deviceCoor)) {
                    self.deviceCoor = CLLocationCoordinate2DMake([itemDit[@"Latitude"] floatValue], [itemDit[@"Longitude"] floatValue]);
                }
                if (self.deviceCoor.latitude != [itemDit[@"Latitude"] floatValue] || self.deviceCoor.longitude != [itemDit[@"Longitude"] floatValue]){
                    self.deviceCoor = CLLocationCoordinate2DMake([itemDit[@"Latitude"] floatValue], [itemDit[@"Longitude"] floatValue]);
                    self.foundDevice = YES;
                }
                if (self.foundDevice) {
                    request = -1;
                    for (NSURLSessionDataTask *task in self.afnRequest.sessionMgr.tasks) {
                        [task cancel];
                    }
                }
            }

            userList.userId = self.user.userId;
            userList.deviceId = [TypeConversionMode strongChangeString:itemDit[@"Id"]];
            userList.devicePh = [TypeConversionMode strongChangeString:itemDit[@"Sim"]];
            userList.deviceNa = [TypeConversionMode strongChangeString:itemDit[@"NickName"]];
            userList.deviceMo = [TypeConversionMode strongChangeString:itemDit[@"Model"]];
            userList.deviceBa = [TypeConversionMode strongChangeString:itemDit[@"Battery"]];
            userList.deviceIMEI = [TypeConversionMode strongChangeString:itemDit[@"SerialNumber"]];
            userList.deviceCoor = CLLocationCoordinate2DMake([itemDit[@"Latitude"] floatValue], [itemDit[@"Longitude"] floatValue]);
            
            if (!self.foundDevice && i == ([[result objectForKey:@"Items"] count] - 1) && !haveUser) {
                NSDictionary *itemDit0 = [[result objectForKey:@"Items"] objectAtIndex:0];
                self.user.deviceId = [TypeConversionMode strongChangeString:itemDit0[@"Id"]];
                self.user.devicePh = [TypeConversionMode strongChangeString:itemDit0[@"Sim"]];
                self.user.deviceNa = [TypeConversionMode strongChangeString:itemDit0[@"NickName"]];
                self.user.deviceBa = [TypeConversionMode strongChangeString:itemDit0[@"Battery"]];
                self.user.deviceMo = [TypeConversionMode strongChangeString:itemDit0[@"Model"]];
                self.user.deviceIMEI = [TypeConversionMode strongChangeString:itemDit0[@"SerialNumber"]];
                self.user.deviceCoor = CLLocationCoordinate2DMake([itemDit0[@"Latitude"] floatValue], [itemDit0[@"Longitude"] floatValue]);
//                self.oldUser = self.user;
            }
            
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[TypeConversionMode strongChangeString:itemDit[@"Avatar"]]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (!image) {
                    image = [UIImage imageNamed:@"pho_touxiang"];
                }
                userList.deviceIm = [UIImageJPEGRepresentation(image, 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                [[FMDBConversionMode sharedCoreBlueTool] insertDevice:userList];
                 if (!self.foundDevice && i == ([[result objectForKey:@"Items"] count] - 1) && !haveUser && [self.user.deviceId isEqualToString:[TypeConversionMode strongChangeString:itemDit[@"Id"]]]) {
                     [CHAccountTool saveUser:self.user];
                 }
                if ([self.user.deviceId isEqualToString:[TypeConversionMode strongChangeString:itemDit[@"Id"]]]) {
//                    if ([itemDit[@"Id"] isEqualToString:self.oldUser.deviceId]) {
//                        [CHAccountTool saveUser:userList];
//                    }
//                    [self.devices insertObject:userList atIndex:0];
                    [self.devices addObject:userList];
                }
                else{
                    [self.devices addObject:userList];
                }
                if (self.foundDevice) {
                    NSLog(@"getRegoCoding");
                    if (self.devices.count > 0) {
                         NSLog(@"%lu getRegoCoding1",(unsigned long)self.devices.count);
                        self.geocodeNum = 0;
                        for (CHUserInfo *user in self.devices) {
                            if ([self.user.deviceId isEqualToString:user.deviceId]) {
                                NSInteger inter = [self.devices indexOfObject:user];
                                [self.devices exchangeObjectAtIndex:0 withObjectAtIndex:inter];
                                break;
                            }
                        }
                        for (CHUserInfo *user in self.devices) {
                            [self getRegoCoding:user];
                        }
                    }
                    else{
                         NSLog(@"MBProgressHUD");
                       [MBProgressHUD hideHUD];
                        self.afnRequest.moreRequest = NO;
                    }
                }
                NSLog(@"userfoundDevice %d _devices %@  user = %@",self.foundDevice,_devices,_user);
            }];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        if (error.code != 999) {
             request = 0;
            for (NSURLSessionDataTask *tasks in self.afnRequest.sessionMgr.tasks) {
                if (tasks != task) {
                     [tasks cancel];
                }
            }
        }
    }];
    
    request --;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self updateDeviceListWithRequestTimes:request];
//    });
}

- (void)getRegoCoding:(CHUserInfo *)user{
    NSLog(@"&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [_locationMar regeoCoding:user.deviceCoor callBack:^(CHGeoCodingMode *geo) {
            NSLog(@"str ********************************* %@",geo);
            selfWeak.geocodeNum ++;
            if (geo) {
                user.GeoCoding = geo;
            }
            if (selfWeak.geocodeNum == [selfWeak.devices count]) {
                [MBProgressHUD hideHUD];
                selfWeak.geocodeNum = 0;
                selfWeak.afnRequest.moreRequest = NO;
                [selfWeak updateUI];
            }
        }];
    });
}

- (void)updateUI{
    [UIView animateWithDuration:1 animations:^{
        [self.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_bottom).mas_offset(-160 * WIDTHAdaptive - HOME_INDICATOR_HEIGHT);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(160 * WIDTHAdaptive + HOME_INDICATOR_HEIGHT);
        }];
         [self.view layoutIfNeeded];
    }];
    
    self.infoView.locaLab.text = (_user.GeoCoding.FormattedAddress && ![_user.GeoCoding.FormattedAddress isEqualToString:@""]) ? _user.GeoCoding.FormattedAddress:CHLocalizedString(@"location_none", nil);
    self.infoView.selectDevice = _user;
    [self.infoView setDevices:_devices];
    @WeakObj(self)
    [self.infoView didSelectItem:^(CHUserInfo *selDevice) {
        @StrongObj(self)
        if (self.user == selDevice) {
            return ;
        }
        self.user = selDevice;
        self.infoView.locaLab.text = (self.user.GeoCoding.FormattedAddress && ![self.user.GeoCoding.FormattedAddress isEqualToString:@""]) ? self.user.GeoCoding.FormattedAddress:CHLocalizedString(@"location_none", nil);
//        [CHAccountTool saveUser:self.user];
        [self.mapView userDidSelectAnnotationView:self.user];
        [self.mapView setCenterCoordinate:self.user.deviceCoor animated:NO];
    }];
    [self.mapView removeAnnotionsView];
    self.mapView.selectUser = self.user;
    [self.mapView addAnnotationsWithPoints:_devices];
    [self.mapView setCenterCoordinate:self.user.deviceCoor animated:NO];
}

- (void)setMonitor{
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"DeviceId":self.user.deviceId,
                                    @"DeviceModel": self.user.deviceMo,
                                    @"CmdCode": DEVICE_LISTEN,
                                    @"Params": self.CellPhone,
                                    @"UserId": self.user.userId}];
    //    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_SendCommand parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        if ([result[@"State"] intValue] == 0) {
//            if (mess) {
                [MBProgressHUD showSuccess:CHLocalizedString(@"location_monitor", nil)];
//            }
        }
//        callBack(YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
//        callBack(NO);
    }];
}

- (void)dealloc{
    [self.mapView removeFromSuperview];
    self.mapView = nil;
    NSLog(@"dealloc %@",self.mapView);
    self.afnRequest.moreRequest = NO;
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
