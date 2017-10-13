//
//  CHFenceViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHFenceViewController.h"

@interface CHFenceViewController ()
@property (nonatomic, strong) CHMKMapView *mapView;
@property (nonatomic, strong) CHTextField *searchField;
@property (nonatomic, strong) NYSliderPopover *fenceSlider;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) CHLabel *fenceNameLab, *adressLab;
@property (nonatomic, strong) SMALocatiuonManager *locationMgr;
@property (nonatomic, strong) UITableView *fenceTab;
@property (nonatomic, strong) NSArray *fenceArr;
@property (nonatomic, copy) CHFenceInfoMode *fenceInfoMode;
@end

@implementation CHFenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateUI];
}

- (void)updateUI{
    if (_fenceInfoMode.FenceName) {
        _fenceNameLab.text = _fenceInfoMode.FenceName ? _fenceInfoMode.FenceName:@"";
        _adressLab.text = _fenceInfoMode.Address ? _fenceInfoMode.Address:@"";
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(_fenceInfoMode.Latitude, _fenceInfoMode.Longitude) animated:NO];
        if (_fenceInfoMode.Latitude != 0 || _fenceInfoMode.Longitude != 0) {
            [self addAnnomationViewWithCoordinate:CLLocationCoordinate2DMake(_fenceInfoMode.Latitude, _fenceInfoMode.Longitude)];
            if (_fenceInfoMode.Radius > 0) {
                [self addCircleOlyerWithCenterCoordinate:CLLocationCoordinate2DMake(_fenceInfoMode.Latitude, _fenceInfoMode.Longitude) radius:(int)_fenceInfoMode.Radius animation:YES];
            }
        }
        else{
            if (self.user.deviceCoor.longitude > 0 && self.user.deviceCoor.latitude > 0) {
                [self.mapView setCenterCoordinate:self.user.deviceCoor animated:NO];
            }
        }
        self.fenceSlider.value = _fenceInfoMode.Radius/1000;
    }
    else{
        if (self.user.deviceCoor.longitude > 0 && self.user.deviceCoor.latitude > 0) {
             [self.mapView setCenterCoordinate:self.user.deviceCoor animated:NO];
        }
    }
}

- (void)createUI{
    self.mapView = [CHMKMapView createMapView];
    self.mapView.zoomLevel = 15;
    _fenceInfoMode = [_fenceCacheMode copy];
    if (!_fenceInfoMode) {
        self.fenceInfoMode = [[CHFenceInfoMode alloc] init];
    }
    @WeakObj(self)
    [self.mapView tapMapCallBack:^(MKMapView *mapView) {
        [selfWeak.view endEditing:YES];
    }];
    [self.mapView longMapCallBack:^(MKMapView *mapView,CGPoint point) {
        [selfWeak.view endEditing:YES];
        CLLocationCoordinate2D center = [selfWeak.mapView convertPoint:point toCoordinateFromView:mapView];
        [selfWeak.locationMgr regeoCoding:center callBack:^(CHGeoCodingMode *geo) {
            if (selfWeak.changeModeName) {
                selfWeak.fenceInfoMode.FenceName = geo.Name;
            }
            selfWeak.fenceInfoMode.Latitude = geo.latitude;
            selfWeak.fenceInfoMode.Longitude = geo.longitude;
            selfWeak.fenceInfoMode.Address = geo.FormattedAddress;
            [selfWeak updateUI];
        }];
    }];
    [self.view addSubview:self.mapView];
    self.searchField = [CHTextField createWithPlace:CHLocalizedString(@"搜索位置", nil) text:@"" textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) font:CHFontNormal(nil, 14)];
    self.searchField.backgroundColor = [UIColor whiteColor];
    self.searchField.layer.masksToBounds = YES;
    self.searchField.layer.cornerRadius = 8.0;
    self.searchField.layer.borderColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0).CGColor;
    self.searchField.layer.borderWidth = 1.0;
    UIImageView *rightIma = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_sousuo"] backColor:nil];
    rightIma.frame = CGRectMake(0, 0, 18, 18);
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 35)];
    rightIma.center = CGPointMake(CGRectGetWidth(rightView.frame)/2 - 4, CGRectGetHeight(rightView.frame)/2);
    [rightView addSubview:rightIma];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 35)];
    self.searchField.rightView = rightView;
    self.searchField.rightViewMode = UITextFieldViewModeAlways;
    self.searchField.leftView = leftView;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;
    self.searchField.layer.shadowRadius = 4.0f;
    self.searchField.layer.shadowOffset = CGSizeMake(0, 5);
    self.searchField.layer.shadowOpacity = 1.0f;
    self.searchField.delegate = self;
    [self.view addSubview:self.searchField];
    
    self.fenceSlider = [[NYSliderPopover alloc] init];
    [self.fenceSlider setThumbImage:[UIImage imageNamed:@"icon_ydan"] forState:UIControlStateNormal];
    [self.fenceSlider setThumbImage:[UIImage imageNamed:@"icon_ydan"] forState:UIControlStateHighlighted];
    [self.fenceSlider setMaximumTrackImage:[UIImage imageNamed:@"icon_biaochi_1"] forState:UIControlStateNormal];
    [self.fenceSlider setMinimumTrackImage:[UIImage imageNamed:@"icon_biaochi_2"] forState:UIControlStateNormal];
    [self.fenceSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.fenceSlider];
    
    self.fenceTab = [[UITableView alloc] init];
    self.fenceTab.delegate = self;
    self.fenceTab.dataSource = self;
    [self.view addSubview:self.fenceTab];
    [self.fenceTab setSeparatorInset:UIEdgeInsetsZero];
    [self.fenceTab setSeparatorColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0)];
    self.fenceTab.tableFooterView = [UIView new];
    self.fenceTab.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem CHItemWithTit:CHLocalizedString(@"保存", nil) textColor:nil textFont:CHFontNormal(nil, 14) touchCallBack:^(UIBarButtonItem *item) {
        [selfWeak setFence];
    }];
    [self.navigationItem.rightBarButtonItem.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(40);
        make.height.mas_equalTo(40);
    }];
    
    CHButton *addBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_fangda"] Radius:0 touchBlock:^(CHButton *sender) {
        @StrongObj(self)
        self.mapView.zoomLevel = self.mapView.zoomLevel + 1;
    }];
    [self.view addSubview:addBut];
    
    CHButton *reduBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_suofang"] Radius:0 touchBlock:^(CHButton *sender) {
        @StrongObj(self)
        self.mapView.zoomLevel = self.mapView.zoomLevel - 1;
    }];
    [self.view addSubview:reduBut];
    
    [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.searchField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-45);
        make.height.mas_equalTo(35);
    }];
    
    [self.fenceTab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchField.mas_bottom);
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-45);
        make.height.mas_equalTo(70 * WIDTHAdaptive * 3);
    }];
    
    [self addAdressView];
    
    [self.fenceSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_backView.mas_top).mas_offset(-8);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(40);
    }];
    
    [reduBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.fenceSlider.mas_top).mas_offset(-12);
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
}

