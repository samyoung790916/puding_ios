//
//  PDConfigNetWorkStepOneController.m
//  Pudding
//
//  Created by william on 16/3/4.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//


#import "PDConfigNetStepTwoController.h"
#import "PDConfigNetStepThreeController.h"
#import "PDPlayVideo.h"
#import "NSObject+ChangeSystemVoice.h"
#import "SandboxFile.h"
#import "soundtrans.h"
#import "PDHtmlViewController.h"
#import "RBPuddingWifiAnimail.h"

typedef NS_ENUM(NSUInteger, ConfigNetStep) {
    ConfigNetStepOne,
    ConfigNetStepTwo,
    ConfigNetStepThree,
};

@interface PDConfigNetStepTwoController (){
    NSTimer * showAnamailTimer;
}



/** 通知文本 */
@property (nonatomic, weak) UILabel * notifyLab;
/** 下一步按钮 */
@property (nonatomic, weak) UIButton * nextStepBtn;
/** 播放器 */
@property (nonatomic, weak) PDPlayVideo * player;
/** 配网步骤 */
@property (nonatomic, assign) ConfigNetStep step;

/** 是否是进入下一个界面 */
@property (nonatomic, assign) BOOL isPushToNext;


/** 准备好按钮 */
@property (nonatomic, weak) UIButton *readyBtn;
/** 重新通知按钮 */
@property (nonatomic, weak) UIButton *reNotyBtn;
/** 音频路径 */
@property (nonatomic, strong) NSString * voicePath;
/** 设置 Id */
@property (nonatomic, strong) NSString * settingID;

/** 第一个音频文件时常 */
@property (nonatomic, assign) CGFloat urlOneDuration;
/** 第二个音频文件的时常 */
@property (nonatomic, assign) CGFloat urlTwoDuration;
/** 是否是动画 */
@property (nonatomic, assign) BOOL userAbled;

/** 重新发送通知点击的次数 */
@property (nonatomic, assign) NSInteger numOfReNotify;
@property (nonatomic, weak) RBPuddingWifiAnimail * anmialView;
@end

@implementation PDConfigNetStepTwoController

#pragma mark ------------------- life cycle ------------------------
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.numOfReNotify = 0;
    /** 设置导航 */
    [self initialNav];
    self.anmialView.hidden = NO;
    /** 设置配网步骤 */
    self.step = ConfigNetStepOne;
    self.userAbled = YES;
}
#pragma mark - action: 重置按钮
- (void)resetButtons{

    self.step = ConfigNetStepTwo;

}
#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeVoiceToMax:self.view];
    self.numOfReNotify = 0;
    [self.anmialView setUpAnimail];

}

#pragma mark - viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.numOfReNotify = 0;

    if(showAnamailTimer){
        [showAnamailTimer invalidate];
        showAnamailTimer = nil;
    }

    NSString * urlStr = [[NSBundle mainBundle]pathForResource:@"nearpudding" ofType:@"mp3"];
    [PDPlayVideo stopMusic:urlStr];
    [self resetToOldVoiceValue];
}
#pragma mark - dealloc
- (void)dealloc{
    LogError(@"%s",__func__);

}



#pragma mark - 初始化导航
- (void)initialNav{
    self.title = R.prepare_pudding;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = mRGBToColor(0xFFFFFF);
}



#pragma mark ------------------- LazyLoad ------------------------
-(RBPuddingWifiAnimail *)anmialView{
    if(!_anmialView){
        RBPuddingWifiAnimail * animailView = [[RBPuddingWifiAnimail alloc] initWithFrame:CGRectMake(0, self.navView.height, self.view.width, self.view.width)];
        [self.view addSubview:animailView];
        [animailView addStartWifiAnimail];
        [animailView addOnpuddingMoveAnimation:^(BOOL finished) {
            
        }];
        
        _anmialView = animailView;
    }
    return _anmialView;
}


