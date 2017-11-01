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
@property (nonatomic, strong) NSMutableArray *itemArrs;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, assign) CHButton *addBut;
@property (nonatomic, assign) BOOL isAdmin;
@end

@implementation CHGuarderViewController

static NSString *Identifier = @"GUARDERCELL";
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initializeMetod];
    _user = [CHAccountTool user];

    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initializeMetod];
    NSLog(@"viewWillAppear");
}

- (NSMutableArray <CHAdressMode *> *)adressArrs{
    if (!_adressArrs) {
        _adressArrs = [NSMutableArray array];
    }
    return _adressArrs;
}

- (void)initializeMetod{
    self.isAdmin = NO;
    CHAFNWorking *afn = [CHAFNWorking shareAFNworking];
     self.addBut.enabled = NO;
    if (!self.user.deviceId || [self.user.deviceId isEqualToString:@""]) {
        return;
    }
    if (self.addressBook) {
        NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
        [dic addEntriesFromDictionary:@{@"DeviceId":self.user.deviceId}];
        @WeakObj(self)
       
        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_CommandList parameters:dic Mess:nil showError:NO progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
             @StrongObj(self)
            for (NSDictionary *dic in result[@"Items"]) {
                if ([dic[@"Code"] intValue] == [PHONE_BOOK intValue]) {
                    NSLog(@"fwgoijgo == %@",dic);
                    [selfWeak.adressArrs removeAllObjects];
                    [selfWeak BreakPhoneBookValue:dic];
                    break;
                }
            }
            self.addBut.enabled = YES;
            if (self.itemArrs.count >= 20) {
                self.addBut.enabled = NO;
            }
             [self.table reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
             [self.table reloadData];
        }];
    }
    NSMutableDictionary *dic = afn.requestDic;
    [dic addEntriesFromDictionary:@{@"DeviceId":_user.deviceId}];
    @WeakObj(self)
    [afn CHAFNPostRequestUrl:REQUESTURL_ShareList parameters:dic Mess:nil showError:NO progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        @StrongObj(self)
        self.itemArrs = [[CHGuarderItemMode mj_objectArrayWithKeyValuesArray:result[@"Items"]] mutableCopy];
        [self setGuarderNum];
        self.addBut.enabled = YES;
        if (self.itemArrs.count >= 20) {
            self.addBut.enabled = NO;
        }
        [self.table reloadData];
         [MBProgressHUD hideHUD];
        NSLog(@"_itemArrs %@",_itemArrs);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (CHAdressMode *)setNewMode{
    CHAdressMode *mode = [[CHAdressMode alloc] init];
    return mode;
}

- (void)createUI{
    self.guarderNumLab = [CHLabel new];
    [self setGuarderNum];
    [self.view addSubview:self.guarderNumLab];
    @WeakObj(self)
    self.addBut = [CHButton createWithTit:CHLocalizedString(@"device_guar_add", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        CHSAddGuarderViewController *addVc = [[CHSAddGuarderViewController alloc] init];
        addVc.isAddress = selfWeak.addressBook;
        CHAdressMode *mode = [selfWeak setNewMode];
//        [selfWeak.adressArrs addObject:mode];
        addVc.mode = mode;
        addVc.cmdList = selfWeak.adressArrs;
        addVc.itemArrs = selfWeak.itemArrs;
        [selfWeak.navigationController pushViewController:addVc animated:YES];
    }];
    [self.view addSubview:self.addBut];
    if (!self.user.deviceId || [self.user.deviceId isEqualToString:@""]) {
        self.guarderNumLab.hidden = YES;
        self.addBut.hidden = YES;
    }
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CHMainScreen.size.width, 40)];
    CHLabel *headLab = [CHLabel createWithTit:self.addressBook ? CHLocalizedString(@"device_guar_phoneBook", nil):CHLocalizedString(@"device_guar_kinship", nil) font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(0x646464, 1.0) backColor:nil textAlignment:0];
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
        make.bottom.mas_equalTo(-4 - HOME_INDICATOR_HEIGHT);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.addBut mas_remakeConstraints:^(MASConstraintMaker *make) {
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
        make.bottom.mas_equalTo(self.addBut.mas_top).mas_offset(-12);
        make.right.mas_equalTo(0);
    }];
}

