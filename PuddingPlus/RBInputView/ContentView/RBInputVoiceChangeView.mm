//
//  RBInputVoiceChangeView.m
//  RBInputView
//
//  Created by kieran on 2017/2/10.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBInputVoiceChangeView.h"
#import "PDVoiceRecorder.h"
#import "PDVoiceButton.h"
#import "PDAudioRecordHUD.h"
#import "PDBottomButtom.h"
#import "PDAudioChangeConfig.h"
#import "PDTimerManager.h"
#import "UIImage+TintColor.h"
#import "PDSoundTouchManager.h"
#import "RBNetworkHandle+ctrl_device.h"
#import "PDSoundTouchOperation.h"

typedef NS_ENUM(NSInteger,PDAudioRecordState) {
    PDAudioStateReadyRecord = 0, // 准备录音
    PDAudioStateRecording,      // 录音中
    PDAudioStaterReadyPlay,    // 准备播放
    PDAudioStaterPlaying      // 播放中
};

@interface RBInputVoiceChangeView()<PDVoiceRecorderDelegate>{

}
@property (nonatomic,assign) CGFloat viewHight; // 高度值
@property (nonatomic,assign) CGFloat viewWidth; // 宽度
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) PDVoiceButton *selectBtn;
@property (nonatomic,strong) NSOperationQueue *audioQueue;
@property (nonatomic,assign) NSTimeInterval audioDuration;
@property (nonatomic,assign) NSInteger selectChageType;
@property (nonatomic,assign) PDAudioRecordState recordState;
@property (nonatomic,strong) UIButton *recordBtn;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) PDAudioRecordHUD *recordHUD;
@property (nonatomic,assign) BOOL isIgnoreEvent;
@property (nonatomic,strong) UILabel *toastLabel;
@property (nonatomic,assign) BOOL isInterrupt; // 录音被打断
@property (nonatomic,assign) NSTimeInterval totalDuration;

@end




@implementation RBInputVoiceChangeView
@synthesize InputVoiceErrorBlock = _InputVoiceErrorBlock;
@synthesize SendPlayVoiceBlock = _SendPlayVoiceBlock;


-(instancetype) initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = mRGBToColor(0xf7f7f7);
        self.viewWidth = frame.size.width;
        self.viewHight = frame.size.height;
        [self showVoiceChangeView];
        [self addNotification];
    }
    return self;
}

-(CGFloat)viewHight{
    if (_viewHight<=0) {
        _viewHight = 270;
    }
    return _viewHight;
}
-(CGFloat)viewWidth{
    if (_viewWidth<=0) {
        _viewWidth =SC_WIDTH;
    }
    return _viewWidth;
}


-(PDAudioRecordHUD*)recordHUD{
    if (!_recordHUD) {
        _recordHUD = [[PDAudioRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 135, 125)];
    }
    return _recordHUD;
}
-(void) addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioDidStartPlayBack) name:@"playbackQueueStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioDidFinshPlayBack) name:@"playbackQueueStop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioDidFinshPlayBack) name:@"playbackDisposeQueue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideHUD) name:UIApplicationWillResignActiveNotification object:nil];
}
-(void) hideHUD{
    self.isInterrupt = YES;
    [self stopRecordAction];
}

