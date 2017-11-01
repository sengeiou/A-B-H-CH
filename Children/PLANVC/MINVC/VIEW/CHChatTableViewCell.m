//
//  CHChatTableViewCell.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/25.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHChatTableViewCell.h"

typedef void(^playCellBloc)(CHVideoMode *mode);
@interface CHChatTableViewCell ()
@property (nonatomic, strong) CHLabel *leftLab, *rightLab, *leftHeadLab, *rightHeadLab, *dateLab;
@property (nonatomic, strong) UIImageView *leftReadIma, *rightReadIma;
@property (nonatomic, strong) NSMutableDictionary *userInfoDic;
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) AVAudioPlayer *avPlay;
@property (nonatomic, copy) playCellBloc block;
@end

@implementation CHChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.user = [CHAccountTool user];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = [UIColor clearColor];
  self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _dateLab = [CHLabel createWithTit:CHLocalizedString(@"chat_baby", nil) font:CHFontNormal(nil, 12) textColor:CHUIColorFromRGB(0xffffff, 1.0) backColor:nil textAlignment:1];
    [self.contentView addSubview:_dateLab];
    
    _leftHeadIma = [UIImageView itemWithImage:[UIImage imageNamed:@"pho_touxiang_1"] backColor:nil Radius:25];
    [self.contentView addSubview:_leftHeadIma];
    
    @WeakObj(self)
    _leftSoundIma = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_qipao_1"] backColor:nil imageTouchedBlock:^(UIImageView *sender, UIGestureRecognizerState recognizerState) {
        if (selfWeak.block) {
            selfWeak.block(selfWeak.mode);
        }
    } eventId:nil];
    [self.contentView addSubview:_leftSoundIma];
    
    _leftActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    _leftActivity.hidesWhenStopped = YES;
    _leftActivity.hidden = YES;
     [self.contentView addSubview:_leftActivity];
    
   _leftFailBut = [CHButton createWithNorImage:[UIImage imageNamed:@"icon_fssb"] lightIma:[UIImage imageNamed:@"icon_fssb"] touchBlock:^(CHButton *sender) {
        
    }];
    _leftFailBut.hidden = YES;
    [self.contentView addSubview:_leftFailBut];
    
    _leftPlayingIma = [[UIImageView alloc] init];
    _leftPlayingIma.image = [UIImage imageNamed:@"icon_sy_zuo_n"];
//    [UIImageView itemWithImage:[UIImage imageNamed:@"icon_sy_zuo_n"] backColor:nil Radius:0];
     _leftPlayingIma.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"icon_sy_zuo_1"],[UIImage imageNamed:@"icon_sy_zuo_2"],[UIImage imageNamed:@"icon_sy_zuo_n"], nil];
    [self.contentView addSubview:_leftPlayingIma];
    
    _leftHeadLab = [CHLabel createWithTit:CHLocalizedString(@"", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(0xffffff, 1.0) backColor:nil textAlignment:1];
    [self.contentView addSubview:_leftHeadLab];
    
    _leftLab = [CHLabel createWithTit:CHLocalizedString(@"15”", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(0x348c06, 1.0) backColor:nil textAlignment:0];
    [self.contentView addSubview:_leftLab];
    
    _rightHeadIma = [UIImageView itemWithImage:[UIImage imageNamed:@"pho_touxiang_1"] backColor:nil Radius:25];
    [self.contentView addSubview:_rightHeadIma];
    
    _rightSoundIma = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_qipao_2"] backColor:nil imageTouchedBlock:^(UIImageView *sender, UIGestureRecognizerState recognizerState) {
        if (selfWeak.block) {
            selfWeak.block(selfWeak.mode);
        }
    } eventId:nil];
    [self.contentView addSubview:_rightSoundIma];
    
    _rightActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    _rightActivity.hidesWhenStopped = YES;
//    _rightActivity.hidden = YES;
    [self.contentView addSubview:_rightActivity];
    
    _rightFailBut = [CHButton createWithNorImage:[UIImage imageNamed:@"icon_fssb"] lightIma:[UIImage imageNamed:@"icon_fssb"] touchBlock:^(CHButton *sender) {
        [selfWeak uploadVideoMode:selfWeak.mode];
    }];
    _rightFailBut.hidden = YES;
    [self.contentView addSubview:_rightFailBut];
    
    _leftReadIma = [UIImageView itemWithImage:[UIImage CHimageWithColor:[UIColor redColor] size:CGSizeMake(6, 6)] backColor:nil Radius:3];
    [self.contentView addSubview:_leftReadIma];
    
