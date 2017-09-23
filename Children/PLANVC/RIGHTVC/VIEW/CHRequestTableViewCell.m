//
//  CHRequestTableViewCell.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/23.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHRequestTableViewCell.h"

typedef void(^didTouchUpInBlock)(BOOL Agree);

@interface CHRequestTableViewCell ()
@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) CHLabel *titLab, *headLab, *messLab;
@property (nonatomic, strong) CHButton *refuseBut, *consentBut;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, copy) didTouchUpInBlock callBack;
@end

@implementation CHRequestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    }
    return _dateFormatter;
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
    
    UIView *backView = [[UIView alloc] init];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 8.0f;
    backView.layer.borderWidth = 1.0f;
    backView.layer.borderColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 0.8).CGColor;
    [self.contentView addSubview:backView];
    
    _cellImageView = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_dld"] backColor:nil Radius:51 * WIDTHAdaptive/2];
    [backView addSubview:_cellImageView];
    
    _headLab = [CHLabel createWithTit:@"" font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(0x242424, 1.0) backColor:nil textAlignment:0];
    [backView addSubview:_headLab];
    
    _messLab = [CHLabel createWithTit:@"" font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:nil textAlignment:0];
    _messLab.numberOfLines = 0;
    [backView addSubview:_messLab];
    
    _titLab = [CHLabel createWithTit:@"abc" font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(0x757575, 1.0) backColor:nil textAlignment:1];
    [self.contentView addSubview:_titLab];
    
    CGRect consentRect = [CHCalculatedMode CHCalculatedWithStr:CHLocalizedString(@"同意", nil) size:CGSizeMake(1000, 24 * WIDTHAdaptive) attributes:@{NSFontAttributeName:CHFontNormal(nil, 14)}];
    CGRect refuseRect = [CHCalculatedMode CHCalculatedWithStr:CHLocalizedString(@"拒绝", nil) size:CGSizeMake(1000, 24 * WIDTHAdaptive) attributes:@{NSFontAttributeName:CHFontNormal(nil, 14)}];
    
    float maxWidth = MAX(consentRect.size.width, refuseRect.size.width) + 16;
    maxWidth = MAX(maxWidth, 80);
    @WeakObj(self)
    _consentBut = [CHButton createWithTit:CHLocalizedString(@"同意", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 14) backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) Radius:6.0 touchBlock:^(CHButton *sender) {
        if (selfWeak.callBack) {
            selfWeak.callBack(YES);
        }
    }];
    [self.contentView addSubview:_consentBut];
    
    _refuseBut = [CHButton createWithTit:CHLocalizedString(@"拒绝", nil) titColor:[UIColor whiteColor] textFont:CHFontNormal(nil, 14) backColor:CHUIColorFromRGB(0x757575, 1.0) Radius:6.0 touchBlock:^(CHButton *sender) {
        if (selfWeak.callBack) {
            selfWeak.callBack(NO);
        }
    }];
    [self.contentView addSubview:_refuseBut];
    
    //   _titLab.backgroundColor = [UIColor greenColor];
    [_titLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(18);
    }];
    
    [backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titLab.mas_bottom).mas_offset(6);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
    }];
    
    [_cellImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-8);
        make.left.mas_equalTo(backView.mas_left).mas_offset(16);
        make.width.mas_equalTo(51 * WIDTHAdaptive);
        make.height.mas_equalTo(51 * WIDTHAdaptive);
    }];
    
    [_headLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView.mas_top).mas_offset(8);
        make.left.mas_equalTo(_cellImageView.mas_right).mas_offset(16);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(backView.right).mas_offset(-16);
    }];
    [_messLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headLab.mas_bottom).mas_offset(2);
        make.left.mas_equalTo(_cellImageView.mas_right).mas_offset(16);
        make.right.mas_equalTo(backView.right).mas_offset(-16);
        make.bottom.mas_equalTo(_refuseBut.mas_top).mas_offset(-6);
    }];
    
    [_consentBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).mas_offset(-8);
        make.bottom.mas_equalTo(-8);
        make.height.mas_equalTo(24 * WIDTHAdaptive);
        make.width.mas_equalTo(maxWidth);
    }];
    
    [_refuseBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_consentBut.mas_left).mas_offset(-24);
        make.bottom.mas_equalTo(-8);
        make.height.mas_equalTo(24 * WIDTHAdaptive);
        make.width.mas_equalTo(maxWidth);
    }];
}

- (void)requestDispose:(void (^)(BOOL))callBack{
    _callBack = callBack;
}

- (void)setInfoMode:(CHRequestInfoMode *)infoMode{
    _infoMode = infoMode;
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:infoMode.Avatar] placeholderImage:[UIImage imageNamed:@"pho_usetouxiang"]];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [NSDate getNowDateFromatAnDate:[_dateFormatter dateFromString:infoMode.Created]];
    NSLog(@"fniowegj %@",[self.dateFormatter stringFromDate:date]);
    self.dateFormatter.dateFormat = @"HH:mm";
    NSLog(@"fniowegj %@",[_dateFormatter stringFromDate:date]);
    _titLab.text = [self.dateFormatter stringFromDate:date];
    _headLab.text = infoMode.Nickname;
    _messLab.text = [NSString stringWithFormat:@"%@%@",[TypeConversionMode strongChangeString:infoMode.UserName],CHLocalizedString(@"申请成为%@的监护人", [TypeConversionMode strongChangeString:infoMode.Nickname])];
    _consentBut.hidden = YES;
    _refuseBut.hidden = YES;
    [_consentBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (infoMode.Status == 0) {
        _consentBut.hidden = NO;
        _refuseBut.hidden = NO;
    }
    else {
        _consentBut.hidden = NO;
        [_consentBut setBackgroundColor:[UIColor clearColor]];
        [_consentBut setTitleColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) forState:UIControlStateNormal];
        if (infoMode.Status == 1) {
            [_consentBut setTitle:CHLocalizedString(@"已同意", nil) forState:UIControlStateNormal];
        }
        else{
            [_consentBut setTitle:CHLocalizedString(@"已拒绝", nil) forState:UIControlStateNormal];
        }
    }
}
@end
