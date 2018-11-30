//
//  PDConfigNetStepThree.m
//  Pudding
//
//  Created by william on 16/3/7.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDConfigNetStepThreeController.h"
#import "PDConfigNetloadView.h"
#import "SandboxFile.h"
#import "soundtrans.h"
#import "PDPlayVideo.h"
#import "NSObject+ChangeSystemVoice.h"
#import "NSString+Helper.h"
#import "UIViewController+WifiBackToSetting.h"
#import "PDConfigNetStepOneController.h"
#import "PDGeneralSettingsController.h"
#import "PDHtmlViewController.h"
#import "PDRightImageBtn.h"
#import "PDConfigNetStepFourController.h"
#import "RBPuddingWifiAnimail.h"
#import "AppDelegate.h"
#import "ZYAlterView.h"

typedef NS_ENUM(NSUInteger, SendSoundState) {
    SendSoundStateStart,
    SendSoundStateSending,
    SendSoundStateConnectInternet,
};


@interface PDConfigNetStepThreeController ()<UIAlertViewDelegate>



#pragma mark - UI
/** 提示文本 */
@property (nonatomic, weak) UILabel * alertLab;
/** 发送声波的阶段 */
@property (nonatomic, assign) SendSoundState state;
/** 下一步按钮 */
@property (nonatomic, weak) UIButton *nextStepBtn;
/** 发送声波按钮 */
@property (nonatomic, weak) UIButton *sendSoudBtn;

@property (nonatomic, weak) UIButton * littleAlertButton;

@property (nonatomic, weak) RBPuddingWifiAnimail * anmialView;

#pragma mark - Function
/** 音频路径 */
@property (nonatomic, strong) NSString * voicePath;
/** 设置 Id */
@property (nonatomic, strong) NSString * settingID;
/** 播放器 */
@property (nonatomic, weak) PDPlayVideo * player;
/** 音频文件的持续时间 */
@property (nonatomic, assign) CGFloat soundDuration;

/** 数据模型 */
@property (nonatomic, strong) RBDeviceModel * configModle;
/** 超时时间 */
@property (nonatomic, assign) NSInteger timeOut;

/** 重新发送 文本 */
@property (nonatomic, weak) UILabel * reSendLab;

/** 富文本 */
@property (nonatomic, strong) NSAttributedString *attributeString;

/** 重新发送通知点击的次数 */
@property (nonatomic, assign) NSInteger numOfReNotify;



/** 应该执行 block */
@property (nonatomic, assign) BOOL shouldExcuteTimer;

/** 队列 */
@property (nonatomic, strong) NSOperationQueue *mainQueue;

@property (nonatomic, weak) ZYAlterView * voiceAlter;
@end

@implementation PDConfigNetStepThreeController
{
    dispatch_block_t blockDuty;
}
#pragma mark ------------------- LifeCycle ------------------------
#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.numOfReNotify = 0;
    self.shouldExcuteTimer = YES;
    [self addNotification];
    [self changeVoiceToMax:self.view];
    [self.anmialView setUpAnimail];


}

#pragma mark - viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    LogWarm(@"%s",__func__);
    self.numOfReNotify = 0;
    [self resetToOldVoiceValue];

    [PDPlayVideo stopMusic:self.voicePath];
    NSString * urlStr = [[NSBundle mainBundle]pathForResource:@"opensoudwave" ofType:@"mp3"];
    [PDPlayVideo stopMusic:urlStr];

    self.shouldExcuteTimer = NO;
    [MitLoadingView dismiss];
    [self.mainQueue cancelAllOperations];
    self.mainQueue = nil;
    [self removeNotification];
}

#pragma mark - viewDidDisappear
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    LogWarm(@"%s",__func__);
    self.shouldExcuteTimer = NO;

}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 初始化导航栏 */
    [self initialNav];
    
    self.anmialView.hidden = NO;
    
    /** 设置发送声波的阶段 */
    self.state = SendSoundStateStart;
    
    /** 设置超时时间 */
    self.timeOut = 0;

}

