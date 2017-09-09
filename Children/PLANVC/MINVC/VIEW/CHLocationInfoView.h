//
//  CHLocationInfoView.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/27.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHDeiceCollectionViewCell.h"

typedef void(^didSelectCollection)(CHUserInfo *selDevice);

@interface CHLocationInfoView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *deviceCollView;
@property (nonatomic, strong) NSMutableArray <CHUserInfo *>* devices;
@property (nonatomic, strong) CHUserInfo *selectDevice;
@property (nonatomic, strong) CHLabel *locaLab;
- (instancetype)initWithShowView:(BOOL)show;
- (void)didSelectItem:(didSelectCollection) callBack;
- (void)didUpdateLogo:(ButTouchedBlock) callBack;
@end
