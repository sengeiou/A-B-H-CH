//
//  CHSOSViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHSOSViewController.h"

@interface CHSOSViewController ()
@property (nonatomic, strong) CHTextField *phoneField;
@property (nonatomic, strong) CHTextField *phoneField1;
@property (nonatomic, strong) CHTextField *phoneField2;
@property (nonatomic, strong) CHTextField *selectField;
@property (nonatomic, strong) CHButton *confimBut;
@end

@implementation CHSOSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)createUI{
    self.title = CHLocalizedString(@"SOS设置", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    CHLabel *phoneTit = [CHLabel createWithTit:CHLocalizedString(@"紧急号码一", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:phoneTit];
    
    CHLabel *line2 = [CHLabel createWithTit:nil font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line2];
    
    self.phoneField = [CHTextField createWithPlace:CHLocalizedString(@"请输入电话号码", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) font:CHFontNormal(nil, 16)];
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
    
    CHLabel *phoneTit1 = [CHLabel createWithTit:CHLocalizedString(@"紧急号码二", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:phoneTit1];
    
    CHLabel *line2_1 = [CHLabel createWithTit:nil font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line2_1];
    
    self.phoneField1 = [CHTextField createWithPlace:CHLocalizedString(@"请输入电话号码", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) font:CHFontNormal(nil, 16)];
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
    
    CHLabel *phoneTit2 = [CHLabel createWithTit:CHLocalizedString(@"紧急号码三", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:nil textAlignment:0];
    [self.view addSubview:phoneTit2];
    
    CHLabel *line2_2 = [CHLabel createWithTit:nil font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line2_2];
    
    self.phoneField2 = [CHTextField createWithPlace:CHLocalizedString(@"请输入电话号码", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) font:CHFontNormal(nil, 16)];
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
    textView.text = CHLocalizedString(@"提示：\n 1.建议您保存和宝贝关系最亲密的三个号码 \n2.长按SOS按键超过5秒，触发报警求助，并按次序拨打第一，二，三联系人电话（第一接听人30秒不接，拨打第二联系人，第二接听人30秒不接，拨打第三联系人，依次循环，有人接听时不再拨打） ", nil);
    [self.view addSubview:textView];
        
    
    _confimBut = [CHButton createWithTit:CHLocalizedString(@"确认", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
//        [selfWeak addGuarder];
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
        make.bottom.mas_equalTo(-30);
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
        if (_phoneField.text.length > 0 && _phoneField1.text.length > 0 && _phoneField2.text.length > 0) {
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
             if (_phoneField.text.length > 0 && _phoneField1.text.length > 0 && _phoneField2.text.length > 0) {
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
    if (_phoneField.text.length > 0 && _phoneField1.text.length > 0 && _phoneField2.text.length > 0) {
        _confimBut.enabled = YES;
    }
    else{
        _confimBut.enabled = NO;
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
