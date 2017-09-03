//
//  CHButton+HQX.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/15.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHButton+HQX.h"
static const void *butBlockKey = &butBlockKey;
@implementation CHButton (HQX)

+ (CHButton *)createWithTit:(NSString *)tit titColor:(UIColor *)color textFont:(UIFont *)font backColor:(UIColor *)backColor touchBlock:(ButTouchedBlock)butTouchedBlack{
    CHButton *but = [CHButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:tit ? tit:@"" forState:UIControlStateNormal];
    [but setTitleColor:color ? color:[UIColor blackColor] forState:UIControlStateNormal];
    but.backgroundColor = backColor ? backColor:[UIColor clearColor];
    but.titleLabel.font = font;
    objc_setAssociatedObject(but, butBlockKey, butTouchedBlack, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [but addTarget:but action:@selector(didTouchBut:) forControlEvents:UIControlEventTouchUpInside];
    return but;
}

+ (CHButton *)createWithTit:(NSString *)tit titColor:(UIColor *)color textFont:(UIFont *)font backImageColor:(UIColor *)backColor touchBlock:(ButTouchedBlock)butTouchedBlack{
    CHButton *but = [CHButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:tit ? tit:@"" forState:UIControlStateNormal];
    [but setTitleColor:color ? color:[UIColor blackColor] forState:UIControlStateNormal];
    [but setBackgroundImage:[UIImage CHimageWithColor:backColor ? backColor:[UIColor clearColor] size:CHMainScreen.size] forState:UIControlStateNormal];
    objc_setAssociatedObject(but, butBlockKey, butTouchedBlack, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [but addTarget:but action:@selector(didTouchBut:) forControlEvents:UIControlEventTouchUpInside];
    return but;
}

+ (CHButton *)createWithBackImage:(UIImage *)Ima touchBlock:(ButTouchedBlock)butTouchedBlack{
    CHButton *but = [CHButton buttonWithType:UIButtonTypeCustom];
    [but setBackgroundImage:Ima forState:UIControlStateNormal];
    objc_setAssociatedObject(but, butBlockKey, butTouchedBlack, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [but addTarget:but action:@selector(didTouchBut:) forControlEvents:UIControlEventTouchUpInside];
    return but;
}

+ (CHButton *)createWithTit:(NSString *)tit titColor:(UIColor *)color textFont:(UIFont *)font backColor:(UIColor *)backColor Radius:(CGFloat)radius touchBlock:(ButTouchedBlock)butTouchedBlack{
    CHButton *but = [self createWithTit:tit titColor:color textFont:font backColor:backColor touchBlock:butTouchedBlack];
    [but.layer setMasksToBounds:YES];
    [but.layer setCornerRadius:radius];
    return but;
}

+ (CHButton *)createWithTit:(NSString *)tit titColor:(UIColor *)color textFont:(UIFont *)font backImaColor:(UIColor *)backColor Radius:(CGFloat)radius touchBlock:(ButTouchedBlock)butTouchedBlack{
    CHButton *but = [self createWithTit:tit titColor:color textFont:font backImageColor:backColor touchBlock:butTouchedBlack];
    [but.layer setMasksToBounds:YES];
    [but.layer setCornerRadius:radius];

    return but;
}

+ (CHButton *)createWithNorImage:(UIImage *)norIma lightIma:(UIImage *)liIma touchBlock:(ButTouchedBlock)butTouchedBlack{
    CHButton *but = [CHButton buttonWithType:UIButtonTypeCustom];
    [but setImage:norIma forState:UIControlStateNormal];
    [but setImage:liIma forState:UIControlStateHighlighted];
    objc_setAssociatedObject(but, butBlockKey, butTouchedBlack, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [but addTarget:but action:@selector(didTouchBut:) forControlEvents:UIControlEventTouchUpInside];
    return but;
}

+ (CHButton *)createAttributedString:(NSString *)Text attributedDic:(NSDictionary *)dic touchBlock:(ButTouchedBlock)butTouchedBlack{
    CHButton *but = [CHButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:Text attributes:dic];
    [but setAttributedTitle:attributedText forState:UIControlStateNormal];
    objc_setAssociatedObject(but, butBlockKey, butTouchedBlack, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [but addTarget:but action:@selector(didTouchBut:) forControlEvents:UIControlEventTouchUpInside];
    return but;
}

+ (CHButton *)createWithImage:(UIImage *)iamge Radius:(CGFloat)radius touchBlock:(ButTouchedBlock)butTouchedBlack{
    CHButton *but = [self createWithBackImage:iamge touchBlock:butTouchedBlack];
    [but.layer setMasksToBounds:YES];
    [but.layer setCornerRadius:radius];
    return but;
}

- (void)drawRadius:(CGFloat)radius{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:radius];
}

- (void)didTouchBut:(CHButton *)sender{
    ButTouchedBlock block = objc_getAssociatedObject(self, butBlockKey);
    if (block) {
        block(sender);
    }
}

- (void)layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style space:(CGFloat)space{
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case buttonddgeinsetsstyletop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case buttonddgeinsetsstyleleft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case buttonddgeinsetsstyletopbottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case buttonddgeinsetsstyletopright:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}
@end
