//
//  CHAlarmTableViewCell.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/20.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHAlarmTableViewCell.h"

typedef void(^didSelectSwitchBlock)(UISwitch *oSwitch);

@interface CHAlarmTableViewCell ()
@property (nonatomic, strong) CHLabel *timeLab, *weekTitkLab, *weekLab;
@property (nonatomic, strong) UISwitch *openSwitch;
@property (nonatomic, copy) didSelectSwitchBlock block;
@end

@implementation CHAlarmTableViewCell

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

    CHLabel *line1 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self.contentView addSubview:line1];
    
    _timeLab = [CHLabel createWithTit:@"07:00" font:CHFontNormal(nil, 36) textColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) backColor:nil textAlignment:0];
    [self.contentView addSubview:_timeLab];
    
    _openSwitch = [[UISwitch alloc] init];
    _openSwitch.onTintColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    [_openSwitch addTarget:self action:@selector(didSelectSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_openSwitch];
    
    _weekTitkLab = [CHLabel createWithTit:CHLocalizedString(@"星期", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    _weekTitkLab.numberOfLines = 2;
    [self.contentView addSubview:_weekTitkLab];
    
    _weekLab = [CHLabel createWithTit:@"" font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [self.contentView addSubview:_weekLab];
    
    [line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(1);
    }];
    
    [_openSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-36);
        make.centerY.mas_equalTo(self.contentView.centerY).mas_offset(-15);
    }];
    [_timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(33);
        make.bottom.mas_equalTo(_openSwitch.mas_bottom);
        make.right.mas_equalTo(_openSwitch.mas_left).mas_offset(-8);
    }];
    
    [_weekTitkLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLab.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(33);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(60);
    }];
    
    [_weekLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLab.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(_weekTitkLab.mas_right).mas_offset(8);
        make.right.mas_equalTo(_openSwitch.mas_left).mas_offset(-8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-2);
    }];
}

- (void)selectSwitchCallBack:(void(^)(UISwitch *oSwitch))callBack{
    _block = callBack;
}

- (void)didSelectSwitch:(UISwitch *)sender{
    if (_block) {
        _block(sender);
    }
}

- (void)setDemo:(CHCmdClassDemo *)demo{
    _demo = demo;
    _timeLab.text = demo.starTime;
    _weekLab.text = [[self weekSelectWithMode:demo] componentsJoinedByString:@","];
    _openSwitch.on = demo.open.intValue;
}

- (NSMutableArray *)weekSelectWithMode:(CHCmdClassDemo *)mode{
    NSArray *weekTits = @[CHLocalizedString(@"周一", nil),CHLocalizedString(@"周二", nil),CHLocalizedString(@"周三", nil),CHLocalizedString(@"周四", nil),CHLocalizedString(@"周五", nil),CHLocalizedString(@"周六", nil),CHLocalizedString(@"周日", nil)];
    NSMutableArray *arr = [NSMutableArray array];
    NSString *weekStr = mode.week;
    if ([weekStr containsString:@"1"]) {
        [arr addObject:weekTits[0]];
    }
    if ([weekStr containsString:@"2"]) {
        [arr addObject:weekTits[1]];
    }
    if ([weekStr containsString:@"3"]) {
        [arr addObject:weekTits[2]];
    }
    if ([weekStr containsString:@"4"]) {
        [arr addObject:weekTits[3]];
    }
    if ([weekStr containsString:@"5"]) {
      [arr addObject:weekTits[4]];
    }
    if ([weekStr containsString:@"6"]) {
       [arr addObject:weekTits[5]];
    }
    if ([weekStr containsString:@"7"]) {
        [arr addObject:weekTits[6]];
    }
    return arr;
}
@end
