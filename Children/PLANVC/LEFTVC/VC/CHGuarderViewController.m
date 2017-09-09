//
//  CHGuarderViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/9.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHGuarderViewController.h"

@interface CHGuarderViewController ()
@property (nonatomic, strong) CHLabel *guarderNumLab;
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) NSArray *itemArrs;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) BOOL isAdmin;
@end

@implementation CHGuarderViewController

static NSString *Identifier = @"GUARDERCELL";
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initializeMetod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)initializeMetod{
    self.isAdmin = NO;
    _user = [CHAccountTool user];
    CHAFNWorking *afn = [CHAFNWorking shareAFNworking];
    NSMutableDictionary *dic = afn.requestDic;
    [dic addEntriesFromDictionary:@{@"DeviceId":_user.deviceId}];
    @WeakObj(self)
    [afn CHAFNPostRequestUrl:REQUESTURL_ShareList parameters:dic Mess:nil showError:NO progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        @StrongObj(self)
        self.itemArrs = [CHGuarderItemMode mj_objectArrayWithKeyValuesArray:result[@"Items"]];
        [self.table reloadData];
        NSLog(@"_itemArrs %@",_itemArrs);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (void)createUI{
    self.guarderNumLab = [CHLabel new];
    NSString *str = [NSString stringWithFormat:@"电话本还可以添加%@个",@"17"];
    
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:CHFontNormal(nil, 12)}];
    
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName  value:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) range:[str rangeOfString:@"17"]];
    self.guarderNumLab.attributedText = attrDescribeStr;
    [self.view addSubview:self.guarderNumLab];
    
    CHButton *addBut = [CHButton createWithTit:CHLocalizedString(@"添加新成员", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 18) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
    
    }];
    [self.view addSubview:addBut];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CHMainScreen.size.width, 40)];
    CHLabel *headLab = [CHLabel createWithTit:self.addressBook ? CHLocalizedString(@"电话本（帮手表存储电话号码）", nil):CHLocalizedString(@"亲情号（手机可与手表相互拔通）", nil) font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(0x646464, 1.0) backColor:nil textAlignment:0];
    [headView addSubview:headLab];
    
    CHLabel *lineLab = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [headView addSubview:lineLab];
    
    [self.view addSubview:headView];
    [headLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-8);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-1);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(0.5);
    }];
    
    self.table = [[UITableView alloc] init];
    [self.table setTableFooterView:[UIView new]];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table setSeparatorInset:UIEdgeInsetsMake(0,12, 0, 12)];
    [self.table setSeparatorColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0)];
    [self.table registerClass:[CHGuarderCell class] forCellReuseIdentifier:Identifier];
    [self.view addSubview: self.table];
    
    [self.guarderNumLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-4);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [addBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.guarderNumLab.mas_top).mas_offset(-4);
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(44);
//        make.width.mas_equalTo(44);
    }];
    
    [self.table mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(addBut.mas_top).mas_offset(-12);
        make.right.mas_equalTo(0);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CHGuarderCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (!self.addressBook) {
        CHGuarderItemMode *guarder = [self.itemArrs objectAtIndex:indexPath.row];
        cell.titLab.text = guarder.RelationName;
        cell.phoneLab.text = guarder.RelationPhone;
        cell.isAdmin = guarder.IsAdmin;
        [cell.headView sd_setImageWithURL:[NSURL URLWithString:guarder.Avatar] placeholderImage:[UIImage imageNamed:@"pho_touxing"]];
        if (guarder.IsAdmin && guarder.UserId == self.user.userId.intValue) {
            self.isAdmin = YES;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!self.addressBook) {
        CHEditGuarderTableViewController *editVC = [[CHEditGuarderTableViewController alloc] init];
        [editVC popViewUpdateUI:^(CHGuarderItemMode *itemMode) {
            [tableView reloadData];
        }];
        editVC.itemMode = [self.itemArrs objectAtIndex:indexPath.row];
        editVC.isAdmin = self.isAdmin;
        [self.navigationController pushViewController:editVC animated:YES];
    }
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