#pragma mark - dealloc
- (void)dealloc{
    LogError(@"%s",__func__);
    self.voicePath = nil;
    if( [[NSFileManager defaultManager] fileExistsAtPath:self.voicePath]){
        NSError * error;
        [[NSFileManager defaultManager] removeItemAtPath:self.voicePath error:&error];
        if(error){
            NSLog(@"%@",[error debugDescription]);
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 初始化导航栏
- (void)initialNav{
    self.title = NSLocalizedString( @"send_sound_wave_3", nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = mRGBToColor(0xFFFFFF);
    
}



#pragma mark ------------------- LazyLoad ------------------------
static CGFloat kEdgePacing = 45;
static CGFloat kTxtHeight = 45;
-(RBPuddingWifiAnimail *)anmialView{
    if(!_anmialView){
        RBPuddingWifiAnimail * animailView = [[RBPuddingWifiAnimail alloc] initWithFrame:CGRectMake(0, self.navView.height, self.view.width, self.view.width)];
        [self.view addSubview:animailView];
        [animailView addSettingAnimail];
        [animailView changeHandleLocation];

        _anmialView = animailView;
    }
    return _anmialView;
}


#pragma mark - 创建 -> 提示文本
-(UILabel *)alertLab{
    if (!_alertLab) {
        UILabel *lab = [[UILabel alloc]init];
        if (IPHONE_4S_OR_LESS) {
             lab.frame = CGRectMake(kEdgePacing*1.2, self.anmialView.bottom - kTxtHeight*2 - SX(20) , self.view.width- 2.4*kEdgePacing, kTxtHeight*2);
        }else{
           lab.frame = CGRectMake(kEdgePacing*1.2, self.anmialView.bottom - kTxtHeight*2, self.view.width- 2.4*kEdgePacing, kTxtHeight*2);
        }
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:FontSize];
        lab.textColor = mRGBToColor(0x8c8c8c);
        lab.numberOfLines = 0;
        [self.view addSubview:lab];
        _alertLab = lab;
    }
    return _alertLab;
}

#pragma mark - action: 创建队列
-(NSOperationQueue *)mainQueue{
    if (!_mainQueue) {
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        queue.maxConcurrentOperationCount = 1;
        _mainQueue = queue;
    }
    return _mainQueue;
}

#pragma mark - 创建 -> 发送声波按钮
-(UIButton *)sendSoudBtn{
    if (!_sendSoudBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kEdgePacing, SC_HEIGHT - SX(100),SC_WIDTH - 2*kEdgePacing,SX(kEdgePacing));
        [btn addTarget:self action:@selector(sendVociceAction) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:FontSize +1];
        btn.layer.cornerRadius = btn.height *0.5;
        btn.layer.masksToBounds = true;
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.numberOfLines = 0;
        [btn setTitle:NSLocalizedString( @"send_sound_wave_3", nil) forState:UIControlStateNormal];
        btn.hidden = YES;
        btn.backgroundColor = PDMainColor;
        [self.view addSubview:btn];
        _sendSoudBtn = btn;
    }
    return _sendSoudBtn;
}
#pragma mark - action: 创建下面的提示



-(UIButton *)littleAlertButton{
    if (!_littleAlertButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kEdgePacing, self.nextStepBtn.bottom+ SX(10), SC_WIDTH - 2*kEdgePacing, SX(kEdgePacing));
        [btn setTitle:R.not_hear_tip forState: UIControlStateNormal];
        [btn setTitleColor:PDMainColor forState:UIControlStateNormal];
        btn.layer.borderColor = PDMainColor.CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = btn.height *0.5;
        btn.layer.masksToBounds = true;
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(reNotify) forControlEvents:UIControlEventTouchUpInside];
        _littleAlertButton = btn;
    }

    return _littleAlertButton;
}






#pragma mark - 创建 -> 富文本
-(NSAttributedString *)attributeString{
    if (!_attributeString) {
        NSMutableAttributedString * content = [[NSMutableAttributedString alloc]initWithString:R.not_hear_tip_say];
        NSRange contentRange = NSMakeRange(15, 4);
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        [content addAttribute:NSForegroundColorAttributeName value:PDUnabledColor range:contentRange];
        _attributeString = content;
    }
    return _attributeString;
}

#pragma mark - 创建 -> 下一步按钮
-(UIButton *)nextStepBtn{
    if (!_nextStepBtn) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kEdgePacing, self.view.height - SX(150), self.view.width - 2*kEdgePacing, SX(kTxtHeight));
        [btn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = PDMainColor;
        [btn setTitle:R.voice_scuess forState:UIControlStateNormal];
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = btn.height *0.5;
        [self.view addSubview:btn];
        _nextStepBtn = btn;
    }
    return _nextStepBtn;
    
}



