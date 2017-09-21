//
//  CHFenceViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHMKMapView.h"
#import "NYSliderPopover.h"

@interface CHFenceViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CHFenceInfoMode *fenceCacheMode;
@property (nonatomic, assign) BOOL changeModeName;
@property (nonatomic, strong) CHUserInfo *user;
@end
