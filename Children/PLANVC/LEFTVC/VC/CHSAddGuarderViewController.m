//
//  CHSAddGuarderViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/11.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHSAddGuarderViewController.h"

@interface CHSAddGuarderViewController ()

@property (nonatomic, strong) CHTextField *relationField;
@property (nonatomic, strong) CHTextField *phoneField;
@property (nonatomic, strong) CHButton *confimBut;
@end

@implementation CHSAddGuarderViewController

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = CHLocalizedString(@"添加新成员", nil);
    CHLabel *relatioTit = [CHLabel createWithTit:CHLocalizedString(@"关系", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:relatioTit];
    
    CHLabel *line0 = [CHLabel createWithTit:nil font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line0];
    
    self.relationField = [CHTextField createWithPlace:CHLocalizedString(@"与宝贝关系", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) font:CHFontNormal(nil, 16)];
    self.relationField.delegate = self;
    [self.view addSubview:self.relationField];
    
    CHLabel *line1 = [CHLabel createWithTit:nil font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line1];
    
    CHLabel *phoneTit = [CHLabel createWithTit:CHLocalizedString(@"手机号码", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:phoneTit];
    
    CHLabel *line2 = [CHLabel createWithTit:nil font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line2];
    
    self.phoneField = [CHTextField createWithPlace:CHLocalizedString(@"请输入电话号码", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) font:CHFontNormal(nil, 16)];
    self.phoneField.delegate = self;
    self.phoneField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:self.phoneField];
    
    @WeakObj(self)
    UIImageView *phoneIma = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_txl"] backColor:nil imageTouchedBlock:^(UIImageView *sender, UIGestureRecognizerState recognizerState) {
        NSLog(@"imageTouchedBlock");
        [selfWeak JudgeAddressBookPower];
    } eventId:@""];
    [self.view addSubview:phoneIma];
    
    CHLabel *line3 = [CHLabel createWithTit:nil font:CHFontNormal(nil, 14) textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line3];
    
    _confimBut = [CHButton createWithTit:CHLocalizedString(@"确认", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        [selfWeak addGuarder];
    }];
    _confimBut.enabled = NO;
    [self.view addSubview:_confimBut];
    
    [relatioTit mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(31);
    }];
    
    [line0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(relatioTit.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(1);
    }];
    
    [self.relationField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line0.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(44);
    }];
    
    [line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.relationField.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(1);
    }];
    
    [phoneTit mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom).mas_offset(50);
        make.left.mas_equalTo(30);
    }];
    
    [line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneTit.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(1);
    }];
    
    [phoneIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom).mas_offset(18);
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
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(1);
    }];
    
    [_confimBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
    }];
}