#pragma mark ------------------- Action ------------------------

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
}
#pragma mark - action: 进入后台
- (void)enterBackground{
    LogWarm(@"%s",__func__);
    LogWarm(@"currentThread = %@",[NSThread currentThread]);
}
#pragma mark - action: 活跃状态
- (void)becomeActive{
    LogWarm(@"%s",__func__);
    switch (self.state) {
        case SendSoundStateStart:
            LogWarm(@"SendSoundStateStart");
            break;
        case SendSoundStateSending:
//            [self.animateTwoImgV startAnimating];
            LogWarm(@"SendSoundStateSending");
            break;
        case SendSoundStateConnectInternet:
            LogWarm(@"SendSoundStateConnectInternet");
            break;
        default:
            break;
    }    
    LogWarm(@"currentThread = %@",[NSThread currentThread]);

}

#pragma mark - action: 重新通知
- (void)reNotify{
    NSLog(@"aaaaaaa = %s",__func__);
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"reNotify = %s",__func__);
        //1.通知次数+1
        self.numOfReNotify++;
        dispatch_async(dispatch_get_main_queue(), ^{
            //2.将动画切换为发送声波
            [self sendVociceAction];

        });

    }];
    if ([self.mainQueue.operations count]==0) {
        [self.mainQueue addOperation:operation];
    }

}

#pragma mark - action: 进入下一步
- (void)nextClick{
    PDConfigNetStepFourController * vc = [[PDConfigNetStepFourController alloc]init];
    vc.settingID = self.settingID;
    vc.wifiName = self.wifiName;
    vc.configType = self.configType;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - action: 生成配网音频文件
- (void)createConfigNetFile{
    if (!self.wifiName) {
        self.wifiName = @"Test";
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"wifi_name_is_empty", nil)];
    }
   
    self.voicePath = [[SandboxFile GetCachePath] stringByAppendingPathComponent:@"wifi.wav"];
    NSAssert([RBDataHandle loginData].userid != nil, NSLocalizedString( @"user_id_can_not_empty", nil)) ;
    if (![RBDataHandle loginData].userid) {
        [self tipAlter:nil AlterString:NSLocalizedString( @"login_timeout_", nil) Item:@[NSLocalizedString( @"i_now", nil)] type:0 delay:0 :^(int index) {
            [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
        }];
    }
    NSString * fromString = [NSString stringWithFormat:@"%@",[RBDataHandle loginData].userid];
    self.settingID  = fromString;
    //新版本直接传递userId
    createWifiWarFile(self.wifiName, self.wifiPsd, fromString, self.voicePath);
}

#pragma mark - action: 设置阶段
-(void)setState:(SendSoundState)state{
    _state = state;
    switch (state) {
            /* 开始 */
        case SendSoundStateStart:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /** 生成播音文件 */
                [self createConfigNetFile];
                NSString * urlStr = [[NSBundle mainBundle]pathForResource:@"nearpudding" ofType:@"mp3"];
                NSInteger duration = [PDPlayVideo musicDruction:urlStr];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((duration+0.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                });

            });

            //上方提示文本
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:R.send_voice];
            [content addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x8c8c8c) range:NSMakeRange(0, content.string.length)];
            self.alertLab.attributedText = content;

            //下一步按钮
            self.nextStepBtn.hidden = YES;
            //重新发送文本
            self.reSendLab.hidden = YES;
            //开始第一步动画
            

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.sendSoudBtn.alpha = 0;
                self.sendSoudBtn.hidden = NO;
                [UIView animateWithDuration:.3 animations:^{
                    self.sendSoudBtn.alpha = 1;
                }];
            });
        }
            break;
   
        case SendSoundStateSending:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.anmialView showSendAnimails:YES];
                [self.anmialView addSettingAnimail];
                self.sendSoudBtn.hidden = YES;
                self.littleAlertButton.hidden = YES;
                
                //提示文本
                NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:NSLocalizedString( @"is_sending_sound", nil)]];
                [content addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x505a66) range:NSMakeRange(0, content.string.length)];
                [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(FontSize)] range:NSMakeRange(0, content.string.length)];
                self.alertLab.attributedText = content;
                //开始第二步动画
                //重新发送文本
                self.reSendLab.alpha = 0;
                self.nextStepBtn.alpha = 0;
                
            });
          

        }
            break;
            /** 连接网络 */
        case SendSoundStateConnectInternet:
        {
            [self.anmialView showSendAnimails:NO];
            [self.anmialView addWifiAnimail];
            //重新发送文本
            self.reSendLab.hidden = NO;
            //开始第三步动画
            [self startAnimateThree];
        }
            break;
    }
}


