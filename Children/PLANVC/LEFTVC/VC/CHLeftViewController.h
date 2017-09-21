//
//  CHLeftViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/24.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfiniteScrollPicker.h"
#import "MNWheelView.h"
#import "CHBaseViewController.h"
#import "CHMemberViewController.h"
#import "CHJBWViewController.h"
#import "CHHistoryTrackViewController.h"
#import "CHDeviceDataViewController.h"
#import "CHMessViewController.h"
#import "CHMoreSetTableViewController.h"
typedef enum {
    LeftViewControllerRowTypeOne,
    LeftViewControllerRowTypeTwo,
    LeftViewControllerRowTypeThree
}LeftViewControllerRowType;

@protocol LeftViewControllerDelegate <NSObject>

- (void)LeftViewControllerdidSelectRow:(LeftViewControllerRowType)LeftViewControllerRowType;

@end

@interface CHLeftViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) id <LeftViewControllerDelegate> delegate;
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) NSMutableArray *deviceLists;
@property (nonatomic, strong) NSArray *leftArrs;

@end
