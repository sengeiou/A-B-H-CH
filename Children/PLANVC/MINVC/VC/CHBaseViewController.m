//
//  CHBaseViewController.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/27.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHBaseViewController.h"

@interface CHBaseViewController ()<AVAudioPlayerDelegate>
@property (nonatomic, strong) D3RecordButton *soundBut;
@property (nonatomic, strong) UITableView *chatTab;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSMutableArray *videoList;
@property (nonatomic, strong) CHUserInfo *user;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) CHChatTableViewCell *OldCell;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) BOOL IsScrollBottom;
@end

@implementation CHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.IsScrollBottom = YES;
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(requestVideoNot:) name:@"VIDEONOTIFICATION" object:nil];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)videoList{
    if (!_videoList) {
        _videoList = [NSMutableArray array];
    }
    return _videoList;
}

- (CHUserInfo *)user{
    if (!_user) {
        _user = [CHAccountTool user];
    }
    return _user;
}

- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        _dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    }
    return _dateFormatter;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage CHimageWithColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0) size:CGSizeMake(CHMainScreen.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
}

- (void)initializeMethod{
    
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"pageCount":@10,@"pageNo":[NSString stringWithFormat:@"%d",self.pageNo],@"UserId":self.user.userId,@"Type":@2,@"Imei":self.user.deviceIMEI,@"Start":[self.dateFormatter stringFromDate: [[NSDate date] timeDifferenceWithNumbers:-7]],@"End":[self.dateFormatter stringFromDate: [NSDate date]],@"FileType":@1,@"GetTop":@"1"}];
    //
    //    NSURL *url = [NSURL URLWithString:@"http://120.24.58.119:10086/Files/170926/201610140001003/12694939d3554a7fbe57bcb7e90b496d.amr"];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //  NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
    //
    //    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
    //        NSArray *modeFals = [@"http://120.24.58.119:10086/Files/170926/201610140001003/12694939d3554a7fbe57bcb7e90b496d.amr" componentsSeparatedByString:@"/"];
    //        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    //        NSString *directryPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"imageViews/%@",[modeFals lastObject]]];
    //        return [NSURL fileURLWithPath:directryPath];
    //    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
    //        requrstNum ++;
    //    }];
    //    [downloadTask resume];
    
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_VoiceFileListByTime parameters:dic Mess:nil showError:NO progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        NSLog(@"fwegiogjio  ==%@",result);
        NSArray *items = [CHVideoMode mj_objectArrayWithKeyValuesArray:result[@"Items"]];
        if (items.count > 0) {
             NSRange range = NSMakeRange(0, items.count);
             NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
             [selfWeak.videoList insertObjects:items atIndexes:set];
        }
//        [selfWeak.videoList addObjectsFromArray:items];
        __block int requrstNum = 0;
        for (int i = 0; i < selfWeak.videoList.count; i ++) {
            CHVideoMode *mode = selfWeak.videoList[i];
            NSString *directryPath = [selfWeak createAVload];
            NSArray *modeFals = [mode.FileUrl componentsSeparatedByString:@"/"];
            directryPath = [directryPath stringByAppendingPathComponent:[modeFals lastObject]];
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:directryPath]];
           mode.Content = [modeFals lastObject];
           CHVideoMode *hisMode = [[FMDBConversionMode sharedCoreBlueTool] selectChatDataWithMode:mode];
            if (hisMode.FileBase && ![hisMode.FileBase isEqualToString:@""]) {
                requrstNum ++;
//                mode.FileBase = [data base64EncodedStringWithOptions:0];
                mode.FileBase = hisMode.FileBase;
                mode.IsRead = hisMode.IsRead;
                if (requrstNum == selfWeak.videoList.count) {
                    [selfWeak.chatTab reloadData];
                    if (selfWeak.IsScrollBottom) {
                        [selfWeak tableViewScrollCurrentIndexPath];
                    }
                    selfWeak.pageNo ++;
                    [selfWeak.chatTab.mj_header endRefreshing];
                }
            }else{
                NSURL *url = [NSURL URLWithString:mode.FileUrl];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    NSString *directryPath = [selfWeak createAVload];
                    NSArray *modeFals = [mode.FileUrl componentsSeparatedByString:@"/"];
                    directryPath = [directryPath stringByAppendingPathComponent:[modeFals lastObject]];
                    return [NSURL fileURLWithPath:directryPath];
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    requrstNum ++;
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:directryPath]];
                    mode.FileBase = [data base64EncodedStringWithOptions:0];
                    mode.IsRead = NO;
                    [selfWeak removeAVload:directryPath];
                    [[FMDBConversionMode sharedCoreBlueTool] insertChatData:[@[mode] mutableCopy]];
                    if (requrstNum == selfWeak.videoList.count) {
//                        [[FMDBConversionMode sharedCoreBlueTool] insertChatData:selfWeak.videoList];
                        [selfWeak.chatTab reloadData];
                        if (selfWeak.IsScrollBottom) {
                            [selfWeak tableViewScrollCurrentIndexPath];
                        }
                         selfWeak.pageNo ++;
                        [selfWeak.chatTab.mj_header endRefreshing];
                    }
                }];
                [downloadTask resume];
            }
        }
        if ([result[@"Items"] count] <= 0) {
             [selfWeak.chatTab.mj_header endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [selfWeak.chatTab.mj_header endRefreshing];
    }];
}

