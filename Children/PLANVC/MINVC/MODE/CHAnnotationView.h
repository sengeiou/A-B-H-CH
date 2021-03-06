//
//  CHAnnotationView.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/29.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <MapKit/MapKit.h>

typedef void(^tapAnnotation)(id <MKAnnotation> tapAnnotation);

@interface CHAnnotationView : MKAnnotationView
@property (nonatomic, strong) CHLabel *nameLab;
@property (nonatomic, strong) UIImageView *IconImageView;
@property (nonatomic, assign) BOOL annSelect;
- (void)setLabTit:(NSString *)tit;
- (void)didSelectAnnotaton:(tapAnnotation)block;
@end
