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
@end

@implementation CHAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
    
}

- (void)createUI{
    self.title = CHLocalizedString(@"闹钟提醒'", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    _alarmTitLab = [CHLabel new];
    [self setAlarmNum];
    [self.view addSubview:_alarmTitLab];
    
    CHLabel *line = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.view addSubview:line];
    
    _addBut = [CHButton createWithTit:CHLocalizedString(@"添加新闹钟", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        
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
    NSString *str1 = [NSString stringWithFormat:@"%lu",6 - self.alarmList.count];
    NSString *str = CHLocalizedString(@"还可以添加%@个闹钟", str1);
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:CHFontNormal(nil, 12)}];
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName  value:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) range:[str rangeOfString:str1]];
    self.alarmTitLab .attributedText = attrDescribeStr;
    self.addBut.enabled = YES;
    if (self.alarmList.count >= 6) {
        self.addBut.enabled = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _alarmList.count;
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
    [cell selectSwitchCallBack:^(UISwitch *oSwitch) {
        NSLog(@"selectSwitchCallBack %d",indexPath.row);
    }];
    return cell;
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