-(void)showVoiceChangeView{
    self.tipLabel = [UILabel new];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.textColor = mRGBToColor(0xa2acb3);
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.tipLabel];
    CGFloat imageMargin = 30;
    CGFloat imagePadding = 15;
    CGFloat width = (self.viewWidth-imagePadding*3-imageMargin*2)/4;
    PDVoiceButton *girlBtn = [PDVoiceButton new];
    [self addSubview:girlBtn];
    [girlBtn.imageContent setImage:[UIImage imageNamed:@"btn_loli_n"] forState:UIControlStateNormal];
    [girlBtn.imageContent setImage:[UIImage imageNamed:@"btn_loli_p"] forState:UIControlStateHighlighted];
    girlBtn.titleContent.text = @"萝莉";
    girlBtn.tag = PDVoiceChangeTypeGirl;
    [girlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(imageMargin);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(width);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(girlBtn.mas_top).offset(-20);
    }];
    
    [girlBtn addTarget:self action:@selector(voiceChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    PDVoiceButton *monsterBtn = [PDVoiceButton new];
    [self addSubview:monsterBtn];
    
    [monsterBtn.imageContent setImage:[UIImage imageNamed:@"btn_monster_n"] forState:UIControlStateNormal];
    [monsterBtn.imageContent setImage:[UIImage imageNamed:@"btn_monster_p"] forState:UIControlStateHighlighted];
    monsterBtn.titleContent.text = @"搞怪";
    monsterBtn.tag = PDVoiceChangeTypeMonster;
    [monsterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(girlBtn.mas_top);
        make.left.mas_equalTo(girlBtn.mas_right).offset(imagePadding);
        make.height.mas_equalTo(girlBtn.mas_height);
        make.width.mas_equalTo(girlBtn.mas_width);
    }];
    [monsterBtn addTarget:self action:@selector(voiceChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    PDVoiceButton *uncleBtn = [PDVoiceButton new];
    [self addSubview:uncleBtn];
    [uncleBtn.imageContent setImage:[UIImage imageNamed:@"btn_uncle_n"] forState:UIControlStateNormal];
    [uncleBtn.imageContent setImage:[UIImage imageNamed:@"btn_uncle_p"] forState:UIControlStateHighlighted];
    uncleBtn.titleContent.text = @"萌叔";
    uncleBtn.tag = PDVoiceChangeTypeUncle;
    [uncleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(girlBtn.mas_top);
        make.left.mas_equalTo(monsterBtn.mas_right).offset(imagePadding);
        make.height.mas_equalTo(girlBtn.mas_height);
        make.width.mas_equalTo(girlBtn.mas_width);
    }];
    [uncleBtn addTarget:self action:@selector(voiceChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    PDVoiceButton *originBtn = [PDVoiceButton new];
    [self addSubview:originBtn];
    [originBtn.imageContent setImage:[UIImage imageNamed:@"btn_native_n"] forState:UIControlStateNormal];
    [originBtn.imageContent setImage:[UIImage imageNamed:@"btn_native_p"] forState:UIControlStateHighlighted];
    originBtn.titleContent.text = @"原声";
    originBtn.tag = PDVoiceChangeTypeOrigin;
    self.selectChageType = [self currVoiceChangeType];
    PDVoiceButton *voiceBtn= [self viewWithTag:self.selectChageType];
    self.selectBtn = voiceBtn;
    [self.selectBtn setSelected:YES];
    [originBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(girlBtn.mas_top);
        make.left.mas_equalTo(uncleBtn.mas_right).offset(imagePadding);
        make.height.mas_equalTo(girlBtn.mas_height);
        make.width.mas_equalTo(girlBtn.mas_width);
    }];
    [originBtn addTarget:self action:@selector(voiceChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordBtn setExclusiveTouch:YES];
    [self addSubview:self.recordBtn];
    self.isIgnoreEvent = NO;
    self.recordBtn.layer.borderWidth = 1.0/[[UIScreen mainScreen] scale];
    self.recordBtn.layer.borderColor =  mRGBToColor(0xe0e3e6).CGColor;
    [self.recordBtn setTitleColor:mRGBToColor(0xa2acb3) forState:UIControlStateNormal];
    [self.recordBtn setTitle:@"按住录音" forState:UIControlStateNormal];
    [self.recordBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [self.recordBtn setImage:[UIImage imageNamed:@"btn_recording_n"] forState:UIControlStateNormal];
    [self.recordBtn setImage:[UIImage imageNamed:@"btn_recording_p"] forState:UIControlStateHighlighted];
    [self.recordBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                           action:@selector(startRecordAction:)];
    longPress.minimumPressDuration = 0.2f;
    [self.recordBtn addGestureRecognizer:longPress];
    [self.recordBtn setBackgroundImage:[UIImage createImageWithColor:mRGBToColor(0xf2f2f2)] forState:UIControlStateHighlighted];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.mas_width);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    self.recordState = PDAudioStateReadyRecord;
    [self setupSendAudioView];
    [self updateBottomRecordView];
}

-(void) setupSendAudioView{
    self.backBtn = [PDBottomButtom buttonWithType:UIButtonTypeCustom];
    [self.backBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.backBtn setBackgroundImage:[UIImage createImageWithColor:PDMainColor] forState:UIControlStateHighlighted];
    [self.backBtn setTitleColor:mRGBToColor(0xa2acb3) forState:UIControlStateNormal];
    [self addSubview:self.backBtn];
    [self.backBtn addTarget:self action:@selector(returnRecordView) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.sendBtn = [PDBottomButtom buttonWithType:UIButtonTypeCustom];
    [self.sendBtn setBackgroundImage:[UIImage createImageWithColor:PDMainColor] forState:UIControlStateNormal];
    [self.sendBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:mRGBToColor(0X25b4e9) forState:UIControlStateHighlighted];
    [self addSubview:self.sendBtn];
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(50);
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(self.backBtn.mas_right);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
    }];
    [self.sendBtn addTarget:self action:@selector(sendRecordFileHandle) forControlEvents:UIControlEventTouchUpInside];
}

-(void)updateBottomRecordView{
    if (self.recordState == PDAudioStaterReadyPlay) {
        self.tipLabel.text = @"点击任意头像进行试听";
        self.recordBtn.hidden = YES;
        self.sendBtn.hidden = NO;
        self.backBtn.hidden = NO;
        
    }else{
        self.tipLabel.text = @"选择变声效果";
        self.recordBtn.hidden = NO;
        self.sendBtn.hidden = YES;
        self.backBtn.hidden = YES;
    }
    
}
-(void)cancelRecordHandle{
    [self stopRecordAction];
}
-(void)dragOut: (UIButton*)sender withEvent: (UIEvent *) event {
    CGPoint point = [[[event allTouches] anyObject] locationInView:self];
    if (!CGRectContainsPoint(sender.frame, point)&&self.recordState == PDAudioStateRecording) {
        [self stopRecordAction];
    }
}

-(void)voiceChangeAction:(PDVoiceButton*) sender{
    
    if (self.selectChageType!=sender.tag) {
        self.selectChageType = sender.tag;
        [self saveVoiceChangeType:self.selectChageType];
    }
    
    if (sender!=self.selectBtn) {
        [self.selectBtn setSelected:NO];
        self.selectBtn = sender;
        [self.selectBtn setSelected:YES];
        if (self.recordState == PDAudioStaterReadyPlay||self.recordState == PDAudioStaterPlaying) {
            [self startPlayerRecordFile];
        }
    }else{
        if (self.recordState == PDAudioStaterReadyPlay) {
            [self startPlayerRecordFile];
            return;
        }
        if (self.recordState == PDAudioStaterPlaying) {
            [self stopPlayerRecordFile];
        }
    }
}


-(void)startPlayerRecordFile{
    NSString *p = [PDVoiceRecorder shareRecorder].recordFilePath;
    PDSountTouchConfig config = [self voiceChangeConfig];
    [[PDSoundTouchManager manager] PlayWithName:p  config:config];
}
-(void)stopPlayerRecordFile{
    [self stopPlayerTimer];
    [[PDSoundTouchManager manager] disposePlayQueue];
}
-(PDSountTouchConfig )voiceChangeConfig{
    NSInteger type = self.selectChageType;
    PDSountTouchConfig config;
    switch (type) {
        case PDVoiceChangeTypeGirl:
            config.sampleRate = 8000.0;
            config.tempoChange = 0;
            config.pitch = 8;
            config.rate = 22;
            break;
        case PDVoiceChangeTypeMonster:
            config.sampleRate = 8000.0;
            config.tempoChange = -20;
            config.pitch = 0;
            config.rate = 30;
            break;
        case PDVoiceChangeTypeUncle:
            config.sampleRate = 8000.0;
            config.tempoChange = 0;
            config.pitch = -5;
            config.rate = 0;
            break;
        default:
            config.sampleRate = 8000.0;
            config.tempoChange = 0;
            config.pitch = 0;
            config.rate = 0;
            break;
    }
    return config;
}

-(void)returnRecordView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopPlayerRecordFile];
        self.recordState = PDAudioStateReadyRecord;
        [self updateBottomRecordView];
    });
}