- (void)createUI{
    self.title = CHLocalizedString(@"chat_chat", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backIma = [UIImageView itemWithImage:[UIImage imageNamed:@"bk_liaotian"] backColor:nil];
    backIma.userInteractionEnabled = YES;
    [self.view addSubview:backIma];
    
    _soundBut = [D3RecordButton buttonWithType:UIButtonTypeCustom];
    _soundBut.layer.masksToBounds = YES;
    _soundBut.layer.cornerRadius = 8.0;
    [_soundBut setBackgroundColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0)];
    [_soundBut setTitle:CHLocalizedString(@"chat_touch", nil) forState:UIControlStateNormal];
    [_soundBut initRecord:self maxtime:14 title:CHLocalizedString(@"chat_drawCancel", nil)];
    [self.view addSubview:_soundBut];
    
    _chatTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _chatTab.dataSource = self;
    _chatTab.delegate = self;
    _chatTab.showsVerticalScrollIndicator = NO;
    _chatTab.tableFooterView = [UIView new];
    [_chatTab setSeparatorInset:UIEdgeInsetsMake(0, CHMainScreen.size.width, 0, 0)];
    _chatTab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_chatTab];
    
    [backIma mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [_soundBut mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30 - HOME_INDICATOR_HEIGHT);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(44 * WIDTHAdaptive);
    }];
    
    [_chatTab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(_soundBut.mas_top).mas_offset(-8);
        make.right.mas_equalTo(0);
    }];
    [self setupRefrish];
}

- (void)setupRefrish{
    @WeakObj(self)
    MJRefreshNormalHeader *footer = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"footerWithRefreshingBlock");
 //[selfWeak.messTabView.mj_header beginRefreshing];
        [selfWeak initializeMethod];
    }];
    [footer setTitle:CHLocalizedString(@"chat_update", nil) forState:MJRefreshStateIdle];
    [footer setTitle:CHLocalizedString(@"device_mess_updateing", nil) forState:MJRefreshStateRefreshing];
    [footer setTitle:CHLocalizedString(@"device_mess_updatenone", nil) forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.font = CHFontNormal(nil, 14);
    // 设置颜色
    footer.stateLabel.textColor = [UIColor whiteColor];
    // 隐藏时间
    footer.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
//    footer.stateLabel.hidden = YES;
    _chatTab.mj_header = footer;
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)playVideo:(CHVideoMode *)mode{
    //    NSString *playUrlStr = sender;
    //    NSError *playerError;
    //    NSURL *url = [NSURL fileURLWithPath:playUrlStr];
    mode.IsRead = YES;
    [[FMDBConversionMode sharedCoreBlueTool] updateChatDataWithMode:mode];
    _player = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:mode.FileBase options:0];
    NSError *error;
    _player = [[AVAudioPlayer alloc]initWithData:DecodeAMRToWAVE(decodedData) error:&error];
    _player.numberOfLoops=0;
    _player.delegate = self;
    [_player prepareToPlay];
    [_player play];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *chatIndex = @"CHATCELL";
    CHChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatIndex];
    if (!cell) {
        cell = [[CHChatTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:chatIndex];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CHVideoMode *mode = [self.videoList objectAtIndex:indexPath.row];
    cell.mode = mode;
    @WeakObj(self)
    [cell selectPlayCell:^(CHVideoMode *mode) {
        if (selfWeak.OldCell) {
            [selfWeak.OldCell.leftPlayingIma stopAnimating];
            [selfWeak.OldCell.rightPlayingIma stopAnimating];
        }
        if (selfWeak.OldCell == cell && selfWeak.player.isPlaying && selfWeak.player) {
            [selfWeak.player stop];
            return ;
        }
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        selfWeak.OldCell = cell;
        selfWeak.OldCell.leftPlayingIma.animationDuration = 2;
        selfWeak.OldCell.rightPlayingIma.animationDuration = 2;
        selfWeak.OldCell.leftPlayingIma.animationRepeatCount = 0;
        selfWeak.OldCell.rightPlayingIma.animationRepeatCount = 0;
        [selfWeak.OldCell.leftPlayingIma startAnimating];
        [selfWeak.OldCell.rightPlayingIma startAnimating];
        [selfWeak playVideo:mode];
        cell.mode = mode;
    }];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.videoList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90 * (([[UIScreen mainScreen] bounds].size.width) > 375 ? ([UIScreen mainScreen].bounds.size.width/375) : 1.0);
}

-(void)endRecord:(NSData *)voiceData{
    [self videoDataConversion:voiceData];
    [_soundBut setTitle:CHLocalizedString(@"chat_touch", nil) forState:UIControlStateNormal];
    [_soundBut setBackgroundColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0)];
}

