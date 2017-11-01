//
//  CHJBWViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHJBWViewController.h"

@interface CHJBWViewController ()
@property (nonatomic, strong) CHLabel *fenceLab;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) CHButton *addBut;

@property (nonatomic, strong) NSMutableArray *fenceList;
@end

@implementation CHJBWViewController

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
    [self initializeMethod];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}

static NSString *fenceIdent = @"FENCECELL";

- (void)initializeMethod{
//    self.user = [CHAccountTool user];
    if (!self.user.deviceId || [self.user.deviceId isEqualToString:@""]) {
        return;
    }
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"DeviceId": self.user.deviceId,
                                    @"MapType": @"AMap"}];
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_GeofenceList parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        @StrongObj(self)
        self.fenceList = [[CHFenceInfoMode mj_objectArrayWithKeyValuesArray:result[@"Items"]] mutableCopy];
//        if (self.fenceList.count < 2) {
            [self addNormalFence];
//        }
        [self checkHomeFence];
        [self setGuarderNum];
        [MBProgressHUD hideHUD];
        [self.table reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [MBProgressHUD hideHUD];
    }];
}

- (void)addNormalFence{
    if (!self.fenceList) {
        self.fenceList = [NSMutableArray array];
    }
    CHFenceInfoMode *homeFence = [[CHFenceInfoMode alloc] init];
    homeFence.FenceName = CHLocalizedString(@"fence_home", nil);
    homeFence.DeviceId = [self.user.deviceId integerValue];
    homeFence.Description = @"安全圈-家";
    
    CHFenceInfoMode *scrollFence = [[CHFenceInfoMode alloc] init];
    scrollFence.FenceName = CHLocalizedString(@"fence_scrool", nil);
    scrollFence.DeviceId = [self.user.deviceId integerValue];
    scrollFence.Description = @"安全圈-学校";
    
    BOOL findHome = NO;
    BOOL findScroll = NO;
    for (int i = 0; i < self.fenceList.count; i ++) {
        CHFenceInfoMode *ode = [self.fenceList objectAtIndex:i];
        if ([ode.Description isEqualToString:@"安全圈-家"]) {
            findHome = YES;
        }
        if ([ode.Description isEqualToString:@"安全圈-学校"]) {
            findScroll = YES;
        }
    }
    if (!findHome) {
         [self.fenceList addObject:homeFence];
    }
    if (!findScroll) {
        [self.fenceList addObject:scrollFence];
    }
//    for (int j = 0; j < self.fenceList.count; j ++) {
//        CHFenceInfoMode *ode = [self.fenceList objectAtIndex:j];
//        if (![ode.Description isEqualToString:@"安全圈-学校"]) {
//           [self.fenceList addObject:scrollFence];
//             break;
//        }
//    }
//    if (self.fenceList.count == 0) {
//        [self.fenceList addObject:homeFence];
//        [self.fenceList addObject:scrollFence];
//    }
}

- (void)checkHomeFence{
//    CHFenceInfoMode *homeFence = [self.fenceList firstObject];
//    if (![homeFence.Description isEqualToString:@"安全圈-家"]) {
//        [self.fenceList exchangeObjectAtIndex:0 withObjectAtIndex:1];
//    }
    for (int i = 0; i < self.fenceList.count; i ++) {
        CHFenceInfoMode *homeFence = [self.fenceList objectAtIndex:i];
        if ([homeFence.Description isEqualToString:@"安全圈-家"]) {
            [self.fenceList exchangeObjectAtIndex:i withObjectAtIndex:0];
        }
        if ([homeFence.Description isEqualToString:@"安全圈-学校"]) {
            [self.fenceList exchangeObjectAtIndex:i withObjectAtIndex:1];
        }
    }
}

- (void)createUI{
    self.title = CHLocalizedString(@"device_fence", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.fenceLab = [CHLabel new];
    [self setGuarderNum];
    [self.view addSubview:self.fenceLab];
    
    @WeakObj(self)
    self.addBut = [CHButton createWithTit:CHLocalizedString(@"device_jbw_add", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        CHFenceViewController *fenceVC = [[CHFenceViewController alloc] init];
        fenceVC.title = CHLocalizedString(@"device_jbw_add", nil);
        fenceVC.changeModeName = YES;
        fenceVC.user = self.user;
        [selfWeak.navigationController pushViewController:fenceVC animated:YES];
    }];
    [self.view addSubview:self.addBut];
    
    self.table = [[UITableView alloc] init];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.tableFooterView = [UIView new];
    [self.table registerClass:[CHFenceTableViewCell class] forCellReuseIdentifier:fenceIdent];
    [self.view addSubview:self.table];
    
    [self.fenceLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    
    [self.addBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30 - HOME_INDICATOR_HEIGHT);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
    }];
    
    [self.table mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fenceLab.mas_bottom).mas_equalTo(9);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.addBut.mas_top).mas_equalTo(-8);
    }];
}

- (void)setGuarderNum{
    NSString *str1 = [NSString stringWithFormat:@"%lu",10 - self.fenceList.count];
    NSString *str = CHLocalizedString(@"device_jbw_num", str1);
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:CHFontNormal(nil, 12)}];
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName  value:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) range:[str rangeOfString:str1]];
    self.fenceLab.attributedText = attrDescribeStr;
    self.addBut.enabled = YES;
    if (self.fenceList.count >= 10) {
        self.addBut.enabled = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.fenceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CHFenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fenceIdent];
    cell.fenceMode = [self.fenceList objectAtIndex:indexPath.section];
    cell.headIma.image = [UIImage imageNamed:@"icon_quyu"];
    if (indexPath.section == 0) cell.headIma.image = [UIImage imageNamed:@"icon_jia"];
    if (indexPath.section == 1) cell.headIma.image = [UIImage imageNamed:@"icon_xuexiao"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78 * WIDTHAdaptive;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CHMainScreen.size.height, 26)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return NO;
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CHLocalizedString(@"device_jbw_delete", nil);
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CHFenceInfoMode *MODE = [self.fenceList objectAtIndex:indexPath.section];
        NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
        [dic addEntriesFromDictionary:@{@"FenceId":[NSString stringWithFormat:@"%ld",(long)MODE.FenceId],@"DeviceId":[NSString stringWithFormat:@"%ld",(long)MODE.DeviceId]}];
        
        @WeakObj(self)
        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_DeleteGeofence parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
             if ([result[@"State"] intValue] == 0) {
                 [MBProgressHUD showSuccess:CHLocalizedString(@"device_guar_deleSus", nil)];
                 [selfWeak.fenceList removeObjectAtIndex:indexPath.section];
                 [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                 [selfWeak setGuarderNum];
             }else if (![CHAFNWorking shareAFNworking].requestMess){
                 [MBProgressHUD showSuccess:CHLocalizedString(@"device_jbw_deleteFail", nil)];
             }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CHFenceViewController *fenceVC = [[CHFenceViewController alloc] init];
    CHFenceInfoMode *mode = [self.fenceList objectAtIndex:indexPath.section];
    fenceVC.title = mode.FenceName;
    if (indexPath.section != 0 && indexPath.section != 1) {
        fenceVC.changeModeName = YES;
    }
    fenceVC.user = self.user;
    fenceVC.fenceCacheMode = mode;
    [self.navigationController pushViewController:fenceVC animated:YES];
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
