//
//  MNWheelView.m
//  Tab学习
//
//  Created by qsit on 15-1-6.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MNWheelView.h"


//快速生成颜色
#define MNRGB(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0])

@interface MNWheelView()
{
    UIView *_baseView;
    BOOL anibool;
    int _index;
}

@end
@implementation MNWheelView

-(instancetype)init
{
    
    if (self=[super init]) {
        
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (frame.size.height>0) {
        if( _baseView==nil){
            [self viewDidLoad];
        }
    }
    
}
- (void)viewDidLoad
{
    _click=^(CHDeviceView *i)
    {
        NSLog(@"单击了第%@项",i);
    };
    _baseView=[[UIView alloc]init];
    _baseView.frame=self.bounds;
    NSLog(@"_%f",_baseView.frame.size.height);
    [self addSubview:_baseView];
    //  [self createView];
    
    anibool=YES;
    UISwipeGestureRecognizer *rec=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
    rec.direction=UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rec];
    UISwipeGestureRecognizer *recdown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
    recdown.direction=UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:recdown];
    
    
}
-(void)setImages:(NSArray *)images
{
    _images=images;
    
    int count=(int)images.count;
    int mid=count/2;
    CGFloat smallW=8;
    //    if (count>6) {
    //        smallW=10;
    //    }
    for (UIView *view in _baseView.subviews) {
        if ([view isKindOfClass:[CHDeviceView class]]) {
             [view removeFromSuperview];
        }
    }
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view removeFromSuperview];
        }
    }
    CGFloat myW=_baseView.frame.size.width-smallW*mid;
    CGFloat basW=_baseView.frame.size.width/3;
    for (int i=0; i<count; i++) {
        // if (i!=mid) {
        //        UIImageView *view1=[[UIImageView alloc]init];
        CHDeviceView *view1 = [CHDeviceView createView];
        CGFloat dd=abs(mid-i);
        if (i>mid) {
            view1.frame=CGRectMake(smallW*i - 4, smallW*dd,_baseView.frame.size.width/3-smallW,_baseView.frame.size.width/3+smallW*dd/1.8);
            view1.center = CGPointMake(_baseView.center.x-basW*dd, view1.center.y);
        }else if(i<mid)
        {
            view1.frame=CGRectMake(myW+smallW*(dd) + 4,smallW*(dd) ,_baseView.frame.size.width/3-smallW, _baseView.frame.size.width/3+smallW*dd/1.8);
            view1.center = CGPointMake(_baseView.center.x+basW*dd, view1.center.y);
        }else
        {
            view1.frame=CGRectMake(smallW*mid, 0, _baseView.frame.size.width/3,  _baseView.frame.size.height);
            view1.center = CGPointMake(_baseView.center.x, view1.center.y);
        }
        
        if (basW == view1.width) {
            _index = i + 1;
            [view1 updateView:1];
            view1.lable.font = CHFontNormal(nil, 18);
        }
        else{
            [view1 updateView:0.8];
            view1.lable.font = CHFontNormal(nil, 14);
        }
        
        //        view1.image=images[i];
        CHUserInfo *user = [images objectAtIndex:i];
        NSData *imaData = [[NSData alloc] initWithBase64EncodedString:user.deviceIm options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *deviceIma = [UIImage imageWithData:imaData];
        if (!deviceIma) {
            deviceIma = [UIImage imageNamed:@"pho_touxiang"];
        }
        
        view1.image.image= [UIImage drawWithSize:CGSizeMake(_baseView.frame.size.width/3, _baseView.frame.size.width/3) Radius:_baseView.frame.size.width/6 image:deviceIma];
        view1.lable.text = user.deviceNa;
        view1.user = user;
//        view1.backgroundColor=[UIColor redColor];
        view1.tag=i+1;
        //view1.clipsToBounds  = YES;
        //添加四个边阴影
//        view1.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
//        view1.layer.shadowOffset = CGSizeMake(4,4);//偏移距离
//        view1.layer.shadowOpacity = 0.8;//不透明度
//        view1.layer.shadowRadius = 2.0;//半径
        // view1.contentMode=UIViewContentModeScaleAspectFill;
        // view1.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        [_baseView addSubview:view1];
        // }
    }
    
    CGFloat btnX=_baseView.frame.origin.x;
    CGFloat btnY=_baseView.frame.origin.y;
    CGFloat btnW=_baseView.frame.size.width/3;
    CGFloat btnH=_baseView.frame.size.height;
    //    CGFloat btnH=smallW*mid;
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(btnX, btnY, basW, btnH);
    btn.tag=1;
    btn.backgroundColor=[UIColor clearColor];
    [btn addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(btnX + btnW*2, btnY, btnW, btnH);
    btn2.backgroundColor=[UIColor clearColor];
    btn2.tag=2;
    [btn2 addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn2];
    
    UIButton *btn3=[UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame=CGRectMake(btnX +btnW, btnY, btnW, btnH);
    btn3.backgroundColor=[UIColor clearColor];
    btn3.tag=3;
    [btn3 addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn3];
    
}
-(void)setImageNames:(NSArray *)imageNames
{
    _imageNames=imageNames;
    int count=(int)imageNames.count;
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<count; i++) {
        UIImage *image=[UIImage imageNamed:imageNames[i]];
        
        [array addObject:image];
    }
    [self setImages:array];
    
}

-(void)swipeUp:(UISwipeGestureRecognizer *)zer
{
    if (zer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        [self setAllFramge:2];
    }else if(zer.direction==UISwipeGestureRecognizerDirectionRight)
    {
        [self setAllFramge:1];
    }
}

-(void)chick:(UIButton *)btn
{
    NSLog(@"TAG==%lD",btn.tag);
    if (btn.tag==3) {
        NSLog(@"22单击了 %@  %d",[_baseView viewWithTag:_index],[_baseView viewWithTag:_index].tag);
        _click([_baseView viewWithTag:_index]);
        
    }else
    {
        [self setAllFramge:(int)btn.tag];
    }
}
-(void)setAllFramge:(int)tag
{
    
    if (anibool==NO) {
        return;
    }
    
    anibool=NO;
    unsigned long count=_baseView.subviews.count;
    if (tag==2) {
        CGFloat minH=0;
        UIView *minHiew;
        CGFloat maxW= 0.0f;
        for (int i=1; i<count+1; i++)
        {
            UIView *view1=[_baseView viewWithTag:i];
            CGFloat min=CGRectGetMaxY(view1.frame);
            CGFloat max = CGRectGetWidth(view1.frame);
            if (min>minH) {
                minH=min;
                minHiew=[_baseView viewWithTag:i];
            }
            if (max > maxW) {
                maxW = max;
            }
            
        }
        if (minH>0) {
            for (int j=0; j<count; j++)[_baseView sendSubviewToBack:minHiew];
            
        }
        [UIView animateWithDuration:0.4 animations:^{
            CGRect rect=[[_baseView viewWithTag:1] frame];
            for (int i=1; i<count+1; i++)
            {
                
                if (i==count) {
                    [[_baseView viewWithTag:i] setFrame:rect];
                }
                else
                {
                    [[_baseView viewWithTag:i] setFrame:[[_baseView viewWithTag:i+1] frame]];
                }
               
                
                CHDeviceView *device = (CHDeviceView *)[_baseView viewWithTag:i];
                if (maxW == device.width) {
                     [[_baseView viewWithTag:i] updateView:1];
                    device.lable.font = CHFontNormal(nil, 18);
                }
                else{
                     [[_baseView viewWithTag:i] updateView:0.8];
                    device.lable.font = CHFontNormal(nil, 14);
                }
                
            }
            
        } completion:^(BOOL finished) {
            anibool=YES;
            [self bigtop];
        }];
        
    }else
    {
        
        CGFloat minH=10000;
        CGFloat maxW= 0.0f;
        NSUInteger maxTag = 0;
        UIView *minHiew;
        for (int i=1; i<count+1; i++)
        {
            UIView *view1=[_baseView viewWithTag:i];
            CGFloat min=CGRectGetMinY(view1.frame);
            CGFloat max = CGRectGetWidth(view1.frame);
            if (min<minH) {
                minH=min;
                minHiew=[_baseView viewWithTag:i];
            }
            if (max > maxW) {
                maxW = max;
                maxTag = view1.tag;
            }
        }
        if (minH<10000) {
            for (int j=0; j<count; j++)[_baseView sendSubviewToBack:minHiew];
        }
        
        [UIView animateWithDuration:0.4 animations:^{
            CGRect rect=[[_baseView viewWithTag:count] frame];
            for (int i=1; i<count+1; i++)
            {
                if (i==count) {
                    [[_baseView viewWithTag:count-i+1] setFrame:rect];
                }
                else
                {
                    [[_baseView viewWithTag:count-i+1] setFrame:[[_baseView viewWithTag:count-i] frame]];
                    NSLog(@"fwiojojg io == %@",NSStringFromCGRect([[_baseView viewWithTag:count-i] frame]));
                }
                CHDeviceView *device = (CHDeviceView *)[_baseView viewWithTag:count-i+1];
                if (maxW == device.width) {
                    [[_baseView viewWithTag:count-i+1] updateView:1];
                    device.lable.font = CHFontNormal(nil, 18);
                }
                else{
                    [[_baseView viewWithTag:count-i+1] updateView:0.8];
                    device.lable.font = CHFontNormal(nil, 14);
                }
            }
        } completion:^(BOOL finished) {
            anibool=YES;
            [self bigtop];
        }];
    }
    
    
}

-(void)bigtop
{
    unsigned long count=_baseView.subviews.count;
    CGFloat maxW=0;
    UIView *maxHiew;
    for (int i=1; i<count+1; i++)
    {
        UIView *view1=[_baseView viewWithTag:i];
        if (view1.frame.size.width>maxW) {
            maxW=view1.frame.size.width;
            maxHiew=[_baseView viewWithTag:i];
            _index=i;
        }
        
    }
    if (maxW>0) {
        for (int j=0; j<count; j++)[_baseView bringSubviewToFront:maxHiew];
        
    }
    
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
