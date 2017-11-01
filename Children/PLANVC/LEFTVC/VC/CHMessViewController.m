//
//  CHMessViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/17.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHMessViewController.h"

@interface CHMessViewController ()
@property (nonatomic, strong) UITableView *messTabView;
@property (nonatomic, strong) NSMutableArray <CHMessageListInfoMode *> *messList;
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, assign) int mesPage;
@property (nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation CHMessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeMethod:YES];
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

- (CHUserInfo *)user{
    if (!_user) {
        _user = [CHAccountTool user];
    }
    return _user;
}

- (NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy/MM/dd HH:mm";
        _formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    }
    return _formatter;
}

- (void)initializeMethod:(BOOL)showMess{
    self.mesPage ++;
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"Id": self.user.deviceId,
                                    @"PageNo": [NSString stringWithFormat:@"%d",self.mesPage],
                                    @"PageCount": @10,
                                    @"TypeID": @1,
                                    @"DataCode": @"",
                                    @"UserID": self.user.userId,
                                    @"Exclude": @""}];
   @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_ExcdeptionListWhitoutCode parameters:dic Mess:showMess ? @"":nil showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        if (!selfWeak.messList) {
            selfWeak.messList = [NSMutableArray array];
        }
        NSArray *items = [CHMessageListInfoMode mj_objectArrayWithKeyValuesArray:result[@"Items"]];
        [selfWeak.messList addObjectsFromArray:items];
        [selfWeak.messTabView reloadData];
        if (items.count > 0) {
             [selfWeak.messTabView.mj_footer endRefreshing];
                selfWeak.messTabView.backgroundView = [UIView new];
        }
        else{
             [selfWeak.messTabView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [selfWeak.messTabView reloadData];
        [selfWeak.messTabView.mj_footer endRefreshing];
    }];
}

- (void)createUI{
    self.title = CHLocalizedString(@"device_mess_mes", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.messTabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.messTabView.backgroundColor = [UIColor whiteColor];
    self.messTabView.delegate = self;
    self.messTabView.dataSource = self;
    self.messTabView.tableFooterView = [UIView new];
    [self.view addSubview:self.messTabView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CHMainScreen.size.width, CHMainScreen.size.height - 64)];
    self.messTabView.backgroundView = backView;
    
    UIImageView *image = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_kxx"] backColor:nil];
    image.frame = CGRectMake(0, 0, 71, 109);
    image.center = CGPointMake(CHMainScreen.size.width/2, CHMainScreen.size.height/2 - 106);
    [backView addSubview:image];
    
    CHLabel *titLab = [CHLabel createWithTit:CHLocalizedString(@"user_notRequestMs", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:nil textAlignment:1];
    titLab.frame = CGRectMake(30, CGRectGetMaxY(image.frame) + 10, CHMainScreen.size.width - 60, 60);
    [backView addSubview:titLab];
    
//    self.messTabView.backgroundColor = [UIColor greenColor];
    [self.messTabView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0 - HOME_INDICATOR_HEIGHT);
    }];
    
    [self setupRefrish];
}
- (void)setupRefrish{
    @WeakObj(self)
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"footerWithRefreshingBlock");
//        [selfWeak.messTabView.mj_header beginRefreshing];
         [selfWeak initializeMethod:NO];
    }];
    [footer setTitle:CHLocalizedString(@"device_mess_update", nil) forState:MJRefreshStateIdle];
    [footer setTitle:CHLocalizedString(@"device_mess_updateing", nil) forState:MJRefreshStateRefreshing];
    [footer setTitle:CHLocalizedString(@"device_mess_updatenone", nil) forState:MJRefreshStateNoMoreData];
    _messTabView.mj_footer = footer;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.messList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90 * WIDTHAdaptive;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *messIndex = @"MESSCELL";
    CHMessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messIndex];
    if (!cell) {
        cell = [[CHMessTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:messIndex];
    }
    cell.mesMode = self.messList[indexPath.section];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
    CHMessageListInfoMode *mode = self.messList[section];
    NSDate *lastTime = [NSDate getNowDateFromatAnDate:[self.formatter dateFromString:mode.CreateDate]];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        //上次时间
    NSDate *lastDate = [lastTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:lastTime]];
        //当前时间
    NSDate *currentDate = [[NSDate date] dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:[NSDate date]]];
        //时间间隔
    NSInteger intevalTime = [currentDate timeIntervalSinceReferenceDate] - [lastDate timeIntervalSinceReferenceDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSString *titStr = @"";
    if (intevalTime < 60*60*24){
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        if ([[dateFormatter stringFromDate:lastDate] isEqualToString:[dateFormatter stringFromDate:currentDate]]) {
            dateFormatter.dateFormat = @"HH:mm";
            titStr = [dateFormatter stringFromDate:lastDate];
        }else{
            dateFormatter.dateFormat = @"HH:mm";
            titStr = [NSString stringWithFormat:@"%@ %@",CHLocalizedString(@"user_lastData", nil),[dateFormatter stringFromDate:lastDate]];
        }
    }
    else{
        dateFormatter.dateFormat = @"MM/dd HH:mm";
        titStr = [dateFormatter stringFromDate:lastDate];
    }
    CHLabel *lab = [CHLabel createWithTit:titStr font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:CHUIColorFromRGB(0xffffff, 1.0) textAlignment:1];
    return lab;
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
