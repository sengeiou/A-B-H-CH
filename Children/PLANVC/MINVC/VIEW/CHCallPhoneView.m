//
//  CHCallPhoneView.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/11/3.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHCallPhoneView.h"

@interface CHCallPhoneView ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>
@property (nonatomic, strong) CHTextField *textField;
@property (nonatomic, strong) CHButton *canBut, *conBut;
@property (nonatomic, strong) UIView *alerView;
@end

@implementation CHCallPhoneView
@synthesize textField,canBut,conBut,alerView;

- (instancetype)initWithcallBackBlock:(phoneCallBack)backBlock{
    self = [[CHCallPhoneView alloc] initWithFrame:CHMainScreen];
    [CHNotifictionCenter addObserver:self selector:@selector(KeyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [CHNotifictionCenter addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self createUIBlock:backBlock];
    return self;
}

- (void)createUIBlock:(phoneCallBack)backBlock{
    alerView = [[UIView alloc] init];
    alerView.backgroundColor = [UIColor whiteColor];
    alerView.layer.cornerRadius = 8.0;
    alerView.layer.masksToBounds = YES;
    [self addSubview:alerView];
    @WeakObj(self)
    CGRect labR = [CHCalculatedMode CHCalculatedWithStr:CHLocalizedString(@"location_monTit", nil)
                                                   size:CGSizeMake(CHMainScreen.size.width - (80 + 32), 100) attributes:@{NSFontAttributeName:CHFontNormal(nil, 16)}];
    CGFloat height = (labR.size.height + 16) > 50 ? (labR.size.height + 16) : 50;
    
    CHLabel *lab0 = [CHLabel createWithTit:CHLocalizedString(@"location_monTit", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:1];
    lab0.numberOfLines = 0;
    [alerView addSubview:lab0];
    
    CHLabel *lab1 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] textAlignment:0];
    [alerView addSubview:lab1];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    CHButton *phoneBut = [CHButton createWithNorImage:[UIImage imageNamed:@"icon_txl"] lightIma:[UIImage imageNamed:@"icon_txl"] touchBlock:^(CHButton *sender) {
        @StrongObj(self)
        self.alerView.hidden = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self JudgeAddressBookPower];
        });
    }];
    phoneBut.frame = CGRectMake(0, 0, 25, 25);
    phoneBut.center = CGPointMake(25/2.0, 25/2.0);
    [backView addSubview:phoneBut];
    
    UILabel *lab2 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:[UIColor colorWithRed:247/255.0 green:138/255.0 blue:0 alpha:1.0] textAlignment:0];
    [backView addSubview:lab2];
    
    NSString *text = [CHDefaultionfos CHgetValueforKey:CALLPHONE];
    textField = [CHTextField createWithPlace:CHLocalizedString(@"location_input", nil) text:nil textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) font:CHFontNormal(nil, 16)];
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypePhonePad;
    textField.text = text ? text:@"";
    [alerView addSubview:textField];
    [alerView addSubview:backView];
    
    CHLabel *lab3 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] textAlignment:0];
    [alerView addSubview:lab3];
    
    CHLabel *lab4 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0] textAlignment:0];
    [alerView addSubview:lab4];
    
    canBut = [CHButton createWithTit:CHLocalizedString(@"aler_cnacel", nil) titColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) textFont:CHFontNormal(nil, 16) backColor:nil touchBlock:^(CHButton *sender) {
        [selfWeak removeFromSuperview];
    }];
    [alerView addSubview:canBut];
    
    conBut = [CHButton createWithTit:CHLocalizedString(@"location_nixt", nil) titColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textFont:CHFontNormal(nil, 16) backColor:nil touchBlock:^(CHButton *sender) {
        @StrongObj(self)
        backBlock(self.textField.text);
        [selfWeak removeFromSuperview];
    }];
    [conBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    conBut.enabled = NO;
    [alerView addSubview:conBut];
    
    [alerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0).mas_offset(-80);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(CHMainScreen.size.width - 80);
        make.height.mas_equalTo(90 + height);
    }];
    
    [lab0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(height);
    }];
    
    [lab1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab0.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab1.mas_bottom);
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    [phoneBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    //    backView.backgroundColor = [UIColor greenColor];
    //    textField.backgroundColor = [UIColor redColor];
    [lab2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(backView.mas_centerY);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(1);
    }];
    
    [textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView.mas_top);
        //        make.top.mas_equalTo(lab1.mas_bottom);
        make.bottom.mas_equalTo(backView.mas_bottom);
        make.left.mas_equalTo(lab2.mas_right).mas_offset(16);
        make.right.mas_equalTo(-8);
        //        make.width.mas_equalTo(50);
        //         make.height.mas_equalTo(44);
    }];
    
    [lab3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [lab4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab3.mas_bottom);
        make.left.mas_equalTo(canBut.mas_right);
        make.width.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    
    [canBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab3.mas_bottom);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo((CHMainScreen.size.width - 80)/2 - 0.5);
    }];
    
    [conBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab3.mas_bottom);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo((CHMainScreen.size.width - 80)/2 - 0.5);
    }];
    [textField becomeFirstResponder];
}

