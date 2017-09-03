//
//  CHDeviceView.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/1.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHDeviceView.h"

@implementation CHDeviceView

+ (CHDeviceView *)createView{
    CHDeviceView *view = [CHDeviceView new];
    return view;
}

- (void)updateView:(float)proportion{
    
    if (!self.image) {
        self.image = [[UIImageView alloc] init];
        [self addSubview:self.image];
        self.lable = [UILabel new];
        [self addSubview:self.lable];
        self.lable.textAlignment = NSTextAlignmentCenter;
        self.lable.textColor = CHUIColorFromRGB(0xffffff, 1.0);
    }
    _image.frame = CGRectMake(0, 0, self.frame.size.width * proportion, self.frame.size.width * proportion);
    _image.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - ((self.frame.size.height - self.image.frame.size.height) * proportion)/2);
    _lable.frame = CGRectMake(0, CGRectGetMaxY(self.image.frame) + 2, self.frame.size.width, (self.frame.size.height - self.image.frame.size.height - 2) * proportion);
    _lable.center = CGPointMake(self.frame.size.width/2, _lable.center.y);
  
//    self.image.backgroundColor = [UIColor orangeColor];
//    self.lable.backgroundColor = [UIColor lightGrayColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
