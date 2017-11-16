//
//  CHSOSViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHSOSViewController.h"
#import "CHPhotoView.h"
#import "CHPhoneBookMode.h"

@interface CHSOSViewController ()
{
    bool passInt1;
    bool passInt2;
    bool passInt3;
}
@property (nonatomic, strong) CHTextField *phoneField;
@property (nonatomic, strong) CHTextField *phoneField1;
@property (nonatomic, strong) CHTextField *phoneField2;
@property (nonatomic, strong) CHTextField *selectField;
@property (nonatomic, strong) CHButton *confimBut;
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) NSMutableArray <CHPhoneBookMode *>* sosList;
@end

@implementation CHSOSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray <CHPhoneBookMode *>*)sosList{
    if (!_sosList) {
        _sosList = [NSMutableArray array];
    }
    return _sosList;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)createUI{
    self.title = CHLocalizedString(@"device_set_sos", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    CHLabel *phoneTit = [CHLabel createWithTit:CHLocalizedString(@"device_set_phoneO", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:phoneTit];
    
    CHLabel *line2 = [CHLabel createWithTit:nil font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line2];
    
    self.phoneField = [CHTextField createWithPlace:CHLocalizedString(@"login_inputPhone", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) font:CHFontNormal(nil, 16)];
    self.phoneField.delegate = self;
    self.phoneField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:self.phoneField];
    
    @WeakObj(self)
    UIImageView *phoneIma = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_txl"] backColor:nil imageTouchedBlock:^(UIImageView *sender, UIGestureRecognizerState recognizerState) {
        selfWeak.selectField = selfWeak.phoneField;
        NSLog(@"imageTouchedBlock");
        [selfWeak JudgeAddressBookPower];
    } eventId:@""];
    [self.view addSubview:phoneIma];
    
    CHLabel *line3 = [CHLabel createWithTit:nil font:CHFontNormal(nil, 14) textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line3];
    
    CHLabel *phoneTit1 = [CHLabel createWithTit:CHLocalizedString(@"device_set_phoneT", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:phoneTit1];
    
    CHLabel *line2_1 = [CHLabel createWithTit:nil font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line2_1];
    
    self.phoneField1 = [CHTextField createWithPlace:CHLocalizedString(@"login_inputPhone", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) font:CHFontNormal(nil, 16)];
    self.phoneField1.delegate = self;
    self.phoneField1.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:self.phoneField1];
    
    UIImageView *phoneIma1 = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_txl"] backColor:nil imageTouchedBlock:^(UIImageView *sender, UIGestureRecognizerState recognizerState) {
         selfWeak.selectField = selfWeak.phoneField1;
        NSLog(@"imageTouchedBlock");
        [selfWeak JudgeAddressBookPower];
    } eventId:@""];
    [self.view addSubview:phoneIma1];
    
    CHLabel *line3_2 = [CHLabel createWithTit:nil font:CHFontNormal(nil, 14) textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line3_2];
    
    CHLabel *phoneTit2 = [CHLabel createWithTit:CHLocalizedString(@"device_set_phoneTr", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:phoneTit2];
    
    CHLabel *line2_2 = [CHLabel createWithTit:nil font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line2_2];
    
    self.phoneField2 = [CHTextField createWithPlace:CHLocalizedString(@"login_inputPhone", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) font:CHFontNormal(nil, 16)];
    self.phoneField2.delegate = self;
    self.phoneField2.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:self.phoneField2];
    
    UIImageView *phoneIma3 = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_txl"] backColor:nil imageTouchedBlock:^(UIImageView *sender, UIGestureRecognizerState recognizerState) {
         selfWeak.selectField = selfWeak.phoneField2;
        NSLog(@"imageTouchedBlock");
        [selfWeak JudgeAddressBookPower];
    } eventId:@""];
    [self.view addSubview:phoneIma3];
    
    CHLabel *line3_3 = [CHLabel createWithTit:nil font:CHFontNormal(nil, 14) textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line3_3];
    
    UITextView *textView = [UITextView new];
    textView.editable = NO;
    textView.selectable = NO;
    textView.textColor = CHUIColorFromRGB(0x757575, 1.0);
    textView.font = CHFontNormal(nil, 12);
    textView.text = CHLocalizedString(@"device_set_sosMes", nil);
    [self.view addSubview:textView];
        
    
    _confimBut = [CHButton createWithTit:CHLocalizedString(@"aler_confirm", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        [selfWeak addSosPhone];
    }];
    _confimBut.enabled = NO;
    [self.view addSubview:_confimBut];
    
    [phoneTit mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(25);
    }];
    
    [line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneTit.mas_bottom).mas_equalTo(4);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(1);
    }];
    
    [phoneIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(40);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [self.phoneField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneIma.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(phoneIma);
        make.height.mas_equalTo(44);
        make.right.mas_offset(-30);
    }];
    
    [line3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneIma.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(1);
    }];
    
    [phoneTit1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneField.mas_bottom).mas_offset(18);
        make.left.mas_equalTo(25);
    }];
    
    [line2_1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneTit1.mas_bottom).mas_equalTo(4);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(1);
    }];
    
    [phoneIma1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2_1.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(40);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [self.phoneField1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneIma1.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(phoneIma1);
        make.height.mas_equalTo(44);
        make.right.mas_offset(-30);
    }];
    
    [line3_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneIma1.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(1);
    }];
    
    
    [phoneTit2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneField1.mas_bottom).mas_offset(18);
        make.left.mas_equalTo(25);
    }];
    
    [line2_2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneTit2.mas_bottom).mas_equalTo(4);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(1);
    }];
    
    [phoneIma3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2_2.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(40);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [self.phoneField2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneIma3.mas_right).mas_offset(12);
        make.centerY.mas_equalTo(phoneIma3);
        make.height.mas_equalTo(44);
        make.right.mas_offset(-30);
    }];
    
    [line3_3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneIma3.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(1);
    }];
    
    [_confimBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30 - HOME_INDICATOR_HEIGHT);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
    }];
    
    [textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line3_3.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.bottom.mas_equalTo(_confimBut.mas_top).mas_offset(-8);
    }];
}

