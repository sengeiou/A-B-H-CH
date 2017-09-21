//
//  CHTrackingAnnotationView.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/15.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHTrackingAnnotationView.h"

@implementation CHTrackingAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setText:(NSString *)text{
    [self createUIText:text];
}

- (void)setHeadColor:(UIColor *)headColor{
    _headColor = headColor;
    self.trackView.backgroundColor = self.headColor;
}

- (void)createUIText:(NSString *)text{
    self.trackView = [[CHTrackHeadVeiw alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [self.trackView setTitleLabText:text];
    [self addSubview:self.trackView];
    
    CGSize imageSize = [UIImage imageNamed:@"icon_dinwei_qd"].size;
    self.bounds = CGRectMake(0, 0, self.trackView.bounds.size.width <= imageSize.width ? imageSize.width:self.trackView.bounds.size.width, self.trackView.bounds.size.height + imageSize.height + 2);
    
    self.imageView = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_dinwei_qd"] backColor:nil];
    self.imageView.frame = CGRectMake(0, 3, [UIImage imageNamed:@"icon_dinwei_qd"].size.width, [UIImage imageNamed:@"icon_dinwei_qd"].size.height);
    self.imageView.center = CGPointMake(self.bounds.size.width/2, self.imageView.center.y);
    [self addSubview:self.imageView];
    
    self.trackView.frame = CGRectMake(0, CGRectGetMinY(self.imageView.frame) - self.trackView.frame.size.height, self.trackView.frame.size.width, self.trackView.frame.size.height);
    self.trackView.center = CGPointMake(self.bounds.size.width/2, self.trackView.center.y);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
