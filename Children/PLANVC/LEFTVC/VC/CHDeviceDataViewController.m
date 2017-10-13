//
//  CHDeviceDataViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/16.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHDeviceDataViewController.h"

@interface CHDeviceDataViewController ()
@property (nonatomic, strong) CHUserInfo *user;
@end

@implementation CHDeviceDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}

- (CHUserInfo *)user{
    if (!_user) {
        _user = [CHAccountTool user];
    }
    return _user;
}

- (void)createUI{
    self.title = CHLocalizedString(@"宝贝手表", nil);
    self.view.backgroundColor = CHUIColorFromRGB(0xb3e5fc, 1.0);
    UIView *baseView0 = [[UIView alloc] init];
    baseView0.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView0];
    
    UIImageView *encodeImage = [[UIImageView alloc] init];
    [baseView0 addSubview:encodeImage];
    
    CHLabel *remindLab = [CHLabel createWithTit:CHLocalizedString(@"扫描二维码，绑定宝宝手表", nil) font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(0x717171, 1.0) backColor:nil textAlignment:1];
    [baseView0 addSubview:remindLab];
    
    UIView *baseView1 = [[UIView alloc] init];
    baseView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView1];
    
    UITableView *tab = [[UITableView alloc] init];
    tab.delegate = self;
    tab.dataSource = self;
    tab.scrollEnabled = NO;
    tab.tableFooterView = [UIView new];
    [tab setSeparatorInset:UIEdgeInsetsMake(0,12, 0, 12)];
    [tab setSeparatorColor:CHUIColorFromRGB(0xb3e5fc, 1.0)];
    [baseView1 addSubview:tab];
    
    @WeakObj(self)
    CHButton *unBindBut = [CHButton createWithTit:CHLocalizedString(@"解除绑定", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 18) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:CHLocalizedString(@"确认解除当前绑定的手表?", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *canAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [selfWeak RemoveShare];
        }];
        [alerVC addAction:canAct];
        [alerVC addAction:confimAct];
        [self presentViewController:alerVC animated:YES completion:^{
            
        }];
        
    }];
    [baseView1 addSubview:unBindBut];
    
    [baseView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(CHMainScreen.size.height/2.5 - 15);
    }];
    
    [encodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-10);
        make.height.mas_equalTo(160 * WIDTHAdaptive);
        make.width.mas_equalTo(160 * WIDTHAdaptive);
    }];
    
    [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(encodeImage.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-8);
    }];
    
    [baseView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(baseView0.mas_bottom).mas_offset(15);
    }];
    
    [unBindBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
    }];
    
    [tab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(unBindBut.mas_top).mas_offset(-16);
    }];
    
    UIImage *deviceIma = [UIImage imageNamed:@"pho_usetouxiang"];
    if (self.user.deviceIm && ![self.user.deviceIm isEqualToString:@""]) {
        NSData *imaData = [[NSData alloc] initWithBase64EncodedString:self.user.deviceIm options:NSDataBase64DecodingIgnoreUnknownCharacters];
        deviceIma = [UIImage imageWithData:imaData];
        deviceIma = [UIImage drawWithSize:CGSizeMake(deviceIma.size.width, deviceIma.size.width) Radius:deviceIma.size.width/2 image:deviceIma];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *codeImage = [self encodeQRImageWithContent:self.user.deviceIMEI size:CGSizeMake(160 * WIDTHAdaptive, 160 * WIDTHAdaptive)];
        UIImage *newIma = [self mergeMainIma:codeImage subIma:deviceIma callBackSize:codeImage.size];
        dispatch_async(dispatch_get_main_queue(), ^{
            encodeImage.image = newIma;
//            encodeImage.backgroundColor = [UIColor greenColor];
        });
    });
   
}

- (void)RemoveShare{
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"UserId": self.user.userId,
                                    @"DeviceId": self.user.deviceId,
                                    @"TimeOffset": [NSNumber numberWithInteger:[[NSTimeZone systemTimeZone] secondsFromGMT]/3600],
                                    @"MapType": @""}];
    [CHAFNWorking shareAFNworking].moreRequest = YES;
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_PersonTracking parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        NSDictionary *itemDit = [[result objectForKey:@"Items"] objectAtIndex:0];
        CHGuarderItemMode *itemMode = [CHGuarderItemMode mj_objectWithKeyValues:itemDit];
        NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
        [dic addEntriesFromDictionary:@{@"UserId": selfWeak.user.userId,
                                        @"DeviceId": selfWeak.user.deviceId,
                                        @"UserGroupId": [NSString stringWithFormat:@"%ld",(long)itemMode.UserGroupId]}];
        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_RemoveShare parameters:dic Mess:nil showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
            if ([result[@"State"] intValue] == 0) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:CHLocalizedString(@"解绑成功", nil)];
                [[FMDBConversionMode sharedCoreBlueTool] deleteDevice:selfWeak.user];
                [selfWeak clearDevice];
                [CHAFNWorking shareAFNworking].moreRequest = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [selfWeak.navigationController popViewControllerAnimated:YES];
                });
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
    
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

- (UIImage *)encodeQRImageWithContent:(NSString *)content size:(CGSize)size {
    UIImage *codeImage = nil;
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor = [UIColor blackColor];
    UIColor *offColor = [UIColor whiteColor];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return codeImage;
}

- (UIImage *)mergeMainIma:(UIImage *)maIma subIma:(UIImage *)subIma callBackSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [maIma drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //    [[UIImage imageNamed:@"pho_touxiang"] drawInRect:CGRectMake(size.width/2 - size.width/6, size.width/2 - size.width/6, size.width/3, size.width/3)];
    [subIma drawInRect:CGRectMake(size.width/2 - size.width/7, size.width/2 - size.width/7, size.width/3.5, size.width/3.5)];
    UIImage *backIma = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return backIma;
}

- (UIImage *)createEncodeQRImageWithContent:(NSString *)content size:(CGSize)size{
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    // 2. 给滤镜添加数据
    NSString *string = content;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    // 4. 显示二维码
    UIImage *baseImage = [UIImage imageWithCIImage:image];
    
    UIImage *newIma = [self createNonInterpolatedUIImageFormCIImage:image withSize:size.width];
    return newIma;
}



- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndex = @"DATACELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndex];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndex];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = CHFontNormal(nil, 16);
    cell.detailTextLabel.font = CHFontNormal(nil, 14);
    cell.textLabel.textColor = CHUIColorFromRGB(CHMediumBlackColor, 1.0);
    cell.detailTextLabel.textColor = CHUIColorFromRGB(CHMediumBlackColor, 1.0);
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = CHLocalizedString(@"宝贝资料", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"IMEI";
        cell.detailTextLabel.text = [CHAccountTool user].deviceIMEI;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CHDeviceInfoViewController *deviceVC = [[CHDeviceInfoViewController alloc] init];
        deviceVC.user = self.user;
        [self.navigationController pushViewController:deviceVC animated:YES];
    }
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