- (void)updateUI{
    NSArray *array = @[self.phoneField,self.phoneField1,self.phoneField2];
    for (int i = 0; i < self.sosList.count; i ++) {
        CHPhoneBookMode *model = self.sosList[i];
        if (i < 3) {
            UITextField *field = [array objectAtIndex:i];
            field.text = model.phone;
            if (_phoneField == field) {
                if (field.text.length > 0) {
                    passInt1 = YES;
                }
                else{
                    passInt1 = NO;
                }
            }
            if (_phoneField1 == field) {
                if (field.text.length > 0) {
                    passInt2 = YES;
                }
                else{
                    passInt2 = NO;
                }
            }
            if (_phoneField2 == field) {
                if (field.text.length > 0) {
                    passInt3 = YES;
                }
                else{
                    passInt3 = NO;
                }
            }
        }
    }
    if (passInt1 && passInt2 && passInt3) {
        self.confimBut.enabled = YES;
    }
    else{
        self.confimBut.enabled = NO;
    }
}

- (void)initializeMethod{
    _user = [CHAccountTool user];
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"DeviceId":self.user.deviceId}];
    @WeakObj(self)
    
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_CommandList parameters:dic Mess:nil showError:NO progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        @StrongObj(self)
        for (NSDictionary *dic in result[@"Items"]) {
            if ([dic[@"Code"] intValue] == [SOS_PHONE intValue]) {
                NSLog(@"fwgoijgo == %@",dic);
                [self.sosList removeAllObjects];
                [self BreakSosPhoneValue:dic];
                break;
            }
        }
        [self updateUI];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [self updateUI];
    }];
}

- (void)JudgeAddressBookPower {
    ///获取通讯录权限，调用系统通讯录
    [self CheckAddressBookAuthorization:^(bool isAuthorized , bool isUp_ios_9) {
        if (isAuthorized) {
            [self callAddressBook:isUp_ios_9];
        }else {
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }];
}

- (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized , bool isUp_ios_9))block {
    if (Is_up_Ios_9) {
        CNContactStore * contactStore = [[CNContactStore alloc]init];
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                }
                else if (!granted){
                    block(NO,YES);
                }
                else{
                    block(YES,YES);
                }
            }];
        }
        else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized){
            block(YES,YES);
        }
        else {
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }else {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        
        if (authStatus == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error){
                        NSLog(@"Error: %@", (__bridge NSError *)error);
                    }
                    else if (!granted){
                        block(NO,NO);
                    }
                    else{
                        block(YES,NO);
                    }
                });
            });
        }else if (authStatus == kABAuthorizationStatusAuthorized){
            block(YES,NO);
        }else {
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");
        }
    }
}

- (void)callAddressBook:(BOOL)isUp_ios_9 {
    if (isUp_ios_9) {
        CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [self presentViewController:contactPicker animated:YES completion:nil];
    }else {
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        [self presentViewController:peoplePicker animated:YES completion:nil];
    }
}

