//
//  CHPutInViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHPutInViewController.h"

@interface CHPutInViewController ()
{
    CHButton *confimBut;
}
@end

@implementation CHPutInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = CHLocalizedString(@"成员监护申请", nil);
    CHLabel *redLab = [CHLabel createWithTit:CHLocalizedString(@"该手表已被绑定，您需要向管理员申请才能添加成为监护人", nil) font:CHFontNormal(nil, 12) textColor:[UIColor redColor] backColor:nil textAlignment:0];
    redLab.numberOfLines = 0;
    [self.view addSubview:redLab];
    
    CHLabel *remindLab = [CHLabel createWithTit:CHLocalizedString(@"请输入验证信息", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    remindLab.numberOfLines = 0;
    [self.view addSubview:remindLab];
    
    CHLabel *lineLab0 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    lineLab0.numberOfLines = 0;
    [self.view addSubview:lineLab0];
    
    UITextView *putTextView = [UITextView new];
    putTextView.text = CHLocalizedString(@"我是...", nil);
    putTextView.font = CHFontNormal(nil, 16);
    putTextView.textColor = CHUIColorFromRGB(0x808080, 1.0);
    putTextView.delegate = self;
    [self.view addSubview:putTextView];
    
    CHLabel *lineLab1 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    lineLab1.numberOfLines = 0;
    [self.view addSubview:lineLab1];
    
    confimBut = [CHButton createWithTit:CHLocalizedString(@"发送申请", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        CHUserInfo *user = [CHAccountTool user];
        NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
        [dic addEntriesFromDictionary:@{@"DeviceId":_deviceId,@"UserId": user.userId,@"RelationPhone":user.userPh,@"RelationName":@"",@"Info":putTextView.text,@"DeviceType":@6}];
        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_AddDeviceAndUserGroup parameters:dic Mess:CHLocalizedString(@"请求中...", nil) showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
            if([result[@"State"] intValue] == 1500 || [result[@"State"] intValue] == 1501){
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            
        }];
    }];
    confimBut.enabled = NO;
    [self.view addSubview:confimBut];
    
    [redLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [remindLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(redLab.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [lineLab0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(remindLab.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(1);
    }];
    
    [putTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineLab0.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(80);
    }];
    
    [lineLab1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(putTextView.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(1);
    }];

    [confimBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineLab1.mas_bottom).mas_offset(28);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(40);
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *realTextViewText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
    }
    if ([realTextViewText isEqualToString:CHLocalizedString(@"我是...", nil)] || [realTextViewText isEqualToString:@""]) {
        confimBut.enabled = NO;
    }
    else{
        confimBut.enabled = YES;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:CHLocalizedString(@"我是...", nil)]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = CHLocalizedString(@"我是...", nil);
        textView.textColor = CHUIColorFromRGB(0x808080, 1.0);
        confimBut.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