- (SMALocatiuonManager *)locationMgr{
    if (!_locationMgr) {
        _locationMgr = [SMALocatiuonManager sharedCoreBlueTool];
    }
    return _locationMgr;
}

- (void)addAnnomationViewWithCoordinate:(CLLocationCoordinate2D)coor{
    [self.mapView removeAnnotionsView];
    CHUserInfo *poinUser = [[CHUserInfo alloc] init];
    poinUser.deviceCoor = coor;
    [self.mapView addSystemAnnotationWithPoints:[@[poinUser] mutableCopy] bespokeIma:[UIImage imageNamed:@"icon_weizhi"]];
}

- (void)addCircleOlyerWithCenterCoordinate:(CLLocationCoordinate2D)coor radius:(int)radius animation:(BOOL)animation{
    [self.mapView removeOverlayView];
    [self.mapView addCircleWithCenterCoordinate:coor radius:radius animation:animation];
}

- (void)addAdressView{
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView];
    UIImageView *logoView = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_quyu"] backColor:nil];
    [_backView addSubview:logoView];
    
    UIImageView *locationView = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_dwdz"] backColor:nil];
    [_backView addSubview:locationView];
    
    UIImageView *dottedLine = [UIImageView itemWithImage:[UIImage imageNamed:@"dian"] backColor:nil];
    [_backView addSubview:dottedLine];
    
    CHLabel *line = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [_backView addSubview:line];
    
    _fenceNameLab = [CHLabel createWithTit:nil font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) backColor:nil textAlignment:0];
    [_backView addSubview:_fenceNameLab];
    
    _adressLab = [CHLabel createWithTit:@"" font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:nil textAlignment:0];
    _adressLab.numberOfLines = 0;
    [_backView addSubview:_adressLab];
    
    [_backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(80 * WIDTHAdaptive);
    }];
    
    [logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-80 * WIDTHAdaptive * (64.0/158.0)/1.5);
        make.left.mas_equalTo(19);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [locationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(80 * WIDTHAdaptive * (64.0/158.0)/1.5);
        make.centerX.mas_equalTo(logoView.mas_centerX);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [dottedLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logoView.mas_bottom);
        make.centerX.mas_equalTo(logoView.mas_centerX);
        make.bottom.mas_equalTo(locationView.mas_top);
        make.width.mas_equalTo(2.5);
    }];
    
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logoView.mas_right).mas_offset(16);
        make.right.mas_offset(0);
        
        make.top.mas_equalTo(80 * WIDTHAdaptive * (64.0/158.0));
        make.height.mas_equalTo(1);
    }];
    
    [_fenceNameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(2);
        make.left.mas_equalTo(line.mas_left);
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(line.mas_bottom).mas_offset(-2);
    }];
    
    [_adressLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(line.mas_left);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(80 * WIDTHAdaptive * (91.0/158.0) - 8);
    }];
}
static int oldValue;
- (void)sliderValueChanged:(id)sender{
    
    int value = [NSString stringWithFormat:@"%.0f",self.fenceSlider.value*1000].intValue;
    self.fenceSlider.popover.textLabel.textColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    self.fenceSlider.popover.textLabel.text = [NSString stringWithFormat:@"%d米",value/100*100];
    
    int newValue = value/100*100;
    if (newValue != oldValue) {
        oldValue = newValue;
        self.fenceInfoMode.Radius = value/100*100;
        [self addCircleOlyerWithCenterCoordinate:CLLocationCoordinate2DMake(_fenceInfoMode.Latitude, _fenceInfoMode.Longitude) radius:value/100*100 animation:NO];
    }
}

