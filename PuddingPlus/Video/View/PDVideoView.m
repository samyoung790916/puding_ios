//
//  PDVideoView.m
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/11/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDVideoView.h"
#import "CircleAnimationView.h"
#import "RBVideoClientHelper.h"
#import "MitLoading.h"
#import "UIImage+TintColor.h"
#import "PDVideoAnimailBtn.h"
#import "PDRecordingLable.h"
#import "RBVideoFIlterActionView.h"
#import "RBLiveVideoClient+VideoFilter.h"
#import "PDVideoPhotoButton.h"
#import "SandboxFile.h"
#import "PDVideoPlayingName.h"
#import "NSObject+RBPuddingPlayer.h"
#import "RBVideoLoadingView.h"
#import "ZYPlayVideo.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "NSObject+RBGetViewController.h"
#import "PDSelectMtuView.h"
#import "PDSelectMtuView.h"
#import "RBAlterView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PDImageManager.h"
#import <Photos/Photos.h>
@interface PDVideoView(){
    BOOL          videoIsFull;
    UIButton    * backButton;
    UIButton    * fullScreenBtn;
    UIButton    * remoteCallBtn;
    PDVideoAnimailBtn    * singleRemoteCallBtn;
    CGRect        defalutFrame;
    UIButton    * recoredVideoBtn;
    UIButton    * screenShotBtn;
    UIButton    * voiceBtn;
    UIButton    * setvolmeBtn;
    CGRect        remoteViewFrame;

    PDRecordingLable    * recordTime;
    PDVideoPhotoButton * photoBtn;
    PDVideoPlayingName  *playingNameView;
    UIView              * navBar;


}
@property (nonatomic,strong) RBVideoLoadingView * loadingView;
@property (nonatomic,assign) BOOL                 isMute;
@property (nonatomic,weak)   UIView             * remoteView;
@property (nonatomic,weak)   UIImageView        * controlView;
@property (nonatomic,weak)   UIButton           * setMtuBtn;
@property (nonatomic,weak)   PDSelectMtuView    * selectMtuView;
@end

#define VIDEO_RATIO 0.75

@implementation PDVideoView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        defalutFrame = frame;

        if (IS_IPHONE_X){
            navBar = [[UIView alloc] initWithFrame:CGRectMakeFrame(0, 0, self.width, NAV_HEIGHT)];
            navBar.backgroundColor = [UIColor whiteColor];
            [self addSubview:navBar];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(navBar.width*0.25, STATE_HEIGHT, navBar.width*0.5, navBar.height - STATE_HEIGHT)];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont boldSystemFontOfSize:18];
            lab.textColor = [UIColor blackColor];
            lab.text = NSLocalizedString( @"remote_video", nil);
            [navBar addSubview:lab];
        }

