//
//  RBVideoViewController.m
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/11/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBVideoViewController.h"
#import "PDVideoRotateBar.h"
#import "PDVideoFeatureView.h"
#import "RBVideoClientHelper.h"
#import "RBInputView.h"
#import "RBInputHabitsView.h"
#import "RBInputExpressionView.h"
#import "RBInputFunnyKeysView.h"
#import "RBInputVoiceChangeView.h"
#import "PDTTSPlayView.h"
#import "RBInputHeaderView.h"
#import "PDLocalPhotosController.h"
#import "UIDevice+RBAdd.h"
#import "UIViewController+PDUserAccessAuthority.h"
#import "RBInputMultimediaExpressView.h"
#import "PDImageManager.h"

@interface RBVideoViewController (){
    PDVideoView * videoView;
    PDVideoFeatureView * featureList;
    RBInputView * TTSView;
    BOOL playedLocalVideo;
}

@property(nonatomic,assign) BOOL isFinishRotate;


@end

@implementation RBVideoViewController
@synthesize callId = _callId;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO] ;
    [UIApplication sharedApplication].idleTimerDisabled=YES;//自动锁屏
    if (playedLocalVideo) {
        [videoView exitFullSceen];
        videoView.isRomoteType = NO;
        [videoView connectVideo:^{
            
        }];
        playedLocalVideo = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES] ;
    [UIApplication sharedApplication].idleTimerDisabled=NO;//自动锁屏

    if(![self.navigationController.viewControllers containsObject:self]){
        [videoView freeHandle];
    }else{
        NSLog(@"");
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [RBStat logEvent:PD_Home_Video message:nil];
    
    self.isFinishRotate = YES;
    [[PDImageManager manager] createNewAlbum:R.pudding completion:^(BOOL success, PHAssetCollection *collection) {
        
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localVideoPlayed) name:@"localVideoPlayed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiDisConnectVideo) name:@"disConnectVideo" object:nil];

    videoView = [[PDVideoView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width * .75 + ((IS_IPHONE_X==YES)?NAV_HEIGHT: 0))];
   
    videoView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:videoView];
    @weakify(self)
    videoView.dragView.endDragBlock = ^(RBDragView *dragView,CGPoint point){
        @strongify(self)
       // NSLog(@"%@",NSStringFromCGPoint(point));
        [self videoRotateValueChange:point.x*3 RotateDone:NO landscape:YES actionDetail:nil];
    };
    videoView.dragView.boundsDragBlock = ^(RBDragView *dragView,CGPoint point){
        @strongify(self)
        if (point.x>0) {
             [self videoRotateValueChange:point.x*3/2 RotateDone:NO landscape:YES actionDetail:@"right"];
        }else{
            [self videoRotateValueChange:point.x*3/2 RotateDone:NO landscape:YES actionDetail:@"left"];
        }
    };

    videoView.dragView.endLongDragBlock = ^(RBDragView *dragView,CGPoint point){
        @strongify(self)
        [self videoRotateValueChange:0 RotateDone:NO landscape:YES actionDetail:@"stop"];
    };
    
    __block PDVideoRotateBar * scView = [[PDVideoRotateBar alloc] initWithFrame:CGRectMake(0, videoView.height , videoView.width, 50)];
    if (!RBDataHandle.currentDevice.isStorybox) {
        [self.view addSubview:scView];
        [self addRoteAnima:scView];
    }
    
    RBDeviceModel * modle = [RBDataHandle fecthDeviceWithMcid:self.callId];
    featureList.isPlus = [modle isPuddingPlus];
    //创建功能列表视图
    if([[UIDevice currentDevice]isMoreThanIphone4]){
        featureList = [[PDVideoFeatureView alloc] initWithFrame:CGRectMake(0, self.view.bottom - 120 - 160 - SC_FOODER_BOTTON, self.view.width, 120) IsPlus:[modle isPuddingPlus]];
    }else{
        featureList = [[PDVideoFeatureView alloc] initWithFrame:CGRectMake(0, self.view.bottom - 120 - 80, self.view.width, 120) IsPlus:[modle isPuddingPlus]];
    }

    featureList.backgroundColor = [UIColor clearColor];
    
    __weak typeof(videoView) weakVideo = videoView;
    [featureList setMenuClickBlock:^(UIControl * control, VideoButtonType type){
        if(!VIDEO_CLIENT.connected){
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_connect_video", nil)];
            return;
        }
        if(type == VideoButtonTypeRemoteVideo){
            [weakVideo enterRemoteType];
            [RBStat logEvent:PD_VIDEO_TALK message:nil];
        }
    }];
    [self.view addSubview:featureList];

    __weak PDVideoFeatureView * feture = featureList;
    [videoView setVideoRotateBlock:^(BOOL full) {
        scView.hidden = full;
        feture.hidden = full;
        [feture reloadData];

    }];
    [videoView setVideoBackBlock:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [videoView setPhotoButtonAction:^{
        @strongify(self);
        [self openPhotoVideoAlbum];
    }];
  
    [videoView setShouldConnectVideo:^{
       @strongify(self)
        self.callId = self.callId;
    }];
    
    __weak typeof(featureList) weakFet = featureList;
    [videoView setVideoIsRecoed:^(BOOL record){
        weakFet.recoreding = record;
        
    }];
    
    TTSView = [RBInputView initInput];
    [TTSView setViewType:RBInputVideo];

    if(![RBDataHandle.currentDevice isPuddingPlus]){
        [TTSView registContentItem:@"btn_habit_n" SelectIcon:@"btn_habit_p" Class:[RBInputHabitsView class] ShouldShowNew:false];
        [TTSView registContentItem:@"btn_emoji_n" SelectIcon:@"btn_emoji_p" Class:[RBInputExpressionView class] ShouldShowNew:false];
        [TTSView registContentItem:@"btn_funny_n" SelectIcon:@"btn_funny_p" Class:[RBInputFunnyKeysView class] ShouldShowNew:false];
        [TTSView registContentItem:@"btn_play_n1" SelectIcon:@"btn_play_p1" Class:[PDTTSPlayView class] ShouldShowNew:false];
        [TTSView registContentItem:@"tts_history_n" SelectIcon:@"tts_history" Class:[RBInputHistoryView class] ShouldShowNew:false];
        [TTSView registSpeakView:[RBInputVoiceChangeView class]];
    }else{
        //[TTSView registContentItem:@"btn_habit_n" SelectIcon:@"btn_habit_p" Class:[RBInputHabitsView class] ShouldShowNew:false];
        [TTSView registContentItem:@"btn_funny_n" SelectIcon:@"btn_funny_p" Class:[RBInputMultimediaExpressView class] ShouldShowNew:true];
     //   [TTSView registContentItem:@"btn_play_n1" SelectIcon:@"btn_play_p1" Class:[PDTTSPlayView class] ShouldShowNew:false];
        [TTSView registContentItem:@"tts_history_n" SelectIcon:@"tts_history" Class:[RBInputHistoryView class] ShouldShowNew:false];

    }
    
    [TTSView setSendEnableBlock:^{
       if(  VIDEO_CLIENT.connected)
           return YES;
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_connect_video", nil)];
        return NO;
        
    }];

    [TTSView setSendTextBlock:^(NSString * txt,NSString * error) {
        if(error){
            [MitLoadingView showSuceedWithStatus:error];
        }else{
            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"send_success_", nil)];
        }
    }];
    
    [TTSView setSendPlayVoiceBlock:^(NSString * str,NSString * error) {
        if(error){
            [MitLoadingView showSuceedWithStatus:error];
        }else{
            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"send_success_", nil)];
        }
    }];
    
    [TTSView setInputVoiceError:^(RBVoiceError error) {
        NSLog(@"");
        @strongify(self)
        [self showTipString:error];
    }];
    [TTSView setSendExpressionBlock:^(int index, NSString * error) {
        if(error){
            [MitLoadingView showSuceedWithStatus:error];
        }else{
            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"send_success_", nil)];
        }
        
    }];
    
    [TTSView setSendMultipleExpressionBlock:^(NSString * error) {
        if(error){
            [MitLoadingView showSuceedWithStatus:error];
        }else{
            [MitLoadingView showSuceedWithStatus:NSLocalizedString( @"send_success_", nil)];
        }
    }];
    
    
    [self.view insertSubview:TTSView belowSubview:videoView];

    
    
    __weak typeof(TTSView) weakInput = TTSView;
    [TTSView setInputShowContent:^(BOOL isShowContent) {
       @strongify(self)
        if(isShowContent){
            [self.view bringSubviewToFront:weakInput];
        }else{
            [self.view sendSubviewToBack:weakInput];
        }
        
    }];
    
    [self setCallId:_callId];//加载callid ，

    
    [videoView setShowPlayTTS:^{
        [weakInput selectItemAtIndex:3];
    }];

    if (RBDataHandle.currentDevice.isStorybox) {
        TTSView.hidden = YES;
    }
}


