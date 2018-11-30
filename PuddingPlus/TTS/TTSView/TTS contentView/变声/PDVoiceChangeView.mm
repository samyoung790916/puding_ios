//
//  PDVoiceChange.m
//  Pudding
//
//  Created by baxiang on 16/2/25.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//


#include "UIImage+TintColor.h"
#import "PDVoiceChangeView.h"
#import "PDVoiceRecorder.h"
#import "PDAudioChangeConfig.h"
#import "PDTTSDataHandle.h"
#import "PDSoundTouchOperation.h"
#import "PDTimerManager.h"
#import "PDSoundTouchManager.h"
#import "UIViewController+PDUserAccessAuthority.h"
#import "UIViewController+RBAlter.h"
//#import "PDRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface PDAudioRecordHUD : UIView
@property (strong,nonatomic) UILabel *timeLabel;
@property (strong,nonatomic) UIImageView * recordAnimationView;
-(void)show:(UIView*) superView;
-(void)dismiss;
-(void)updateTime:(NSString*)str;
@end
@implementation PDAudioRecordHUD

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame] ) {
        [self setupSubView];
    }
    return self;
}


-(void)setupSubView{

    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    self.backgroundColor= mRGBAToColor(0x000000, 0.8);
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(self.mas_width);
        make.top.mas_equalTo(13);
    }];
    self.recordAnimationView = [UIImageView new];
    self.recordAnimationView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.recordAnimationView];
    [self.recordAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([UIImage imageNamed:@"recording_01.png"].size.height);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_timeLabel.mas_bottom).offset(20);
    }];
    NSMutableArray *imageArray = [NSMutableArray new];
    for (int i =1; i<= 22; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"recording_%02d.png",i]];
        if (image) {
            [imageArray addObject:image];
        }
    }
    self.recordAnimationView.animationImages = imageArray;
    self.recordAnimationView.animationDuration = 2;
    self.recordAnimationView.animationRepeatCount = NSIntegerMax;
}
-(void)show:(UIView*) superView{
     self.center = superView.center;
     [superView addSubview:self];
     self.timeLabel.text = @"0:00";
     [self .recordAnimationView startAnimating];
}
-(void)dismiss{
   [self.recordAnimationView stopAnimating];
   [self removeFromSuperview];
}
-(void)updateTime:(NSString*)str{
    self.timeLabel.text = str;
}
@end


/**
 *  视频播放进度条
 */
@interface PDAudioPlayProgress : UIView

@property (nonatomic,assign)CGFloat startAngle;
@property (nonatomic,assign)CGFloat endAngle;
@property (nonatomic,assign) CGFloat totalTime;
@property (nonatomic,assign) CGFloat time_left;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) NSMutableParagraphStyle *textStyle;
@property (nonatomic,assign) CGFloat progress;
@property (nonatomic,copy) NSString *content;

@end

@implementation PDAudioPlayProgress

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _startAngle = -0.5 * M_PI;
        _endAngle = _startAngle;
        _totalTime = 0;
        _textFont = [UIFont  systemFontOfSize:14];
        _textColor = [UIColor whiteColor];
        _textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        _textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        _textStyle.alignment = NSTextAlignmentCenter;
        self.backgroundColor = mRGBAToColor(0x000000, 0.8);
        self.userInteractionEnabled = NO;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height/2.0;
    
}
-(void)drawRect:(CGRect)rect{
    _endAngle = (_progress * 2*(float)M_PI) + _startAngle;;
    
    UIBezierPath *circle = [UIBezierPath bezierPath];
    [circle addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                      radius:rect.size.width / 2-6
                  startAngle:0
                    endAngle:2 * M_PI
                   clockwise:YES];
    circle.lineWidth = 2;
    [mRGBColor(81, 101, 109) set];
    [circle stroke];
    
    
    UIBezierPath *progress = [UIBezierPath bezierPath];
    [progress addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                        radius:rect.size.width / 2-6
                    startAngle:_startAngle
                      endAngle:_endAngle
                     clockwise:YES];
    progress.lineWidth = 2;
    [mRGBToColor(0x27bef5) set];
    
    [progress stroke];
    NSString *textContent = self.content;
    CGSize textSize = [textContent sizeWithAttributes:@{NSFontAttributeName:_textFont}];
    
    CGRect textRect = CGRectMake(rect.size.width / 2 - textSize.width / 2,
                                 rect.size.height / 2 - textSize.height / 2,
                                 textSize.width , textSize.height);
    
    [textContent drawInRect:textRect withAttributes:@{NSFontAttributeName:_textFont, NSForegroundColorAttributeName:_textColor, NSParagraphStyleAttributeName:_textStyle}];
    
}
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    if (progress <=0) {
        [self setHidden:YES];
    }else{
        [self setHidden:NO];
    }
    [self setNeedsDisplay];
}

@end
@interface PDBottomButtom : UIButton

@end
@implementation PDBottomButtom

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1.0/[[UIScreen mainScreen] scale];
        self.layer.borderColor =  mRGBToColor(0xe0e3e6).CGColor;
       
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        
    }
    return self;
}