- (void)uploadVideo:(NSData *)voiceData date:(NSString *)date{
    NSData *videoData = DecodeAMRToWAVE(voiceData);
    NSString *baseStr = [voiceData base64EncodedStringWithOptions:0];
    NSError *error;
    AVAudioPlayer *wavplay = [[AVAudioPlayer alloc]initWithData:videoData error:&error];
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"SerialNumber":self.user.deviceIMEI,@"Long":[NSNumber numberWithInteger:wavplay.duration],@"VoiceTime":date,@"Command":baseStr,@"IdentityID":@"",@"UserId":self.user.userId,@"ChatType":@"2",@"FileType":@"video"}];
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_VoiceUpload parameters:dic Mess:nil showError:NO progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        NSLog(@"result");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

- (void)videoDataConversion:(NSData *)armData{
    NSData *videoData = DecodeAMRToWAVE(armData);
    NSString *baseStr = [armData base64EncodedStringWithOptions:0];
    NSError *error;
    AVAudioPlayer *wavplay = [[AVAudioPlayer alloc]initWithData:videoData error:&error];
    CHVideoMode *mode = [[CHVideoMode alloc] init];
    mode.UserId = self.user.userId.integerValue;
    mode.FileBase = baseStr;
    mode.AvatarBase = self.user.userIm;
    mode.Long = wavplay.duration;
    mode.IsRead = NO;
    NSDate *date = [NSDate date];
    NSString *str = [self.dateFormatter stringFromDate:date];
    
    mode.Created = str;
    mode.IsUpload = YES;
    mode.IdentityID = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970] * 1000];
    [self.videoList addObject:mode];
    [self.chatTab reloadData];
    [self tableViewScrollCurrentIndexPath];
    NSLog(@"yesssssssssss..........%f (( %F  %@",wavplay.duration,baseStr.length/1024.0,[self.dateFormatter stringFromDate:[NSDate date]]);
//    UITableViewCell *uploadCell = [self.chatTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.videoList.count - 2 inSection:0]];
//    [self uploadVideo:armData date:mode.Created];
}

//不改btn的话这些就不要了
-(void)dragExit{
    [_soundBut setTitle:CHLocalizedString(@"chat_cancelSend", nil) forState:UIControlStateNormal];
    [_soundBut setBackgroundColor:CHUIColorFromRGB(0x757575, 1.0)];
}

- (void)startRecord{
    NSLog(@"startRecord");
    [_soundBut setTitle:CHLocalizedString(@"chat_recordEnd", nil) forState:UIControlStateNormal];
    [_soundBut setBackgroundColor:CHUIColorFromRGB(0x757575, 1.0)];
}

