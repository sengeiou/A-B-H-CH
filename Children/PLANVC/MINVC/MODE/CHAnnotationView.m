//
//  CHAnnotationView.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/29.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHAnnotationView.h"

@implementation CHAnnotationView
{
    tapAnnotation tapBlock;
    BOOL _selected;
}
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
//        self.image = [UIImage imageNamed:@"icon_weixuandingwei"];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
//    MKPinAnnotationView
//    self.backgroundColor = [UIColor greenColor];
    _IconImageView = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_weixuandingwei"] backColor:nil];
    [self addSubview:_IconImageView];
//    self.userInteractionEnabled = YES;
    _IconImageView.userInteractionEnabled = YES;
    [_IconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(43 * WIDTHAdaptive);
        make.width.mas_equalTo(28 * WIDTHAdaptive);
    }];
    
    _nameLab = [CHLabel createWithTit:nil font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(0xe66161, 1.0) backColor:CHUIColorFromRGB(0xffffff, 1.0) textAlignment:1];
    [self addSubview:_nameLab];
    [self updateLayer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
    [self addGestureRecognizer:tap];
    
//    CHButton *but = [CHButton createWithTit:nil titColor:nil textFont:nil backColor:[UIColor greenColor] touchBlock:^(CHButton *sender) {
//        NSLog(@"createWithTit");
//    }];
//    [self addSubview:but];
//    [but mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(0);
//        make.centerX.mas_equalTo(self);
//        make.height.mas_equalTo(50 * WIDTHAdaptive);
//        make.width.mas_equalTo(50 * WIDTHAdaptive);
//    }];
//    NSLog(@"fwegg ==%@",self.gestureRecognizers);
}

- (void)setLabTit:(NSString *)tit{
    if (tit) {
        self.nameLab.text = tit;
    }
    [self updateLayer];
}

- (void)updateLayer{
    CGRect titRect = [CHCalculatedMode CHCalculatedWithStr:self.nameLab.text size:CGSizeMake(CHMainScreen.size.width - 40, 20) attributes:@{NSFontAttributeName:CHFontNormal(nil, 12)}];
    titRect.size.height = titRect.size.width > 0 ? 20:0;
    titRect.size.width = MAX(titRect.size.width, 60) + 6;
    [_nameLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_IconImageView.mas_top);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(titRect.size.height);
        make.width.mas_equalTo(titRect.size.width);
    }];
    
    _nameLab.layer.masksToBounds = YES;
    _nameLab.layer.borderWidth = 1.0;
    _nameLab.layer.borderColor = CHUIColorFromRGB(0xe66161, 1.0).CGColor;
    _nameLab.layer.cornerRadius = 8.0;
    
    self.bounds = CGRectMake(0, 0, _IconImageView.bounds.size.width, titRect.size.height + _IconImageView.bounds.size.height);
}

- (void)tapImage{
    tapBlock(self.annotation);
}

- (void)setAnnSelect:(BOOL)annSelect{
    _annSelect = annSelect;
    [self setSelect:_annSelect];
    NSLog(@"_annSelect  %d",_annSelect);
}

//- (void)setSelected:(BOOL)selected{
//    if (![self isKindOfClass:[CHAnnotationView class]]) {
//        return;
//    }
//    _selected = selected;
//    [self setSelect:_selected];
//    NSLog(@"_selected  %d",_selected);
//}
//
//- (BOOL)isSelected{
//    return _selected;
//}

- (void)setSelect:(BOOL)select{
    if (select) {
        NSLog(@"*******************************annoViewYES %@",self);
        [_IconImageView setImage:[UIImage imageNamed:@"icon_dangqiandingwei"]];
        _nameLab.layer.borderColor = CHUIColorFromRGB(0xff0000, 1.0).CGColor;
        _nameLab.textColor = CHUIColorFromRGB(0xff0000, 1.0);
    }
    else{
        NSLog(@"*******************************annoViewNO %@",self);
        _nameLab.layer.borderColor = CHUIColorFromRGB(0xe66161, 1.0).CGColor;
        _nameLab.textColor = CHUIColorFromRGB(0xe66161, 1.0);
        [_IconImageView setImage:[UIImage imageNamed:@"icon_weixuandingwei"]];
    }
}

- (void)didSelectAnnotaton:(tapAnnotation)block{
        tapBlock = block;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
