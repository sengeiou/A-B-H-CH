//
//  CHGuarderCell.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/9.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHGuarderCell.h"

@implementation CHGuarderCell

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
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
    
    _headView = [UIImageView itemWithImage:nil backColor:nil Radius:22 * WIDTHAdaptive];
    [self.contentView addSubview:_headView];
    
    _titLab = [CHLabel createWithTit:nil font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:1];
    [self.contentView addSubview:_titLab];
    
    _adminLab = [CHLabel createWithTit:CHLocalizedString(@"device_admin", nil) font:CHFontNormal(nil, 10) textColor:CHUIColorFromRGB(0x0288d1, 1.0) backColor:nil textAlignment:1];
    CGRect titRect= [CHCalculatedMode CHCalculatedWithStr:_adminLab.text size:CGSizeMake(100, 200) attributes:@{NSFontAttributeName:CHFontNormal(nil, 10)}];
    _adminLab.layer.masksToBounds = YES;
    _adminLab.layer.cornerRadius = 6;
    _adminLab.layer.borderColor = CHUIColorFromRGB(0x0288d1, 1.0).CGColor;
    _adminLab.layer.borderWidth = 1.0f;
    _adminLab.hidden = YES;
    [self.contentView addSubview:_adminLab];
    
    _phoneLab = [CHLabel createWithTit:nil font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(0x646464, 1.0) backColor:nil textAlignment:1];
    [self.contentView addSubview:_phoneLab];
    
//    _phoneLab = [CHLabel createWithTit:CHLocalizedString(@"同步中...\n需要手表联网", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:1];
//     [self.contentView addSubview:_phoneLab];
    
    [_headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(19);
        make.width.mas_equalTo(44 * WIDTHAdaptive);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
    }];
    
    [_titLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headView.mas_right).mas_offset(21);
        make.centerY.mas_equalTo(self.contentView).mas_offset(-12);
        make.width.mas_lessThanOrEqualTo(CHMainScreen.size.width - 19 - 44 * WIDTHAdaptive - 21 - titRect.size.width - 16 - 56);
    }];
    
    [_adminLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titLab.mas_right).mas_offset(21);
        make.centerY.mas_equalTo(_titLab);
        make.width.mas_equalTo(titRect.size.width + 16);
        make.height.mas_equalTo(_titLab);
    }];
    
    [_phoneLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headView.mas_right).mas_offset(21);
        make.centerY.mas_equalTo(self.contentView).mas_offset(12);
        make.width.mas_lessThanOrEqualTo(CHMainScreen.size.width - 19 - 44 * WIDTHAdaptive - 21 - titRect.size.width - 16 - 56);
    }];
}

- (void)setIsAdmin:(BOOL)isAdmin{
    _isAdmin = isAdmin;
    _adminLab.hidden = !isAdmin;
}

//- (id)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self createUI];
//    }
//    return self;
//}

@end
