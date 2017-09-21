//
//  CHTrackCollectionViewCell.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/14.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHTrackCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) CHLabel *textLab;
@property (nonatomic, assign) BOOL nowDate;
@property (nonatomic, assign) BOOL haveDate;
@property (nonatomic, assign) BOOL selectDate;
@end
