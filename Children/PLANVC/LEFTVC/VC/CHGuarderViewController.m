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
    if (!self.user.deviceId || [self.user.deviceId isEqualToString:@""]) {
        return;
    }
    if (self.addressBook) {
        NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
        [dic addEntriesFromDictionary:@{@"DeviceId":self.user.deviceId}];
        @WeakObj(self)
        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_CommandList parameters:dic Mess:nil showError:NO progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
            for (NSDictionary *dic in result[@"Items"]) {
                if ([dic[@"Code"] intValue] == [PHONE_BOOK intValue]) {
                    NSLog(@"fwgoijgo == %@",dic);
//                    [selfWeak BreakUpAarmValue:dic];
                    break;
                }
            }
//            [selfWeak createUI];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
//            [selfWeak createUI];
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
    self.addBut = [CHButton createWithTit:CHLocalizedString(@"添加新成员", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 18) backImaColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0 touchBlock:^(CHButton *sender) {
        CHSAddGuarderViewController *addVc = [[CHSAddGuarderViewController alloc] init];
        addVc.isAddress = selfWeak.addressBook;
        CHAdressMode *mode = [selfWeak setNewMode];
        [selfWeak.adressArrs addObject:mode];
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

- (void)setGuarderNum{
    NSString *str1 = [NSString stringWithFormat:@"%lu",20 - self.itemArrs.count];
     NSString *str = CHLocalizedString(@"监护人还可以添加%@个", str1);
    if (self.addressBook) {
        str1 = [NSString stringWithFormat:@"%lu",20 - self.adressArrs.count];
        str = CHLocalizedString(@"电话本还可以添加%@个", str1);
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
    }
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
