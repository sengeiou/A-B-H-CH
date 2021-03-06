//
//  CHUserSetViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHUserSetViewController.h"

@interface CHUserSetViewController ()
@property (nonatomic, strong) UITableView *setTab;
@property (nonatomic, strong) NSArray *setTits;
@property (nonatomic, strong) NSArray *headTits;
@end

@implementation CHUserSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (NSArray *)setTits{
    if (!_setTits) {
        //        _setTits = @[@[@[CHLocalizedString(@"用户资料", nil),CHLocalizedString(@"申请消息", nil)],@[[UIImage drawWithSize:CGSizeMake(20 * WIDTHAdaptive, 20 * WIDTHAdaptive) Radius:0 image:[UIImage imageNamed:@"icon_yhzl"]],[UIImage drawWithSize:CGSizeMake(20 * WIDTHAdaptive, 20 * WIDTHAdaptive) Radius:0 image:[UIImage imageNamed:@"icon_sqxx"]]]],@[@[CHLocalizedString(@"修改密码", nil),CHLocalizedString(@"版本", nil),CHLocalizedString(@"意见反馈", nil),CHLocalizedString(@"关于我们", nil)],@[[UIImage drawWithSize:CGSizeMake(20 * WIDTHAdaptive, 20 * WIDTHAdaptive) Radius:0 image:[UIImage imageNamed:@"icon_xgmm"]],[UIImage drawWithSize:CGSizeMake(20 * WIDTHAdaptive, 20 * WIDTHAdaptive) Radius:0 image:[UIImage imageNamed:@"icon_jcgx"]],[UIImage drawWithSize:CGSizeMake(20 * WIDTHAdaptive, 20 * WIDTHAdaptive) Radius:0 image:[UIImage imageNamed:@"icon_yjfk"]],[UIImage drawWithSize:CGSizeMake(20 * WIDTHAdaptive, 20 * WIDTHAdaptive) Radius:0 image:[UIImage imageNamed:@"icon_gywm"]]]]];
        _setTits = @[@[@[CHLocalizedString(@"user_userInfo", nil),CHLocalizedString(@"user_requestMes", nil)],@[[UIImage imageNamed:@"icon_yhzl"],[UIImage imageNamed:@"icon_sqxx"]]],@[@[CHLocalizedString(@"user_changePas", nil),CHLocalizedString(@"user_version", nil),/*CHLocalizedString(@"user_faceBack", nil),*/CHLocalizedString(@"user_aboutAs", nil)],@[[UIImage imageNamed:@"icon_xgmm"],[UIImage imageNamed:@"icon_jcgx"],/*[UIImage imageNamed:@"icon_yjfk"],*/[UIImage imageNamed:@"icon_gywm"]]]];
    }
    return _setTits;
}

- (NSArray *)headTits{
    if (!_headTits) {
        _headTits = @[CHLocalizedString(@"user_account", nil),CHLocalizedString(@"user_moreSet", nil)];
    }
    return _headTits;
}

- (void)createUI{
    self.title = CHLocalizedString(@"user_appSet", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    _setTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _setTab.delegate = self;
    _setTab.dataSource = self;
    _setTab.tableFooterView = [UIView new];
    [_setTab setSeparatorInset:UIEdgeInsetsMake(0, CHMainScreen.size.width, 0, 0)];
    [self.view addSubview:_setTab];
    
    @WeakObj(self)
    CHButton *signOutBut = [CHButton createWithTit:CHLocalizedString(@"user_logOut", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 18) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:CHLocalizedString(@"user_outMes", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *conFimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [JPUSHService setAlias:@"U1" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"fiowjiogj iojg3333222222222222222222222 j %ld",(long)iResCode);
            } seq:0];
            CHUserInfo *user = [[CHUserInfo alloc] init];
            [CHAccountTool saveUser:user];
            [CHDefaultionfos CHremoveValueForKey:CHAPPTOKEN];
            CHKLTViewController *nav = [[CHKLTViewController alloc] initWithRootViewController:[[CHRegAnLogViewController alloc] init]];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.window.rootViewController = nav;
        }];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_cnacel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [aler addAction:cancelAct];
        [aler addAction:conFimAct];
        [selfWeak presentViewController:aler animated:YES completion:^{
            
        }];
    }];
    [self.view addSubview:signOutBut];
    
    [signOutBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20 - HOME_INDICATOR_HEIGHT);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
    }];
    
    [_setTab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(signOutBut.mas_top).mas_offset(-8);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.setTits.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.setTits[section] firstObject] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 * WIDTHAdaptive;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *setIndex = @"SETCELL";
    CHSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:setIndex];
    if (!cell) {
        cell = [[CHSetTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:setIndex];
    }
    cell.headImage.image = [self.setTits[indexPath.section] lastObject][indexPath.row];
    cell.textLab.text = [self.setTits[indexPath.section] firstObject][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = @"";
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.font = CHFontNormal(nil, 12);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    }
    cell.line1.hidden = YES;
    if (indexPath.row == ([[self.setTits[indexPath.section] firstObject] count] - 1)) {
        cell.line1.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 33;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CHMainScreen.size.width, 33)];
    baseView.backgroundColor = [UIColor whiteColor];
    UILabel *textLab = [CHLabel createWithTit:self.headTits[section] font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:nil textAlignment:0];
    [baseView addSubview:textLab];
    [textLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(19);
        make.bottom.mas_equalTo(-4);
    }];
    return baseView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        CHDeviceInfoViewController *userVC = [[CHDeviceInfoViewController alloc] init];
        userVC.user = [CHAccountTool user];
        userVC.setUser = YES;
        [self.navigationController pushViewController:userVC animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self.navigationController pushViewController:[[CHRequestTableViewController alloc] init] animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self.navigationController pushViewController:[[CHChangePassViewController alloc] init] animated:YES];
    }
//    if (indexPath.section == 1 && indexPath.row == 2) {
//        [self.navigationController pushViewController:[[CHFeedbackViewController alloc] init] animated:YES];
//    }
//    if (indexPath.section == 1 && indexPath.row == 3){
     if (indexPath.section == 1 && indexPath.row == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.smawatch.com"]];
    }
    
}

- (void)dealloc{
    
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
