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
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) CHAFNWorking *afnRequest;

@property (nonatomic, assign) CLLocationCoordinate2D deviceCoor;
@property (nonatomic, strong) NSMutableArray <CHUserInfo *> *devices;
@property (nonatomic, strong) SMALocatiuonManager *locationMar;
@property (nonatomic, strong) CHLocationInfoView *infoView;
@property (nonatomic, strong) NSTimer *searchTimer;
//@property (nonatomic, assign) int *afnRequest;
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 0.0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static int request;

- (void)initializeMethod{
    _user = [CHAccountTool user];
    _afnRequest = [CHAFNWorking shareAFNworking];
    _devices = [NSMutableArray array];
    _deviceCoor = CLLocationCoordinate2DMake(MAXFLOAT, MAXFLOAT);
    _locationMar = [SMALocatiuonManager sharedCoreBlueTool];
    if (!_user.deviceMo || [_user.deviceMo isEqualToString:@""]) {
        return;
    }
    NSMutableDictionary *comDic = _afnRequest.requestDic;
    [comDic addEntriesFromDictionary:@{@"DeviceId": _user.deviceId,
                                       @"DeviceModel": _user.deviceMo,
                                       @"CmdCode": LOCATION_REAL_TIME,
                                       @"Params": @"",
                                       @"UserId": _user.userId}];
    _afnRequest.moreRequest = YES;
    @WeakObj(self)
    [_afnRequest CHAFNPostRequestUrl:REQUESTURL_SendCommand parameters:comDic Mess:CHLocalizedString(@"正在加载中，请稍后", nil) showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        @StrongObj(self)
        if ([[result objectForKey:@"State"] intValue] == 0) {
//            [self updateDeviceListWithRequestTimes:30];
            request = 3;
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

- (void)viewDidAppear:(BOOL)animated{
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
    self.title = CHLocalizedString(@"定位", nil);
    self.mapView = [CHMKMapView createMapView];
    self.mapView.showsUserLocation = YES;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.9163854444,116.3971424103) animated:NO];
//    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(39.9076660604,116.3967589906);
//    self.mapView.zoomLevel = 15;
    NSLog(@"fwogio  %@",self.mapView.userLocation.location);
    [self.view addSubview:self.mapView];
    
    CHButton *moniBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_jianting"] Radius:0 touchBlock:^(CHButton *sender) {
         NSLog(@"moniBut  %f  %f",self.mapView.centerCoordinate.latitude,self.mapView.centerCoordinate.latitude);
       AFHTTPSessionManager *_sessionMgr = [AFHTTPSessionManager manager];
        _sessionMgr.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//        _sessionMgr.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript",@"text/plan", nil]; [NSSet setWithObjects:@"<html>",@"<body>",@"<p>", @"</p>",@"</p>",@"</body>",@"</html>", nil]
        [_sessionMgr POST:@"http://www.smart-times.cn/fw/st01" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSString *xmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSArray *xmlStr = [xmlString componentsSeparatedByCharactersInSet:<#(nonnull NSCharacterSet *)#>]
            NSString *str = [self removeHTML2:xmlString];
            NSLog(@"responseObject %@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error %@",error);
        }];
        
        NSURL *url = [NSURL URLWithString:@"http://www.smart-times.cn/fw/st01"];
        
        //A Boolean value that turns an indicator of network activity on or off.
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSData *xmlData = [NSData dataWithContentsOfURL:url];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSString *xmlString = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
        
        if (xmlData == nil) {
            NSLog(@"File read failed!:%@", xmlString);
        }
        else {
            NSLog(@"File read succeed!:%@",xmlString);
        }
    }];
    [self.view addSubview:moniBut];

    @WeakObj(self)
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
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        NSLog(@"moniBut  %f  %f",self.mapView.userLocation.location.coordinate.latitude,self.mapView.userLocation.location.coordinate.latitude);
    }];
    [self.view addSubview:useLocaBut];
    
    self.infoView = [[CHLocationInfoView alloc] initWithShowView:YES];
    [self.view addSubview:self.infoView];
    
    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [moniBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];

    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(160 * WIDTHAdaptive);
    }];

    [reduBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.infoView.mas_top).mas_offset(-12);
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
        make.bottom.mas_equalTo(self.infoView.mas_top).mas_offset(-12);
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    
    UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 30, 40)];
    ima.image = [UIImage drawDeviceImageWithSize:ima.size title:@"宝贝"];
    ima.backgroundColor = [UIColor greenColor];
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
        if (_devices.count > 0) {
            for (CHUserInfo *user in _devices) {
                [self getRegoCoding:user];
            }
        }
        else{
            [MBProgressHUD hideHUD];
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
        BOOL foundDevice = NO;
        if ([[result objectForKey:@"Items"] count] > 0) {
            [self.devices removeAllObjects];
        }
        for (int i = 0; i < [[result objectForKey:@"Items"] count]; i ++) {
            NSDictionary *itemDit = [[result objectForKey:@"Items"] objectAtIndex:i];
            CHUserInfo *userList = [[CHUserInfo alloc] init];
            
            if (!foundDevice && i == ([[result objectForKey:@"Items"] count] - 1)) {
                NSDictionary *itemDit = [[result objectForKey:@"Items"] objectAtIndex:0];
                self.user.deviceId = [TypeConversionMode strongChangeString:itemDit[@"Id"]];
                self.user.devicePh = [TypeConversionMode strongChangeString:itemDit[@"Sim"]];
                self.user.deviceNa = [TypeConversionMode strongChangeString:itemDit[@"NickName"]];
                self.user.deviceMo = [TypeConversionMode strongChangeString:itemDit[@"Model"]];
            }
            
            if ([self.user.deviceId isEqualToString:[TypeConversionMode strongChangeString:itemDit[@"Id"]]]) {
                userList = self.user;
                NSLog(@"CLLocationCoordinate2DIsValid(_deviceCoor)  %d",CLLocationCoordinate2DIsValid(_deviceCoor));
                if (!CLLocationCoordinate2DIsValid(self.deviceCoor)) {
                    self.deviceCoor = CLLocationCoordinate2DMake([itemDit[@"Latitude"] floatValue], [itemDit[@"Longitude"] floatValue]);
                }
                if (self.deviceCoor.latitude != [itemDit[@"Latitude"] floatValue] || self.deviceCoor.longitude != [itemDit[@"Longitude"] floatValue]){
                    self.deviceCoor = CLLocationCoordinate2DMake([itemDit[@"Latitude"] floatValue], [itemDit[@"Longitude"] floatValue]);
                    foundDevice = YES;
                }
                if (foundDevice) {
                    request = 0;
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
            userList.deviceCoor = CLLocationCoordinate2DMake([itemDit[@"Latitude"] floatValue], [itemDit[@"Longitude"] floatValue]);
            
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[TypeConversionMode strongChangeString:itemDit[@"Avatar"]]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (!image) {
                    image = [UIImage imageNamed:@"pho_touxiang"];
                }
                userList.deviceIm = [UIImageJPEGRepresentation(image, 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                [[FMDBConversionMode sharedCoreBlueTool] insertDevice:userList];
                if ([_user.deviceId isEqualToString:[TypeConversionMode strongChangeString:itemDit[@"Id"]]]) {
                    [CHAccountTool saveUser:userList];
                    [self.devices insertObject:userList atIndex:0];
                }
                else{
                    [self.devices addObject:userList];
                }
                if (foundDevice || request == 0) {
                    NSLog(@"getRegoCoding");
                    if (self.devices.count > 0) {
                         NSLog(@"getRegoCoding1");
                        for (CHUserInfo *user in self.devices) {
                            [self getRegoCoding:user];
                        }
                    }
                    else{
                         NSLog(@"MBProgressHUD");
                       [MBProgressHUD hideHUD];
                    }
                }
                NSLog(@"userfoundDevice %d _devices %@  user = %@",foundDevice,_devices,_user);
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [_locationMar regeoCoding:user.deviceCoor callBack:^(CHGeoCodingMode *geo) {
            NSLog(@"str  %@",geo);
            if (geo) {
                user.GeoCoding = geo;
            }
            if (user == [self.devices lastObject]) {
                [MBProgressHUD hideHUD];
                [self updateUI];
            }
        }];
    });
}

- (void)updateUI{
    [UIView animateWithDuration:1 animations:^{
        [self.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_bottom).mas_offset(-160 * WIDTHAdaptive);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(160 * WIDTHAdaptive);
        }];
         [self.view layoutIfNeeded];
    }];
    
    self.infoView.locaLab.text = (_user.GeoCoding.FormattedAddress && ![_user.GeoCoding.FormattedAddress isEqualToString:@""]) ? _user.GeoCoding.FormattedAddress:CHLocalizedString(@"暂无定位信息", nil);
    [self.infoView setDevices:_devices];
    [self.mapView addAnnotationsWithPoints:_devices];
}

- (void)dealloc{
    NSLog(@"dealloc");
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
