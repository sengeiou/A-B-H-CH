//
//  RecordHUD.m
//  D3RecordButtonDemo
//
//  Created by 超级腕电商 on 16/5/31.
//  Copyright © 2016年 super. All rights reserved.
//

#import "RecordHUD.h"

@implementation RecordHUD

@synthesize overlayWindow;

+ (RecordHUD*)shareView{
    static dispatch_once_t once;
    static RecordHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[RecordHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        //        sharedView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    });
    return sharedView;
}

+ (void)show{
    [[RecordHUD shareView] show];
}


- (void)show{
    if(!self.superview){
        [self.overlayWindow addSubview:self];
    }
    
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 190)];
    }
    view.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2);
    view.layer.cornerRadius = 8.0f;
    view.clipsToBounds = YES;
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:view];
    
    if (!imgView) {
        imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_luyin_1.png"]];
        imgView.frame = CGRectMake(0, 0, 164, 139);
    }
    imgView.center = CGPointMake([view bounds].size.width/2,imgView.center.y);
    imgView.layer.cornerRadius = 10.0f;
    imgView.clipsToBounds = YES;
//    imgView.backgroundColor = [UIColor greenColor];
    
    if (!titleLabel){
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame), 150, 48)];
        titleLabel.backgroundColor = [UIColor clearColor];
    }
    titleLabel.center = CGPointMake(imgView.center.x, titleLabel.center.y);
    titleLabel.text = CHLocalizedString(@"chat_drawCancel", nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = CHFontNormal(nil, 14);
    titleLabel.numberOfLines = 2;
    titleLabel.adjustsFontSizeToFitWidth = YES;
//    titleLabel.backgroundColor =[UIColor greenColor];
    titleLabel.textColor = [UIColor whiteColor];
    
    if (!timeLabel) {
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
        timeLabel.backgroundColor = [UIColor clearColor];
    }
    timeLabel.center = CGPointMake(imgView.center.x, imgView.center.y - 77);
    timeLabel.text = @"录音: 0\"";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont boldSystemFontOfSize:14];
    timeLabel.textColor = [UIColor whiteColor];
    
    
    [view addSubview:imgView];
    [view addSubview:titleLabel];
    //        [self addSubview:timeLabel];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 1;
                     }
                     completion:^(BOOL finished){
                     }];
    [self setNeedsDisplay];
}


+ (void)dismiss{
    [[RecordHUD shareView]dismiss];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         if(self.alpha == 0) {
                             [imgView removeFromSuperview];
                             imgView = nil;
                             [titleLabel removeFromSuperview];
                             titleLabel.text = nil;
                             [timeLabel removeFromSuperview];
                             timeLabel.text = nil;
                             
                             NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                             [windows removeObject:overlayWindow];
                             overlayWindow = nil;
                             
                             [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                 if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                     [window makeKeyWindow];
                                     *stop = YES;
                                 }
                             }];
                         }
                     }];
}


+(void)setTitle:(NSString *)title{
    [[RecordHUD shareView]setTitle:title];
}

- (void)setTitle:(NSString *)title{
    if (titleLabel) {
        titleLabel.text = title;
    }
}

+(void)setTimeTitle:(NSString *)time{
    [[RecordHUD shareView]setTimeTitle:time];
}

- (void)setTimeTitle:(NSString *)time{
    if (timeLabel) {
        timeLabel.text = time;
    }
}

+(void)setImage:(NSString *)imgName{
    [[RecordHUD shareView]setImage:imgName];
}

-(void)setImage:(NSString *)imgName{
    if (imgView) {
        imgView.image = [UIImage imageNamed:imgName];
    }
}

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.userInteractionEnabled = NO;
        [overlayWindow makeKeyAndVisible];
    }
    return overlayWindow;
}
@end
