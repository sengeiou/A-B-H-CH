//
//  CHChatTableViewCell.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/25.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHVideoMode.h"

@interface CHChatTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *leftHeadIma, *leftSoundIma, *leftPlayingIma, *rightHeadIma, *rightSoundIma, *rightPlayingIma;
@property (nonatomic, strong) UIActivityIndicatorView *leftActivity, *rightActivity;
@property (nonatomic, strong) CHButton *leftFailBut, *rightFailBut;
@property (nonatomic, strong) CHVideoMode *mode;
- (void)selectPlayCell:(void(^)(CHVideoMode *mode))callBack;
@end