//   _rightPlayingIma = [UIImageView itemWithImage:[UIImage imageNamed:@"icon_sy_you_n"] backColor:nil Radius:0];
    _rightPlayingIma = [[UIImageView alloc] init];
    _rightPlayingIma.image = [UIImage imageNamed:@"icon_sy_you_n"];
    _rightPlayingIma.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"icon_sy_you_1"],[UIImage imageNamed:@"icon_sy_you_2"],[UIImage imageNamed:@"icon_sy_you_n"], nil];
    [self.contentView addSubview:_rightPlayingIma];
    
    _rightHeadLab = [CHLabel createWithTit:CHLocalizedString(@"", nil) font:CHFontNormal(nil, 14) textColor:CHUIColorFromRGB(0xffffff, 1.0) backColor:nil textAlignment:1];
    [self.contentView addSubview:_rightHeadLab];
    
    _rightLab = [CHLabel createWithTit:CHLocalizedString(@"15”", nil) font:CHFontNormal(nil, 16) textColor:CHUIColorFromRGB(0x348c06, 1.0) backColor:nil textAlignment:2];
    [self.contentView addSubview:_rightLab];
    
    _rightReadIma = [UIImageView itemWithImage:[UIImage CHimageWithColor:[UIColor redColor] size:CGSizeMake(6, 6)] backColor:nil Radius:3];
//    [self.contentView addSubview:_rightReadIma];
    
    [_leftHeadIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    [_dateLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_leftHeadIma.mas_top).mas_offset(-2);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(2);
    }];
    
    [_leftHeadLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftHeadIma.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(_leftHeadIma.mas_left);
        make.right.mas_equalTo(_leftHeadIma.mas_right);
//      make.bottom.mas_equalTo(0);
    }];
    
//    _leftSoundIma.backgroundColor = [UIColor orangeColor];
    [_leftSoundIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_offset(4);
//        make.top.mas_equalTo(10);
        make.left.mas_equalTo(_leftHeadIma.mas_right).mas_offset(8);
//        make.left.mas_equalTo(20);
        make.width.mas_equalTo(146);
        make.height.mas_equalTo(36);
    }];
    
    [_leftActivity mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftSoundIma.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(_leftSoundIma.mas_centerY);
    }];
//    _leftActivity.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
//    _leftFailBut.backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:1 alpha:0.5];
    [_leftFailBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftSoundIma.mas_right).mas_offset(0);
        make.centerY.mas_equalTo(_leftSoundIma.mas_centerY);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(36);
    }];
    
    [_leftPlayingIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftSoundIma.mas_left).mas_offset(23);
        make.centerY.mas_equalTo(_leftSoundIma.mas_centerY);
        make.width.mas_equalTo(11);
        make.height.mas_equalTo(16);
    }];
    
    [_leftLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftPlayingIma.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(_leftSoundIma.mas_centerY);
    }];
    
    [_leftReadIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftSoundIma.mas_top);
        make.left.mas_equalTo(_leftSoundIma.mas_right).mas_equalTo(2);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(6);
    }];
    
    [_rightHeadIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    [_rightHeadLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_rightHeadIma.mas_bottom).mas_offset(4);
        make.left.mas_equalTo(_rightHeadIma.mas_left);
        make.right.mas_equalTo(_rightHeadIma.mas_right);
//        make.bottom.mas_equalTo(0);
    }];
    
    [_rightSoundIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_rightHeadIma.mas_centerY).mas_offset(4);
        make.right.mas_equalTo(_rightHeadIma.mas_left).mas_offset(-8);
        make.width.mas_equalTo(146);
        make.height.mas_equalTo(36);
    }];
    
    [_rightActivity mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_rightSoundIma.mas_left).mas_offset(-8);
        make.centerY.mas_equalTo(_rightSoundIma.mas_centerY);
    }];
//    [_rightActivity startAnimating];
//    [_leftActivity startAnimating];
    [_rightFailBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_rightSoundIma.mas_left).mas_offset(0);
        make.centerY.mas_equalTo(_rightSoundIma.mas_centerY);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(36);
    }];
    
    [_rightPlayingIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_rightSoundIma.mas_right).mas_offset(-23);
        make.centerY.mas_equalTo(_rightSoundIma.mas_centerY);
        make.width.mas_equalTo(11);
        make.height.mas_equalTo(16);
    }];
    
    [_rightLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_rightPlayingIma.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(_rightSoundIma.mas_centerY);
    }];
    
//    [_rightReadIma mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_rightSoundIma.mas_top);
//        make.left.mas_equalTo(_rightSoundIma.mas_left).mas_equalTo(-2);
//        make.width.mas_equalTo(6);
//        make.height.mas_equalTo(6);
//    }];
}

- (void)hiddenLeftView:(BOOL)hidden{
    _leftPlayingIma.hidden = hidden;
    _leftSoundIma.hidden = hidden;
    _leftHeadIma.hidden = hidden;
    _leftHeadLab.hidden = hidden;
    _leftLab.hidden = hidden;
    _leftReadIma.hidden = hidden;
    
    _rightHeadIma.hidden = !hidden;
    _rightSoundIma.hidden = !hidden;
    _rightPlayingIma.hidden = !hidden;
    _rightHeadLab.hidden = !hidden;
    _rightLab.hidden = !hidden;
//    _rightReadIma.hidden = !hidden;
}

- (void)selectPlayCell:(void (^)(CHVideoMode *))callBack{
    _block = callBack;
}