-(void)sendRecordFileHandle{
    [self stopPlayerRecordFile];
    self.recordState = PDAudioStateReadyRecord;
    [self voiceChangeStat];
    [self updateBottomRecordView];
    NSString *path = [PDVoiceRecorder shareRecorder].recordFilePath;
    [self audioConvertDecodeToAmr:path];
}

/**
 *  开始录音
 */
-(void)startRecordAction:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        @weakify(self);
        void (^recordBlock)() = ^{
            @strongify(self);
            self.isInterrupt = NO;
            [self.recordBtn setHighlighted:YES];
            [self.recordHUD show:[self viewController].view];
            [self startRecordTime];
            [PDVoiceRecorder shareRecorder].recorderDelegate = self;
            [[PDVoiceRecorder shareRecorder]startRecord];
            // [PDRecorder shareRecorder].recorderDelegate = self;
            //  [self.audioRecorder startRecord];
            
        };
        void (^grantedBlock)() = ^{
            if (![self.recordBtn isHighlighted]) {
                return ;
            }
            recordBlock();
        };
        
        [self checkAudioAuthStatusWithContinueBlock:recordBlock grantedBlock:grantedBlock];
    }
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [sender locationInView:self];
        if (!CGRectContainsPoint(self.recordBtn.frame, point)&&self.recordState == PDAudioStateRecording) {
            [self stopRecordAction];
        }
    }
    if(sender.state == UIGestureRecognizerStateEnded){
        [self stopRecordAction];
        
    }
}