- (void)BreakPhoneBookValue:(NSDictionary *)dic{
    if (dic) {
        NSMutableArray *cmdValues = [[dic[@"CmdValue"] componentsSeparatedByString:@","] mutableCopy];
        if (cmdValues.count <= 0) return;
        NSInteger count = (cmdValues.count)/4;
        for (int i = 0; i < count; i ++) {
            CHAdressMode *model = [[CHAdressMode alloc] init];
            model.name = [TypeConversionMode strongChangeString:cmdValues[0 + i * 4]];
            model.relation = [TypeConversionMode strongChangeString:cmdValues[1 + i * 4]];
            model.adressLogo = [TypeConversionMode strongChangeString:cmdValues[2 + i * 4]];
            model.phoneNum = [TypeConversionMode strongChangeString:cmdValues[3 + i * 4]];
            [self.adressArrs addObject:model];
        }
    }
}

- (void)setGuarderNum{
    NSString *str1 = [NSString stringWithFormat:@"%lu",20 - self.itemArrs.count];
     NSString *str = CHLocalizedString(@"device_guar_guardian", str1);
    if (self.addressBook) {
        str1 = [NSString stringWithFormat:@"%lu",20 - self.adressArrs.count];
        str = CHLocalizedString(@"device_guar_phoneNum", str1);
    }
   
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:CHFontNormal(nil, 12)}];
        [attrDescribeStr addAttribute:NSForegroundColorAttributeName  value:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) range:[str rangeOfString:str1]];
    self.guarderNumLab.attributedText = attrDescribeStr;
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
    }else{
        CHAdressMode *adress = [self.adressArrs objectAtIndex:indexPath.row];
        cell.titLab.text = adress.name;
        cell.phoneLab.text = adress.phoneNum;
        cell.headView.image = [UIImage imageNamed:@"pho_touxing"];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.addressBook) {
        return self.adressArrs.count;
    }
    return _itemArrs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!self.addressBook) {
        CHEditGuarderTableViewController *editVC = [[CHEditGuarderTableViewController alloc] init];
        @WeakObj(self)
        [editVC popViewUpdateUI:^(CHGuarderItemMode *itemMode, BOOL deleMode) {
            if (deleMode) {
                [selfWeak.itemArrs removeObject:itemMode];
            }
             [tableView reloadData];
        }];
        editVC.itemMode = [self.itemArrs objectAtIndex:indexPath.row];
        editVC.isAdmin = self.isAdmin;
        [self.navigationController pushViewController:editVC animated:YES];
    }else{
        CHEditGuarderTableViewController *editVC = [[CHEditGuarderTableViewController alloc] init];
        @WeakObj(self)
        [editVC popViewUpdateUI:^(CHAdressMode *itemMode, BOOL deleMode) {
            if (deleMode) {
                [selfWeak.adressArrs removeObject:itemMode];
            }
            [tableView reloadData];
        }];
        editVC.adressMode = [self.adressArrs objectAtIndex:indexPath.row];
        editVC.adressArrs = self.adressArrs;
//        editVC.isAdmin = self.isAdmin;
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.addressBook) {
         return YES;
    }
    return NO;
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
        CHAdressMode *mode = self.adressArrs[indexPath.row];
        [self delegateAdressWithModel:mode cell:indexPath];
    }
}

- (void)delegateAdressWithModel:(CHAdressMode *)model cell:(NSIndexPath *)cellIndex{
    NSMutableArray <CHAdressMode *>* temporaryList = [self.adressArrs mutableCopy];
    [temporaryList removeObject:model];
    NSString *alarmListStr = @"";
    for (int i = 0; i < temporaryList.count; i ++) {
        alarmListStr = [alarmListStr stringByAppendingString:[NSString stringWithFormat:@"%@,%@,%@,%@",temporaryList[i].name,temporaryList[i].relation,temporaryList[i].adressLogo,temporaryList[i].phoneNum]];
    }
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    NSString *params = alarmListStr;
    [dic addEntriesFromDictionary:@{@"DeviceId":[CHAccountTool user].deviceId,
                                    @"DeviceModel": [CHAccountTool user].deviceMo,
                                    @"CmdCode": PHONE_BOOK,
                                    @"Params": params,
                                    @"UserId": [CHAccountTool user].userId}];
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_SendCommand parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        if ([result[@"State"] intValue] == 0) {
            [MBProgressHUD showSuccess:CHLocalizedString(@"device_guar_deleSus", nil)];
            [selfWeak.adressArrs removeObject:model];
            [selfWeak.table deleteRowsAtIndexPaths:@[cellIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            [selfWeak setGuarderNum];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (void)dealloc{
    NSLog(@"dealloc");
    [CHAFNWorking shareAFNworking].moreRequest = NO;
    [MBProgressHUD hideHUD];
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
