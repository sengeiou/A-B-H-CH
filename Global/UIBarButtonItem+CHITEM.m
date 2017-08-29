//
//  UIBarButtonItem+CHITEM.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "UIBarButtonItem+CHITEM.h"

static const void *itemBlockKey = &itemBlockKey;
@implementation UIBarButtonItem (CHITEM)
+ (UIBarButtonItem *)backItemWithIma:(UIImage *)image target:(id)target action:(SEL)action{
    UIButton *backBut = [UIButton buttonWithType:UIButtonTypeCustom];
    backBut.frame = CGRectMake(0, 0, 30, 25);
    [backBut setImage:image forState:UIControlStateNormal];
    [backBut setImage:[UIImage imageNamed:@"btu_fanhui_p"] forState:UIControlStateHighlighted];
    [backBut addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:backBut];
}

+ (UIBarButtonItem *)CHitemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon frame:(CGRect)frame  target:(id)target action:(SEL)action transfrom:(int)rotation
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img=[UIImage imageNamed:icon];
    UIImage *img1=[UIImage imageNamed:highIcon];
    
    [button setImage :img forState:UIControlStateNormal];
    
    [button setImage: img1 forState:UIControlStateHighlighted];
    button.frame = frame;
    button.transform = CGAffineTransformMakeRotation(rotation*M_PI/180);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)CHItemWithTit:(NSString *)tit textColor:(UIColor *)tcolor textFont:(UIFont *)tfont touchCallBack:(touchItemBlock)touchItem{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = tfont ? tfont:CHFontNormal(nil, 16);
    [button setTitle:tit forState:UIControlStateNormal];
    [button setTitleColor:tcolor ? tcolor:[UIColor whiteColor] forState:UIControlStateNormal];
    objc_setAssociatedObject(self, itemBlockKey, touchItem, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [button addTarget:self action:@selector(didTouchItem:) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)CHItemWithBackIma:(UIImage *)backIma Radius:(CGFloat)radius touchCallBack:(touchItemBlock)touchItem{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:backIma forState:UIControlStateNormal];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:radius];
    objc_setAssociatedObject(self, itemBlockKey, touchItem, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [button addTarget:self action:@selector(didTouchItem:) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)CHItemWithNorIma:(UIImage *)norIma highIma:(UIImage *)highIma touchCallBack:(touchItemBlock)touchItem{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage :norIma forState:UIControlStateNormal];
    [button setImage: highIma forState:UIControlStateHighlighted];
    objc_setAssociatedObject(self, itemBlockKey, touchItem, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [button addTarget:self action:@selector(didTouchItem:) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (void)didTouchItem:(UIBarButtonItem *)item{
    touchItemBlock block = objc_getAssociatedObject(self, itemBlockKey);
    if (block) {
        NSLog(@"点击item");
        block(item);
    }
    
}
@end