- (void)addRoteAnima:(PDVideoRotateBar *)rotateBar{
    //创建滑动块上方提示背景视图
    __block UIImageView * view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tips_fov"]];
    [self.view addSubview:view];
    
    
    __weak PDVideoRotateBar * weakBar = rotateBar;
    //监听滑块的中心点 滑动
    [RACObserve(rotateBar,thumbCenterX) subscribeNext:^(id x) {
        CGFloat centerX = [x doubleValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            view.center = CGPointMake(centerX, weakBar.top - view.height*0.5 - 5);
        });
    }];
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, SX(45))];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:SX(12)];
    lable.textColor = [UIColor whiteColor];
    [view addSubview:lable];
    
    view.alpha = .0;
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, .1, .1);
    __block BOOL isShow = NO;
    //设置旋转角度变化
    @weakify(self)
    [rotateBar setVideoRotate:^(float angle,NSString * actionDetail,BOOL isRotateDone) {
        @strongify(self);
        if ([actionDetail isEqualToString:@"left"]||[actionDetail isEqualToString:@"right"]||[actionDetail isEqualToString:@"nothing"]) {
            view.hidden = YES;
        }else{
            view.hidden = NO;
        }
        //设置旋转的背景视图 显示 和 消失
        if (actionDetail.length > 0) {
            [UIView animateWithDuration:.2 animations:^{
                if(!isShow ){
                    LogWarm(@"没显示");
                    view.alpha = 1.0;
                    view.transform = CGAffineTransformIdentity;
                    isShow = YES;
                }else if(isShow ){
                    LogWarm(@"显示");
                    view.alpha = .0;
                    isShow = NO;
                }
            }];
        }else{
            [UIView animateWithDuration:.2 animations:^{
                if(!isShow && !isRotateDone){
                    view.alpha = 1.0;
                    view.transform = CGAffineTransformIdentity;
                    isShow = YES;
                }else if(isShow && isRotateDone){
                    view.alpha = .0;
                    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, .1, .1);
                    isShow = NO;
                }
            }];
        }
        //如果是 nothing 那么只是将文字去掉
        if ([actionDetail isEqualToString:@"nothing"]) {
            LogError(@"action 是 nothing");
            return;
        }else{
            view.hidden = NO;
            [self videoRotateValueChange:angle RotateDone:isRotateDone landscape:NO actionDetail:actionDetail];
        }
        //设置文字
        NSString * detailString = [NSString stringWithFormat:@"%@%.0f°",-angle > 0 ? NSLocalizedString( @"turn_left", nil) : NSLocalizedString( @"turn_right", nil) ,fabsf(angle)];
        NSMutableAttributedString *content =[[NSMutableAttributedString alloc]initWithString:detailString];
        [content addAttribute:NSForegroundColorAttributeName value:mRGBToColor(0x53caf5) range:NSMakeRange(3, detailString.length - 3)];
        lable.attributedText = content;
    }];
}

