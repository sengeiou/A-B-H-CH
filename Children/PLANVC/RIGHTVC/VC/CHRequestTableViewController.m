//
//  CHRequestTableViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/23.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHRequestTableViewController.h"

@interface CHRequestTableViewController ()
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) NSArray *requestArr;
@end

@implementation CHRequestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
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

- (void)createUI{
    self.title = CHLocalizedString(@"申请消息", nil);
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, CHMainScreen.size.width, 0, 0)];
}

- (void)initializeMethod{
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"UserId":self.user.userId}];
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_RequestList parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        selfWeak.requestArr = [CHRequestInfoMode mj_objectArrayWithKeyValuesArray:result[@"Items"]];
        [selfWeak.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 3;
    return self.requestArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 148 * (([[UIScreen mainScreen] bounds].size.width) > 375 ? ([UIScreen mainScreen].bounds.size.width/375) : 1.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *requestIndex = @"REQUESTCELL";
    CHRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestIndex];
    if (!cell) {
        cell = [[CHRequestTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:requestIndex];
    }
    CHRequestInfoMode *mode = [self.requestArr objectAtIndex:indexPath.row];
    cell.infoMode = mode;
    [cell requestDispose:^(BOOL agree) {
        NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
        [dic addEntriesFromDictionary:@{@"RequestId": [NSString stringWithFormat:@"%ld",(long)cell.infoMode.RequestId],
                                        @"TypeId": agree ? @"1":@"2"}];
        [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_Process parameters:dic Mess:@"" showError:YES progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
            if ([result[@"State"] intValue] == 0) {
                mode.Status = agree ? 1:2;
                cell.infoMode = mode;
                [MBProgressHUD showSuccess:CHLocalizedString(@"已处理", nil)];
            }
            else{
                 [MBProgressHUD showSuccess:CHLocalizedString(@"处理失败", nil)];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            
        }];
    }];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
