//
//  CHDeiceCollectionViewCell.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/27.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHDeiceCollectionViewCell.h"

@implementation CHDeiceCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
//    self.contentView.backgroundColor = [UIColor redColor];
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.imageView = [UIImageView new];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = self.frame.size.height/3;
//    self.imageView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.imageView];
    
    self.maskView = [UIView new];
    self.maskView.layer.masksToBounds = YES;
    self.maskView.layer.cornerRadius = self.frame.size.height/3;
    self.maskView.backgroundColor = CHUIColorFromRGB(0x000000, 0.5);
    self.maskView.hidden = YES;
    [self.contentView addSubview:self.maskView];
    
    self.titleLab = [CHLabel createWithTit:nil font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) backColor:nil textAlignment:1];
//    self.titleLab.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:self.titleLab];
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.frame.size.height/1.5);
        make.width.mas_equalTo(self.frame.size.height/1.5);
    }];
    
    [self.maskView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.frame.size.height/1.5);
        make.width.mas_equalTo(self.frame.size.height/1.5);
    }];
    
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-2);
        make.right.mas_equalTo(0);
    }];
}

- (void)setCellMask:(BOOL)cellMask{
    _cellMask = cellMask;
    if (cellMask) {
        self.maskView.hidden = YES;
        self.titleLab.textColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    }
    else{
        self.maskView.hidden = NO;
        self.titleLab.textColor = CHUIColorFromRGB(0xafafaf, 1.0);
    }
}
@end
