//
//  CHDeviceInfoViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHDeviceInfoViewController.h"

@interface CHDeviceInfoViewController ()
{
    NSArray *titArr;
    CHUserInfo *user;
    CHButton *gailBut;
    CHButton *mainBut;
    UIImagePickerController *picker;
    CHButton *headBut;
}
@end

@implementation CHDeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
     titArr = @[CHLocalizedString(@"昵称", nil),CHLocalizedString(@"生日", nil),CHLocalizedString(@"身高", nil),CHLocalizedString(@"体重", nil),CHLocalizedString(@"手机号码", nil),CHLocalizedString(@"IMEI", nil)];
    user = [CHAccountTool user];
    if (!user.deviceHe) {
        user.deviceHe = @"115";
    }
    if (!user.deviceBi) {
        user.deviceHe = @"115";
    }
    if (!user.deviceWi) {
        user.deviceWi = @"20";
    }
    if (!user.deviceGe) {
        user.deviceGe = @"0";
    }
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = CHLocalizedString(@"宝贝资料", nil);
    UIView *headView = [UIView new];
    headView.backgroundColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    [self.view addSubview:headView];
    __block UIImagePickerControllerSourceType sourceType ;
    
//    @WeakObject(picker)
    headBut = [CHButton createWithImage:[UIImage mergeMainIma:[UIImage imageNamed:@"pho_touxiang"] subIma:[UIImage imageNamed:@"icon_xiangji"] callBackSize:CGSizeMake((CHMainScreen.size.width * WIDTHAdaptive)/3.5, (CHMainScreen.size.width * WIDTHAdaptive)/3.5)] Radius:(CHMainScreen.size.width * WIDTHAdaptive)/7 touchBlock:^(CHButton *sender) {
//        @StrongObject(picker)
//        UIImagePickerController *_pick = (UIImagePickerController *)strongOjb;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        CHPhotoView *photoView = [CHPhotoView initWithNomarSheet];
        [photoView createPhotoUIWithTouchPhoto:^(CHButton *sender) {
            NSLog(@"点击相机");
            sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                if (!picker) {
                    picker = [[UIImagePickerController alloc] init];//初始化
                    picker.delegate = self;
                    picker.allowsEditing = YES;//设置可编辑
                }
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:^{
                    
                }];
            }
            else{
                [MBProgressHUD showError:CHLocalizedString(@"相机不可用", nil)];
            }
        } touchAlum:^(CHButton *sender) {
            NSLog(@"点击相册");
//            @StrongObject(picker)
//            UIImagePickerController *_pick = (UIImagePickerController *)strongOjb;
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
                if (!picker) {
                    picker = [[UIImagePickerController alloc] init];//初始化
                    picker.delegate = self;
                    picker.allowsEditing = YES;//设置可编辑
                }
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:^{
                    
                }];
            }
            else{
                [MBProgressHUD showError:CHLocalizedString(@"相册不可用", nil)];
            }
        }];
        [app.window addSubview:photoView];
    }];
    [headView addSubview:headBut];
    
    mainBut = [CHButton createWithTit:CHLocalizedString(@"男", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 16) backImaColor:CHUIColorFromRGB(0xb3e5fc, 1.0) Radius:16 touchBlock:^(CHButton *sender) {
        sender.selected = YES;
        user.deviceGe = @"0";
        gailBut.selected = NO;
    }];
    [mainBut setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(0x0288d1, 1.0) size:CHMainScreen.size] forState:UIControlStateSelected];
    [mainBut setImage:[UIImage imageNamed:@"icon_nan"] forState:UIControlStateNormal];
    [mainBut setTitleColor:CHUIColorFromRGB(0xffffff, 1.0) forState:UIControlStateSelected];
    [mainBut setTitleColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) forState:UIControlStateNormal];
    [headView addSubview:mainBut];
    
    gailBut = [CHButton createWithTit:CHLocalizedString(@"女", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 16) backImaColor:CHUIColorFromRGB(0xb3e5fc, 1.0) Radius:16 touchBlock:^(CHButton *sender) {
        sender.selected = YES;
        mainBut.selected = NO;
        user.deviceGe = @"1";
    }];
    [gailBut setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(0xff23cf, 1.0) size:CHMainScreen.size] forState:UIControlStateSelected];
    [gailBut setImage:[UIImage imageNamed:@"icon_nv"] forState:UIControlStateNormal];
    [gailBut setTitleColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) forState:UIControlStateNormal];
    [gailBut setTitleColor:CHUIColorFromRGB(0xffffff, 1.0) forState:UIControlStateSelected];
    if (user.deviceGe.intValue) {
        gailBut.selected = YES;
        mainBut.selected = NO;
    }
    else{
        mainBut.selected = YES;
        gailBut.selected = NO;
    }
    [headView addSubview:gailBut];
    
    CHButton *confimBut = [CHButton createWithTit:CHLocalizedString(@"确定", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 18) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:8.0f touchBlock:^(CHButton *sender) {
        
    }];
    [self.view addSubview:confimBut];
    
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    if ([tabView respondsToSelector:@selector(setSeparatorColor:)]) {
        tabView.separatorColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    }
    tabView.dataSource = self;
    tabView.delegate = self;
    tabView.tableFooterView = [UIView new];
    [self.view addSubview:tabView];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(170 * WIDTHAdaptive);
    }];
    
    [headBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.centerX.mas_equalTo(headView);
        make.size.mas_equalTo(CGSizeMake((CHMainScreen.size.width * WIDTHAdaptive)/3.5, (CHMainScreen.size.width * WIDTHAdaptive)/3.5));
    }];
    
    CGRect MainSize = [CHCalculatedMode CHCalculatedWithStr:mainBut.titleLabel.text size:CGSizeMake(CHMainScreen.size.width/2-20, 32) attributes:@{NSFontAttributeName:CHFontBold(nil, 15)}];
    CGRect GailSize = [CHCalculatedMode CHCalculatedWithStr:gailBut.titleLabel.text size:CGSizeMake(CHMainScreen.size.width/2-20, 32) attributes:@{NSFontAttributeName:CHFontBold(nil, 15)}];
    CGFloat offset = MAX(MainSize.size.width, GailSize.size.width) + 70;
    
    [mainBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.centerX.mas_equalTo(headView.mas_centerX).mas_offset(-offset/2 - 20);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(offset);
    }];
    [mainBut layoutButtonWithEdgeInsetsStyle:buttonddgeinsetsstyleleft space:10];
    
    [gailBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.centerX.mas_equalTo(headView.mas_centerX).mas_offset(offset/2 + 20);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(offset);
    }];
    [gailBut layoutButtonWithEdgeInsetsStyle:buttonddgeinsetsstyleleft space:10];
    
    [confimBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(40);
    }];
    
    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(confimBut.mas_top).mas_offset(-40);
        make.right.mas_equalTo(0);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndex = @"INFOCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndex];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndex];
        cell.textLabel.font = CHFontNormal(nil, 16);
        cell.detailTextLabel.font = CHFontNormal(nil, 16);
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == titArr.count - 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.textColor = CHUIColorFromRGB(CHMediumBlackColor, 1.0);
    }
    cell.textLabel.text = [titArr objectAtIndex:indexPath.row];
    if (indexPath.row == 0) cell.detailTextLabel.text = user.deviceNa ? user.deviceNa:CHLocalizedString(@"宝贝", nil);
    if (indexPath.row == 1) cell.detailTextLabel.text = user.deviceBi ? user.deviceBi:CHLocalizedString(@"", nil);
    if (indexPath.row == 2) cell.detailTextLabel.text = [NSString stringWithFormat:@"%d%@",user.deviceHe.intValue,CHLocalizedString(@"厘米", nil)];
    if (indexPath.row == 3) cell.detailTextLabel.text = [NSString stringWithFormat:@"%d%@",user.deviceWi.intValue,CHLocalizedString(@"公斤", nil)];
    if (indexPath.row == 4) cell.detailTextLabel.text = user.devicePh ? user.devicePh:CHLocalizedString(@"", nil);
    if (indexPath.row == 5) cell.detailTextLabel.text = user.deviceIMEI ? user.deviceIMEI:CHLocalizedString(@"", nil);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:CHLocalizedString(@"昵称", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [aler addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
        }];
        UIAlertAction *conFimAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *nickField = (UITextField *)aler.textFields[0];
            user.deviceNa = nickField.text;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = nickField.text;
        }];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:CHLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [aler addAction:cancelAct];
        [aler addAction:conFimAct];
        [self presentViewController:aler animated:YES completion:^{
            
        }];
    }
    if (indexPath.row) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        CHPhotoView *PickView = [CHPhotoView initWithNomarSheet];
        [PickView createBirthdayUIDidSelectConfirm:^(CHButton *sender) {
            
        }];
        [app.window addSubview:PickView];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    __block UIImage* image;
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",user.deviceId]];
        image = [UIImage image:image fortargetSize:CGSizeMake(200, 200)];
        NSLog(@"rgerh==%lu",UIImageJPEGRepresentation(image, 1).length);
        BOOL result = [UIImageJPEGRepresentation(image, 1) writeToFile: filePath  atomically:YES];
        if(result) {
        NSLog(@"上传成功");
        }else{
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{
        user.deviceIm = [UIImageJPEGRepresentation(image, 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [headBut setImage:[UIImage mergeMainIma:image subIma:[UIImage imageNamed:@"icon_xiangji"] callBackSize:CGSizeMake((CHMainScreen.size.width * WIDTHAdaptive)/3.5, (CHMainScreen.size.width * WIDTHAdaptive)/3.5)] forState:UIControlStateNormal];
    }];
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
