//
//  CHMessTableViewCell.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/18.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHMessTableViewCell.h"

@interface CHMessTableViewCell ()
@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) CHLabel *headLab, *messLab;
@end

@implementation CHMessTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _cellImageView = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_dld"] backColor:nil];
    [self.contentView addSubview:_cellImageView];
    
    _headLab = [CHLabel createWithTit:@"" font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(0x242424, 1.0) backColor:nil textAlignment:0];
    [self.contentView addSubview:_headLab];
    
    _messLab = [CHLabel createWithTit:@"" font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:nil textAlignment:0];
    _messLab.numberOfLines = 0;
    [self.contentView addSubview:_messLab];
    
    UIView *backView = [[UIView alloc] init];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 8.0f;
    backView.layer.borderWidth = 1.0f;
    backView.layer.borderColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0).CGColor;
    [self.contentView addSubview:backView];
    
    [backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
    }];
    
    [_cellImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(backView.mas_left).mas_offset(19);
        make.width.mas_equalTo(51 * WIDTHAdaptive);
        make.height.mas_equalTo(51 * WIDTHAdaptive);
    }];
    
    [_messLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_centerY).mas_offset(-4);
        make.left.mas_equalTo(_cellImageView.mas_right).mas_offset(19);
        make.right.mas_equalTo(backView.right).mas_offset(-19);
    }];
    
    
    [_headLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView.mas_top).mas_offset(2);
        make.left.mas_equalTo(_cellImageView.mas_right).mas_offset(19);
        make.bottom.mas_equalTo(_messLab.mas_top).mas_offset(-2);
        make.right.mas_equalTo(backView.right).mas_offset(-19);
    }];
}

- (void)setMesMode:(CHMessageListInfoMode *)mesMode{
    _mesMode = mesMode;
    _cellImageView.image = [self notImaNotificationType:mesMode.NotificationType];
    _headLab.text = (mesMode.NotificationType != 1 && mesMode.NotificationType != 2) ? mesMode.ExceptionName:mesMode.GeoName;
    _messLab.text = mesMode.Message;
}

- (UIImage *)notImaNotificationType:(NSInteger)type{
    switch (type) {
        case 1:
            return [UIImage imageNamed:@"icon_djtx"];
            break;
        case 2:
            return [UIImage imageNamed:@"icon_aqwl"];
            break;
        case 3:
            return [UIImage imageNamed:@"icon_dld"];
            break;
        default:
            break;
    }
    return [UIImage imageNamed:@"icon_xiaoxi"];
}

@end
