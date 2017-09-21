//
//  CHTrackCollectionViewCell.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/14.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHTrackCollectionViewCell.h"

@interface CHTrackCollectionViewCell ()
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CALayer *redCircleLayer;
@end
@implementation CHTrackCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    _textLab = [CHLabel createWithTit:@"12" font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(CHMediumBlackColor, 1.0) backColor:[UIColor whiteColor] textAlignment:1];
    [self.contentView addSubview:_textLab];
    [_textLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.right.mas_equalTo(-8);
    }];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2 - 6 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.path = circlePath.CGPath;
    self.circleLayer.lineDashPattern = @[@3, @1];
    self.circleLayer.fillColor   = nil;
    self.circleLayer.strokeColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0).CGColor;
    self.circleLayer.hidden = NO;
    [self.contentView.layer addSublayer:self.circleLayer];
    
    self.redCircleLayer = [CALayer layer];
    self.redCircleLayer.frame = CGRectMake(CGRectGetWidth(self.frame)/2 + self.frame.size.width/2 - 8, 8, 4, 4);
    self.redCircleLayer.masksToBounds = YES;
    self.redCircleLayer.cornerRadius = 2;
    self.redCircleLayer.backgroundColor = [UIColor redColor].CGColor;
    self.redCircleLayer.hidden = NO;
    [self.contentView.layer addSublayer:self.redCircleLayer];
}

- (void)setNowDate:(BOOL)nowDate{
    _nowDate = nowDate;
    if (nowDate) {
        _textLab.textColor = CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0);
    }
    else{
        _textLab.textColor = CHUIColorFromRGB(CHMediumBlackColor, 1.0);
    }
}

- (void)setHaveDate:(BOOL)haveDate{
    _haveDate = haveDate;
    self.redCircleLayer.hidden = !_haveDate;
}

- (void)setSelectDate:(BOOL)selectDate{
    _selectDate = selectDate;
    self.circleLayer.hidden = !selectDate;
}
@end
