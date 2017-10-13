//
//  CHBingViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/21.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHBingViewController.h"

@interface CHBingViewController (){
    UIImageView *searchView;
    UIActivityIndicatorView *activityIndicatorView;
    
    UIImageView *lineImage;
}
@end

@implementation CHBingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self setupScanSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startScan];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
      [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}

- (void)didClickBackBarButtonItem:(id)sender{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CHKLTViewController *nav = [[CHKLTViewController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    CHLeftViewController *leftVC = [[CHLeftViewController alloc] init];
    app.leftSliderViewController = [[LeftSliderViewController alloc] initWithLeftView:leftVC andMainView:nav];
    [UIApplication sharedApplication].keyWindow.rootViewController = app.leftSliderViewController;
}

- (void)createUI{
    self.view.backgroundColor = CHUIColorFromRGB(0x000000, 1.0);
    self.title = CHLocalizedString(@"绑定手表", nil);
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithIma:[UIImage imageNamed:@"btu_fanhui_w"] target:self action:@selector(didClickBackBarButtonItem:)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem CHItemWithTit:CHLocalizedString(@"跳过", nil) textColor:nil textFont:CHFontNormal(nil, 14) touchCallBack:^(UIBarButtonItem *item) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        CHKLTViewController *nav = [[CHKLTViewController alloc] initWithRootViewController:[[MainViewController alloc] init]];
        CHLeftViewController *leftVC = [[CHLeftViewController alloc] init];
        app.leftSliderViewController = [[LeftSliderViewController alloc] initWithLeftView:leftVC andMainView:nav];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = app.leftSliderViewController;
    }];
    [self.navigationItem.rightBarButtonItem.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(40);
        make.height.mas_equalTo(40);
    }];
    
    CHLabel *titLAab = [CHLabel createWithTit:CHLocalizedString(@"扫描二维码", nil) font:CHFontNormal(nil, 18) textColor:nil backColor:nil textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titLAab];
    
    CHLabel *titLAab1 = [CHLabel createWithTit:CHLocalizedString(@"二维码在说明书上，或已绑定手表的爱保护APP宝贝手表选项", nil) font:CHFontNormal(nil, 12) textColor:nil backColor:nil textAlignment:NSTextAlignmentCenter];
    titLAab1.numberOfLines = 0;
    [self.view addSubview:titLAab1];
    
    searchView = [UIImageView itemWithImage:[UIImage imageNamed:@"pic_saomakuang"] backColor:[UIColor clearColor]];
    searchView.layer.masksToBounds = YES;
    searchView.layer.borderWidth = .5f;
    searchView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:searchView];
    
    lineImage = [UIImageView itemWithImage:[UIImage imageNamed:@"pic_saomianxian"] backColor:nil];
    [searchView addSubview:lineImage];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.hidesWhenStopped = YES;
    [searchView addSubview:activityIndicatorView];
    
    CHButton *inputBut = [CHButton createWithTit:CHLocalizedString(@"手动输入", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 18) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        [self.navigationController pushViewController:[[CHInputViewController alloc] init] animated:YES];
    }];
    [self.view addSubview:inputBut];
    
    [titLAab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [titLAab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titLAab.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(self.view);
        make.right.mas_equalTo(-40);
        make.left.mas_equalTo(40);
    }];
    
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view).centerOffset(CGPointMake(0, -34));
        make.width.mas_equalTo(CHMainScreen.size.width/1.5);
        make.height.mas_equalTo(CHMainScreen.size.width/1.5);
    }];
    
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(searchView);
        make.width.mas_equalTo(searchView.mas_width).mas_offset(-20);
        make.height.mas_equalTo(4);
    }];
    
    [activityIndicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(searchView);
    }];
    
    [inputBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-60);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.centerX.mas_equalTo(self.view);
    }];
}

- (void)setupScanSession{
    //设置捕捉设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    //设置设备输入输出
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:CHLocalizedString(@"摄像头不可用", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [aler addAction:confimAct];
        [self presentViewController:aler animated:YES completion:^{
            
        }];
        return;
    }
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置会话
    AVCaptureSession *scanSession = [[AVCaptureSession alloc] init];
    [scanSession canSetSessionPreset:AVCaptureSessionPresetHigh];
    if ([scanSession canAddInput:input]) {
        [scanSession addInput:input];
    }
    if ([scanSession canAddOutput:output]) {
        [scanSession addOutput:output];
    }
    //设置扫描类型(二维码和条形码)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeCode39Code,
                                   AVMetadataObjectTypeCode128Code,
                                   AVMetadataObjectTypeCode39Mod43Code,
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode93Code];
    //预览图层
    AVCaptureVideoPreviewLayer *scanPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:scanSession];
    scanPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    scanPreviewLayer.frame = self.view.layer.bounds;
    scanPreviewLayer.backgroundColor = CHUIColorFromRGB(0x000000, 1).CGColor;
    [self.view.layer insertSublayer:scanPreviewLayer atIndex:0];
    //设置扫描区域
    [CHNotifictionCenter addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        output.rectOfInterest = [scanPreviewLayer metadataOutputRectOfInterestForRect:searchView.frame];
    }];
    _scanSession = scanSession;
}

