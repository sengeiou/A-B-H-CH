//
//  ViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/11.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIPageControl *page;
    UIScrollView *firstScro;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *but = [UIButton new];
    but.backgroundColor = [UIColor blueColor];
//    NSLog(@"CHLocalizedString  %@",CHLocalizedString(@"123 %@",@"0123"));

//    [self.view addSubview:but];
//    @WeakObj(self);
//    [but mas_makeConstraints:^(MASConstraintMaker *make) {
//         @StrongObj(self);
//        make.height.mas_equalTo(42);
//        make.width.mas_greaterThanOrEqualTo(42);
//        make.center.mas_equalTo(self.view);
//        self.view.backgroundColor = [UIColor greenColor];
//    }];
//   [but setTitle:CHLocalizedString(@"123 %@ 12144",nil) forState:UIControlStateNormal];
//    but.titleLabel.font = CHFontNormal(nil, 23);
//    UIFont *fon = [UIFont boldSystemFontOfSize:23];
//    NSLog(@"font %@ \n fontNamr %@",fon,fon.fontName);
    [self createUI];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    firstScro = [UIScrollView new];
    firstScro.pagingEnabled = YES;
    firstScro.showsHorizontalScrollIndicator = NO;
    firstScro.delegate = self;
    [self.view addSubview:firstScro];
    [firstScro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    NSArray *imageArr = @[@"bk_dingwei_1",@"bk_qunliao_2",@"bk_anquanquyu_3",@"bk_jibu_4"];
    NSArray *titArr = @[CHLocalizedString(@"firstLun_loca", nil),CHLocalizedString(@"firstLun_group", nil),CHLocalizedString(@"firstLun_security", nil),CHLocalizedString(@"firstLun_gauge", nil)];
    NSArray *mesArr = @[CHLocalizedString(@"firstLun_locaMes", nil),CHLocalizedString(@"firstLun_groupMes", nil),CHLocalizedString(@"firstLun_securityMes", nil),CHLocalizedString(@"firstLun_gaugeMes", nil)];
     firstScro.contentSize = CGSizeMake(CHMainScreen.size.width * imageArr.count, CHMainScreen.size.height);
    for (int i = 0; i < imageArr.count; i ++) {
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = i%2? [UIColor yellowColor]:[UIColor blueColor];
        imageView.image = [UIImage imageNamed:[imageArr objectAtIndex:i]];
        [firstScro addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CHMainScreen.size);
            make.centerX.mas_equalTo((CHMainScreen.size.width * i));
            make.centerY.mas_equalTo(firstScro);
        }];
        
        UILabel *titLab = [UILabel new];
        titLab.text = titArr[i];
        titLab.font = [UIFont systemFontOfSize:17];
        titLab.textAlignment = NSTextAlignmentCenter;
        titLab.textColor = [UIColor blackColor];
        titLab.font = CHFontNormal(nil, 30);
        [firstScro addSubview:titLab];
        [titLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView);
            make.centerY.mas_equalTo(imageView).mas_offset(75);
        }];
        
        UILabel *mesLab = [UILabel new];
        mesLab.text = mesArr[i];
        mesLab.font = [UIFont systemFontOfSize:17];
        mesLab.textAlignment = NSTextAlignmentCenter;
        mesLab.textColor = [UIColor blackColor];
        mesLab.font = CHFontNormal(nil, 16);
        mesLab.numberOfLines = 0;
        [firstScro addSubview:mesLab];
        [mesLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView);
            make.top.mas_equalTo(titLab.mas_bottom).mas_offset(20);
            make.width.mas_equalTo(CHMainScreen.size.width - 40);
        }];
        
        if (i == imageArr.count - 1) {
            imageView.userInteractionEnabled = YES;
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.backgroundColor = CHUIColorFromRGB(0x28ccfa, 1.0);
            but.layer.masksToBounds = YES;
            but.layer.cornerRadius = 35.0/2;
            [but setTitle:CHLocalizedString(@"firstLun_experience", nil) forState:UIControlStateNormal];
            [but addTarget:self action:@selector(tapExperience) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:but];
            [but mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(imageView);
                make.bottom.mas_equalTo(self.view).mas_offset(-60);
                make.width.mas_equalTo(imageView.mas_width).mas_offset(-80);
                make.height.mas_equalTo(35);
            }];
        }
    }
    
    page = [UIPageControl new];
    page.numberOfPages = imageArr.count;
    page.pageIndicatorTintColor = [UIColor lightGrayColor];
    page.currentPageIndicatorTintColor = CHUIColorFromRGB(0x28ccfa, 1.0);
    [page addTarget:self action:@selector(didPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:page];
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-30);
        make.centerX.mas_equalTo(firstScro);
        make.width.mas_equalTo(CHMainScreen.size.width - 40);
        make.height.mas_equalTo(20);
    }];
    
//    UIImageView *logoView = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_haoma"] backColor:nil];
    
}

- (void)didPage{
     page.currentPage = firstScro.contentOffset.x/CHMainScreen.size.width;
}

- (void)tapExperience{
    [CHDefaultionfos CHputKey:CHFIRSTLUN andValue:CHFIRSTLUN];
//    CHNavViewController *nav = [[CHNavViewController alloc] initWithRootViewController:[[CHRegAnLogViewController alloc] init]];
    CHKLTViewController *nav = [[CHKLTViewController alloc] initWithRootViewController:[[CHRegAnLogViewController alloc] init]];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = nav;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    page.currentPage = scrollView.contentOffset.x/CHMainScreen.size.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
