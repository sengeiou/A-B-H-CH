//
//  CHMemberViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/9.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHMemberViewController.h"

@interface CHMemberViewController ()

@property (nonatomic, strong) NSArray *musicCategories;
@end

@implementation CHMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 0.0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}


- (NSArray *)musicCategories {
    if (!_musicCategories) {
        _musicCategories = @[CHLocalizedString(@"监护人", nil),CHLocalizedString(@"电话本", nil)];
    }
    return _musicCategories;
}

- (instancetype)init {
    if (self = [super init]) {
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 15;
        self.menuViewStyle = WMMenuViewStyleLine;
        int imtemWidth;
        NSMutableArray *weightArr = [NSMutableArray array];
        for (int i = 0; i < self.musicCategories.count; i ++) {
            CGSize size = [[self.musicCategories objectAtIndex:i] sizeWithAttributes:@{NSFontAttributeName:CHFontNormal(nil, 18)}];
            [weightArr addObject:[NSString stringWithFormat:@"%f",size.width]];
        }
        imtemWidth =[[weightArr valueForKeyPath:@"@max.floatValue"] floatValue];
        self.menuItemWidth = imtemWidth + 3;
        self.titleSizeSelected = 18.0;
        self.titleSizeNormal = 18.0;
        self.titleFontName = @".SFUIText";
        self.menuHeight = 40;
        self.menuBGColor = CHUIColorFromRGB(0xb3e5fc, 1.0);
        self.titleColorSelected = CHUIColorFromRGB(0x0288d1, 1.0);
        self.titleColorNormal = CHUIColorFromRGB(CHMediumBlackColor, 1.0);
        
    }
    return self;
}

- (void)createUI{
    self.title = CHLocalizedString(@"家庭成员", nil);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.musicCategories.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    //创建一个layout布局类
//    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//    //设置布局方向为垂直流布局
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    //设置每个item的大小为100*100
//    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-50)/3, ([UIScreen mainScreen].bounds.size.width-50)/3);
//    SMAWatchCollectionController *vc = [[SMAWatchCollectionController alloc] initWithCollectionViewLayout:layout];
//    watchInfos = @[watchface_recommending,watchface_dynamic,watchface_pointer,watchface_number,watchface_other];
//    vc.watchBucket = [watchInfos objectAtIndex:index];
    CHGuarderViewController *vc = [[CHGuarderViewController alloc] init];
    if (index == 1) {
//        vc.addressBook = YES;
    }
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.musicCategories[index];
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    NSLog(@"%@",viewController);
    CHGuarderViewController *vc = (CHGuarderViewController *)viewController;
    [vc initializeMetod];
    //    NSLog(@"%@", NSStringFromCGPoint(vc.tableView.contentOffset));
    //    if (vc.tableView.contentOffset.y > kWMHeaderViewHeight) {
    //        return;
    //    }
    //    vc.tableView.contentOffset = CGPointMake(0, kNavigationBarHeight + kWMHeaderViewHeight - self.viewTop);
}

- (void)dealloc{
    NSLog(@"dealloc");
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
