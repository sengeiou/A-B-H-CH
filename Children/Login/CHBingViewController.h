//
//  CHBingViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/21.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CHInputViewController.h"
#import "CHDeviceInfoViewController.h"

@interface CHBingViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *scanSession;
@end