- (void)checkAudioAuthStatusWithContinueBlock:(void (^)())continueBlock grantedBlock:(void (^)())grantedBlock
{
    
    NSString *mediaType = AVMediaTypeAudio;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted){
        if(self.InputVoiceErrorBlock){
            RBVoiceError error;
            error.errorType = RBVoiceRestricted;
            self.InputVoiceErrorBlock(error);
        }
    }else if (authStatus == AVAuthorizationStatusDenied){
        if(self.InputVoiceErrorBlock){
            RBVoiceError  error ;
            error.errorType = RBVoiceDenied;
            self.InputVoiceErrorBlock(error);
        }
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(granted){
                    if (grantedBlock) {
                        grantedBlock();
                    }
                }else {
                    if(self.InputVoiceErrorBlock){
                        RBVoiceError  error ;
                        error.errorType = RBVoiceDenied;
                        self.InputVoiceErrorBlock(error);
                    }
                }
            });
        }];
    }else{
        if (continueBlock) {
            continueBlock();
        }
    }
}

-(void)touchupRecodHandle{
    [self stopRecordAction];
}
/**
 *  结束录音
 */
-(void)stopRecordAction{
    if (self.recordState ==PDAudioStateRecording) {
        [[PDVoiceRecorder shareRecorder] stopRecord];
    }
    //[self.audioRecorder stopRecord];
}
-(void)stopRecordingView{
    [[PDTimerManager sharedInstance] cancelTimerWithName:@"RecordTime"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recordBtn setHighlighted:NO];
        [self.recordHUD dismiss];
    });
    
}

#pragma mark 动画定时器
-(void) startRecordTime{
    __block int currentTime= 0;
    [[PDTimerManager sharedInstance] cancelTimerWithName:@"RecordTime"];
    [[PDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"RecordTime"
                                                       timeInterval:1
                                                              queue:nil
                                                            repeats:YES
                                                       actionOption:AbandonPreviousAction
                                                             action:^{
                                                                 currentTime++;
                                                                 int mint = currentTime / 60;
                                                                 int sec = (NSInteger)currentTime % 60;
                                                                 NSString *strTime = [NSString stringWithFormat:@"%01d:%02d", mint, sec];
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     [self.recordHUD updateTime:strTime];
                                                                     
                                                                 });
                                                                 
                                                                 
                                                             }];
    
}


-(void)startPlayerTimer{
    @weakify(self);
    [[PDTimerManager sharedInstance] cancelTimerWithName:@"PlayTime"];
    [[PDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"PlayTime"
                                                       timeInterval:0.3
                                                              queue:nil
                                                            repeats:YES
                                                       actionOption:AbandonPreviousAction
                                                             action:^{
                                                                 @strongify(self)
                                                                 [self currentPlayTime];
                                                             }];
}
- (void)stopPlayerTimer
{
    [[PDTimerManager sharedInstance] cancelTimerWithName:@"PlayTime"];
}
-(void)currentPlayTime{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval currTime = [[PDSoundTouchManager manager] playedTime];
        [self.selectBtn updatePlayProgress:currTime/self.totalDuration andContent:[NSString stringWithFormat:@"%.1fs",currTime]];
    });
}

#pragma mark PDVoiceRecorderDelegate
-(void)recorderStart{
    self.recordState = PDAudioStateRecording;
}
/**
 * 录音完成的回调
 * filePath 录音文件保存路径
 * fileName 录音文件名
 * duration 录音时长
 **/
-(void)recorderStop:(NSString *)filePath duration:(NSTimeInterval)duration{
    self.totalDuration = duration;
    [self stopRecordingView];
    if (self.isInterrupt) {
        self.recordState = PDAudioStateReadyRecord;
        return;
    }
    
    if (duration >1.0) {
        self.recordState = PDAudioStaterReadyPlay;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateBottomRecordView];
            [self voiceChangeAction:_selectBtn];
        });
        if (self.totalDuration==60) {
            if(self.InputVoiceErrorBlock){
                RBVoiceError  error ;
                error.errorString = (char *)[@"最多录音一分钟" UTF8String];
                error.errorType = RBVoiceLongTime;
                self.InputVoiceErrorBlock(error);
            }
        }
    }else{
        self.recordState = PDAudioStateReadyRecord;
        if(self.InputVoiceErrorBlock){
            RBVoiceError error ;
            error.errorString = (char *)[@"说话时间太短" UTF8String];
            error.errorType = RBVoiceSortTime;
            self.InputVoiceErrorBlock(error);
        }
    }
}


