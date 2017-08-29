//
//  CHLocationInfoView.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/27.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHDeiceCollectionViewCell.h"
@interface CHLocationInfoView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *deviceCollView;
@property (nonatomic, strong) NSMutableArray <CHUserInfo *>* devices;
@property (nonatomic, strong) CHLabel *locaLab;
- (instancetype)initWithShowView:(BOOL)show;
@end
