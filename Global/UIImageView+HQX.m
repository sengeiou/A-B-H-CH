//
//  UIImageView+HQX.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/15.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "UIImageView+HQX.h"

static const void *ImageBlockKey = &ImageBlockKey;
static const void *ImageEventKey = &ImageEventKey;

@implementation UIImageView (HQX)
+ (UIImageView*)itemWithImage:(UIImage *)image backColor:(UIColor *)backColor
{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.backgroundColor = backColor?backColor:[UIColor clearColor];
    imageView.clipsToBounds = YES;
    return imageView;
}

+ (UIImageView*)itemWithImage:(UIImage *)image backColor:(UIColor *)backColor Radius:(CGFloat)radius
{
    UIImageView* imageView = [self itemWithImage:image backColor:backColor];
    [imageView.layer setMasksToBounds:YES];
    [imageView.layer setCornerRadius:radius];
    return imageView;
}

+ (UIImageView*)itemWithImage:(UIImage *)image backColor:(UIColor *)backColor Radius:(CGFloat)radius BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor
{
    UIImageView* imageView = [self itemWithImage:image backColor:backColor Radius:radius];
    [imageView.layer setBorderWidth:borderWidth];
    [imageView.layer setBorderColor:borderColor.CGColor];
    return imageView;
}

+ (UIImageView*)itemWithImage:(UIImage *)image backColor:(UIColor *)backColor imageTouchedBlock:(ImageTouchedBlock)imageTouchedBlock eventId:(NSString*)eventId
{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    
    objc_setAssociatedObject(imageView, ImageBlockKey, imageTouchedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(imageView, ImageEventKey, eventId, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    imageView.backgroundColor = backColor?backColor:[UIColor clearColor];
    
    if (imageTouchedBlock) {
        imageView.userInteractionEnabled = YES;
        //创建手势对象
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:imageView action:@selector(tapAction:)];
        //轻拍次数
        tap.numberOfTapsRequired =1;
        //轻拍手指个数
        tap.numberOfTouchesRequired =1;
        //讲手势添加到指定的视图上
        [imageView addGestureRecognizer:tap];
    }
    
    return imageView;
}

+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor Radius:(CGFloat)radius imageTouchedBlock:(ImageTouchedBlock)imageTouchedBlock eventId:(NSString*)eventId
{
    UIImageView* imageView = [self itemWithImage:image backColor:backColor imageTouchedBlock:imageTouchedBlock eventId:eventId];
    [imageView.layer setMasksToBounds:YES];
    [imageView.layer setCornerRadius:radius];
    return imageView;
}

+ (UIImageView *)itemWithImage:(UIImage*)image backColor:(UIColor*)backColor Radius:(CGFloat)radius BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor*) borderColor imageTouchedBlock:(ImageTouchedBlock)imageTouchedBlock eventId:(NSString*)eventId
{
    UIImageView* imageView = [self itemWithImage:image backColor:backColor Radius:radius imageTouchedBlock:imageTouchedBlock eventId:eventId];
    [imageView.layer setBorderWidth:borderWidth];
    [imageView.layer setBorderColor:borderColor.CGColor];
    return imageView;
}


-(void)tapAction:(UITapGestureRecognizer *)tap
{
    ImageTouchedBlock block = objc_getAssociatedObject(self, ImageBlockKey);
    NSString* eventId = objc_getAssociatedObject(self, ImageEventKey);
    if (eventId&&eventId.length>0) {
//        [MobClick event:eventId];
    }
    if (block) {
        block(self,tap.state);
    }
}

@end