float aa = SC_WIDTH;
        _loadingView = [[RBVideoLoadingView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        @weakify(self);
        self.loadingView.center = CGRectGetCenter(remoteViewFrame);
        [self addSubview:_loadingView];
        
        
        [_loadingView setConnectBlock:^(id a) {
            @strongify(self);
            [self connectAction:nil];
        }];
        
        photoBtn = [[PDVideoPhotoButton alloc] initWithFrame:CGRectMake(6, self.height - SX(48) - SX(6), SX(43), SX(48))];
        [photoBtn addTarget:self action:@selector(photoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        photoBtn.image = [UIImage imageWithContentsOfFile:[[SandboxFile GetTmpPath] stringByAppendingString:@"\photo.png"]];
        [self addSubview:photoBtn];
        
        recordTime = [[PDRecordingLable alloc] init];
        [self addSubview:recordTime];

        //全屏
        fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        fullScreenBtn.frame = CGRectMake(self.width - SX(53),(IS_IPHONE_X ? NAV_HEIGHT : SX(3 + 20)), SX(50), SX(50));
        [fullScreenBtn addTarget:self action:@selector(fullScreenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [fullScreenBtn setImage:[UIImage imageNamed:@"btn_video_full_n"] forState:UIControlStateNormal];
        [fullScreenBtn setImage:[UIImage imageNamed:@"btn_video_full_p"] forState:UIControlStateHighlighted];
        [self addSubview:fullScreenBtn];
        recordTime.center = CGPointMake(SC_WIDTH/2, fullScreenBtn.center.y);

        //返回
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (!IS_IPHONE_X)
            [backButton setImage:[[UIImage imageNamed:@"icon_back"] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        else
            [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];

        backButton.accessibilityIdentifier = @"video_back";
        [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateHighlighted];
        backButton.frame = CGRectMake(SX(3),STATE_HEIGHT, SX(50), SX(50));
        [self addSubview:backButton];
        
        //返回
        remoteCallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [remoteCallBtn addTarget:self action:@selector(remoteModleChangeAction:) forControlEvents:UIControlEventTouchUpInside];
        [remoteCallBtn setImage:[UIImage imageNamed:@"icon_hang-up"] forState:UIControlStateNormal];
//        [remoteCallBtn setImage:[UIImage imageNamed:@"icon_hang-up"] forState:UIControlStateSelected];
        remoteCallBtn.frame = CGRectMake(SX(3),STATE_HEIGHT, SX(55), SX(55));
        [self addSubview:remoteCallBtn];
        remoteCallBtn.hidden = YES;
        //单向视频通话按钮
        singleRemoteCallBtn = [[PDVideoAnimailBtn alloc] init];
        singleRemoteCallBtn.type = VideoBtnVoice;
        [singleRemoteCallBtn setNormailImage:[UIImage imageNamed:@"btn_video_call_n"]];
        singleRemoteCallBtn.frame = CGRectMake(SX(3),STATE_HEIGHT, SX(55), SX(55));
        [singleRemoteCallBtn addTarget:self action:@selector(singleRemoteCallBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        singleRemoteCallBtn.hidden = YES;
        if (!RBDataHandle.currentDevice.isPuddingPlus) {
            [self addSubview:singleRemoteCallBtn];
        }
        recoredVideoBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [recoredVideoBtn setBackgroundImage:[UIImage imageNamed:@"icon_video"] forState:UIControlStateNormal];
        [recoredVideoBtn setBackgroundImage:[UIImage imageNamed:@"icon_video_sel"] forState:UIControlStateSelected];
        [recoredVideoBtn addTarget:self action:@selector(recoredVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:recoredVideoBtn];
        
        voiceBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [voiceBtn setBackgroundImage:[UIImage imageNamed:@"icon_mute"] forState:UIControlStateNormal];
        [voiceBtn setBackgroundImage:[UIImage imageNamed:@"icon_mute_sel"] forState:UIControlStateSelected];
        [voiceBtn addTarget:self action:@selector(spakeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:voiceBtn];
        
        screenShotBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [screenShotBtn addTarget:self action:@selector(screenShotAction:) forControlEvents:UIControlEventTouchUpInside];
        [screenShotBtn setBackgroundImage:[UIImage imageNamed:@"icon_screenshots"] forState:UIControlStateNormal];
        [screenShotBtn setBackgroundImage:[UIImage imageNamed:@"icon_screenshots_sel"] forState:UIControlStateSelected];
        [self addSubview:screenShotBtn];
       
        setvolmeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [setvolmeBtn addTarget:self action:@selector(changeVoiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [setvolmeBtn setImage:[UIImage imageNamed:@"video_volume_on"] forState:UIControlStateNormal];
        [setvolmeBtn setImage:[UIImage imageNamed:@"video_volume_off"] forState:UIControlStateSelected];
        [self addSubview:setvolmeBtn];
        setvolmeBtn.frame = CGRectMake(self.width - SX(53), self.height - SX(48) - SX(6), SX(48), SX(48));

        setvolmeBtn.hidden = NO;
        //音乐按钮
        CGFloat nameHeight = SX(36);
        CGFloat nameY = photoBtn.center.y - nameHeight * 0.5 + SX(4);
        playingNameView = [[PDVideoPlayingName alloc] initWithFrame:CGRectMake(self.width - SX(68) - nameHeight,nameY , nameHeight, nameHeight)];
        playingNameView.backgroundColor = [UIColor clearColor];
        playingNameView.clickedBack = ^(NSInteger btnTag){
            @strongify(self);
            [self musicBtnClicked:btnTag];
        };
//        [self addSubview:playingNameView];
        playingNameView.hidden = YES;

        recoredVideoBtn.hidden = YES;
        voiceBtn.hidden = YES;
        screenShotBtn.hidden = YES;

        
        UIImageView *controlView = [UIImageView new];
        controlView.userInteractionEnabled = YES;
        controlView.image = [UIImage imageNamed:@"remotecontrol"];
        self.controlView = controlView;
        controlView.frame = CGRectMake(SC_HEIGHT-85-35, SC_WIDTH-85-15, 85, 85);
        controlView.hidden = YES;
        RBDragView *dragView = [[RBDragView alloc] initWithFrame:CGRectMake((controlView.image.size.width-25)/2, (controlView.image.size.height-25)/2 , 25, 25)];
        dragView.backgroundColor = [UIColor whiteColor];
        dragView.dragDirection = RBDragViewDirectionHorizontal;
        dragView.isBounds = YES;
        dragView.layer.cornerRadius = 25/2.0f;
        dragView.layer.masksToBounds = YES;
        [controlView addSubview:dragView];
        self.dragView = dragView;
        if (RBDataHandle.currentDevice.isPuddingPlus) {
            [self addSubview:controlView];
        }
        
        
        __weak typeof(playingNameView) weakNameView = playingNameView;
        
        [self initVideoConfig];

        [self rb_playStatus:^(RBPuddingPlayStatus status) {
            if(status == RBPlayLoading ){
                [MitLoadingView showWithStatus:NSLocalizedString( @"is_loading", nil)];
                return ;
            }else if(status != RBPlayReady){
                [MitLoadingView dismiss];
                if (status == RBPlayPlaying) {
                    weakNameView.isPlaying = YES;
                }else{
                    weakNameView.isPlaying = NO;
                }
            }else{
                [MitLoadingView dismiss];
            }
            [weakNameView setModel:RBDataHandle.currentDevice.playinfo];
        }];
        
        [self.topViewController setAlterBg:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiDelAllPhoto) name:@"notiDelAllPhoto" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiDisConnectVideo) name:@"disConnectVideo" object:nil];

    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    if (videoIsFull){
        remoteViewFrame = CGRectMake(0, 0, frame.size.height, frame.size.width);
    } else{
        float videoHeight = frame.size.width * VIDEO_RATIO;
        remoteViewFrame = CGRectMake(0, frame.size.height - videoHeight, frame.size.width, videoHeight);
    }
    if (self.remoteView){
        [self.remoteView setFrame:remoteViewFrame];
    }
}

#pragma mark - make view


- (PDSelectMtuView *)selectMtuView{
    if(!_selectMtuView){
        PDSelectMtuView * view = [[PDSelectMtuView alloc] initWithFrame:CGRectMake(SC_HEIGHT - SX(168), 0, SX(168), self.width)];
        [self addSubview:view];
        @weakify(self)
        

        [view setMtuValueChange:^(NSString * value){
            @strongify(self)
            [self.setMtuBtn setTitle:[PDSelectMtuView getMtuValue] forState:UIControlStateNormal] ;
            [VIDEO_CLIENT setVideoMTU:[value intValue]];
            self.setMtuBtn.hidden =NO;
        }];
        [self.setMtuBtn setTitle:[PDSelectMtuView getMtuValue] forState:UIControlStateNormal] ;

        _selectMtuView = view;
    }
    return _selectMtuView;
}




- (UIButton *)setMtuBtn{
    if (!_setMtuBtn) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [btn setBackgroundImage:[UIImage imageWithColor:mRGBAToColor(0x000000, 0.6)] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showSetMutView:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageWithColor:mRGBAToColor(0x000000, 0.7)] forState:UIControlStateHighlighted];
        btn.layer.cornerRadius = SX(30/2.0);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setClipsToBounds:YES];
        btn.titleLabel.font = [UIFont systemFontOfSize:SX(13)];
        [btn setTitle:[PDSelectMtuView getMtuValue] forState:UIControlStateNormal] ;
//        [self addSubview:btn];
        btn.hidden = YES;

        btn.frame = CGRectMake(SC_HEIGHT - SX(55) -SX(35), SX(30), SX(55), SX(30));
        _setMtuBtn = btn;
    }
    return _setMtuBtn;
}


#pragma mark - video

- (void)disConnectVideo{
    [self unInitConfit];
    [self.loadingView disConnectedState];
    [VIDEO_CLIENT hangup];
    VIDEO_CLIENT.localView.hidden =YES;
}

- (void)connectVideo:(void(^)())block{
    [self disConnectVideo];

    [self initVideoConfig];
    [_loadingView connectState];
    RBDeviceModel * modle = [RBDataHandle fecthDeviceDetail:_callId];
    @weakify(self);
    [RBNetworkHandle getVideoId:modle.mcid WithBlock:^(id res) {
        @strongify(self);
        if ([res isKindOfClass:[NSDictionary class]]&&[[res objectForKey:@"result"] integerValue]==0) {
            NSDictionary *data = res[@"data"];
            NSString *videoId = data[@"videoId"];
            //            NSString *videoToken = data[@"videoToken"];
            //            NSString *expireTime = data[@"expireTime"];
            [VIDEO_CLIENT createVideoView:self];
            [VIDEO_CLIENT setupClientId:videoId auth:RBDataHandle.loginData.userid password: [self createPassword]];
        }
        else{
            [VIDEO_CLIENT call:_callId OldVideoEnable:![modle isPuddingPlus]];
        }
        if(self.isRomoteType){
            [VIDEO_CLIENT setLocalAudioEnable:YES ResultBlock:nil];
            VIDEO_CLIENT.localVideoEnable = YES;
        }else{
            [VIDEO_CLIENT setLocalAudioEnable:NO ResultBlock:nil];
            VIDEO_CLIENT.localVideoEnable = NO;
        }
        block();
    }];

}
- (NSString*)createPassword{
    NSString *str = @"qwertyuiopasdfghjklzxcvbnm1234567890";
    NSMutableString *finalStr = [NSMutableString string];
    for (int i=0; i<16; i++) {
        int value = arc4random()%36;
        NSString *temp = [str substringWithRange:NSMakeRange(value, 1)];
        [finalStr appendString:temp];
    }
    NSString *md5Str = [[finalStr md5String] substringFromIndex:16];
    [finalStr appendString:md5Str];
    return finalStr;
}

- (void)fullScreenBtnAction:(UIButton *)sender{
    if(!VIDEO_CLIENT.connected){
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_connect_video", nil)];
        return;
    }
    if(videoIsFull){
        [fullScreenBtn setImage:[UIImage imageNamed:@"btn_video_full_n"] forState:UIControlStateNormal];
        [fullScreenBtn setImage:[UIImage imageNamed:@"btn_video_full_p"] forState:UIControlStateHighlighted];
        [self exitFullSceen];
    }else{
        [fullScreenBtn setImage:[UIImage imageNamed:@"btn_video_resize_n"] forState:UIControlStateNormal];
        [fullScreenBtn setImage:[UIImage imageNamed:@"btn_video_resize_p"] forState:UIControlStateHighlighted];
        [self fullScreen];
    }
}

- (void)enterRemoteType{
    _isRomoteType = YES;
    [VIDEO_CLIENT setLocalAudioEnable:YES ResultBlock:nil];
    VIDEO_CLIENT.localVideoEnable = YES;
    if([VIDEO_CLIENT connected]){
        VIDEO_CLIENT.localView.hidden = NO;
    }
    [self fullScreen];

}

- (void)fullScreen{
    if(videoIsFull)
        return;
    videoIsFull = YES;
    navBar.hidden = YES;
    
    [self.topViewController setAlterBg:self];

    if(_VideoRotateBlock){
        _VideoRotateBlock(YES);
    }
    voiceBtn.selected = !VIDEO_CLIENT.remoteAudioEnable;
    voiceBtn.hidden = NO;
    screenShotBtn.hidden = NO;
    playingNameView.hidden = YES;
    self.dragView.hidden = NO;
    self.controlView.hidden = NO;
    [singleRemoteCallBtn setSelected:VIDEO_CLIENT.localAudioEnable];
    @weakify(self)
    [UIView animateWithDuration:.3 animations:^{
        [VIDEO_CLIENT setFullScreen];
        @strongify(self)
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, [self getTanfromAngle]);
        self.frame = CGRectMake(0, 0, SC_WIDTH, SC_HEIGHT);
        self.center = [[UIApplication sharedApplication] keyWindow].center;
        self.loadingView.center = CGPointMake(self.center.y, self.center.x);

        remoteCallBtn.frame = CGRectMake(self.height/2 - SX(55/2),self.width - SX(55)- SX(28), SX(55), SX(55));
        singleRemoteCallBtn.frame = CGRectMake(self.height/2 - SX(55/2),self.width - SX(55)- SX(28), SX(55), SX(55));

        if(self.isRomoteType){
            fullScreenBtn.hidden = YES;
            remoteCallBtn.hidden = NO;
            backButton.hidden = YES;
            singleRemoteCallBtn.hidden = YES;
        }else{
            fullScreenBtn.hidden = NO;
            remoteCallBtn.hidden = YES;
            backButton.hidden = NO;
            singleRemoteCallBtn.hidden = NO;
        }
        backButton.frame = CGRectMake(STATE_HEIGHT, SX(3 + 20), SX(50), SX(50));
        if IS_IPHONE_X{
            [backButton setImage:[[UIImage imageNamed:@"icon_back"] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        }


        fullScreenBtn.frame = CGRectMake(self.height - 30 - (STATE_HEIGHT),SX(3 + 20), 50, 50);
        recoredVideoBtn.frame = CGRectMake(self.height/2 - SX(71/2), 15, 71, 71);
        voiceBtn.frame = CGRectMake(self.height/2 - SX(71/2) - 71 - 30, 15, 71, 71);
        screenShotBtn.frame = CGRectMake(self.height/2 + SX(71/2) + 30, 15, 71, 71);
        recordTime.center = CGPointMake(SC_HEIGHT/2, recoredVideoBtn.center.y + 35);
        if(self.isRomoteType){
            photoBtn.frame = CGRectMake(STATE_HEIGHT,  self.width - SX(71)- 85, SX(40), SX(40));
        }else{
            photoBtn.frame = CGRectMake(STATE_HEIGHT,  self.width - SX(71), SX(40), SX(40));
        }
        [[UIApplication sharedApplication] setStatusBarHidden:YES  withAnimation:UIStatusBarAnimationFade];
        recoredVideoBtn.hidden = NO;
        voiceBtn.hidden = NO;
        screenShotBtn.hidden = NO;
        photoBtn.hidden = NO;
        setvolmeBtn.hidden = YES;
        _controlView.hidden = NO;
    } completion:^(BOOL finished) {
        @strongify(self)
        if(self.isRomoteType){
            self.setMtuBtn.hidden = NO;
        }
    }];
}


- (void)exitFullSceen{
    if(!videoIsFull)
        return;
    [self.topViewController setAlterBg:nil];
    videoIsFull = NO;
    navBar.hidden = NO;

    voiceBtn.selected = !VIDEO_CLIENT.remoteAudioEnable;

    [UIView animateWithDuration:.3 animations:^{
        [VIDEO_CLIENT exitFullScreen];
        self.transform = CGAffineTransformIdentity;
        self.frame = defalutFrame;
        self.loadingView.center = CGRectGetCenter(remoteViewFrame);
        fullScreenBtn.hidden = NO;
        recordTime.center = CGPointMake(SC_WIDTH/2, fullScreenBtn.center.y);

        [[UIApplication sharedApplication] setStatusBarHidden:NO  withAnimation:UIStatusBarAnimationFade];
        remoteCallBtn.hidden = YES;
        singleRemoteCallBtn.hidden = YES;
        recoredVideoBtn.hidden = YES;
        voiceBtn.hidden = YES;
        fullScreenBtn.frame = CGRectMake(self.width - SX(53),(IS_IPHONE_X ? NAV_HEIGHT : SX(3 + 20)), SX(50), SX(50));

        backButton.frame = CGRectMake(SX(3), STATE_HEIGHT, SX(50), SX(50));
        if (IS_IPHONE_X)
            [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];

        screenShotBtn.hidden = YES;
        setvolmeBtn.frame = CGRectMake(self.width - SX(53), self.height - SX(48) - SX(6), SX(48), SX(48));
        photoBtn.hidden = NO;
        setvolmeBtn.hidden = NO;
        
        photoBtn.frame = CGRectMake(6, self.height - SX(48) - SX(6), SX(43), SX(48));

        CGRect playNameFrame = CGRectMake(self.width - SX(68) - SX(36), photoBtn.center.y - SX(36) * 0.5, SX(36), SX(36));
        if (playingNameView.isViewExtension) {
            playNameFrame = CGRectMake(SX(68), photoBtn.center.y - SX(36) * 0.5, self.width - SX(68) * 2, SX(36));
        }
        playingNameView.frame = playNameFrame;
        _controlView.hidden = YES;
    } completion:^(BOOL finished) {
        
        if(_VideoRotateBlock){
            _VideoRotateBlock(NO);
        }
    }];
}

#pragma mark - config
- (void)unInitConfit{
    [VIDEO_CLIENT setRemoteVideoViewChange:nil];
    [VIDEO_CLIENT setConnectProgressBlock:nil];
    
    [VIDEO_CLIENT setCallError:nil];
    [VIDEO_CLIENT setEnterCallModleBlock:nil];
    
    [VIDEO_CLIENT setEnterRemoteModleBlock:nil];
    
    [VIDEO_CLIENT setCaptureImage:nil];
    [VIDEO_CLIENT setRecoredResut:nil];
    
    [VIDEO_CLIENT setRecoredState:nil];
    
    [self.remoteView removeFromSuperview];
}

- (void)initVideoConfig{
    [VIDEO_CLIENT setLocalViewFitModle:RBVideoAspectFill];
    [VIDEO_CLIENT setRemoteViewFitModle:RBVideoAspectFill];
    @weakify(self);
    [VIDEO_CLIENT setRemoteVideoViewChange:^(UIView * view, BOOL isAdd) {
        @strongify(self);
        if(isAdd){
            [self.remoteView removeFromSuperview];
            self.remoteView = view;
            view.frame = remoteViewFrame;
            [self insertSubview:view atIndex:0];
        }else{
            [view removeFromSuperview];
            self.remoteView = nil;
            
        }
    }];
    [VIDEO_CLIENT setConnectProgressBlock:^(BOOL isDone, float progress) {
        @strongify(self);
        [self.loadingView setMaxProgress:progress];
        if(isDone){
            NSString * isShow = [[NSUserDefaults standardUserDefaults]objectForKey:@"showVideoVoiceTip"];
            if(![isShow isEqualToString:@"YES"]){
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"showVideoVoiceTip"];
                [MitLoadingView showErrorWithStatus:NSLocalizedString( @"keep_phone_away_from_pudding_when_you_hear_sharp_echo", nil)];
            }
            [RBStat logEvent:PD_Video_Connect_Suc message:nil];
        }
        
        
        if(isDone && self.isRomoteType && videoIsFull){
            VIDEO_CLIENT.localView.hidden =NO;

        }else{
            VIDEO_CLIENT.localView.hidden =YES;
        }
    }];
    
    [VIDEO_CLIENT setCallError:^(NSString * error) {
        @strongify(self);
        [self disConnectVideo];
        [MitLoadingView showErrorWithStatus:error afterTime:0 isVertical:self.transform];
        [RBStat logEvent:PD_Video_Connect_Failed message:nil];
    }];

    [VIDEO_CLIENT setCaptureImage:^(UIImage * image) {
        @strongify(self);
        if(image){
            [self addShotImageAnimailView:image];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                [self saveImageToALAssetsLibrary:image];
            });
        }else{
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"screenshot_fail", nil) afterTime:0 isVertical:self.transform];
        }
    }];
    [VIDEO_CLIENT setRecoredResut:^(NSString * error) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [MitLoadingView showErrorWithStatus:error afterTime:0 isVertical:self.transform];
        });
    }];
    
    __weak typeof(recordTime) weaklat  = recordTime;
    __strong typeof(recoredVideoBtn) weakBtn  = recoredVideoBtn;
    [VIDEO_CLIENT setRecoredState:^(BOOL state) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.VideoIsRecoed){
                self.VideoIsRecoed(state);
            }
            [weaklat setIsRecoreding:state];
            weakBtn.selected = state;
        });
    }];
    
    VIDEO_CLIENT.localView.backgroundColor = [UIColor blackColor];
    VIDEO_CLIENT.localView.frame = CGRectMake(SX(20), self.width - SX(71)- 20, SX(105), SX(71));
    VIDEO_CLIENT.localView.layer.cornerRadius = 5;
    [VIDEO_CLIENT.localView setClipsToBounds:YES];
    [self addSubview:VIDEO_CLIENT.localView];
    
    VIDEO_CLIENT.localView.hidden =YES;
}

