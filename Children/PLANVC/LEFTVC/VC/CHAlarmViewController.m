//
//  CHAlarmViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/20.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHAlarmViewController.h"

@interface CHAlarmViewController ()
@property (nonatomic, strong) CHLabel *alarmTitLab;
@property (nonatomic, strong) NSMutableArray *alarmList;
@property (nonatomic, strong) CHButton *addBut;
@property (nonatomic, strong) UITableView *alarmTab;
@property (nonatomic, strong) CHUserInfo *user;
@end

@implementation CHAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeMethod];
    //    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CHUserInfo *)user{
    if (!_user) {
        _user = [CHAccountTool user];
    }
    return _user;
}

- (void)initializeMethod{
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"DeviceId":self.user.deviceId}];
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_CommandList parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        for (NSDictionary *dic in result[@"Items"]) {
            if ([dic[@"Code"] intValue] == [ALARM_CLOCK intValue]) {
                [selfWeak BreakUpAarmValue:dic];
                break;
            }
        }
        [selfWeak createUI];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [selfWeak createUI];
    }];
}

- (CHCmdClassDemo *)cmdDemo{
    CHCmdClassDemo *_cmdDemo = [[CHCmdClassDemo alloc] init];
    _cmdDemo.starTime = @"09:00";
    _cmdDemo.week = @"12345";
    _cmdDemo.open = @"1";
    return _cmdDemo;
}

- (NSMutableArray <CHCmdClassDemo *>*)commandList{
    if (!_commandList) {
        _commandList = [NSMutableArray array];
    }
    return _commandList;
}

- (void)BreakUpAarmValue:(NSDictionary *)dic{
    if (dic) {
        NSMutableArray *cmdValues = [[dic[@"CmdValue"] componentsSeparatedByString:@","] mutableCopy];
        if (cmdValues.count <= 0) return;
        NSInteger count = (cmdValues.count - 1)/3;
        for (int i = 0; i < count; i ++) {
            CHCmdClassDemo *mode = [[CHCmdClassDemo alloc] init];
            if (cmdValues.count <= (1 + i * 3)) return;
            mode.starTime = cmdValues[1 + i * 3];
            if (cmdValues.count <= (2 + i * 3)) return;
            mode.week = cmdValues[2 + i * 3];
            if (cmdValues.count <= (3 + i * 3)) return;
            mode.open = cmdValues[3 + i * 3];
            [self.commandList addObject:mode];
        }
    }
}

- (void)createUI{
    self.title = CHLocalizedString(@"闹钟提醒", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    _alarmTitLab = [CHLabel new];
    [self setAlarmNum];
    [self.view addSubview:_alarmTitLab];
    
    CHLabel *line = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line];
    @WeakObj(self);
    _addBut = [CHButton createWithTit:CHLocalizedString(@"添加新闹钟", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        CHSubAlarmViewController *alarmSubVC = [[CHSubAlarmViewController alloc] init];
        CHCmdClassDemo *demo = [selfWeak cmdDemo];
        [selfWeak.commandList addObject:demo];
        alarmSubVC.cmdDemo = demo;
        alarmSubVC.delegate = self;
        [selfWeak.navigationController pushViewController:alarmSubVC animated:YES];
    }];
    [self.view addSubview:_addBut];
    
    _alarmTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _alarmTab.dataSource = self;
    _alarmTab.delegate = self;
    [_alarmTab setSeparatorInset:UIEdgeInsetsMake(0, CHMainScreen.size.width, 0, 0)];
    [self.view addSubview:_alarmTab];
    
    [_alarmTitLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
    }];
    
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_alarmTitLab.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(1);
    }];
    
    [_addBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
    }];
    
    [_alarmTab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_addBut.mas_top).mas_offset(-8);
    }];
}

