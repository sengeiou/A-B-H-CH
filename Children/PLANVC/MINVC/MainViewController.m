//
//  MainViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/24.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) NSMutableArray *deviceLists;
@end

@implementation MainViewController

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
    AppDelegate * appDelegate  =(AppDelegate *) [UIApplication sharedApplication].delegate;
    appDelegate.leftSliderViewController.closedDraw = NO;
}

- (void)initializeMethod{
    self.deviceLists = [[FMDBConversionMode sharedCoreBlueTool] searchDevice:self.user];
}

- (CHUserInfo *)user{
    if (!_user) {
        _user = [CHAccountTool user];
    }
    return _user;
}

- (void)createUI{
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
    CHButton *leftBut = [CHButton createWithImage:deviceIma Radius:25 touchBlock:^(CHButton *sender) {
        
    }];
    [backImage addSubview:leftBut];
    
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
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:cellView];
        
    }];
    [backImage addSubview:phoneBut];
    
    CHLabel *phoneLab = [CHLabel createWithTit:CHLocalizedString(@"电话", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(0x010101, 1.0) backColor:nil textAlignment:0];
    [backImage addSubview:phoneLab];
    
    
    CHButton *locaBut = [CHButton createWithImage:[UIImage imageNamed:@"icon_dinwei"] Radius:0 touchBlock:^(CHButton *sender) {
//        UINavigationController *nav = (UINavigationController *)self.xl_sldeMenu.rootViewController;
//                [nav pushViewController:newVc animated:false];
        //关闭抽屉
        AppDelegate * appDelegate  =(AppDelegate *) [UIApplication sharedApplication].delegate;
        appDelegate.leftSliderViewController.closedDraw = YES;
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
    
    [leftBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(28);
        make.left.mas_equalTo(18);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    [leftIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftBut.mas_right).mas_offset(4);
        make.centerY.mas_equalTo(leftBut.mas_centerY);
        make.width.mas_equalTo(3.5);
        make.height.mas_equalTo(17);
    }];
    
    [rightBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftBut.mas_centerY);
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
        NSLog(@"fw %f",phoneBut.frame.size.width);
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