- (void)KeyboardWillChange:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    CGRect KeyboardFrame = [dict[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat KeyboardY = KeyboardFrame.origin.y;
    NSLog(@"KeyboardWillChange %f  %f  %f",KeyboardY,self.alerView.frame.size.height,KeyboardFrame.size.height);
    //获取动画时间
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    //    CGFloat transY =  KeyboardY  - self.view.frame.size.height / 1.5;
    CGFloat transY = -34;
    NSLog(@"%f KeyboardWillChange %f",KeyboardY,transY);
    //动画
    [UIView animateWithDuration:duration animations:^{
        self.alerView.transform = CGAffineTransformMakeTranslation(0, transY);
    }];
}

- (void)KeyboardWillHide:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.alerView.transform = CGAffineTransformIdentity;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (aString.length > 0) {
        conBut.enabled = YES;
    }else{
        conBut.enabled = NO;
    }
    return YES;
}

#pragma mark -- CNContactPickerDelegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        /// 联系人
        NSString *contactStr = @"";
        if ([contactProperty.key isEqualToString:@"phoneNumbers"]) {
            contactStr = [NSString stringWithFormat:@"%@",[contactProperty.value stringValue]];
        }
        else{
            return ;
            //   contactStr = [NSString stringWithFormat:@"%@",contactProperty.value];
        }
        NSString *text1 = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
        
        NSString *contactNStr = @"";
        NSArray *contactArr = [contactStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()-"]];
        for (NSString *str in contactArr) {
            if (![str isEqualToString:@"("] || ![str isEqualToString:@")"] || ![str isEqualToString:@"-"] || ![str isEqualToString:@""]) {
                contactNStr = [contactNStr stringByAppendingString:[str stringByReplacingOccurrencesOfString:@" " withString:@""]];
            }
        }
        self.textField.text = contactNStr;
        self.alerView.hidden = NO;
        if (self.textField.text.length > 0) {
            conBut.enabled = YES;
        }else{
            conBut.enabled = NO;
        }
        NSLog(@"联系人：%@, 电话：%@",text1,contactNStr);
    }];
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        self.alerView.hidden = NO;
    }];
}

- (void)callAddressBook:(BOOL)isUp_ios_9 {
    //    alerVC.view.hidden = YES;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (isUp_ios_9) {
        CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        [app.window.rootViewController presentViewController:contactPicker animated:YES completion:nil];
    }else {
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        [app.window.rootViewController presentViewController:peoplePicker animated:YES completion:nil];
    }
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
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        if (property == 3 || property == 4) {
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property == 3 ? kABPersonPhoneProperty:kABPersonEmailProperty);
            //       ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
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
            self.textField.text = contactStr;
            NSLog(@"联系人：%@, 电话：%@  *** contactStr: %@",text1,text2,contactStr0);
        }
        self.alerView.hidden = NO;
        if (self.textField.text.length > 0) {
            conBut.enabled = YES;
        }else{
            conBut.enabled = NO;
        }
    }];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window.rootViewController dismissViewControllerAnimated:YES completion:^{
    self.alerView.hidden = NO;
        }];
}
@end
