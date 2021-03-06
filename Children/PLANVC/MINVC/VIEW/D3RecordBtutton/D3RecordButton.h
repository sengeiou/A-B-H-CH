//
//  D3RecordButton.h
//  D3RecordButtonDemo
//
//  Created by 超级腕电商 on 16/5/31.
//  Copyright © 2016年 super. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mp3Recorder.h"
#import "lame.h"
#import <AVFoundation/AVFoundation.h>

@protocol D3RecordDelegate <NSObject>
- (void)endRecord:(NSData *)voiceData;

@optional
- (void)recording:(float) recordTime;
- (void)startRecord;
- (void)endRecord;
- (void)dragExit;
- (void)dragEnter;

@end

@interface D3RecordButton : UIButton<Mp3RecorderDelegate>{
    int maxTime;
    Mp3Recorder *mp3;
    NSString *title;
    BOOL dismantle;
    CGFloat recorderTimer;
}
@property (nonatomic,weak) id<D3RecordDelegate> delegate;

- (void)initRecord:(id<D3RecordDelegate>)delegate maxtime:(int)_maxTime title:(NSString*)title;
- (void)initRecord:(id<D3RecordDelegate>)delegate maxtime:(int)_maxTime;
- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;

@end
