//
//  CHHistoryTrackViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/14.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHHistoryTrackViewController.h"

@interface CHHistoryTrackViewController ()
@property (nonatomic, strong) UICollectionView *dateCollection;
@property (nonatomic, strong) CHMKMapView *mapView;
@property (nonatomic, strong) CHLabel *adressLab, *dateLab;
@property (nonatomic, strong) CHButton *playBut;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSMutableArray *modeArr;
@property (nonatomic, strong) NSMutableArray *dataDateArr;
@property (nonatomic, strong) NSArray *historyInfoArr;
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) CHTracking *tracking;
@end

@implementation CHHistoryTrackViewController

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self initializeMethod];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}
- (CHUserInfo *)user{
    if (!_user) {
        _user = [CHAccountTool user];
    }
    return _user;
}

- (NSMutableArray *)dataDateArr{
    if (!_dataDateArr) {
        _dataDateArr = [NSMutableArray array];
    }
    return _dataDateArr;
}

- (NSMutableArray *)modeArr{
    if (!_modeArr) {
        _modeArr = [NSMutableArray array];
    }
    return _modeArr;
}

- (void)initializeMethod{
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateFormat = @"yyyy-MM-dd";
    self.title = [self.formatter stringFromDate:[NSDate date]];
    if (!self.user.deviceId || [self.user.deviceId isEqualToString:@""]) {
        return;
    }
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"DeviceId": [TypeConversionMode strongChangeString:self.user.deviceId],
                                    @"TimeOffset": [NSNumber numberWithInteger:0],
                                    @"Time": [self.formatter stringFromDate:[NSDate date]]}];
    @WeakObj(self)
    [CHAFNWorking shareAFNworking].moreRequest = YES;
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_MonthHistoryDays parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        NSArray *arr = result[@"Days"];
        [selfWeak.dataDateArr removeAllObjects];
        for (NSString *date in arr) {
            [selfWeak.dataDateArr addObject:[date substringToIndex:10]];
        }
        [selfWeak updateHeadView];
        NSLog(@"fewfe    %@",selfWeak.dataDateArr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
       
    }];
}

- (void)updateHeadView{
    self.formatter.dateFormat = @"yyyy-MM-dd";
    NSMutableArray *dateArr = [NSMutableArray array];
    for (int i = 6; i >= 0; i --) {
        NSDate *date = [[NSDate date] timeDifferenceWithNumbers:-i];
        [dateArr addObject:date];
    }
    for (int j = 0; j < dateArr.count; j++) {
        NSString *date =[self.formatter stringFromDate: dateArr[j]];
        CHTrackDateMode *mode = [[CHTrackDateMode alloc] init];
        mode.haveDate = NO;
        mode.nowDate = NO;
        mode.selectDate = NO;
        mode.textLab = date;
        if ([self.dataDateArr containsObject:date]) {
            mode.haveDate = YES;
        }
        if ([date isEqualToString:[self.formatter stringFromDate:[NSDate date]]]) {
            mode.nowDate = YES;
        }
        if (j == dateArr.count - 1) {
            mode.selectDate = YES;
            [self requestHistoryDataWithDateMode:mode showMess:NO];
        }
        [self.modeArr addObject:mode];
    }
    [self.dateCollection reloadData];
}

- (void)updateFootAdress:(NSString *)adress time:(NSString *)time{
    self.adressLab.text = adress;
    self.dateLab.text = time;
}

