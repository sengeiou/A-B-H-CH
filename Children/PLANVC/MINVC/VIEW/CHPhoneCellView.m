//
//  CHPhoneCellView.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/25.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHPhoneCellView.h"

@interface CHPhoneCellView ()
@property (nonatomic, strong) NSMutableArray <CHUserInfo *>*deiveArr;
@property (nonatomic, copy) didSelectCellBlock block;
@end

@implementation CHPhoneCellView

- (instancetype)initWithDevices:(NSMutableArray *)deviceList callBackBlock:(didSelectCellBlock)backBlock{
    self = [[CHPhoneCellView alloc] initWithFrame:CHMainScreen];
    self.deiveArr = deviceList;
    self.block = backBlock;
    [self createUI];
    return self;
}

- (void)createUI{
    self.backgroundColor = CHUIColorFromRGB(0x000000, 0.5);
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tpaAction)];
//    [self addGestureRecognizer:tap];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIView *but = [UIView new];
    but.backgroundColor = [UIColor clearColor];
    [but addTarget:self action:@selector(tpaAction) forControlEvents:UIControlEventTouchUpInside];
//     [but addGestureRecognizer:tap];
    [self addSubview:but];
    
    UITableView *cellTab = [UITableView new];
    cellTab.dataSource = self;
    cellTab.delegate = self;
    cellTab.layer.masksToBounds = YES;
    cellTab.layer.cornerRadius = 8.0;
    [self addSubview:cellTab];
    
    [but mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [cellTab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(44 * (self.deiveArr.count > 5 ? 5:self.deiveArr.count));
    }];
    
}

- (void)tpaAction{
    [self removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deiveArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *phoneCell = @"PHONECELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:phoneCell];
    }
    cell.textLabel.text = self.deiveArr[indexPath.row].deviceNa;
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_boda"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.block) {
        self.block(self.deiveArr[indexPath.row]);
    }
    [self tpaAction];
}


@end