- (void)addGuarder{
    if (self.isAddress) {
        NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
        NSString *params = [self arrangeAdressList];
        [dic addEntriesFromDictionary:@{@"DeviceId":[CHAccountTool user].deviceId,
                                        @"DeviceModel": [CHAccountTool user].deviceMo,
                                        @"CmdCode": PHONE_BOOK,
                                        @"Params": params,
                                        @"UserId": [CHAccountTool user].userId}];
        @WeakObj(self)
        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_SendCommand parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
            if ([result[@"State"] intValue] == 0) {
                [MBProgressHUD showSuccess:CHLocalizedString(@"保存成功", nil)];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [selfWeak.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            
        }];
        return;
    }
    @WeakObj(self)
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"Phone": selfWeak.phoneField.text,
                                    @"RelationName": selfWeak.relationField.text,
                                    @"DeviceId":[CHAccountTool user].deviceId,
                                    @"UserId": [CHAccountTool user].userId}];
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_UInviteUser parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        if ([result[@"State"] intValue] == 0) {
            [MBProgressHUD showSuccess:CHLocalizedString(@"邀请成功", nil)];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [selfWeak.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (NSString *)arrangeAdressList{
    self.mode.name = self.relationField.text;
    self.mode.relation = self.relationField.text;
    self.mode.phoneNum = self.phoneField.text;
    NSMutableString *adressLogo = [[NSMutableString alloc] initWithString:@"000"];
    for (CHGuarderItemMode *guarder in self.itemArrs) {
        if ([self.phoneField.text containsString:guarder.RelationPhone]) {
            [adressLogo replaceCharactersInRange:NSMakeRange(1, 1) withString:@"1"];
        }
        if (guarder.IsAdmin && [self.phoneField.text containsString:guarder.RelationPhone]) {
            [adressLogo replaceCharactersInRange:NSMakeRange(0, 1) withString:@"1"];
        }
    }
    self.mode.adressLogo = adressLogo;
    
    NSMutableArray <CHAdressMode *>* cmdList = self.cmdList;
    NSString *alarmListStr = @"";
    for (int i = 0; i < cmdList.count; i ++) {
        alarmListStr = [alarmListStr stringByAppendingString:[NSString stringWithFormat:@"%@%@,%@,%@,%@",i != 0 ? @",":@"",cmdList[i].name,cmdList[i].relation,cmdList[i].adressLogo,cmdList[i].phoneNum]];
    }
    return alarmListStr;
}

- (void)openAddress{
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authorizationStatus != kABAuthorizationStatusAuthorized) {
        //        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\n设置-隐私-通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil nil];
        //        [alart show];
        return;
        
    }
    
    ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
    nav.peoplePickerDelegate = self;
    if([[UIDevice currentDevice].systemVersion floatValue]>=8.0){
        nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
    [self presentViewController:nav animated:YES completion:nil];
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
                if (error)
                {
                    NSLog(@"Error: %@", error);
                }
                else if (!granted)
                {
                    
                    block(NO,YES);
                }
                else
                {
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
                    if (error)
                    {
                        NSLog(@"Error: %@", (__bridge NSError *)error);
                    }
                    else if (!granted)
                    {
                        
                        block(NO,NO);
                    }
                    else
                    {
                        block(YES,NO);
                    }
                });
            });
        }else if (authStatus == kABAuthorizationStatusAuthorized)
        {
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
             contactStr = [NSString stringWithFormat:@"%@",contactProperty.value];
                return;
            }
            NSString *text1 = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
        
            NSString *contactNStr = @"";
            NSArray *contactArr = [contactStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()-"]];
            for (NSString *str in contactArr) {
                if (![str isEqualToString:@"("] || ![str isEqualToString:@")"] || ![str isEqualToString:@"-"] || ![str isEqualToString:@""]) {
                    contactNStr = [contactNStr stringByAppendingString:[str stringByReplacingOccurrencesOfString:@" " withString:@""]];
                }
            }
            _phoneField.text = contactNStr;
            if (_phoneField.text.length > 0 && _relationField.text.length > 0) {
                _confimBut.enabled = YES;
            }
            else{
                _confimBut.enabled = NO;
            }
            NSLog(@"联系人：%@, 电话：%@",text1,contactNStr);
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
            _phoneField.text = contactStr;
            if (_phoneField.text.length > 0 && _relationField.text.length > 0) {
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
    if (_relationField == textField) {
        [_phoneField becomeFirstResponder];
    }
    else{
        [_phoneField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (_phoneField.text.length > 0 && _relationField.text.length > 0) {
        _confimBut.enabled = YES;
    }
    else{
        _confimBut.enabled = NO;
    }
    return YES;
}

////取消选择
//- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
//{
////    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
//    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
//    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
//    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
//
//    if ([phoneNO hasPrefix:@"+"]) {
//        phoneNO = [phoneNO substringFromIndex:3];
//    }
//
//    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
////    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
//
//
//    NSString *firstName=(__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
//    NSString *lastName=(__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
//    NSString *allName;
////    if ([CommandHelp checkStringIsNull:lastName] && [CommandHelp checkStringIsNull:firstName]) {
//        allName = [NSString stringWithFormat:@"%@%@",lastName,firstName];
////    }else if([CommandHelp checkStringIsNull:firstName]){
////        allName = firstName;
////    }else if ([CommandHelp checkStringIsNull:lastName]){
////        allName = lastName;
////    }
//
//
////    if (phone && [CommandHelp checkStringIsNull:phoneNO]) {
//        NSLog(@"====name:%@  phoneNumber:%@",allName,phoneNO);
//        //        [self.tableView reloadData];
////        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
////        return;
////    }
//}
//
//- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
//{
//    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
//    personViewController.displayedPerson = person;
//    [peoplePicker pushViewController:personViewController animated:YES];
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
