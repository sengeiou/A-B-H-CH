//
//  CHDeiceCollectionViewCell.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/27.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHDeiceCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) CHLabel *titleLab;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) BOOL cellMask;
@end
