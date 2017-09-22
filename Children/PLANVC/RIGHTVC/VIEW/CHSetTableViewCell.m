//
//  CHSetTableViewCell.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/22.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHSetTableViewCell.h"

@implementation CHSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    CHLabel *line0 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self addSubview:line0];
    
    _line1 = [CHLabel createWithTit:nil font:nil textColor:nil backColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) textAlignment:0];
    [self addSubview:_line1];
    
    _headImage = [UIImageView new];
    [self.contentView addSubview:_headImage];
    
    _textLab = [CHLabel createWithTit:@"" font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:nil textAlignment:0];
    [self.contentView addSubview:_textLab];
    
    [line0 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(-12);
    }];
    
    [_line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-12);
    }];
    
    [_headImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(28);
        make.width.mas_equalTo(22 * WIDTHAdaptive);
        make.height.mas_equalTo(22 * WIDTHAdaptive);
    }];
    
    [_textLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(_headImage.mas_right).mas_equalTo(18);
        NSLog(@"self.detailTextLabelself.detailTextLabel %@",self.detailTextLabel);
        make.right.mas_equalTo(self.detailTextLabel.mas_left).mas_offset(-8);
    }];
}

@end