- (void)setFence{
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    self.fenceInfoMode.FenceType = 1;
//    if ([self.fenceInfoMode.Description isEqualToString:@"安全圈-家"]) {
//        self.fenceInfoMode.AlarmType = 1;
//    }
//    else if ([self.fenceInfoMode.Description isEqualToString:@"安全圈-学校"]){
//         self.fenceInfoMode.AlarmType = 1;
//    }
//    else{
         self.fenceInfoMode.AlarmType = 3;
//    }
    self.fenceInfoMode.IsDeviceFence = 0;
    self.fenceInfoMode.AlarmModel = 0;
    self.fenceInfoMode.DeviceFenceNo = 0;
    self.fenceInfoMode.InUse = YES;
    self.fenceInfoMode.DeviceId = [self.user.deviceId integerValue];
    [dic addEntriesFromDictionary:@{@"Item":self.fenceInfoMode.mj_keyValues,@"MapType":@"AMap"}];
    REQUESTURL url = REQUESTURL_CreateGeofence;
    if (self.fenceInfoMode.Radius <= 0) {
        [MBProgressHUD showError:CHLocalizedString(@"请设置围栏距离", nil)];
        return;
    }
    if (_fenceCacheMode) {
        url = REQUESTURL_EditGeofence;
    }
    else{
        if (!self.fenceInfoMode.Address) {
            [MBProgressHUD showError:CHLocalizedString(@"请设置围栏位置", nil)];
            return;
        }
    }
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:url parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        if ([result[@"State"] intValue] == 0) {
            if (selfWeak.fenceCacheMode) {
                [MBProgressHUD showSuccess:CHLocalizedString(@"修改成功", nil)];
            }
            else{
                [MBProgressHUD showSuccess:CHLocalizedString(@"保存成功", nil)];
                
            }
            selfWeak.fenceCacheMode = selfWeak.fenceInfoMode;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [selfWeak.navigationController popViewControllerAnimated:YES];
            });
        }
        else{
            
            if (selfWeak.fenceCacheMode) {
                if (![CHAFNWorking shareAFNworking].requestMess) {
                    [MBProgressHUD showSuccess:CHLocalizedString(@"修改失败", nil)];
                }
            }
            else{
                if (![CHAFNWorking shareAFNworking].requestMess) {
                    [MBProgressHUD showSuccess:CHLocalizedString(@"保存失败", nil)];
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"textField %@",aString);
    @WeakObj(self)
    [self.locationMgr geocodeAddressString:aString callBlack:^(NSMutableArray *geos) {
        NSLog(@"getos ==%@",geos);
        selfWeak.fenceArr = [geos copy];
        [selfWeak.fenceTab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(70 * WIDTHAdaptive * (selfWeak.fenceArr.count > 3 ? 3:selfWeak.fenceArr.count));
        }];
        selfWeak.fenceTab.hidden = NO;
        [selfWeak.fenceTab reloadData];
    }];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fenceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70 * WIDTHAdaptive;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *fenceIndex = @"FENCECELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fenceIndex];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:fenceIndex];
    }
    cell.accessoryView = nil;
    CHGeoCodingMode *fenceMode = self.fenceArr[indexPath.row];
    cell.textLabel.textColor = CHUIColorFromRGB(CHMediumBlackColor, 1.0);
    cell.detailTextLabel.textColor = CHUIColorFromRGB(0x757575, 1.0);
    cell.textLabel.font = CHFontNormal(nil, 14);
    cell.detailTextLabel.font = CHFontNormal(nil, 12);
    cell.textLabel.text = fenceMode.Name;
    cell.detailTextLabel.text = fenceMode.FormattedAddress;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageView = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_xuanzhong"] backColor:nil];
    imageView.frame = CGRectMake(0, 0, 10, 10);
    cell.accessoryView = imageView;
    CHGeoCodingMode *fenceMode = self.fenceArr[indexPath.row];
    if (_changeModeName) {
        _fenceInfoMode.FenceName = fenceMode.Name;
    }
    _fenceInfoMode.Latitude = fenceMode.latitude;
    _fenceInfoMode.Longitude = fenceMode.longitude;
    _fenceInfoMode.Address = fenceMode.FormattedAddress;
    [self updateUI];
    [tableView setHidden:YES];
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