- (void)setAlarmNum{
    NSString *str1 = [NSString stringWithFormat:@"%lu",6 - self.commandList.count];
    NSString *str = CHLocalizedString(@"还可以添加%@个闹钟", str1);
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:CHFontNormal(nil, 12)}];
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName  value:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) range:[str rangeOfString:str1]];
    self.alarmTitLab .attributedText = attrDescribeStr;
    self.addBut.enabled = YES;
    if (self.commandList.count >= 6) {
        self.addBut.enabled = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commandList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndex = @"ALARMCELL";
    CHAlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndex];
    if (!cell) {
        cell = [[CHAlarmTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndex];
    }
    @WeakObj(self)
    cell.demo = self.commandList[indexPath.row];
    [cell selectSwitchCallBack:^(UISwitch *oSwitch) {
        NSLog(@"selectSwitchCallBack %d",oSwitch.on);
//        CHCmdClassDemo *mode = selfWeak.commandList[indexPath.row];
        cell.demo.open = [NSString stringWithFormat:@"%d",oSwitch.on];
        NSInteger row = [self.commandList indexOfObject:cell.demo];
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:row inSection:0];
        [selfWeak addAlarm:cell.demo cell:indexP delete:NO];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CHSubAlarmViewController *alarmSubVC = [[CHSubAlarmViewController alloc] init];
    CHCmdClassDemo *mode = self.commandList[indexPath.row];
    alarmSubVC.cmdDemo = mode;
    alarmSubVC.delegate = self;
   [self.navigationController pushViewController:alarmSubVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CHLocalizedString(@"删除", nil);
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setEditing:NO animated:YES];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CHCmdClassDemo *mode = self.commandList[indexPath.row];
        [self addAlarm:mode cell:indexPath delete:YES];
    }
}

- (void)addAlarm:(CHCmdClassDemo *)mode cell:(NSIndexPath *)cellIndex delete:(BOOL)isdelete{
    CHAlarmTableViewCell *cell = [self.alarmTab cellForRowAtIndexPath:cellIndex];
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
//    NSString *alarmListStr = [NSString stringWithFormat:@"1,%lu",(unsigned long)self.commandList.count];
    NSString *alarmListStr = @"1";
    for (int i = 0; i < self.commandList.count; i ++) {
        alarmListStr = [alarmListStr stringByAppendingString:[NSString stringWithFormat:@",%@,%@,%@",self.commandList[i].starTime,self.commandList[i].week,self.commandList[i].open]];
    }
    if (isdelete) {
        NSMutableArray <CHCmdClassDemo *>*temporaryList = [self.commandList mutableCopy];
        [temporaryList removeObject:mode];
//        alarmListStr = [NSString stringWithFormat:@"1,%lu",(unsigned long)temporaryList.count];
         alarmListStr = @"1";
        for (int i = 0; i < temporaryList.count; i ++) {
            alarmListStr = [alarmListStr stringByAppendingString:[NSString stringWithFormat:@",%@,%@,%@",temporaryList[i].starTime,temporaryList[i].week,temporaryList[i].open]];
        }
    }
    
    [dic addEntriesFromDictionary:@{@"DeviceId":self.user.deviceId,
                                    @"DeviceModel": self.user.deviceMo,
                                    @"CmdCode": ALARM_CLOCK,
                                    @"Params": alarmListStr,
                                    @"UserId": self.user.userId}];
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_SendCommand parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        if ([result[@"State"] intValue] == 0) {
            if (isdelete) {
                [MBProgressHUD showSuccess:CHLocalizedString(@"删除成功", nil)];
                [selfWeak.commandList removeObject:mode];
                [selfWeak.alarmTab deleteRowsAtIndexPaths:@[cellIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                [selfWeak setAlarmNum];
            }
            else{
                [MBProgressHUD showSuccess:CHLocalizedString(@"修改成功", nil)];
            }
        }
        else{
            if (!isdelete) {
                mode.open = [NSString stringWithFormat:@"%d",!mode.open.boolValue];
                cell.demo = mode;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        if (!isdelete) {
            mode.open = [NSString stringWithFormat:@"%d",!mode.open.boolValue];
            cell.demo = mode;
        }
    }];
}

- (void)viewWillPop{
    [self.alarmTab reloadData];
    [self setAlarmNum];
}

#pragma mark - Navigation
/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
