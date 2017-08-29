//
//  CHInputViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHInputViewController.h"

@interface CHInputViewController ()
{
    CHButton *confimBut;
    CHTextField *_imeiField;
}
@end

@implementation CHInputViewController

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

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = CHLocalizedString(@"手动输入", nil);
    CHLabel *inputTit = [CHLabel createWithTit:CHLocalizedString(@"输入IMEI码", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:inputTit];
    [inputTit mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(43);
        make.left.mas_equalTo(40);
        
    }];
    
    _imeiField = [CHTextField createWithPlace:CHLocalizedString(@"15位数", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) font:CHFontNormal(nil, 16)];
    _imeiField.delegate = self;
    [self.view addSubview:_imeiField];
    [_imeiField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inputTit.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(43);
        make.right.mas_equalTo(-43);
        make.height.mas_equalTo(44);
    }];
    
    CHLabel *lineLab = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:lineLab];
    [lineLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imeiField.mas_bottom);
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(-11);
        make.height.mas_equalTo(1);
    }];
    
    @WeakObj(self)
//    @WeakObj(_imeiField)
    @WeakObject(_imeiField);
    confimBut = [CHButton createWithTit:CHLocalizedString(@"确定", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        @StrongObj(self)
        @StrongObject(_imeiField)
         CHUserInfo *user = [CHAccountTool user];
        
        NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
        [dic addEntriesFromDictionary:@{@"SerialNumber":[(CHTextField *)strongOjb text],@"UserId": user.userId}];
        user.deviceIMEI = [(CHTextField *)strongOjb text];
        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_CheckDevice parameters:dic Mess:CHLocalizedString(@"", nil) showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
            user.deviceId = [TypeConversionMode strongChangeString:[result objectForKey:@"DeviceId"]];
            if ([[result objectForKey:@"State"] intValue] == 0) {
                NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
                [dic addEntriesFromDictionary:@{@"DeviceId":user.deviceId,@"UserId": user.userId,@"RelationPhone":user.userPh,@"RelationName":@"",@"Info":@"",@"DeviceType":@6}];
                [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_AddDeviceAndUserGroup parameters:dic Mess:nil showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                    if ([result[@"State"] intValue] == 0) {
                        CHDeviceInfoViewController *deviceVC = [[CHDeviceInfoViewController alloc] init];
                        deviceVC.user = user;
                        [self.navigationController pushViewController:deviceVC animated:YES];
                    }
                    if([result[@"State"] intValue] == 1500 || [result[@"State"] intValue] == 1501){
                        
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                    
                }];
            }else if ([[result objectForKey:@"State"] intValue] == 1107) {
                CHPutInViewController *putInVC = [[CHPutInViewController alloc] init];
                putInVC.deviceId = [TypeConversionMode strongChangeString:[result objectForKey:@"DeviceId"]];
                [self.navigationController pushViewController:putInVC animated:YES];
            }else{
                 [MBProgressHUD showError:[result objectForKey:@"Message"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        }];
        
    }];
    confimBut.enabled = NO;
    [self.view addSubview:confimBut];
    [confimBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineLab.mas_bottom).mas_equalTo(24);
        make.left.mas_equalTo(self.view).mas_offset(30);
        make.right.mas_equalTo(self.view).mas_offset(-30);
        make.height.mas_equalTo(40);
    }];
    
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *realTextViewText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textField resignFirstResponder];
    }
    //如果有高亮
    if (selectedRange && pos) {
        return YES;
    }
    if (realTextViewText.length >= 15) {
        NSInteger length = string.length + 15 - realTextViewText.length;
        NSRange rg = {0,MAX(length,0)};
        if (rg.length>0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        confimBut.enabled = YES;
        return NO;
    }
    else{
        confimBut.enabled = NO;
    }
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textField resignFirstResponder];
    }
    return YES;
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
