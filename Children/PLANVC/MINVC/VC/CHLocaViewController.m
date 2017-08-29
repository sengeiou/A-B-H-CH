//
//  CHLocaViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/25.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHLocaViewController.h"

@interface CHLocaViewController ()

@property (nonatomic, strong) CHMKMapView *mapView;
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) CHAFNWorking *afnRequest;
//@property (nonatomic, assign) CLLocationCoordinate2D *deviceCoor;
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
    [_afnRequest CHAFNPostRequestUrl:REQUESTURL_SendCommand parameters:comDic Mess:CHLocalizedString(@"正在加载中，请稍后", nil) showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        if ([[result objectForKey:@"State"] intValue] == 0) {
//            [self updateDeviceListWithRequestTimes:30];
            request = 30;
            if (_searchTimer) {
                [_searchTimer invalidate];
                _searchTimer = nil;
            }
           _searchTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDeviceListWithRequestTimes:) userInfo:nil repeats:YES];
        }
        else{
             _afnRequest.moreRequest = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}



- (void)createUI{
    self.title = CHLocalizedString(@"定位", nil);
    self.mapView = [CHMKMapView createMapView];
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    CHButton *moniBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_jianting"] Radius:0 touchBlock:^(CHButton *sender) {
        
    }];
    [self.view addSubview:moniBut];
    
    CHButton *addBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_fangda"] Radius:0 touchBlock:^(CHButton *sender) {
        
    }];
    [self.view addSubview:addBut];
    
    CHButton *reduBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_suofang"] Radius:0 touchBlock:^(CHButton *sender) {
        
    }];
    [self.view addSubview:reduBut];
    
    CHButton *useLocaBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_huidaodinwei"] Radius:0 touchBlock:^(CHButton *sender) {
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
    [_afnRequest CHAFNPostRequestUrl:REQUESTURL_PersonDeviceList parameters:dic Mess:nil showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        [[FMDBConversionMode sharedCoreBlueTool] deleteAllDevice:_user];
        BOOL foundDevice = NO;
        if ([[result objectForKey:@"Items"] count] > 0) {
            [_devices removeAllObjects];
        }
        for (int i = 0; i < [[result objectForKey:@"Items"] count]; i ++) {
            NSDictionary *itemDit = [[result objectForKey:@"Items"] objectAtIndex:i];
            CHUserInfo *userList = [[CHUserInfo alloc] init];
            
            if (!foundDevice && i == ([[result objectForKey:@"Items"] count] - 1)) {
                NSDictionary *itemDit = [[result objectForKey:@"Items"] objectAtIndex:0];
                _user.deviceId = [TypeConversionMode strongChangeString:itemDit[@"Id"]];
                _user.devicePh = [TypeConversionMode strongChangeString:itemDit[@"Sim"]];
                _user.deviceNa = [TypeConversionMode strongChangeString:itemDit[@"NickName"]];
                _user.deviceMo = [TypeConversionMode strongChangeString:itemDit[@"Model"]];
            }
            
            if ([_user.deviceId isEqualToString:[TypeConversionMode strongChangeString:itemDit[@"Id"]]]) {
                userList = _user;
                NSLog(@"CLLocationCoordinate2DIsValid(_deviceCoor)  %d",CLLocationCoordinate2DIsValid(_deviceCoor));
                if (!CLLocationCoordinate2DIsValid(_deviceCoor)) {
                    _deviceCoor.latitude = [itemDit[@"Latitude"] floatValue];
                    _deviceCoor.longitude = [itemDit[@"Longitude"] floatValue];
                }
                if (_deviceCoor.latitude != [itemDit[@"Latitude"] floatValue] || _deviceCoor.longitude != [itemDit[@"Longitude"] floatValue]){
                    _deviceCoor.latitude = [itemDit[@"Latitude"] floatValue];
                    _deviceCoor.longitude = [itemDit[@"Longitude"] floatValue];
                    foundDevice = YES;
                }
                if (foundDevice) {
                    request = 0;
                    for (NSURLSessionDataTask *task in _afnRequest.sessionMgr.tasks) {
                        [task cancel];
                    }
                }
            }

            userList.userId = _user.userId;
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
                    [_devices insertObject:userList atIndex:0];
                }
                else{
                    [_devices addObject:userList];
                }
                if (foundDevice || request == 0) {
                    NSLog(@"getRegoCoding");
                    if (_devices.count > 0) {
                         NSLog(@"getRegoCoding1");
                        for (CHUserInfo *user in _devices) {
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
            for (NSURLSessionDataTask *tasks in _afnRequest.sessionMgr.tasks) {
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
    [_locationMar regeoCoding:user.deviceCoor callBack:^(CHGeoCodingMode *geo) {
        NSLog(@"str  %@",geo);
        user.GeoCoding = geo;
        if (user == [_devices lastObject]) {
            [MBProgressHUD hideHUD];
            [self updateUI];
        }
    }];
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
