//
//  CHDeviceInfoViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHPhotoView.h"
@class CHUserInfo;

@interface CHDeviceInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, assign) BOOL setUser;
@end
