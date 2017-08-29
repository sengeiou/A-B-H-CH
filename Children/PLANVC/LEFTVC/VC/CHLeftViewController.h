//
//  CHLeftViewController.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/24.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    LeftViewControllerRowTypeOne,
    LeftViewControllerRowTypeTwo,
    LeftViewControllerRowTypeThree
}LeftViewControllerRowType;

@protocol LeftViewControllerDelegate <NSObject>

- (void)LeftViewControllerdidSelectRow:(LeftViewControllerRowType)LeftViewControllerRowType;

@end

@interface CHLeftViewController : UIViewController
@property (nonatomic, weak) id <LeftViewControllerDelegate> delegate;
@end
