//
//  CHTrackHeadVeiw.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/15.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHTrackHeadVeiw.h"

@implementation CHTrackHeadVeiw

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

- (void)setTitleLabText:(NSString *)titleLab{
    [self createUIText:titleLab];
}

- (void)createUIText:(NSString *)titleLab{
    CGRect titleRect = [CHCalculatedMode CHCalculatedWithStr:titleLab size:CGSizeMake(320, 100) attributes:@{NSFontAttributeName:CHFontNormal(nil, 14)}];
    float radius = (titleRect.size.height + 6)/2;
    self.bounds = CGRectMake(0, 0, titleRect.size.width + 16, radius * 3);
    
    if (!self.titleLab) {
        self.titleLab = [CHLabel createWithTit:titleLab font:CHFontNormal(nil, 14) textColor:nil backColor:nil textAlignment:1];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(2);
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-radius/2);
        }];
    }
    else{
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(2);
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-radius/2);
        }];
    }
    
    self.backgroundColor = CHUIColorFromRGB(0xff0000, 1.0);
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.backgroundColor = [UIColor greenColor].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPath];

    [path moveToPoint:CGPointMake(radius, 0)];
    [path addArcWithCenter:CGPointMake(radius, radius) radius: radius startAngle:-((float)M_PI/2) endAngle:M_PI_2 clockwise:NO];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2 - 4, radius*2)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height - 2)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2 + 4, radius*2)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2 - radius, radius*2)];
    [path addArcWithCenter:CGPointMake(self.frame.size.width-radius, radius) radius: radius startAngle:M_PI_2 endAngle:-((float)M_PI/2) clockwise:NO];
    [path addLineToPoint:CGPointMake(radius, 0)];
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
    self.layer.mask = layer;
    
    
   // [self.layer addSublayer:textLayer];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