- (void)saveImageToALAssetsLibrary:(UIImage *)image{
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    for (PHAssetCollection *collection in albums) {
        if ([collection.localizedTitle isEqualToString:R.pudding]) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //请求创建一个Asset
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset ];
                //相册中添加照片
                [collectonRequest addAssets:@[placeHolder]];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(success){
                        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"screenshot_save_success", nil) isVertical:self.transform];
                    } else {
                        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"screenshot_save_fail", nil) isVertical:self.transform];
                    }
                });
            }];

        }
    }
}

#pragma mark - 动画
- (void)addShotImageAnimailView:(UIImage *)image{
    [self loadPhotoImage:image];
    
    [ZYPlayVideo playTap:@"shot.mp3"];
    
    UIView * view1 = [self viewWithTag:[@"an" hash]];
    if(view1){
        [view1 removeFromSuperview];
        view1 = nil;
    }
    CGRect frame = CGRectZero;
    if (videoIsFull) {
        frame = remoteViewFrame;
    }
    else{
        frame = self.frame;
    }
    UIView * view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = mRGBAToColor(0x000000, .6);
    view.tag = [@"an" hash];
    [self addSubview:view];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 1.5;
    imageView.image = image;
    
    [view addSubview:imageView];
    
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, .5, .5);
    }completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if([view superview])
                [[view superview] bringSubviewToFront:view];
            [UIView animateWithDuration:.3 animations:^{
                
                CGRect rect = [photoBtn convertRect:photoBtn.bounds toView:self];
                imageView.frame = CGRectInset(rect, SX(15), SX(15));
                
                
            }completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        });
        
        
    }];
}



