//
//  CHMoreSetTableViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/18.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHMoreSetTableViewController.h"

@interface CHMoreSetTableViewController ()
@property (nonatomic, strong) NSArray *titArr;

@end

@implementation CHMoreSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}

- (void)initializeMethod{
    _titArr = @[CHLocalizedString(@"上课禁用", nil),CHLocalizedString(@"闹钟提醒", nil),CHLocalizedString(@"声音和震动", nil)/*,CHLocalizedString(@"SOS设置", nil)*/];
}

- (void)createUI{
    self.title = CHLocalizedString(@"更多设置", nil);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollEnabled = NO;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  _titArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 * WIDTHAdaptive;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CHLabel *lab = [CHLabel createWithTit:@"" font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:CHUIColorFromRGB(0xffffff, 1.0) textAlignment:1];
    return lab;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *setCell = @"SETCELL";
    CHMoreSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:setCell];
    if (!cell) {
        cell = [[CHMoreSetTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:setCell];
    }
    cell.textLabel.text = _titArr[indexPath.section];
    cell.textLabel.textColor = CHUIColorFromRGB(CHMediumBlackColor, 1.0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:[[CHClassViewController alloc] init] animated:YES];
    }
    if (indexPath.section == 1) {
        [self.navigationController pushViewController:[[CHAlarmViewController alloc] init] animated:YES];
    }
    if (indexPath.section == 2) {
        [self.navigationController pushViewController:[[CHVolumeViewController alloc] init] animated:YES];
    }
    if (indexPath.section == 3) {
        [self.navigationController pushViewController:[[CHSOSViewController alloc] init] animated:YES];
    }
}

@end