static CGFloat kEdgePacing = 45;
static CGFloat kTxtHeight = 45;
#pragma mark - 创建 -> 下一步按钮
-(UIButton *)nextStepBtn{
    if (!_nextStepBtn) {
        UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kEdgePacing, self.view.height - SX(100), self.view.width - 2*kEdgePacing, SX(kTxtHeight));
        [btn setTitle:NSLocalizedString( @"send_voice_command", nil) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = btn.height*0.5;
        btn.layer.masksToBounds = true;
        [btn addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.hidden = YES;
        _nextStepBtn = btn;
    }
    return _nextStepBtn;
}

#pragma mark - 创建 -> 已听到布丁准备好了
-(UIButton *)readyBtn{
    if (!_readyBtn) {
        UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(kEdgePacing, self.view.height - SX(150), self.view.width - 2*kEdgePacing, SX(kTxtHeight));
        [btn setTitle:NSLocalizedString( @"have_seen_animation_and_send_sound", nil) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = PDMainColor;
        btn.layer.cornerRadius = btn.height*0.5;
        btn.layer.masksToBounds = true;
        [btn addTarget:self action:@selector(readyToPlay) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _readyBtn = btn;
    }
    return  _readyBtn;
}



#pragma mark - 创建 -> 没听到布丁提示，重新通知
-(UIButton *)reNotyBtn{
    if (!_reNotyBtn) {
        UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(kEdgePacing, self.view.height - SX(90), self.view.width - 2*kEdgePacing, SX(kTxtHeight));
        [btn setTitle:NSLocalizedString( @"no_animation_resend", nil) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor = PDMainColor;
        btn.layer.cornerRadius = btn.height*0.5;
        btn.layer.masksToBounds = true;
        btn.layer.borderWidth = 1;
        [btn addTarget:self action:@selector(renotyPlay) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _reNotyBtn = btn;
    }
    return  _reNotyBtn;
}






#pragma mark - 创建 -> 通知按钮
-(UILabel *)notifyLab{
    if (!_notifyLab) {
        UILabel *lab  = [[UILabel alloc]init];
        if (IPHONE_4S_OR_LESS) {
            lab.frame = CGRectMake(kEdgePacing*1.2, self.anmialView.bottom - kTxtHeight*2 - SX(20) , self.view.width- 2.4*kEdgePacing, kTxtHeight*2);
        }else{
           lab.frame = CGRectMake(kEdgePacing*1.2, self.anmialView.bottom - kTxtHeight*2, self.view.width- 2.4*kEdgePacing, kTxtHeight*2);
        }
        lab.numberOfLines = 0;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font =[UIFont systemFontOfSize:SX(FontSize)];
        lab.textColor = mRGBToColor(0x8c8c8c);
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:R.near_pudding];
        lab.attributedText = content;
        [self.view addSubview:lab];
        _notifyLab = lab;
    }
    return _notifyLab;
}


#pragma mark ------------------- Action ------------------------
#pragma mark - action: 设置当前的阶段
-(void)setStep:(ConfigNetStep)step{
    switch (step) {
        case ConfigNetStepOne:
        {
            self.nextStepBtn.backgroundColor = PDMainColor;
            /** 开启动画 */
            /** 播放声音 */
            [self playUrlOne];
            self.readyBtn.hidden = YES;
            self.reNotyBtn.hidden = YES;
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:R.near_pudding];
            self.notifyLab.attributedText = content;
            [self.anmialView addStartWifiAnimail];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.nextStepBtn.alpha = 0;
                self.nextStepBtn.hidden = NO;
                [UIView animateWithDuration:.3 animations:^{
                    self.nextStepBtn.alpha = 1;
                }];
            });

        }
            break;
        case ConfigNetStepTwo:
        {
            [self playUrlTwo];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.readyBtn.hidden = YES;
                self.reNotyBtn.hidden = YES;
                self.nextStepBtn.hidden = YES;
                self.readyBtn.backgroundColor = PDUnabledColor;
                self.readyBtn.layer.borderColor = PDUnabledColor.CGColor;
                self.reNotyBtn.backgroundColor = [UIColor whiteColor];
                self.reNotyBtn.layer.borderColor = PDUnabledColor.CGColor;
                [self.reNotyBtn setTitleColor:PDUnabledColor forState:UIControlStateNormal];
                self.notifyLab.text = NSLocalizedString( @"is_sending_command", nil);
            });
            //打开声波配网
            if (self.configType==PDAddPuddingTypeUpdateData) {
                //发送请求打开声波配网
                [RBNetworkHandle openVoiceConfigBlock:^(id res) {
                    LogError(@"%@",res);
                }];
            }
            
            LogWarm(@"持续时间 = %f",self.urlTwoDuration);
            @weakify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.urlTwoDuration + 5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                self.step = ConfigNetStepThree;
                //0.判断是否需要弹需要帮助的框
                if (self.numOfReNotify >= 2) {
                    self.readyBtn.userInteractionEnabled = NO;
                    self.reNotyBtn.userInteractionEnabled = NO;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        @strongify(self);
                        self.readyBtn.userInteractionEnabled = YES;
                        self.reNotyBtn.userInteractionEnabled = YES;
                        ZYAlterView * al = [self tipAlter:NSLocalizedString( @"never_hear_sound_prompt", nil) AlterString:R.other_config_network Item:@[NSLocalizedString( @"heard", nil),NSLocalizedString( @"other_way", nil)] type:ZYAlterNone delay:0.2 :^(int index) {
                            if (index == 1) {
                                PDHtmlViewController * vc=  [[PDHtmlViewController alloc]init];
                                vc.navTitle = NSLocalizedString(@"use_help", nil);
                                vc.urlString = [NSString stringWithFormat:@"http://puddings.roobo.com/apphelp/problem.html#wifi"];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        }];
                        al.frame = CGRectMake(al.frame.origin.x, al.frame.origin.y, CGRectGetWidth(al.frame), CGRectGetHeight(al.frame) +20);
                        [al reset];
                    });
                }
            });
            
            
            
            
            
            

        }
            break;
        case ConfigNetStepThree:
        {
            [self.anmialView addSettingAnimail];

            self.readyBtn.backgroundColor = PDMainColor;
            self.readyBtn.layer.borderColor = PDMainColor.CGColor;
            self.reNotyBtn.backgroundColor = [UIColor whiteColor];
            [self.reNotyBtn setTitleColor:PDMainColor forState:UIControlStateNormal];
            self.reNotyBtn.layer.borderColor = PDMainColor.CGColor;
            self.readyBtn.hidden = NO;
            self.reNotyBtn.hidden = NO;
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:NSLocalizedString( @"received_instruction_and_screen_will_display_lamp", nil)]];
            self.notifyLab.attributedText = content;
        }
            break;
    }
    
    
    
}

