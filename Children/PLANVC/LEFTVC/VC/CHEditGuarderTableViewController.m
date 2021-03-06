//
//  CHEditGuarderTableViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/9.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHEditGuarderTableViewController.h"

@interface CHEditGuarderTableViewController ()
{
    NSArray *titArr;
}
@property (nonatomic, strong) CHButton *transferBut;
@property (nonatomic, strong) CHButton *deleteBut;
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, copy) updatePopViewBlock block;
@end

@implementation CHEditGuarderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
    titArr = @[CHLocalizedString(@"device_guar_head", nil),CHLocalizedString(@"device_guar_relation", nil),CHLocalizedString(@"device_guar_phone", nil)];
    _user = [CHAccountTool user];
}

- (void)createUI{
    @WeakObj(self)
    if (_itemMode.UserId == _user.userId.intValue || self.isAdmin || self.adressMode) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem CHItemWithTit:CHLocalizedString(@"device_guar_save", nil) textColor:nil textFont:CHFontNormal(nil, 14) touchCallBack:^(UIBarButtonItem *item) {
            if (self.adressMode) {
                [selfWeak updateAdress];
            }else{
            [selfWeak updateRelation:selfWeak];
            }
        }];
        [self.navigationItem.rightBarButtonItem.customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_greaterThanOrEqualTo(40);
            make.height.mas_equalTo(40);
        }];
    }
    self.title = CHLocalizedString(@"device_guar_edit", nil);
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,12, 0, 12)];
    [self.tableView setSeparatorColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0)];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollEnabled = NO;
    if (_itemMode.UserId != _user.userId.intValue && self.isAdmin) {
        self.transferBut = [CHButton createWithTit:CHLocalizedString(@"device_guar_makeover", nil) titColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textFont:CHFontNormal(nil, 18) backColor:nil Radius:8.0 touchBlock:^(CHButton *sender) {
            NSLog(@"转让管理权限");
            [selfWeak transferAdmin];
        }];
        self.transferBut.layer.borderColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0).CGColor;
        self.transferBut.layer.borderWidth = 1.0f;
        self.deleteBut = [CHButton createWithTit:CHLocalizedString(@"device_guar_delete", nil) titColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textFont:CHFontNormal(nil, 18) backColor:nil Radius:8.0 touchBlock:^(CHButton *sender) {
            NSLog(@"删除该联系人");
            UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:nil message:CHLocalizedString(@"device_guar_deleMas", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *canAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_cnacel", nil) style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *confimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
                [dic addEntriesFromDictionary:@{@"UserId":  [TypeConversionMode strongChangeString:[NSString stringWithFormat:@"%ld",(long)_itemMode.UserId]],
                                                @"DeviceId": [TypeConversionMode strongChangeString:[NSString stringWithFormat:@"%ld",(long)_itemMode.DeviceId]],
                                                @"UserGroupId": [TypeConversionMode strongChangeString:[NSString stringWithFormat:@"%ld",(long)_itemMode.UserGroupId]]}];
                [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_RemoveShare parameters:dic Mess:CHLocalizedString(@"device_guar_deleteing", nil) showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
                    if ([result[@"State"] intValue] == 0) {
                        [MBProgressHUD showSuccess:CHLocalizedString(@"device_guar_deleSus", nil)];
                        CHUserInfo *delegateDevict = [[CHUserInfo alloc] init];
                        delegateDevict.userId = [TypeConversionMode strongChangeString:[NSString stringWithFormat:@"%ld",(long)_itemMode.UserId]];
                        delegateDevict.deviceId = [TypeConversionMode strongChangeString:[NSString stringWithFormat:@"%ld",(long)_itemMode.DeviceId]];
                        [[FMDBConversionMode sharedCoreBlueTool] deleteDevice:delegateDevict];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (selfWeak.block) {
                                selfWeak.block(selfWeak.itemMode,YES);
                            }
                            [selfWeak.navigationController popViewControllerAnimated:YES];
                        });
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
                    
                }];
            }];
            [alerVC addAction:canAct];
            [alerVC addAction:confimAct];
            [selfWeak presentViewController:alerVC animated:YES completion:^{
                
            }];
        }];
    }
    self.deleteBut.layer.borderColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0).CGColor;
    self.deleteBut.layer.borderWidth = 1.0f;
}

- (void)transferAdmin{
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:nil message:CHLocalizedString(@"device_guar_makeMas", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *canAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_cnacel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
        [dic addEntriesFromDictionary:@{@"UserId":  [TypeConversionMode strongChangeString:[NSString stringWithFormat:@"%ld",(long)_itemMode.UserId]],
                                        @"DeviceId": [TypeConversionMode strongChangeString:[NSString stringWithFormat:@"%ld",(long)_itemMode.DeviceId]],
                                        @"UserGroupId": [TypeConversionMode strongChangeString:[NSString stringWithFormat:@"%ld",(long)_itemMode.UserGroupId]]}];
        @WeakObj(self)
        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_ChangeMasterUser parameters:dic Mess:CHLocalizedString(@"device_guar_makeing", nil) showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
            if ([result[@"State"] intValue] == 0) {
                [MBProgressHUD showSuccess:CHLocalizedString(@"device_guar_makeSus", nil)];
                CHUserInfo *delegateDevict = [[CHUserInfo alloc] init];
                delegateDevict.userId = [TypeConversionMode strongChangeString:[NSString stringWithFormat:@"%ld",(long)_itemMode.UserId]];
                delegateDevict.deviceId = [TypeConversionMode strongChangeString:[NSString stringWithFormat:@"%ld",(long)_itemMode.DeviceId]];
                selfWeak.itemMode.IsAdmin = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (selfWeak.block) {
                        selfWeak.block(selfWeak.itemMode,NO);
                    }
                    [selfWeak.navigationController popViewControllerAnimated:YES];
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            
        }];
    }];
    [alerVC addAction:canAct];
    [alerVC addAction:confimAct];
    [self presentViewController:alerVC animated:YES completion:^{
        
    }];
}