#pragma mark - set get
- (void)loadPhotoImage:(UIImage *)image{
    if (image) {
        photoBtn.image = image;
    }
//    if(!self.isRomoteType)
//        photoBtn.image = image;
//    else
//        [photoBtn setImage:[UIImage imageNamed:@"icon_photos"] ShouldBorder:NO] ;
}



- (void)isShowNameView {
    if(VIDEO_CLIENT.connected){
        if(setvolmeBtn.hidden == YES){
            playingNameView.hidden = YES;
        }else{
            RBDeviceModel * modle = [RBDataHandle fecthDeviceDetail:self.playDeviceId];

            PDSourcePlayModle * playModle = modle.playinfo;
            BOOL notHidden = ([playModle.type isEqualToString:@"app"] && ([playModle.status isEqualToString:@"start"] || [playModle.status isEqualToString:@"pause"] || [playModle.status isEqualToString:@"readying"]) && !modle.isPuddingPlus) ;
            playingNameView.hidden = !notHidden;
            [playingNameView setModel:playModle];
        }
    }else{
        playingNameView.hidden = YES;
    }
}

#pragma mark - button action

- (void)showSetMutView:(UIButton *)sender{
    _setMtuBtn.hidden = YES;
    [self.selectMtuView showSelectView];
}

- (void)remoteModleChangeAction:(UIButton * )sender{
    [VIDEO_CLIENT hangup];
    if(_VideoBackBlock){
        _VideoBackBlock();
    }
}

