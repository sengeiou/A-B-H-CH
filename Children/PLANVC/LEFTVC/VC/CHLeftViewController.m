//
//  CHLeftViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/24.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHLeftViewController.h"


@interface CHLeftViewController ()
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) NSMutableArray *deviceLists;
@property (nonatomic, strong) NSArray *leftArrs;
@property (nonatomic, strong) AppDelegate *app;
@end

@implementation CHLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
    self.deviceLists = [[FMDBConversionMode sharedCoreBlueTool] searchDevice:self.user];
    self.app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CHUserInfo *addUser = [[CHUserInfo alloc] init];
    addUser.deviceIm = [UIImageJPEGRepresentation([UIImage imageNamed:@"leftbar_tjsb"], 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    addUser.deviceNa = CHLocalizedString(@"添加设备", nil);
    [self.deviceLists addObject:addUser];
    
    NSUInteger deInte = 0;
    for (CHUserInfo *deUse in self.deviceLists) {
        if ([deUse.deviceId isEqualToString:self.user.deviceId]) {
            deInte = [self.deviceLists indexOfObject:deUse];
        }
    }
     NSInteger mid = self.deviceLists.count/2;
    [self.deviceLists exchangeObjectAtIndex:mid withObjectAtIndex:deInte];
    self.leftArrs = @[@[[UIImage imageNamed:@"leftbar_jtcy"],CHLocalizedString(@"家庭成员", nil)],@[[UIImage imageNamed:@"leftbar_aqwl"],CHLocalizedString(@"安全围栏", nil)],@[[UIImage imageNamed:@"leftbar_lsgj"],CHLocalizedString(@"历史轨迹", nil)],@[[UIImage imageNamed:@"leftbar_bbsb"],CHLocalizedString(@"宝贝手表", nil)],@[[UIImage imageNamed:@"leftbar_xxzx"],CHLocalizedString(@"消息中心", nil)],@[[UIImage imageNamed:@"leftbar_sz"],CHLocalizedString(@"更多设置", nil)]];
}

- (CHUserInfo *)user{
    if (!_user) {
        _user = [CHAccountTool user];
    }
    return _user;
}

- (void)createUI{
    self.view.backgroundColor = [UIColor greenColor];

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth - kMainPageDistance), 190 * WIDTHAdaptive)];
    headView.backgroundColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    [self.view addSubview:headView];
    
    MNWheelView *wheelView = [[MNWheelView alloc] initWithFrame:CGRectMake(0, 20, (kScreenWidth - kMainPageDistance) - 30, 140 * WIDTHAdaptive)];
    [headView addSubview:wheelView];
    wheelView.center = CGPointMake(((kScreenWidth - kMainPageDistance))/2, wheelView.center.y);
    wheelView.images = self.deviceLists;
    wheelView.click = ^(CHDeviceView *user){
         NSLog(@"11单击 %@",user);
    };
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:wheelView.bounds];
    
    CAShapeLayer *makeLayer = [CAShapeLayer layer];
    makeLayer.frame = wheelView.bounds;
    makeLayer.backgroundColor = [UIColor clearColor].CGColor;
    makeLayer.path = path.CGPath;
    wheelView.layer.mask = makeLayer;
    
    UIImageView *electricityView = [UIImageView itemWithImage:[UIImage imageNamed:@"leftbar_dl_1"] backColor:nil];
    [headView addSubview:electricityView];
    
    CHLabel *electricityLab = [CHLabel createWithTit:@"100%" font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(0xffffff, 1.0) backColor:nil textAlignment:1];
    [headView addSubview:electricityLab];
    
    UITableView *leftTab = [UITableView new];
    leftTab.delegate = self;
    leftTab.dataSource = self;
    leftTab.tableFooterView = [UIView new];
    [self.view addSubview:leftTab];
    
    [electricityLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-4);
        make.left.mas_equalTo(16);
    }];
    
    [electricityView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(electricityLab.mas_top).mas_offset(-2);
        make.left.mas_equalTo(electricityLab.mas_left);
        make.width.mas_equalTo(28 * WIDTHAdaptive);
        make.height.mas_equalTo(15 * WIDTHAdaptive);
    }];
    
    [leftTab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo((kScreenWidth - kMainPageDistance));
    }];
    
//    if ([leftTab respondsToSelector:@selector(setSeparatorInset:)]) {
        [leftTab setSeparatorInset:UIEdgeInsetsMake(0,12, 0, 0)];
//          [leftTab setSeparatorInset: UIEdgeInsetsZero];
//    }
//    if ([leftTab respondsToSelector:@selector(setSeparatorColor:)]) {
        [leftTab setSeparatorColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0)];
//    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *leftCell = @"LEFTCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:leftCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.imageView.image = self.leftArrs[indexPath.row][0];
    cell.textLabel.text = self.leftArrs[indexPath.row][1];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57 * WIDTHAdaptive;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"fwgg == %@",self.app.leftSliderViewController.mainVC);
//    [(CHKLTViewController *)self.app.leftSliderViewController.mainVC pushViewController:[[CHBaseViewController alloc] init] animated:YES];
    NSString * postName = @"HomePagePush";
    [[NSNotificationCenter defaultCenter] postNotificationName:postName object:nil userInfo:@{@"pushViewController":[[CHBaseViewController alloc] init]}];
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