- (void)requestHistoryDataWithDateMode:(CHTrackDateMode *)mode showMess:(BOOL)show{
    [self.tracking clear];
    [self.mapView removeOverlayView];
    [self.mapView removeAnnotionsView];
    [self updateFootAdress:CHLocalizedString(@"device_track_none", nil) time:@""];
    if (!mode.haveDate) {
        _playBut.enabled = NO;
        [MBProgressHUD hideHUD];
        return;
    }
     _playBut.enabled = YES;
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeZone *zone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDate *Startdate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",mode.textLab]];
    NSDate *Enddate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 23:59:59",mode.textLab]];
    dateFormatter.timeZone = zone;
    [dic addEntriesFromDictionary:@{@"DeviceId": [TypeConversionMode strongChangeString:self.user.deviceId],
     @"StartTime": [dateFormatter stringFromDate:Startdate],
     @"EndTime": [dateFormatter stringFromDate:Enddate],
     @"ShowLbs": @1,
     @"MapType": @"AMap",
     @"SelectCount": @500}];
    
//    [dic addEntriesFromDictionary:@{@"DeviceId": [TypeConversionMode strongChangeString:self.user.deviceId],
//                                    @"StartTime": [NSString stringWithFormat:@"%@ 00:00:00",mode.textLab],
//                                    @"EndTime": [NSString stringWithFormat:@"%@ 23:59:59",mode.textLab],
//                                    @"ShowLbs": @1,
//                                    @"MapType": @"AMap",
//                                    @"SelectCount": @500}];
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_History parameters:dic Mess:show ? @"":nil showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        selfWeak.historyInfoArr = [CHHistoryInfo mj_objectArrayWithKeyValuesArray:result[@"Items"]];
        [CHAFNWorking shareAFNworking].moreRequest = NO;
        [selfWeak selectLocationAdress:[selfWeak.historyInfoArr lastObject] callBack:^{
            [MBProgressHUD hideHUD];
            [selfWeak drawPoly];
        }];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (void)drawPoly{
    [self.mapView addPolyOverLaysWithTarckModes:self.historyInfoArr];
     [self.mapView addAnnotationsWithTrackPoints:[self.historyInfoArr mutableCopy]];
    if (self.tracking) {
        self.tracking = nil;
    }
    [self createTracking];
}

- (void)selectLocationAdress:(CHHistoryInfo *)info callBack:(void(^)(void))callBack{
    @WeakObj(self);
    [[SMALocatiuonManager sharedCoreBlueTool] regeoCoding:CLLocationCoordinate2DMake(info.Lat, info.Lng) callBack:^(CHGeoCodingMode *geo) {
        if (!geo) {
            [selfWeak updateFootAdress:CHLocalizedString(@"device_track_none", nil) time:@""];
        }
        else{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSTimeZone *zone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            dateFormatter.timeZone = zone;
            NSDate *nowDate = [NSDate getNowDateFromatAnDate:[dateFormatter dateFromString:info.Time]];
            dateFormatter.dateFormat = @"HH:mm";
            NSString *str = [dateFormatter stringFromDate:nowDate];
            [selfWeak updateFootAdress:geo.FormattedAddress time:[NSString stringWithFormat:@"%@ %@",str,CHLocalizedString(@"device_track_watchGps", nil)]];
        }
        callBack();
    }];
}

- (void)createTracking{
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(self.historyInfoArr.count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < self.historyInfoArr.count; i ++) {
        CHHistoryInfo *mode = self.historyInfoArr[i];
        coords[i].latitude = mode.Lat;
        coords[i].longitude = mode.Lng;
    }
    
    if (!self.tracking) {
        self.tracking = [[CHTracking alloc] initWithCoordinates:coords count:self.historyInfoArr.count];
        self.tracking.mapView = self.mapView;
        self.tracking.duration = 5.0;
        self.tracking.edgeInsets = UIEdgeInsetsMake(60 * WIDTHAdaptive, 20, 12, 20);
    }
}

static NSString *trackIndex = @"TRACKCELL";
- (void)createUI{
    _mapView = [CHMKMapView createMapView];
    _mapView.zoomLevel = 15;
    [self.view addSubview:_mapView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _dateCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _dateCollection.delegate = self;
    _dateCollection.dataSource = self;
    _dateCollection.backgroundColor = [UIColor whiteColor];
    [_dateCollection registerClass:[CHTrackCollectionViewCell class] forCellWithReuseIdentifier:trackIndex];
    [self.view addSubview:_dateCollection];
    
    [_mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(- 100 * WIDTHAdaptive);
    }];
    
    [_dateCollection mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [self addAdressView];
}

- (void)addAdressView{
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    @WeakObj(self)
    _playBut = [CHButton createWithTit:CHLocalizedString(@"device_tarck_play", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 16) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:20 * WIDTHAdaptive touchBlock:^(CHButton *sender) {
        [selfWeak.tracking execute];
    }];
    _playBut.titleLabel.numberOfLines = 0;
    _playBut.titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:_playBut];
    
    [backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(100 * WIDTHAdaptive + HOME_INDICATOR_HEIGHT);
    }];
    
    _adressLab = [CHLabel createWithTit:nil font:CHFontNormal(nil, 20) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:CHUIColorFromRGB(0xffffff, 1.0) textAlignment:0];
    _adressLab.numberOfLines = 0;
    [backView addSubview:_adressLab];
    
    _dateLab = [CHLabel createWithTit:nil font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:CHUIColorFromRGB(0xffffff, 1.0) textAlignment:0];
    [backView addSubview:_dateLab];
    
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
    
    CGRect butRect = [CHCalculatedMode CHCalculatedWithStr:CHLocalizedString(@"device_tarck_play", nil) size:CGSizeMake(100, 22 * WIDTHAdaptive) attributes:@{NSFontAttributeName:CHFontNormal(nil, 16)}];
    [_playBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(butRect.size.width + 18);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
    }];
    
    [_adressLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(backView.mas_height).multipliedBy(0.6);
        make.right.mas_equalTo(_playBut.mas_left).mas_offset(-8);
    }];
    
    [_dateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_adressLab.mas_bottom).mas_offset(4);
        make.right.mas_equalTo(_playBut.mas_left).mas_offset(-8);
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-4);
    }];
    
    [reduBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(backView.mas_top).mas_offset(-22);
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
    _playBut.enabled = NO;
    backView.backgroundColor = [UIColor whiteColor];
    [selfWeak updateFootAdress:CHLocalizedString(@"device_track_none", nil) time:@""];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modeArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CHTrackCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:trackIndex forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    CHTrackDateMode *mode = [self.modeArr objectAtIndex:indexPath.row];
    cell.textLab.text = [mode.textLab substringWithRange:NSMakeRange(mode.textLab.length - 2, 2)];
    cell.nowDate = mode.nowDate;
    cell.selectDate = mode.selectDate;
    cell.haveDate = mode.haveDate;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CHTrackDateMode *selMode = [self.modeArr objectAtIndex:indexPath.row];
    for (CHTrackDateMode *mode in self.modeArr) {
        if (mode == selMode) {
            mode.selectDate = YES;
        }
        else{
            mode.selectDate = NO;
        }
    }
    if ([self.title isEqualToString:selMode.textLab]) {
        return;
    }
    self.title = selMode.textLab;
    [collectionView reloadData];
    [self requestHistoryDataWithDateMode:selMode showMess:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.size.height, collectionView.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat offset = (CHMainScreen.size.width - collectionView.size.height * 7)/8;
    return UIEdgeInsetsMake(0, offset, 0, offset);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    CGFloat offset = (CHMainScreen.size.width - collectionView.size.height * 7)/8;
    return offset;
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