- (void)endRecord{
    NSLog(@"endRecord");
    [_soundBut setTitle:CHLocalizedString(@"chat_touch", nil) forState:UIControlStateNormal];
    [_soundBut setBackgroundColor:CHUIColorFromRGB(CHMediumSkyBlueColor, 1.0)];
}

-(void)dragEnter{
    [_soundBut setTitle:CHLocalizedString(@"chat_recordEnd", nil) forState:UIControlStateNormal];
    [_soundBut setBackgroundColor:CHUIColorFromRGB(0x757575, 1.0)];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"播放完成");
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [self.OldCell.leftPlayingIma stopAnimating];
    [self.OldCell.rightPlayingIma stopAnimating];
    _player = nil;
}

- (void)requestVideoNot:(NSNotification *) notification{
    NSLog(@"requestVideoNot");
    NSDictionary * dict  = notification.userInfo;
    NSMutableDictionary *dic = [CHAFNWorking shareAFNworking].requestDic;
    [dic addEntriesFromDictionary:@{@"FileId":[TypeConversionMode strongChangeString:dict[@"VIDEO"][@"FileId"]]}];
    @WeakObj(self)
    [[CHAFNWorking shareAFNworking] CHAFNPostRequestUrl:REQUESTURL_GetVoice parameters:dic Mess:nil showError:NO progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        NSArray *items = [CHVideoMode mj_objectArrayWithKeyValuesArray:result[@"Items"]];
        [selfWeak.videoList addObjectsFromArray:items];
        __block int requrstNum = 0;
        for (int i = 0; i < selfWeak.videoList.count; i ++) {
            CHVideoMode *mode = selfWeak.videoList[i];
            NSString *directryPath = [selfWeak createAVload];
            NSArray *modeFals = [mode.FileUrl componentsSeparatedByString:@"/"];
            directryPath = [directryPath stringByAppendingPathComponent:[modeFals lastObject]];
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:directryPath]];
            mode.Content = [modeFals lastObject];
            CHVideoMode *hisMode = [[FMDBConversionMode sharedCoreBlueTool] selectChatDataWithMode:mode];
            if (hisMode.FileBase && ![hisMode.FileBase isEqualToString:@""]) {
                requrstNum ++;
//                mode.FileBase = [data base64EncodedStringWithOptions:0];
                mode.FileBase = hisMode.FileBase;
                mode.IsRead = hisMode.IsRead;
                if (requrstNum == selfWeak.videoList.count) {
                    [selfWeak.chatTab reloadData];
                    if (selfWeak.IsScrollBottom) {
                        [selfWeak tableViewScrollCurrentIndexPath];
                    }
                }
            }else{
                NSURL *url = [NSURL URLWithString:mode.FileUrl];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    NSString *directryPath = [selfWeak createAVload];
                    NSArray *modeFals = [mode.FileUrl componentsSeparatedByString:@"/"];
                    directryPath = [directryPath stringByAppendingPathComponent:[modeFals lastObject]];
                    return [NSURL fileURLWithPath:directryPath];
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    requrstNum ++;
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:directryPath]];
                    mode.FileBase = [[data base64EncodedStringWithOptions:0] copy];
                    mode.IsRead = NO;
                    [selfWeak removeAVload:directryPath];
                    [[FMDBConversionMode sharedCoreBlueTool] insertChatData:[@[mode] mutableCopy]];
                    if (requrstNum == selfWeak.videoList.count) {
                        [selfWeak.chatTab reloadData];
                        if (selfWeak.IsScrollBottom) {
                            [selfWeak tableViewScrollCurrentIndexPath];
                        }
                    }
                }];
                [downloadTask resume];
            }
        }
        if ([result[@"Items"] count] <= 0) {
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
    if (bottomOffset <= height)  {
        //在最底部
        self.IsScrollBottom = YES;
//         NSLog(@"底部");
    }
    else{
//        NSLog(@"非底部");
        self.IsScrollBottom = NO;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)createAVload{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    NSString *directryPath = [path stringByAppendingPathComponent:@"arms"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:directryPath]) {
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return directryPath;
}

- (void)removeAVload:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
//        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
     BOOL res = [fileManager removeItemAtPath:path error:nil];
    NSLog(@"res %d",res);
    }
}

-(void)tableViewScrollCurrentIndexPath{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.videoList.count-1 inSection:0];
    [self.chatTab scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