#pragma mark - showTip

- (void)showTipString:(RBVoiceError ) error{
    switch (error.errorType) {
        case RBVoiceRestricted: {
            [self openSettingPermission];
            break;
        }
        case RBVoiceDenied: {
            [self openSettingPermission];
            break;
        }
        case RBVoiceLongTime:
        case RBVoiceSortTime: {
            [MitLoadingView showErrorWithStatus:[NSString stringWithUTF8String:error.errorString]];
            break;
        }
    }

}

#pragma mark - 是否支持远程监控



#pragma mark - Rotate

/**
 *  @author 智奎宇, 16-02-23 20:02:06
 *
 *  视频 旋转
 *
 *  @param angle  旋转角度
 *  @param isDone 旋转完成
 */
- (void)videoRotateValueChange:(CGFloat)angle RotateDone:(BOOL)isDone  landscape:(BOOL)landscape  actionDetail:(NSString *)actionDetail{
    if(!VIDEO_CLIENT.connected){
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"ps_wait_connect_video", nil)];
        return;
    }
    
    NSString *currId =self.callId;
    if (![currId isNotBlank]) {
        return;
    }
    RBDeviceModel *model  = [RBDataHandle fecthDeviceWithMcid:currId];
    NSInteger currAngle = 0;
    if ([model isPuddingPlus]&&landscape) {
         currAngle = (angle/360)*36;
    }else{
         currAngle = (angle/180)*36;// baxing 旋转角度服务器是不支持浮点值 需要转成整数 刷掉不是一直旋转且转化为0的角度
    }
   
    if (!actionDetail&&labs(currAngle)==0) {
        return;
    }
    if(!self.isFinishRotate)
        return;
    
    
    [RBStat logEvent:PD_Video_Turn message:nil];
    self.isFinishRotate = NO;
    @weakify(self)
    
    
    [RBNetworkHandle RotateDevice:model.mcid Angle:currAngle actionDetail:actionDetail WithBlock:^(id res) {

        @strongify(self)
        self.isFinishRotate = YES;
        LogError(@"%@",res);
    }];

}