- (void)updateRelation:(UIViewController *)weakSelf{
    UITableViewCell *relationCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (!relationCell.detailTextLabel || [relationCell.detailTextLabel.text isEqualToString:@""]) {
        [MBProgressHUD showError:CHLocalizedString(@"device_guar_inputRela", nil)];
        return;
    }
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"UserId":[TypeConversionMode strongChangeString:[NSString stringWithFormat:@"%ld",(long)_itemMode.UserId]],
                                    @"DeviceId":[TypeConversionMode strongChangeString:[NSString stringWithFormat:@"%ld",(long)_itemMode.DeviceId]],
                                    @"RelationName":relationCell.detailTextLabel.text}];
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_UpdateRelationName parameters:dic Mess:CHLocalizedString(@"", nil) showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        if ([result[@"State"] intValue] == 0) {
            [MBProgressHUD showSuccess:CHLocalizedString(@"aler_saveSuss", nil)];
            _itemMode.RelationName = relationCell.detailTextLabel.text;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (void)updateAdress{
    NSMutableArray <CHAdressMode *>* cmdList = self.adressArrs;
//    NSArray *superNavs = [self.navigationController childViewControllers];
//    for (UIViewController *nav in superNavs) {
//        if ([nav isKindOfClass:[CHGuarderViewController class]]) {
//            cmdList = [(CHGuarderViewController *)nav adressArrs];
//            break;
//        }
//    }
    NSString *alarmListStr = @"";
    for (int i = 0; i < cmdList.count; i ++) {
        alarmListStr = [alarmListStr stringByAppendingString:[NSString stringWithFormat:@"%@%@,%@,%@,%@",i == 0 ? @"":@",", cmdList[i].name,cmdList[i].relation,cmdList[i].adressLogo,cmdList[i].phoneNum]];
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
            [MBProgressHUD showSuccess:CHLocalizedString(@"aler_saveSuss", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [selfWeak.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (void)popViewUpdateUI:(updatePopViewBlock)callBack{
    self.block = callBack;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 2) {
        return 100;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indexCell = @"EDITCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indexCell];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
    cell.detailTextLabel.textColor = CHUIColorFromRGB(0x646464, 1.0);
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = titArr[indexPath.row];
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        if (self.adressMode) {
            headView.image = [UIImage imageNamed:@"pho_touxing"];
            cell.accessoryView = headView;
        }else{
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:_itemMode.Avatar] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image) {
                    UIImage *radiusIma = [UIImage drawWithSize:CGSizeMake(44, 44) Radius:22 image:image];
                    headView.image = radiusIma;
                }
                else{
                    headView.image = [UIImage imageNamed:@"pho_touxing"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.accessoryView = headView;
                });
            }];
        }
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = titArr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (self.adressMode) {
            cell.detailTextLabel.text = _adressMode.relation;
        }else{
        cell.detailTextLabel.text = _itemMode.RelationName;
        }
    }
    if (indexPath.row == 2) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = titArr[indexPath.row];
        if (self.adressMode) {
            cell.detailTextLabel.text = _adressMode.phoneNum;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }else{
        cell.detailTextLabel.text = _itemMode.RelationPhone;
        }
        cell.detailTextLabel.textColor = CHUIColorFromRGB(CHMediumBlackColor, 1.0);
    }
    if (indexPath.row == 3) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width+1000, 0,0);
        [self.transferBut removeFromSuperview];
        [cell.contentView addSubview:self.transferBut];
        [self.transferBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-12);
            make.left.mas_equalTo(47);
            make.right.mas_equalTo(-47);
            make.height.mas_equalTo(44 * WIDTHAdaptive);
        }];
    }
    if (indexPath.row == 4) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width+1000, 0,0);
        [self.deleteBut removeFromSuperview];
        [cell.contentView addSubview:self.deleteBut];
        [self.deleteBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(47);
            make.right.mas_equalTo(-47);
            make.height.mas_equalTo(44 * WIDTHAdaptive);
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 1) {
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:CHLocalizedString(@"device_guar_inputRela", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alerVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.delegate = self;
        }];
        UIAlertAction *canAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_cnacel", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *nickField = (UITextField *)alerVC.textFields[0];
            if (self.adressMode) {
                self.adressMode.relation = nickField.text;
                self.adressMode.name = nickField.text;
            }else{
            _itemMode.RelationName = nickField.text;
            }
            cell.detailTextLabel.text = nickField.text;
        }];
        [alerVC addAction:canAct];
        [alerVC addAction:confimAct];
        [self presentViewController:alerVC animated:YES completion:^{
            
        }];
    }
    if (indexPath.row == 2 && self.adressMode) {
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:CHLocalizedString(@"device_guar_phone", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alerVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.delegate = self;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        UIAlertAction *canAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_cnacel", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"aler_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *nickField = (UITextField *)alerVC.textFields[0];
            self.adressMode.phoneNum = nickField.text;
            cell.detailTextLabel.text = nickField.text;
        }];
        [alerVC addAction:canAct];
        [alerVC addAction:confimAct];
        [self presentViewController:alerVC animated:YES completion:^{
            
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSString *aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([string isEqualToString:@","]) {
        return NO;
    }
    return YES;
}

- (void)dealloc{
    NSLog(@"dealloc");
}
@end