-(UILabel*)toastLabel{
    if (!_toastLabel) {
        _toastLabel = [UILabel new];
        _toastLabel.font = [UIFont systemFontOfSize:15];
        _toastLabel.layer.masksToBounds = YES;
        _toastLabel.layer.cornerRadius = 5;
        _toastLabel.textColor = [UIColor whiteColor];
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        _toastLabel.backgroundColor = [UIColor blackColor];
        [[self viewController].view addSubview:_toastLabel];
        _toastLabel.frame = CGRectMake(0, 0, 120, 40);
        _toastLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0);
    }else{
        [[self viewController].view addSubview:_toastLabel];
    }
    return _toastLabel;
}
- (NSOperationQueue *)myAudioQue {
    if (!_audioQueue) {
        _audioQueue = [[NSOperationQueue alloc] init];
        _audioQueue.maxConcurrentOperationCount = 1;
    }
    return _audioQueue;
}
- (void)audioConvertDecodeToAmr:(NSString *)sourcePath {
    PDSoundTouchOperation *manSTO = [[PDSoundTouchOperation alloc]initWithTarget:self action:@selector(finsih:) SoundTouchConfig:[self voiceChangeConfig] soundFile:sourcePath];
    [[self myAudioQue] cancelAllOperations];
    [[self myAudioQue] addOperation:manSTO];
    
}
-(void) finsih:(NSString*) filePath{
    if(self.SendPlayVoiceBlock){
        __weak typeof(self) weakself = self;
        self.SendPlayVoiceBlock(filePath,weakself);
    }
   
}
/**
 *  发送TTS心跳数据包
 */
- (void)sendTTSHeartbeat{
//    [RBNetworkHandle configRooboWithSSLType:1 ctrlId:DataHandle.currentCtrl.mcid Block:^(id res) {
//        if(res && [[res objectForKey:@"result"] intValue] == 0){
//        }else{
//        }
//    }];
}
-(void)audioDidStartPlayBack{
    self.recordState = PDAudioStaterPlaying;
    [self startPlayerTimer];
    
}
-(void)audioDidFinshPlayBack{
    self.recordState = PDAudioStaterReadyPlay;
    [self stopPlayerTimer];
    [self.selectBtn updatePlayProgress:0 andContent:@""];
}

-(void)dealloc{
    [PDVoiceRecorder recorderDealloc];
    [PDSoundTouchManager managerDealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
/**
 *  布丁变声数据打点
 */
-(void)voiceChangeStat{
    NSString *currScene = PD_Send_Voice;
//    if([PDTTSDataHandle getInstanse].isVideoViewModle){
//        currScene = PD_Video_Voice;
//    }
    if (self.currVoiceChangeType == PDVoiceChangeTypeOrigin) {
        [RBStat logEvent:currScene message:@"index=3"];
    }else if (self.currVoiceChangeType == PDVoiceChangeTypeUncle){
        [RBStat logEvent:currScene message:@"index=2"];
    }else if (self.currVoiceChangeType == PDVoiceChangeTypeMonster){
        [RBStat logEvent:currScene message:@"index=1"];
    }else if (self.currVoiceChangeType == PDVoiceChangeTypeGirl){
        [RBStat logEvent:currScene message:@"index=0"];
    }
}

-(NSInteger)currVoiceChangeType{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger currChangeType = [userDefaults integerForKey:@"PDVoiceChangeType"];
    if (currChangeType==0) {
        return PDVoiceChangeTypeOrigin;
    }
    return currChangeType;
}
-(BOOL)saveVoiceChangeType:(NSInteger)voiceChangeType{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:voiceChangeType forKey:@"PDVoiceChangeType"];
    return [userDefaults synchronize];
}

#pragma mark -  delegate

- (void)updateData{
    if(self.recordState != PDAudioStateReadyRecord){
        [self stopPlayerRecordFile];
        self.recordState = PDAudioStateReadyRecord;
        [self updateBottomRecordView];
    }
 
}

@end
