//
//  D3RecordButton.m
//  D3RecordButtonDemo
//
//  Created by 超级腕电商 on 16/5/31.
//  Copyright © 2016年 super. All rights reserved.
//

#import "D3RecordButton.h"
#import "RecordHUD.h"

@implementation D3RecordButton

-(void)initRecord:(id<D3RecordDelegate>)delegate maxtime:(int)_maxTime title:(NSString *)_title{
    self.delegate = delegate;
    maxTime = _maxTime;
    title = _title;
    mp3 = [[Mp3Recorder alloc]initWithDelegate:self];
    
    [self addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(cancelRecord) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [self addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
}

-(void)initRecord:(id<D3RecordDelegate>)delegate maxtime:(int)_maxTime{
    [self initRecord:delegate maxtime:_maxTime title:nil];
}


//开始录音
-(void)startRecord{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (!granted) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:CHLocalizedString(@"请在iPhone\"设置-隐私-麦克风\"中，允许手机访问你的麦克风", nil) delegate:self cancelButtonTitle:CHLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        dismantle = NO;
        [mp3 startRecord];
        [RecordHUD show];
        [self setHUDTitle];
        if ([_delegate respondsToSelector:@selector(startRecord)]) {
            [_delegate startRecord];
        }
    }];
   }

//正常停止录音，开始转换数据
-(void)stopRecord{
    if ([_delegate respondsToSelector:@selector(endRecord)]) {
        [_delegate endRecord];
    }
    if (mp3.recorder.currentTime < 1) {
        [mp3 cancelRecord];
        [RecordHUD dismiss];
        [RecordHUD setImage:[NSString stringWithFormat:@"icon_lytd"]];
        [RecordHUD setTitle:CHLocalizedString(@"录音时间太短", nil)];
        return;
    }
    [mp3 stopRecord];
    [RecordHUD dismiss];
}

//取消录音
-(void)cancelRecord{
    [mp3 cancelRecord];
    [RecordHUD dismiss];
    [RecordHUD setTitle:CHLocalizedString(@"已取消录音", nil)];
    if ([_delegate respondsToSelector:@selector(endRecord)]) {
        [_delegate endRecord];
    }
}

//离开按钮范围
- (void)RemindDragExit:(UIButton *)button{
    [RecordHUD setTitle:CHLocalizedString(@"松开手指，取消发送", nil)];
    dismantle = YES;
    [RecordHUD setImage:[NSString stringWithFormat:@"icon_cexiao"]];
    if ([_delegate respondsToSelector:@selector(dragExit)]) {
        [_delegate dragExit];
    }
}

//进入按钮范围
- (void)RemindDragEnter:(UIButton *)button{
    dismantle = NO;
    [self setHUDTitle];
    if ([_delegate respondsToSelector:@selector(dragEnter)]) {
        [_delegate dragEnter];
    }
}

-(void)setHUDTitle{
    if (title != nil) {
        [RecordHUD setTitle:title];
    }
    else{
        [RecordHUD setTitle:CHLocalizedString(@"手指上滑，取消发送", nil)];
    }
}


#pragma mark Mp3RecordDelegate
-(void)beginConvert{
}

//录音失败
- (void)failRecord
{
}


//回调录音资料
- (void)endConvertWithData:(NSData *)voiceData{
    [RecordHUD setTitle:CHLocalizedString(@"录音成功", nil)];
    if ([_delegate respondsToSelector:@selector(endRecord:)]) {
        [_delegate endRecord:voiceData];
    }
}

-(void)recording:(float)recordTime volume:(float)volume{
    if (recordTime>=maxTime) {
        [self stopRecord];
    }
    recorderTimer = recordTime;
    if (dismantle == YES) {
        return;
    }
    NSLog(@"**************************8 %f",volume);
    if (0<volume<=0.08) {
        [RecordHUD setImage:[NSString stringWithFormat:@"icon_luyinf"]];
    }else if (0.08<volume<=0.3) {
        [RecordHUD setImage:[NSString stringWithFormat:@"icon_luyin_1"]];
    }else if (0.3<volume<=0.50) {
         [RecordHUD setImage:[NSString stringWithFormat:@"icon_luyin_2"]];
    }else if (volume>0.50) {
         [RecordHUD setImage:[NSString stringWithFormat:@"icon_luyin_3"]];
    }
   
    [RecordHUD setTimeTitle:[NSString stringWithFormat:@"录音: %.0f\"",recordTime]];
}
@end