#pragma mark - set get 

- (void)setCallId:(NSString *)callId{
    _callId = callId;
    if(videoView == nil)
        return;
    
    self.playDeviceId = callId;
    @weakify(self)

    __weak typeof(videoView) weakVideo = videoView;
    RBDeviceModel * modle = [RBDataHandle fecthDeviceWithMcid:callId];
    if([modle isPuddingPlus]){
        [RBDataHandle checkPuddingPlusSupperFamilyDysm:^(BOOL isSupper,NSString * error) {
            if(error){
                [MitLoadingView showErrorWithStatus:error];
                return ;
            }
            @strongify(self)
            if(isSupper){
                [RBDataHandle checkConflictPlusApp:@"videoCall" Block:^(BOOL iscon, NSString *tipString, NSArray *tipButItem, NSInteger continueIndex, BOOL canContinue) {
                    @strongify(self)
                    if(!iscon || _isFromMctl){ //没有应用冲突，布丁s直接返回 因为TUTK视频SDK主控直接返回冲突导致需要请求处理,而主控呼叫也需要额外判断,此处逻辑很繁琐
                        [self connectVideo:callId];
                    }else{
                        if(tipString){//是否需要弹窗
                            if([tipButItem mCount] > 0){//弹有提示按钮的弹窗
                                [[self topViewController] tipAlter:tipString ItemsArray:tipButItem :^(int index) {
                                    if(index == continueIndex){
                                        [self connectVideo:callId];
                                    }else{
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [self.navigationController popViewControllerAnimated:YES];
                                        });
                                    }
                                }];
                            }else{
                                [MitLoadingView showErrorWithStatus:tipString];
                                if(canContinue){
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [self.navigationController popViewControllerAnimated:YES];
                                    });
                                }else{
                                    [self disConnect];
                                }
                            }
                        }
                    }
                }];
            }else{
                [self tipAlter:NSLocalizedString( @"update_to_new_version_then_use_video_monitoring", nil) ItemsArray:@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"continue_call", nil)] :^(int index) {
                    if(index == 1){
                        self.defaultRemoteModle = NO;
                        [self connectVideo:callId];
                        
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
        }];
        
    }else{
        [weakVideo setCallId:callId];
        [weakVideo connectVideo:^{
            
        }];
    }
}

- (void)disConnect{
    [videoView disConnectVideo];

}

- (void)connectVideo:(NSString *)callId{
    [videoView setCallId:callId];
    [videoView connectVideo:^{
        if(![self defaultRemoteModle]){
            [videoView enterRemoteType];
        }
    }];

}



- (NSString *)callId{
    if(_callId == nil){
        self.callId = RB_Current_Mcid;
    }
    return _callId;
}


#pragma mark - open controller

- (void)openPhotoVideoAlbum{
    @weakify(self)
    [self isRejectPhotoAlbum:^(BOOL isReject) {
        @strongify(self)
        if(!isReject){
            PDLocalPhotosController *familVC = [PDLocalPhotosController new];
            [self.navigationController pushViewController:familVC animated:YES];
        }
    }];
    
}
- (void)localVideoPlayed{
    dispatch_async(dispatch_get_main_queue(), ^{
        playedLocalVideo = YES;
        featureList.recoreding = NO;
        featureList.spakeing = NO;
        VIDEO_CLIENT.isRecoreding = NO;
        [VIDEO_CLIENT freeTutkVideoClient];
        [videoView disConnectVideo];
    });
}
- (void)notiDisConnectVideo{
    dispatch_async(dispatch_get_main_queue(), ^{
        featureList.recoreding = NO;
        featureList.spakeing = NO;
    });
}
- (void)dealloc{

}

@end