- (void)startScan{
    [lineImage.layer addAnimation:[self scanAnimation] forKey:@"scan"];
    if (_scanSession && !_scanSession.running) {
        [_scanSession startRunning];
    }
}

- (CABasicAnimation *)scanAnimation{
    CGPoint starPoint = CGPointMake(lineImage.center.x, 2);
    CGPoint endPoint = CGPointMake(lineImage.center.x, searchView.bounds.size.height - 2);
    CABasicAnimation *transLation = [CABasicAnimation animationWithKeyPath:@"position"];
    transLation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transLation.fromValue = [NSValue valueWithCGPoint:starPoint];
    transLation.toValue = [NSValue valueWithCGPoint:endPoint];
    transLation.duration = 3.0;
    transLation.repeatCount = MAXFLOAT;
    transLation.autoreverses = YES;
    return transLation;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    [lineImage.layer removeAllAnimations];
    [_scanSession stopRunning];
    if (metadataObjects.count > 0) {
        CHUserInfo *user = [CHAccountTool user];
        AVMetadataMachineReadableCodeObject * resultObj = metadataObjects.firstObject;
        [activityIndicatorView startAnimating];
        NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
        [dic addEntriesFromDictionary:@{@"SerialNumber":resultObj.stringValue,@"UserId": user.userId}];
        user.deviceIMEI = resultObj.stringValue;
        [CHAFNWorking shareAFNworking].moreRequest = YES;
        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_CheckDevice parameters:dic Mess:nil showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
            user.deviceId = [TypeConversionMode strongChangeString:[result objectForKey:@"DeviceId"]];
            if ([[result objectForKey:@"State"] intValue] == 0) {
                
                NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
                [dic addEntriesFromDictionary:@{@"DeviceId":user.deviceId,@"UserId": user.userId,@"RelationPhone":user.userPh,@"RelationName":@"",@"Info":@"",@"DeviceType":@6}];
                [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_AddDeviceAndUserGroup parameters:dic Mess:nil showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                    if ([result[@"State"] intValue] == 0) {
                        
                        NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
                        [dic addEntriesFromDictionary:@{@"UserId": user.userId,
                                                        @"DeviceId": user.deviceId,
                                                        @"TimeOffset": [NSNumber numberWithInteger:[[NSTimeZone systemTimeZone] secondsFromGMT]/3600],
                                                        @"MapType": @""}];
                        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_PersonTracking parameters:dic Mess:nil showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
                            
                        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                            NSDictionary *itemDit = [[result objectForKey:@"Items"] objectAtIndex:0];
                            user.deviceMo = [TypeConversionMode strongChangeString:itemDit[@"Model"]];
                            user.deviceIMEI = [TypeConversionMode strongChangeString:itemDit[@"SerialNumber"]];
                            [CHAFNWorking shareAFNworking].moreRequest = NO;
                            [activityIndicatorView stopAnimating];
                            [MBProgressHUD hideHUD];
                            CHDeviceInfoViewController *deviceVC = [[CHDeviceInfoViewController alloc] init];
                            deviceVC.user = user;
                            [self.navigationController pushViewController:deviceVC animated:YES];

                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                            [activityIndicatorView stopAnimating];
                        }];
                    }
                    if([result[@"State"] intValue] == 1500 || [result[@"State"] intValue] == 1501){
                        
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                    [activityIndicatorView stopAnimating];
                }];
               
            }else if ([[result objectForKey:@"State"] intValue] == 1107) {
                [activityIndicatorView stopAnimating];
                CHPutInViewController *putInVC = [[CHPutInViewController alloc] init];
                putInVC.deviceId = [TypeConversionMode strongChangeString:[result objectForKey:@"DeviceId"]];
                putInVC.user = user;
                [CHAFNWorking shareAFNworking].moreRequest = NO;
                [self.navigationController pushViewController:putInVC animated:YES];
            }else{
                [CHAFNWorking shareAFNworking].moreRequest = NO;
                [MBProgressHUD showError:[result objectForKey:@"Message"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.navigationController popViewControllerAnimated:YES];
                    [activityIndicatorView stopAnimating];
                });
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
           [activityIndicatorView stopAnimating];
        }];
    }
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