#pragma mark -- CNContactPickerDelegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    [self dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *contactStr = @"";
        if ([contactProperty.key isEqualToString:@"phoneNumbers"]) {
            contactStr = [NSString stringWithFormat:@"%@",[contactProperty.value stringValue]];
        }
        else{
            return ;
//            contactStr = [NSString stringWithFormat:@"%@",contactProperty.value];
        }
        NSString *text1 = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
        
        NSString *contactNStr = @"";
        NSArray *contactArr = [contactStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()-"]];
        for (NSString *str in contactArr) {
            if (![str isEqualToString:@"("] || ![str isEqualToString:@")"] || ![str isEqualToString:@"-"] || ![str isEqualToString:@""]) {
                contactNStr = [contactNStr stringByAppendingString:[str stringByReplacingOccurrencesOfString:@" " withString:@""]];
            }
        }
         self.selectField.text = contactNStr;
        if (_phoneField.text.length > 0 || _phoneField1.text.length > 0 || _phoneField2.text.length > 0) {
            _confimBut.enabled = YES;
        }
        else{
            _confimBut.enabled = NO;
        }
        NSLog(@"联系人：%@, 电话：%@",text1,contactNStr);
    }];
}

- (void)BreakSosPhoneValue:(NSDictionary *)dic{
    if (dic) {
        NSMutableArray *cmdValues = [[dic[@"CmdValue"] componentsSeparatedByString:@","] mutableCopy];
        if (cmdValues.count <= 0) return;
        NSInteger count = (cmdValues.count)/2;
        for (int i = 0; i < count; i ++) {
            CHPhoneBookMode *model = [[CHPhoneBookMode alloc] init];
            model.name = [TypeConversionMode strongChangeString:cmdValues[0 + i * 2]];
            model.phone = [TypeConversionMode strongChangeString:cmdValues[1 + i * 2]];
            [self.sosList addObject:model];
        }
    }
}

- (void)addSosPhone{
    @WeakObj(self)
    NSArray *sosArr = @[_phoneField.text,_phoneField1.text,_phoneField2.text];
//    NSString *params = [NSString stringWithFormat:@"sos_1,%@,sos_2,%@,sos_3,%@",_phoneField.text,_phoneField1.text,_phoneField2.text];
    NSString *params = @"";
    for(int i = 0; i < 3; i ++){
        NSString *phStr = sosArr[i];
        if(phStr && ![phStr isEqualToString:@""]){
            params = [params stringByAppendingFormat:@"%@sos,%@",[params isEqualToString:@""] ? @"":@",",phStr];
        }
    }
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"DeviceId":[CHAccountTool user].deviceId,
                                    @"DeviceModel": [CHAccountTool user].deviceMo,
                                    @"CmdCode": SOS_PHONE,
                                    @"Params": params,
                                    @"UserId": [CHAccountTool user].userId}];
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_SendCommand parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        if ([result[@"State"] intValue] == 0) {
            [MBProgressHUD showSuccess:CHLocalizedString(@"aler_saveSuss", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [selfWeak.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

#pragma mark -- ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABPropertyID propertyID;
    if (property == 3) {
        propertyID = kABPersonPhoneProperty;
    }
    else{
        propertyID = kABPersonEmailProperty;
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (property == 3 || property == 4) {
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property == 3 ? kABPersonPhoneProperty:kABPersonEmailProperty);
//            ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
            CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
            CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
            CFStringRef anFullName = ABRecordCopyCompositeName(person);
            /// 联系人
            NSString *text1 = [NSString stringWithFormat:@"%@",anFullName];
            /// 电话
            NSString *text2 = (__bridge NSString*)value;
            NSArray *contactArr = [text2 componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()-"]];
            NSString *contactStr = @"";
            for (NSString *str in contactArr) {
                if (![str isEqualToString:@"("] || ![str isEqualToString:@")"] || ![str isEqualToString:@"-"] || ![str isEqualToString:@""]) {
                    contactStr = [contactStr stringByAppendingString:[str stringByReplacingOccurrencesOfString:@" " withString:@""]];
                }
            }
            NSString *contactStr0 = [contactStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//            _phoneField.text = contactStr;
             self.selectField.text = contactStr;
             if (_phoneField.text.length > 0 || _phoneField1.text.length > 0 || _phoneField2.text.length > 0) {
                _confimBut.enabled = YES;
            }
            else{
                _confimBut.enabled = NO;
            }
            NSLog(@"联系人：%@, 电话：%@  *** contactStr: %@",text1,text2,contactStr0);
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn");
    if (_phoneField == textField) {
        [_phoneField1 becomeFirstResponder];
    }
    else if (_phoneField1 == textField){
        [_phoneField2 becomeFirstResponder];
    }
    else{
        [_phoneField2 resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_phoneField == textField) {
        if (aString.length > 0) {
            passInt1 = YES;
        }
        else{
            passInt1 = NO;
        }
    }
    if (_phoneField1 == textField) {
        if (aString.length > 0) {
            passInt2 = YES;
        }
        else{
            passInt2 = NO;
        }
    }
    if (_phoneField2 == textField) {
        if (aString.length > 0) {
            passInt3 = YES;
        }
        else{
            passInt3 = NO;
        }
    }
    if (passInt1 || passInt2 || passInt3) {
        self.confimBut.enabled = YES;
    }
    else{
        self.confimBut.enabled = NO;
    }
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
