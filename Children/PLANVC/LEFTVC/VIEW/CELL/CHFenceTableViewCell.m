//
//  CHFenceTableViewCell.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHFenceTableViewCell.h"

@implementation CHFenceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    CHLabel *line0 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.contentView addSubview:line0];
    
    self.headIma = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_quyu"] backColor:nil];
    [self.contentView addSubview:self.headIma];
    
    self.fenceLab = [CHLabel createWithTit:CHLocalizedString(@"", nil) font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(0x646464, 1.0) backColor:nil textAlignment:2];
    [self.contentView addSubview:self.fenceLab];
    
    self.titLab = [CHLabel createWithTit:CHLocalizedString(@"", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [self.contentView addSubview:self.titLab];
    
    self.adressLab = [CHLabel createWithTit:CHLocalizedString(@"", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(0x646464, 1.0) backColor:nil textAlignment:0];
    self.adressLab.numberOfLines = 0;
    [self.contentView addSubview:self.adressLab];
    
    CHLabel *line1 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.contentView addSubview:line1];
    
    [line0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(16);
        make.height.mas_equalTo(1);
    }];
    
    [self.headIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(19);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [self.fenceLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(3);
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_centerY).mas_equalTo(-6);
        make.width.mas_lessThanOrEqualTo(self.contentView.mas_width).multipliedBy(0.5).mas_offset(-10);
    }];
    [self.fenceLab setContentHuggingPriority:UILayoutPriorityRequired
                               forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.titLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(3);
        make.left.mas_equalTo(self.headIma.mas_right).mas_offset(17);
        make.bottom.mas_equalTo(self.contentView.mas_centerY).mas_equalTo(-6);
        make.right.mas_equalTo(self.fenceLab.mas_left).mas_offset(-8);
    }];
    
    [self.adressLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headIma.mas_right).mas_offset(17);
        make.top.mas_equalTo(self.contentView.mas_centerY).mas_equalTo(-4);
        make.right.mas_equalTo(self.contentView).mas_offset(-16);
        make.bottom.mas_equalTo(-2);
    }];
    
    [line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(16);
        make.height.mas_equalTo(1);
    }];
    
//    self.fenceLab.backgroundColor = [UIColor greenColor];
//    self.titLab.backgroundColor = [UIColor redColor];
//    self.adressLab.backgroundColor = [UIColor orangeColor];
}

- (void)setFenceMode:(CHFenceInfoMode *)fenceMode{
    _fenceMode = fenceMode;
    self.titLab.text = fenceMode.FenceName ? fenceMode.FenceName:@"";
    self.adressLab.text = fenceMode.Address ? fenceMode.Address:@"";
    NSString *fenceStr = [NSString stringWithFormat:@"%.0f",fenceMode.Radius];
    self.fenceLab.text = [fenceStr intValue]>0 ? CHLocalizedString(@"安全范围%@米", fenceStr):@"";
}
@end
