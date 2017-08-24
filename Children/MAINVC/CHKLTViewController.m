//
//  CHKLTViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHKLTViewController.h"

@interface CHKLTViewController ()

@end

@implementation CHKLTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //解决无法左滑返回问题
    self.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self setBackgroudImage:[UIImage new]];
    //     [self setBackgroudImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) size:CGSizeMake(CHMainScreen.size.width, 44)]];
    [self setStatusbarBackgroundColor:CHUIColorFromRGB(0x28ccfa, 1.0)];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:CHFontNormal(nil, 18),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if (!self.backImage) {
        self.backImage = [UIImage imageNamed:@"btu_fanhui_w"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count >= 1) {
        if (!self.backImage) {
            self.backImage = [UIImage imageNamed:@"btu_fanhui_w"];
        }
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithIma:self.backImage target:self action:@selector(didClickBackBarButtonItem:)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)didClickBackBarButtonItem:(id)sender{
    [self.view endEditing:YES];
    [self popViewControllerAnimated:YES];
}

//解决无法左滑返回问题
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.childViewControllers.count > 1;
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