- (void)spakeButtonAction:(UIButton *)sender{
    if(!VIDEO_CLIENT.connected){
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_connect_video", nil) afterTime:0 isVertical:self.transform];
        return;
    }
    sender.selected = !sender.selected;
    [VIDEO_CLIENT setRemoteAudioEnable:!sender.selected];
}

- (void)recoredVideoButtonAction:(UIButton *)sender{
    if(!VIDEO_CLIENT.connected){
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_connect_video", nil) afterTime:0 isVertical:self.transform];
        return;
    }
    if(VIDEO_CLIENT.isRecoreding){
        [VIDEO_CLIENT stopRecord];
    }else{
        [VIDEO_CLIENT recordVideo];
    }
}

- (void)screenShotAction:(UIButton *)sender{
    if(!VIDEO_CLIENT.connected){
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_connect_video", nil) afterTime:0 isVertical:self.transform];
        return;
    }
    [VIDEO_CLIENT captureImage];
    
}

- (void)backButtonAction:(id)sender{
    // 返回按钮只做单纯的退出功能
//    if(videoIsFull)
//        [self fullScreenBtnAction:nil];
//    else{
        [VIDEO_CLIENT hangup];
        if(_VideoBackBlock){
            _VideoBackBlock();
        }
//    }
}

- (void)connectAction:(id)sender{
    
    if(self.ShouldConnectVideo){
        self.ShouldConnectVideo();
    }
}