#pragma mark - action: 播放提示声音1：请将手机靠近布丁
- (void)playUrlOne{
    NSString * urlStr = [[NSBundle mainBundle]pathForResource:@"nearpudding" ofType:@"mp3"];
    [PDPlayVideo playMusic:urlStr];
    if (self.urlOneDuration>0) {
        return;
    }
    self.urlOneDuration = [PDPlayVideo musicDruction:urlStr];

    
}
#pragma mark - action: 播放提示声音2：准备连接网络
- (void)playUrlTwo{
    //先播放提示音
    NSString * urlStr = [[NSBundle mainBundle]pathForResource:@"opensoudwave" ofType:@"mp3"];
    [PDPlayVideo playMusic:urlStr];
    if (self.urlTwoDuration>0) {
        return;
    }
    self.urlTwoDuration = [PDPlayVideo musicDruction:urlStr];
}


#pragma mark - action: 开启动画


#pragma mark - action: 下一步点击
- (void)nextStepAction{
    self.step = ConfigNetStepTwo;
    self.userAbled = NO;
}
#pragma mark - action: 已听到布丁按钮点击
- (void)readyToPlay{
    [self pushToStepThree];
}
#pragma mark - action: 没听到布丁提示，重新通知
- (void)renotyPlay{
    self.numOfReNotify++;
    [self resetButtons];
    
    
}

#pragma mark - action: 去第三步配网
- (void)pushToStepThree{
    PDConfigNetStepThreeController *vc = [PDConfigNetStepThreeController new];
    vc.wifiName = self.wifiName;
    vc.wifiPsd = self.wifiPsd;
    vc.configType = self.configType;
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