- (void)setMode:(CHVideoMode *)mode{
    _mode = mode;
    if (mode.UserId == self.user.userId.integerValue) {
         [self hiddenLeftView:YES];
        _rightLab.text = [NSString stringWithFormat:@"%ld\"",(long)mode.Long];
        NSData *imaData = [[NSData alloc] initWithBase64EncodedString:[TypeConversionMode strongChangeString:mode.AvatarBase] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *headIma = [UIImage imageWithData:imaData];
        if (!headIma) {
            NSLog(@"fewfg =%@",[NSURL URLWithString:[TypeConversionMode strongChangeString:mode.Avatar]]);
            [_rightHeadIma sd_setImageWithURL:[NSURL URLWithString:[TypeConversionMode strongChangeString:mode.Avatar]] placeholderImage:[UIImage imageNamed:@"pho_touxiang_1"]];
        }
        else{
            _rightHeadIma.image = [UIImage imageWithData:imaData];
        }
        _rightHeadLab.text = [TypeConversionMode strongChangeString:self.user.userNa];
    }
    else{
         [self hiddenLeftView:NO];
        _leftLab.text = [NSString stringWithFormat:@"%ld\"",(long)mode.Long];
        _leftReadIma.hidden = mode.IsRead;
        NSData *imaData = [[NSData alloc] initWithBase64EncodedString:[TypeConversionMode strongChangeString:mode.AvatarBase] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *headIma = [UIImage imageWithData:imaData];
        if (!headIma) {
            [_leftHeadIma sd_setImageWithURL:[NSURL URLWithString:[TypeConversionMode strongChangeString:mode.Avatar]] placeholderImage:[UIImage imageNamed:@"pho_usetouxiang"]];
        }
        else{
            _leftHeadIma.image = [UIImage imageWithData:imaData];
        }
        if (mode.UserId == 0) {
            _leftHeadLab.text = self.user.deviceNa;
        }
       else if (!_leftHeadLab.text || [_leftHeadLab.text isEqualToString:@""]) {
           [self requestUserInfo];
        }
    }
    _dateLab.text = [self requestDate:mode];
    if (mode.IsUpload) {
        [self uploadVideoMode:mode];
    }
}

- (void)requestUserInfo{
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"UserId":self.user.userId}];
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_UserInfo parameters:dic Mess:nil showError:NO progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        selfWeak.userInfoDic = [result[@"UserInfo"] mutableCopy];
        selfWeak.leftHeadLab.text = [TypeConversionMode strongChangeString:selfWeak.userInfoDic[@"Username"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        selfWeak.leftHeadLab.text = CHLocalizedString(@"device_family", nil);
    }];
}

- (void)uploadVideoMode:(CHVideoMode *)mode{
//    NSData *videoData = DecodeAMRToWAVE(voiceData);
//    NSString *baseStr = [voiceData base64EncodedStringWithOptions:0];
//    NSError *error;
//    AVAudioPlayer *wavplay = [[AVAudioPlayer alloc]initWithData:videoData error:&error];
    self.rightFailBut.hidden = YES;
//    self.rightActivity.hidden = NO;
     [self.rightActivity startAnimating];
    @WeakObj(self)
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"SerialNumber":self.user.deviceIMEI,@"Long":[NSString stringWithFormat:@"%ld",(long)mode.Long],@"VoiceTime":mode.Created,@"Command":mode.FileBase,@"IdentityID":mode.IdentityID,@"UserId":self.user.userId,@"ChatType":@"2",@"FileType":@"video"}];
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_VoiceUpload parameters:dic Mess:nil showError:NO progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        NSLog(@"result");
//      selfWeak.rightActivity.hidden = YES;
        [selfWeak.rightActivity stopAnimating];
        if ([result[@"State"] intValue] != 0) {
            selfWeak.rightFailBut.hidden = YES;
        }
        else{
            mode.IsUpload = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        selfWeak.rightFailBut.hidden = NO;
//      selfWeak.rightActivity.hidden = YES;
        [selfWeak.rightActivity stopAnimating];
    }];
}

- (NSString *)requestDate:(CHVideoMode *)mode{
    NSDateFormatter * _formatter = [[NSDateFormatter alloc] init];
    _formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    _formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDate *lastTime = [NSDate getNowDateFromatAnDate:[_formatter dateFromString:mode.Created]];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //上次时间
    NSDate *lastDate = [lastTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:lastTime]];
    //当前时间
    NSDate *currentDate = [[NSDate date] dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:[NSDate date]]];
    //时间间隔
    NSInteger intevalTime = [currentDate timeIntervalSinceReferenceDate] - [lastDate timeIntervalSinceReferenceDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSString *titStr = @"";
    if (intevalTime < 60*60*24){
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        if ([[dateFormatter stringFromDate:lastDate] isEqualToString:[dateFormatter stringFromDate:currentDate]]) {
            dateFormatter.dateFormat = @"HH:mm";
            titStr = [dateFormatter stringFromDate:lastDate];
        }else{
            dateFormatter.dateFormat = @"HH:mm";
            titStr = [NSString stringWithFormat:@"%@ %@",CHLocalizedString(@"user_lastData", nil),[dateFormatter stringFromDate:lastDate]];
        }
    }
    else{
        dateFormatter.dateFormat = @"MM/dd HH:mm";
        titStr = [dateFormatter stringFromDate:lastDate];
    }
    return titStr;
}
@end