#pragma mark - action: 查看其他解决方法
- (void)checkWayToResolve:(UITapGestureRecognizer*)tap{
    NSLog(@"%s",__func__);
    CGPoint p = [tap locationInView:[self.view viewWithTag:10001]];
    LogWarm(@"%@",NSStringFromCGPoint(p));
    if (p.x>70&&p.y>50) {
        PDHtmlViewController * vc=  [[PDHtmlViewController alloc]init];
        vc.navTitle = NSLocalizedString(@"use_help", @"");
        vc.urlString = [NSString stringWithFormat:@"http://puddings.roobo.com/apphelp/problem.html#wifi"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark - action: 播放声波文件
- (void)sendVociceAction{
    
    //0.判断是否需要弹需要帮助的框
    if (self.numOfReNotify >= 2) {
        @weakify(self);
       // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.voiceAlter) return;
           self.voiceAlter = [self tipAlter:NSLocalizedString( @"never_hear_sound_prompt", nil) AlterString:R.other_config_network Item:@[NSLocalizedString( @"heard", nil),NSLocalizedString( @"other_way", nil)] type:ZYAlterNone delay:0.2 :^(int index) {
                @strongify(self);
                if (index == 1) {
                    PDHtmlViewController * vc=  [[PDHtmlViewController alloc]init];
                    vc.navTitle = NSLocalizedString(@"use_help", @"");
                    vc.urlString = [NSString stringWithFormat:@"http://puddings.roobo.com/apphelp/problem.html#wifi"];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    self.voiceAlter = nil;
                    self.numOfReNotify = 0;
                }
            }];
            self.voiceAlter.frame = CGRectMake(self.voiceAlter.frame.origin.x, self.voiceAlter.frame.origin.y, CGRectGetWidth(self.voiceAlter.frame), CGRectGetHeight(self.voiceAlter.frame) +20);
            [self.voiceAlter reset];
       //});
        return;
    }
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"sendVociceAction = %s",__func__);
        if (!self.voicePath) {
            return;
        }
        //1.播放声波配网文件
        [PDPlayVideo playMusic:self.voicePath];
        //2.获取声波文件时长，用来生成进度动画
        self.soundDuration = [PDPlayVideo musicDruction:self.voicePath];
        //3.如果文件正常，那么进入发送动画状态
        if(self.soundDuration > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                //3.1 改变发送状态为正在发送
                self.state = SendSoundStateSending;
            });
            __weak typeof(self) weakself = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.soundDuration+1) * NSEC_PER_SEC)), dispatch_get_main_queue(),blockDuty = ^{
                __strong typeof(self) strongSelf = weakself;
                if (strongSelf.shouldExcuteTimer) {
                    strongSelf.state = SendSoundStateConnectInternet;
                }
            });
        }
        
    }];
    if ([self.mainQueue.operations count]==0) {
        [self.mainQueue addOperation:operation];
    }

}


#pragma mark - action: 点击发送按钮点击
- (void)nextBtnClick{
    self.timeOut = 0;
    [self sendVociceAction];
}



#pragma mark - action: 开始动画 轮询
- (void)startAnimateThree{
    //提示文本
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:R.send_voice_scuess];
    NSRange rang = [content.string rangeOfString:NSLocalizedString( @"sound_received_success", nil)];
    if(rang.location != NSNotFound){
        [content addAttribute:NSForegroundColorAttributeName value:PDMainColor range:rang];
    }
    
    [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SX(FontSize)] range:NSMakeRange(0, content.string.length)];
    self.alertLab.attributedText = content;
    
    
    self.nextStepBtn.hidden = NO;
    self.nextStepBtn.alpha = 1;
    self.littleAlertButton.alpha = 1;
    self.littleAlertButton.hidden = NO;
    
    
    
}

#pragma mark ------------------- UIAlertViewDelegate ------------------------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //取消返回通用设置
    if (buttonIndex ==0) {
        [self backToGeneralSetting];
    }else{
        //确定返回声波配网第一步骤
        [self backToRetryConfigNet];
    }
}

@end