/**
 *  @author 智奎宇, 16-03-17 17:03:09
 *
 *  设置布丁声音的按钮
 *
 */
- (void)changeVoiceButtonAction:(UIButton *)sender{
    if(!VIDEO_CLIENT.connected){
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_connect_video", nil) afterTime:0 isVertical:self.transform];
        return;
    }
    sender.selected = !sender.selected;
    [VIDEO_CLIENT setRemoteAudioEnable:!sender.selected];
    self.isMute = !_isMute;
    
    
}

- (void)photoBtnAction:(id)sender{
    
    if(_photoButtonAction){
        _photoButtonAction();
    }
    
}
- (void)musicBtnClicked:(NSInteger)tag{
    if (!VIDEO_CLIENT.connected) {
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_connect_video", nil) afterTime:0 isVertical:self.transform];
        return;
    }
    switch (tag) {
        case 10:
            [self.topViewController rb_next:^(NSString *error) {
                [MitLoadingView showWithStatus:error ];
            }];
            break;
        case 11:{
            // 暂停/播放
            
            __weak typeof(playingNameView) weakNameView = playingNameView;
            
            if(self.playingState == RBPlayReady){
                [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_then_ready_to_play", nil)];
                return;
            }else if(self.playingState == RBPlayPlaying){
                playingNameView.isPlaying = NO;
                [[self topViewController] rb_stop:^(NSString *error) {
                    [MitLoadingView showWithStatus:error];
                    if(!error){
                        weakNameView.isPlaying = NO;
                    }
                }];
            
            }else if(self.playingState == RBPlayNone ||self.playingState == RBPlayPause){
                [self.topViewController rb_play:nil IsVideo:YES Error:^(NSString *error) {
                    if(error){
                        [MitLoadingView showWithStatus:error];
                    }
                }];
            }}
            break;
        case 13:
            // 点击歌曲名
            if(self.ShowPlayTTS){
                self.ShowPlayTTS();
            }
            break;
        default:
            break;
    }
}
- (void)singleRemoteCallBtnAction:(PDVideoAnimailBtn*)btn{
    if (btn.selected) {
        [VIDEO_CLIENT setLocalAudioEnable:NO ResultBlock:^(Boolean flag) {
            
        }];
        btn.selected = NO;
    }
    else{
        [VIDEO_CLIENT setLocalAudioEnable:YES ResultBlock:^(Boolean flag) {
            
        }];
        btn.selected = YES;
    }
}
- (float)getTanfromAngle{
    float angle = 0;
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    if(orient == UIDeviceOrientationLandscapeLeft){
        angle = M_PI/2;
    }else if(orient == UIDeviceOrientationLandscapeRight){
        angle = M_PI/2 + M_PI;
    }else{
        angle = M_PI/2 ;
    }
    return angle;
    
}
UIDeviceOrientation current = UIDeviceOrientationLandscapeRight;

#pragma mark - 设置旋转
- (void)orientChange:(NSNotification *)noti
{
    if(!videoIsFull)
        return;
    
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    @weakify(self)
    if(UIDeviceOrientationIsLandscape(orient) && current != orient){
        [UIView animateWithDuration:.5 animations:^{
            @strongify(self)
            self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, [self getTanfromAngle]);
        }];
        current = orient;
    }
    
}
- (void)notiDelAllPhoto{
    [photoBtn setImage:[UIImage imageNamed:@"icon_photos"] ShouldBorder:NO] ;
}
- (void)notiDisConnectVideo{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self disConnectVideo];
    });
}

