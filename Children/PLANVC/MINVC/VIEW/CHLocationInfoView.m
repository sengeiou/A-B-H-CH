//
//  CHLocationInfoView.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/27.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHLocationInfoView.h"

@interface CHLocationInfoView ()
{
    CHButton *updateBut;
    NSIndexPath *selectIndex;
    didSelectCollection block;
    ButTouchedBlock butBlock;
}
@end

@implementation CHLocationInfoView
static NSString * const reuseIdentifier = @"DEVICECELL";

- (instancetype)initWithShowView:(BOOL)show{
    self = [CHLocationInfoView new];
    [self createUI];
    return self;
}

- (void)createUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.deviceCollView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.deviceCollView.delegate = self;
    self.deviceCollView.dataSource = self;
    [self.deviceCollView registerClass:[CHDeiceCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.deviceCollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.deviceCollView];
    
    UIView *locaView = [UIView new];
    locaView.backgroundColor = [UIColor whiteColor];
    [self addSubview:locaView];
    
    self.locaLab = [CHLabel createWithTit:nil font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    self.locaLab.numberOfLines = 0;
    [locaView addSubview:self.locaLab];
    
    updateBut = [CHButton createWithTit:CHLocalizedString(@"location_update", nil) titColor:CHUIColorFromRGB(0xffffff, 1.0) textFont:CHFontNormal(nil, 9) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:22 touchBlock:^(CHButton *sender) {
        butBlock(sender);
    }];
    [updateBut setImage:[UIImage imageNamed:@"icon_shuaxin"] forState:UIControlStateNormal];
    
    [self addSubview:updateBut];
    
    UIView *iphoneX = [UIView new];
    iphoneX.backgroundColor = [UIColor whiteColor];
     [self addSubview:iphoneX];
    
    [self.deviceCollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(iphoneX.mas_top);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(self.mas_height).multipliedBy(iPhoneX ? 0.4:0.5);
    }];
    
    [locaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.deviceCollView.mas_top).mas_offset(-2);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(22);
//        make.height.mas_equalTo(self.mas_height).multipliedBy(iPhoneX ? 0.4:0.5).mas_offset(-16);
    }];
    
    [updateBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
//    [updateBut sizeToFit];
    
    [self.locaLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(updateBut.mas_left).mas_offset(-8);
    }];
    
    [iphoneX mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(HOME_INDICATOR_HEIGHT);
    }];
}

- (void)layoutSubviews{
    [updateBut layoutButtonWithEdgeInsetsStyle:buttonddgeinsetsstyletop space:8];
}

- (void)setDevices:(NSMutableArray<CHUserInfo *> *)devices{
    _devices = devices;
    [self.deviceCollView reloadData];
}

- (void)didSelectItem:(didSelectCollection)callBack{
    block = callBack;
}

- (void)didUpdateLogo:(ButTouchedBlock) callBack{
    butBlock = callBack;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _devices.count;
//    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CHDeiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    dispatch_queue_t queue = dispatch_queue_create("imageQuiet", DISPATCH_QUEUE_CONCURRENT);
    CHUserInfo *device = [_devices objectAtIndex:indexPath.row];
    dispatch_async(queue, ^{
        UIImage *deviceIma = [UIImage imageNamed:@"pho_touxiang"];
        if (device.deviceIm && ![[device deviceIm] isEqualToString:@""]) {
            NSData *imaData = [[NSData alloc] initWithBase64EncodedString:device.deviceIm options:NSDataBase64DecodingIgnoreUnknownCharacters];
            deviceIma = [UIImage imageWithData:imaData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = deviceIma;
            if (_selectDevice.deviceId.intValue == device.deviceId.intValue) {
                cell.cellMask = YES;
            }
            else{
                cell.cellMask = NO;
            }
        });
    });
    cell.titleLab.text = [TypeConversionMode strongChangeString:device.deviceNa];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (int i = 0; i < _devices.count; i ++) {
        CHDeiceCollectionViewCell *cell1 = (CHDeiceCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (indexPath.row == i) {
            cell1.cellMask = YES;
        }
        else{
            cell1.cellMask = NO;
        }
    }
    _selectDevice = [_devices objectAtIndex:indexPath.row];
    if (block) {
        block(_selectDevice);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((CHMainScreen.size.width - (20 * 5))/4, collectionView.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20.0f;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