@end
@interface PDVoiceButton : UIControl
@property (strong,nonatomic) UIButton* imageContent;
@property (strong,nonatomic) UILabel *titleContent;
@property (strong,nonatomic) PDAudioPlayProgress *progressView;
@end
@implementation PDVoiceButton


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.imageContent = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imageContent.contentMode = UIViewContentModeScaleAspectFit;
        self.imageContent.userInteractionEnabled = NO;
        [self addSubview:self.imageContent];
        self.titleContent = [UILabel new];
        self.titleContent.font =[UIFont systemFontOfSize:14];
        self.titleContent.textAlignment = NSTextAlignmentCenter;
        self.titleContent.backgroundColor = [UIColor whiteColor];
        self.titleContent.layer.masksToBounds = YES;
        self.titleContent.layer.cornerRadius = 7;
        
        //UIEdgeInsetsMake(3, 5, 3, 5);
        [self addSubview:self.titleContent];
        self.titleContent.textColor = mRGBToColor(0xa6adb2);
        [self.imageContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.mas_width);
            make.height.mas_equalTo(self.mas_width);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(0);
        }];
        [self.titleContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.6);
            make.height.mas_equalTo(15);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.imageContent.mas_bottom).offset(5);
            
        }];
        self.progressView = [PDAudioPlayProgress new];
        [self addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.imageContent.imageView.mas_width);
            make.height.mas_equalTo(self.imageContent.imageView.mas_height);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.imageContent.imageView.mas_top);
        }];
        [self.progressView setProgress:0];
    }
    return self;
}

- (void)setSelected:(BOOL )selected{
    if (selected == YES) {
        self.titleContent.backgroundColor = PDMainColor;
        self.titleContent.textColor = mRGBToColor(0xffffff);
    }else{
        [self.progressView setProgress:0];
        self.titleContent.backgroundColor = [UIColor whiteColor];
        self.titleContent.textColor = mRGBToColor(0xa6adb2);
    }
    
}
-(void) updatePlayProgress:(CGFloat) progress andContent:(NSString*) text{
    [self.progressView setContent:text];
    [self.progressView setProgress:progress];
}
@end

typedef NS_ENUM(NSInteger,PDAudioRecordState) {
    PDAudioStateReadyRecord = 0, // 准备录音
    PDAudioStateRecording,      // 录音中
    PDAudioStaterReadyPlay,    // 准备播放
    PDAudioStaterPlaying      // 播放中
};

@interface PDVoiceChangeView()<PDVoiceRecorderDelegate>
@property (nonatomic,assign) CGFloat viewHight; // 高度值
@property (nonatomic,assign) CGFloat viewWidth; // 宽度
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,copy)   hideView hideView;
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
@implementation PDVoiceChangeView


-(instancetype) initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor =[UIColor whiteColor];
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
    //NSString *p = [[PDRecorder shareRecorder] recordFilePath];
    //NSString *p = [self.audioRecorder recordFilePath];
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

-(void)hideChangeVoiceView:(hideView)hideView{
    self.hideView = hideView;
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


-(void)showMicrophonePermission{
    NSArray * item = nil;
    if([UIDevice isIOS7]){
        item = @[@"我知道了"];
    }else{
        item = @[@"取消",@"设置"];
    }
    [[self viewController] tipAlter:@"请在设置-隐私中允许布丁使用\n您的麦克风" ItemsArray:item :^(int index) {
        if(index== 1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }];

}
- (void)checkAudioAuthStatusWithContinueBlock:(void (^)())continueBlock grantedBlock:(void (^)())grantedBlock
{
    
    NSString *mediaType = AVMediaTypeAudio;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted){
        [MitLoadingView showNoticeWithStatus:@"您的设备似乎不支持麦克风"];
    }else if (authStatus == AVAuthorizationStatusDenied){
        [self showMicrophonePermission];
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(granted){
                    if (grantedBlock) {
                        grantedBlock();
                    }
                }else {
                   [self showMicrophonePermission];
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
            [self showToastInfo:@"最多录音一分钟" duration:1.5];
        }
    }else{
        self.recordState = PDAudioStateReadyRecord;
        [self showToastInfo:@"说话时间太短" duration:0.5];
    }
}


-(void)showToastInfo:(NSString*) text duration:(double)interval{
    self.toastLabel.text = text;
    @weakify(self);
    [[PDTimerManager sharedInstance] cancelTimerWithName:@"showToastInfo"];
    [[PDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"showToastInfo"
                                                       timeInterval:interval
                                                              queue:nil
                                                            repeats:NO
                                                       actionOption:AbandonPreviousAction
                                                             action:^{
                                                                 @strongify(self);
                                                                 [self hideToastInfo];
                                                             }];
}
-(void)hideToastInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.toastLabel removeFromSuperview];
        self.toastLabel = nil;
    });
   
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
//        [_toastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.mas_equalTo([self viewController].view);
//            make.height.mas_equalTo(40);
//            make.width.mas_equalTo(120);
//        }];
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
    [self sendTTSHeartbeat];
    [RBNetworkHandle uploadVoiceChangeWithFileURL:[NSURL fileURLWithPath:filePath] Block:^(id res) {
        if (res&&[[res mObjectForKey:@"result"] integerValue]==0) {
            [[PDTTSDataHandle getInstanse]  sendTTSVideoDataWithView:nil];
        }else{
            [MitLoadingView showErrorWithStatus:@""];
        }

    }];
}
/**
 *  发送TTS心跳数据包
 */
- (void)sendTTSHeartbeat{
//    [RBNetworkHandle configRooboWithSSLType:1 ctrlId:DataHandle.currentCtrl.mcid Block:^(id res) {
//        if(res && [[res mObjectForKey:@"result"] intValue] == 0){
////            LogWarm(@"开始心跳 = %@",res);
//        }else{
////            LogWarm(@"failed");
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
    if([PDTTSDataHandle getInstanse].isVideoViewModle){
        currScene = PD_Video_Voice;
    }
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
@end