#pragma mark - touch
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if([self.selectMtuView isShow]){
        [self.selectMtuView hiddenSelectView];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    UITouch *touch = [touches anyObject];
    
    if(touch.tapCount == 1)
    {
        [UIView animateWithDuration:.2 animations:^{
            if(videoIsFull){
                Boolean hidden = !photoBtn.hidden;
                _setMtuBtn.hidden = !_isRomoteType ? YES : hidden;

                
                backButton.hidden = _isRomoteType ? YES : hidden;
                voiceBtn.hidden = hidden;
                fullScreenBtn.hidden = _isRomoteType ? YES : hidden;
                recoredVideoBtn.hidden = hidden;
                screenShotBtn.hidden = hidden;
                voiceBtn.hidden = hidden;
                photoBtn.hidden = hidden;
                self.dragView.hidden = hidden;
                self.controlView.hidden = hidden;
                remoteCallBtn.hidden = _isRomoteType ? hidden : YES;
                singleRemoteCallBtn.hidden = _isRomoteType ? YES : hidden;
                playingNameView.hidden = YES;
                setvolmeBtn.hidden = YES;
            }else{
                Boolean hidden = fullScreenBtn.hidden;
                if(hidden){
                    backButton.hidden = IS_IPHONE_X ? NO : !hidden;
                    voiceBtn.hidden = !hidden;
                    setvolmeBtn.hidden = !hidden;
                    fullScreenBtn.hidden = !hidden;
                    photoBtn.hidden = !hidden;
                    
                    [self isShowNameView];
                }else{
                    if(!playingNameView.hidden && VIDEO_CLIENT.connected){
                        playingNameView.hidden = YES;
                    }else{
                        fullScreenBtn.hidden = !hidden;
                        backButton.hidden = IS_IPHONE_X ? NO : !hidden;
                        setvolmeBtn.hidden = !hidden;
                        fullScreenBtn.hidden = !hidden;
                        photoBtn.hidden = !hidden;
                        
                    }
                }
                recoredVideoBtn.hidden = YES;
                screenShotBtn.hidden = YES;
                voiceBtn.hidden = YES;

            }
        }];
    }
}

- (BOOL)isInRect:(CGPoint)p rect:(CGRect)rect
{
    CGFloat rectX = rect.origin.x;
    CGFloat rectY = rect.origin.y;
    CGFloat rectWidth = rect.size.width;
    CGFloat rectHeight = rect.size.height;
    
    CGFloat pX = p.x;
    CGFloat pY = p.y;
    
    if(pX < rectX
       ||(pX > rectX + rectWidth)
       || pY < rectY
       || pY > rectY + rectHeight)
    {
        return FALSE;
    }
    
    return TRUE;
}

- (void)freeHandle{
    [self unInitConfit];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notiDelAllPhoto" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"disConnectVideo" object:nil];
    [VIDEO_CLIENT freeTutkVideoClient];
}

- (void)dealloc{
   
}

@end
