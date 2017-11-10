//
//  CHSAddGuarderViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/11.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>
#import "CHAdressMode.h"
#import <MessageUI/MessageUI.h>

@interface CHSAddGuarderViewController : UIViewController<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic, assign) BOOL isAddress;
@property (nonatomic, strong) CHAdressMode *mode;
@property (nonatomic, strong) NSArray *itemArrs;
@property (nonatomic, strong) NSMutableArray *cmdList;
@property (nonatomic, strong) MFMessageComposeViewController *messVC;
@end
