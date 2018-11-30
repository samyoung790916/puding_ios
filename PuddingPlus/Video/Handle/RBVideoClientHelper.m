//
//  RBVideoClientHelper.m
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/11/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBVideoClientHelper.h"
#import "UIViewController+RBVideoCall.h"
#import "RBUserDataHandle+Device.h"
#import "SandboxFile.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "RBVideoViewController.h"
#import "RBLiveVideoClient+Config.h"
#import "RBMessageHandle.h"
#import "NSObject+RBGetViewController.h"
#import "UIViewController+PDUserAccessAuthority.h"
#import <SSZipArchive.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <CallKit/CXCallObserver.h>
#define mNewRecoredVideoImage @"GetRecoredVideoImage"


@interface RBVideoClientHelper ()
{

    RBLiveVideoClient * newClient;
    
    BOOL                currentIsLiveClient;
    BOOL                oldVideoEnable;
    NSString          * clientId;
    NSString          * checkClientId;
    BOOL liveLocalAudioEnable;
    BOOL liveRemoteAudioEnable;
    BOOL liveRemoteVideoEnable;
    RBEAGLVideoView *_localVideoView;
    RBEAGLVideoView *_remoteVideoView;
    UIView *videoViewContainer;
    CGSize videoSize;
    CGSize videoViewContainerSize;
}
@property (nonatomic, strong)RBLiveClient* liveClient;
@property (nonatomic, strong)CTCallCenter *callCenter;
@end

@implementation RBVideoClientHelper


+ (RBVideoClientHelper *)getInstanse{
  
    static RBVideoClientHelper * helper;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [RBVideoClientHelper new];
        [helper addCallMonitor];
    });
    return helper;
}
- (void)addCallMonitor{
    self.callCenter = [[CTCallCenter alloc] init];
    @weakify(self);
    self.callCenter.callEventHandler=^(CTCall* call){
        @strongify(self);
        if (call.callState == CTCallStateDisconnected)
        {
            NSLog(@"-applicationWillResignActive----挂断");   //挂断
        }
        else if (call.callState == CTCallStateConnected)
            
        {
            NSLog(@"--applicationWillResignActive---连通了"); //联通了
        }
        else if(call.callState == CTCallStateIncoming)
        {
            NSLog(@"applicationWillResignActive Call is incoming");
            [self hangup];
            [self needReconnect];
        }
        else if (call.callState ==CTCallStateDialing)
        {
            NSLog(@"--applicationWillResignActive----拨号");  //拨号
        }
        else
        {
            NSLog(@"applicationWillResignActive Nothing is done?");
        }
    };
}
#pragma mark - 生命周期函数


- (void)freeVideoClient{
    LogError(@"freeVideoClient");
    newClient.delegate = nil;
    
    [newClient hangup];
    
    [newClient disConnect];

    [newClient free];
    
    newClient = nil;
    
    [self freeTutkVideoClient];
}
- (void)freeTutkVideoClient{
    if (_liveClient) {
        [_liveClient stop];
    }
    videoSize = CGSizeZero;
    if (_localVideoView) {
        [_localVideoView removeFromSuperview];
        _localVideoView = nil;
    }
    if (_remoteVideoView) {
        [_remoteVideoView removeFromSuperview];
        _remoteVideoView = nil;
    }
}
- (void)setUpVideoClient{
    if(newClient)
        return;
    
    self.environment = [RBNetworkHandle getDefaultEviroment];
    
    newClient = [RBLiveVideoClient getInstanse:@"appkey" AppID:@"appid" Client:@"pudding"];
    [RBLiveVideoClient userInfo:RB_Current_UserId Token:RB_Current_Token];
    newClient.backgroundTime = 10;
    newClient.delegate = self;
    LogError(@"newClient %@" ,newClient);
    if(checkClientId){
        [self checkMcCalling:checkClientId];
        checkClientId = nil;
    }

}
- (void)setupLiveClient{
    if (_liveClient) {
        return;
    }
    [RBLiveClient initGlobal];
    [RBLiveClient setLogLevel:LOG_DEBUG];
    [RBLiveClient setCameraDevice:0];

    _liveClient = [[RBLiveClient alloc] init];
    [_liveClient setObserver:self];
    
    [_liveClient setWorkMode:MODE_CLIENT];
    [_liveClient setVideoFormat:640 height:480 framerate:15];
    [_liveClient setVideoBitrate:500];
    [_liveClient setEnableAudioSend:NO];
    [_liveClient setEnableAudioPlay:YES];
    [_liveClient setEnableVideoSend:NO];
    [_liveClient setEnableVideoPlay:YES];
    [_liveClient SetEnableHwEncode:NO];
    [_liveClient SetEnableHwDecode:NO];
}
- (void)setupClientId:(NSString*)aClientId auth:(NSString*)account password:(NSString*)password{
    currentIsLiveClient= YES;
    [_liveClient setClientId:aClientId];
    [_liveClient setUserAuth:account password:password];

    [_liveClient start];
    [_liveClient setVideoRenderer:~(int)0 render:_remoteVideoView];
    self.connected = NO;
    liveRemoteAudioEnable = YES;

}
- (void)createVideoView:(UIView*)view{
    [self setupLiveClient];
    if (_localVideoView || _remoteVideoView) {
        return;
    }

    videoViewContainer = view;
    videoViewContainerSize = videoViewContainer.frame.size;
    CGRect localFrame = CGRectMake(SX(20), view.width - SX(71)- 20, SX(105), SX(71));
    _localVideoView = [[RBEAGLVideoView alloc] initWithFrame:localFrame];
    _localVideoView.delegate = self;
    CGRect remoteFrame = view.bounds;
    _remoteVideoView = [[RBEAGLVideoView alloc] initWithFrame:remoteFrame];
    _remoteVideoView.delegate = self;
    [view addSubview:_remoteVideoView];
    [view sendSubviewToBack:_remoteVideoView];
    [_liveClient setPreviewRenderer:_localVideoView];
    [videoViewContainer addSubview:_localVideoView];
    _localVideoView.hidden = YES;
}

#pragma mark - video controller

-(UIView *)localView{
    if(currentIsLiveClient){
        return _localVideoView;
    }
    return newClient.localView;
}


- (void)setLocalAudioEnable:(BOOL)localAudioEnable ResultBlock:(void(^)(Boolean flag)) result{

    [[self topViewController] isRejectRecordPermission:^(BOOL isReject) {
        if(result){
            result(!isReject);
        }
        if(isReject){
            return ;
        }
        [RBStat logEvent:PD_Video_Connect_Speak message:nil];
        if(currentIsLiveClient){
            liveLocalAudioEnable = localAudioEnable;
            [_liveClient setEnableAudioSend:localAudioEnable];
        }else{
            [newClient setLocalAudioEnable:localAudioEnable];
        }
    }];
}

- (BOOL)localAudioEnable{
    if(currentIsLiveClient)
        return liveLocalAudioEnable;
    return newClient.localAudioEnable;
}

- (void)setRemoteAudioEnable:(BOOL)remoteAudioEnable{
    if(currentIsLiveClient){
        liveRemoteAudioEnable = remoteAudioEnable;
        [_liveClient SetMute:!remoteAudioEnable];
    }else{
        [newClient setRemoteAudioEnable:remoteAudioEnable];
    }
}

- (BOOL)remoteAudioEnable{
    if(currentIsLiveClient)
        return liveRemoteAudioEnable;
    return newClient.remoteAudioEnable;
}

- (void)setLocalVideoEnable:(BOOL)localVideoEnable{
    if(!currentIsLiveClient){
        [[self topViewController] isRejectCamera:^(BOOL isReject) {
            if(isReject){
                return ;
            }
            [newClient setLocalVideoEnable:localVideoEnable];
        }];
        
    }
    else{
        [_liveClient setEnableVideoSend:localVideoEnable];
    }
}

- (BOOL)localVideoEnable{
    if(!currentIsLiveClient)
        return [newClient localVideoEnable];
    return NO;
}

- (void)setRemoteVideoEnable:(BOOL)remoteVideoEnable{
    if(!currentIsLiveClient){
        [newClient setRemoteVideoEnable:remoteVideoEnable];
    }
    else{
        liveRemoteVideoEnable = remoteVideoEnable;
        [_liveClient setEnableVideoPlay:remoteVideoEnable];
    }
}

- (BOOL)remoteVideoEnable{
    if(!currentIsLiveClient)
        return [newClient remoteVideoEnable];
    return liveRemoteVideoEnable;
}

- (RBVideoViewModle)localViewFitModle{
    if(currentIsLiveClient){
        return RBVideoAspectFill;
    }
    return newClient.localViewFitModle;
}

- (RBVideoViewModle)remoteViewFitModle{
    if(currentIsLiveClient){
        return RBVideoAspectFill;
    }else{
        return newClient.remoteViewFitModle;
    }
}

- (void)setLocalViewFitModle:(RBVideoViewModle)localViewFitModle{
    if(!currentIsLiveClient){
        [newClient setLocalViewFitModle:localViewFitModle];
    }
}

- (void)setRemoteViewFitModle:(RBVideoViewModle)remoteViewFitModle{
    RBViewModle modle;
    switch (remoteViewFitModle) {
        case RBVideoFill:
            modle = RBViewScaleToFill ;
            break;
        case RBVideoAspectFit:
            modle = RBViewScaleAspectFit;
            break;
        case RBVideoAspectFill:
            modle = RBViewAspectFill;
            break;
        default:
            break;
    }
//    [oldClient setViewModle:modle];
    [newClient setRemoteViewFitModle:remoteViewFitModle];
}

/**
 *  @author 智奎宇, 16-11-23 17:11:36
 *
 *  呼叫
 *
 *  @param clientID 呼叫端id
 */
- (void)call:(NSString *)aclientID OldVideoEnable:(BOOL)enable{
    self.isRecoreding = NO;
    currentIsLiveClient= NO;

    oldVideoEnable = NO;
    clientId = aclientID;
    [self callNewVideo];
}

- (void)callOldVideo{
    _connected = NO;
//    [oldClient call:clientId];
    newClient.delegate = nil;
//    oldClient.delegate = self;
}

- (void)callNewVideo{
    newClient.delegate = self;
//    oldClient.delegate = nil;
    _connected = NO;
    currentIsLiveClient= NO;
    [newClient call:clientId];
}

/**
 *  @author 智奎宇, 16-11-23 19:11:05
 *
 *  截屏
 */
- (void)captureImage{

    [[self topViewController] isRejectPhotoAlbum:^(BOOL isReject) {
        if(_CaptureImage){
            if(!isReject){
                [RBStat logEvent:PD_Video_ScreenShot message:nil];
                if(currentIsLiveClient){
                    UIImage * image = [self snapshotScreenInView:_remoteVideoView];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(_CaptureImage && image){
                            _CaptureImage(image);
                        }
                    });
                }else{
                    [newClient captureImage];
                }
            }
        }
    }];
}
-(UIImage *)snapshotScreenInView:(UIView *)contentView{
    CGSize size = CGSizeMake(SC_WIDTH, contentView.bounds.size.height);
    if (contentView.bounds.size.height == SC_WIDTH) {
        size = CGSizeMake(SC_HEIGHT, SC_WIDTH);
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = contentView.frame;
    //  自iOS7开始，UIView类提供了一个方法-drawViewHierarchyInRect:afterScreenUpdates: 它允许你截取一个UIView或者其子类中的内容，并且以位图的形式（bitmap）保存到UIImage中
    [contentView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  @author 智奎宇, 16-11-23 19:11:27
 *
 *  开始录制视频
 */
- (void)recordVideo{
    [[self topViewController] isRejectPhotoAlbum:^(BOOL isReject) {
        if(isReject)
            return ;
        
        if(currentIsLiveClient){
            NSString * path = [[SandboxFile GetDocumentPath] stringByAppendingString:@"/recored.mp4"];
            [_liveClient startRecord:path];
        }else{
            [newClient recordVideo];
        }
        
    }];
    
    
}

/**
 *  @author 智奎宇, 16-11-23 19:11:44
 *
 *  停止录制视频
 */
- (void)stopRecord{
    if(currentIsLiveClient){
        [_liveClient stopRecord];
    }else{
        [newClient stopRecord];
    }
}
#pragma mark -

- (void)setEnvironment:(RBServerState)Environment{
    if(_environment == Environment)
        return;
    _environment = Environment;
    switch (Environment) {
        case RBServerState_Developer:{
            [RBLiveVideoClient setVideoEnvironment:RBDeveloper];
        }
            break;
        case RBServerState_Test:{
            [RBLiveVideoClient setVideoEnvironment:RBDeveloper];
            [RBLiveVideoClient setLogModle:RBLogAll];
        }
            break;
        case RBServerState_Online:{
            [RBLiveVideoClient setVideoEnvironment:RBOnLine];
            if(TESTMODLE)
                [RBLiveVideoClient setLogModle:RBLogAll];
            else
                [RBLiveVideoClient setLogModle:RBLogBase];
        }
            break;
        default:
            break;
    }
}

- (void)setIsRecoreding:(BOOL)isRecoreding{
    if(_isRecoreding != isRecoreding){
        self.recoredTime = 0;
    }
    _isRecoreding = isRecoreding;
    
    if(_RecoredState){
        _RecoredState(_isRecoreding);
    }
}


- (void)setVideoMTU:(int)videoMTU{
    if(newClient){
        [newClient setVideoMTU:videoMTU];
        
    }
    
}

#pragma mark - new video Deleagte

- (void)connectProgress:(float)progress{
    if(progress > 0.99){
        _connected = YES;
    }
    
    if(_ConnectProgressBlock){
        _ConnectProgressBlock(progress > .99,progress);
    }
}


/**
 *  @author 智奎宇, 16-11-23 17:11:16
 *
 *  视频连接出错错误
 *
 *  @param error 错误码
 */
- (void)connectVideoStateError:(RB_CALL_ERROR)error{
 
    _connected = NO;
    if(error == RB_USER_INVALID){
        if(_CallError){
            _CallError(NSLocalizedString( @"dissconnect_video", nil));

        }
        [RBDataHandle refreshCurrentDevice:nil];
        return;
    }
    if(oldVideoEnable && error == RB_OFFLINE){
        [self callOldVideo];
        return;
    }
    
    if(_CallError){
        NSString * errorStr = nil;
        if(error == RB_CLOSE){
            errorStr = NSLocalizedString( @"ps_check_net_state", nil);
        }else if(error == RB_NOLOGIN){
            errorStr = NSLocalizedString( @"video_login_error", nil);
        }else if(error == RB_OFFLINE){
            errorStr = NSLocalizedString( @"pudding_offline", nil);
        }else if(error == RB_HALLON){
            errorStr = NSLocalizedString( @"take_off_the_sleep_paste", nil);
        }else if(error == RB_BUSY){
            errorStr = NSLocalizedString( @"parent_interacting_with_baby_ps_later", nil);
        }else if(error == RB_TIMEOUT){
            errorStr = NSLocalizedString( @"call_timeout", nil);
        }else if(error == RB_UNKNOW){
            errorStr = NSLocalizedString( @"unknown_error_", nil);
        }else {
            errorStr = NSLocalizedString( @"unknown_error_", nil);
        }
        _CallError(errorStr);
    }
   
}

- (void)onCaptureImage:(UIImage *)img{
    if(_CaptureImage && img){
        _CaptureImage(img);
    }
}

/**
 *  @author 智奎宇, 16-11-23 17:11:00
 *
 *  视频录制状态回调
 *
 *  @param event 视频状态
 *  @param error 错误码
 *  @param videoOutPutPath 视频要输出的路径
 */
- (void)onRecored:(RB_RECORD)event ERROR:(RECORD_ERROR)error OutPutPath:(NSString *)videoOutPutPath{
   
    NSString * tip = nil ;
    if(event == RB_RECORD_ERROR){
        if(RB_RECORD_INIT_ERROR == error){
            tip = NSLocalizedString( @"video_record_init_error", nil);
        }else{
            tip = NSLocalizedString( @"video_record_init_error", nil);
            [RBStat endLogEvent:PD_Video_ScreenVideo message:nil];

        }
        self.isRecoreding = NO;
    }else if(event == RB_RECORD_STOPED){
        [self saveRecoredVideo:^(NSString*  tipString) {
            if(_RecoredResut)
                _RecoredResut(tipString);
        }];
        [RBStat endLogEvent:PD_Video_ScreenVideo message:nil];

        self.isRecoreding = NO;
        return;
    }else if(event == RB_RECORD_STARTED){
        [RBStat startLogEvent:PD_Video_ScreenVideo message:nil];
        self.isRecoreding = YES;
    }
    if(tip){
        if(_RecoredResut){
            _RecoredResut(tip);
            
        }
    }
   
}

- (void)pasvCallState:(PASV_STATE_STATE) state Error:(RB_PASV_CALL_ERROR) error{
    
}

- (void)pasvCall:(NSString *)callid{
    [self showMcCallView:callid];

}

- (void)checkPasvCall:(BOOL)inOnline CallerID:(NSString *)callID{
    if(inOnline){
        [self showMcCallView:callID];
    }
}

- (void)pasvDisconnectCall{
    [[RBMessageManager getCurrentVC] dismsissCalling];
}


- (void)onVideoRendering:(uint64_t )sid View:(UIView *)view{
    if(_RemoteVideoViewChange){
        _RemoteVideoViewChange(view,YES);
    }
}

- (void)onVideoDismiss:(uint64_t )sid View:(UIView *)view{
    if(_RemoteVideoViewChange){
        _RemoteVideoViewChange(view,NO);
    }
}

- (void)enterCallModle{
    if(_EnterCallModleBlock){
        _EnterCallModleBlock();
    }

}

#pragma mark - 文件: 获取压缩文件路径
+ (NSString *)zipFilePath{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"video_error.zip"];
    return documentsDirectory;
}
- (void)errorLogPath:(NSString *)errorLog{
    if(![[NSFileManager defaultManager] fileExistsAtPath:errorLog]){
        return;
    }
    //压缩成功之后上传
    __block NSString * filePath = [RBVideoClientHelper zipFilePath];
    if ([SSZipArchive createZipFileAtPath:filePath withFilesAtPaths:@[errorLog]]) {
        NSLog(@"压缩成功");
        [RBNetworkHandle uploadVideoErrorLogWithFileURL:filePath Block:^(id res) {
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            }
        
        }];
    }else{
        NSLog(@"压缩失败");
    }
}


/**
 视频连接状态统计
 
 @param errorLog 日志路径
 */
- (void)videoConnectStateLog:(NSString *)log{
    if(log){
        log = [[[[[[log stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@"="] stringByReplacingOccurrencesOfString:@"{" withString:@""] stringByReplacingOccurrencesOfString:@"}" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [RBStat logEvent:PD_VIDEO_CONNECT_INFO message:log];

    }
    
}

- (void)enterRemoteModle{
    if(_EnterRemoteModleBlock){
        _EnterRemoteModleBlock();
    }

}



#pragma mark - old video Delegate RBVideoEventDelegate

/**
 *  @author 智奎宇, 16-06-02 12:06:05
 *
 *  视频截图
 *
 *  @param state 截图状态
 *  @param msgInfo   信息
 */
- (void)captureVideo:(CAPTURE_VIDEO_STATE) state ResultImage:(UIImage *)captureImage Msg:(NSString *)msgInfo{
   
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_CaptureImage && captureImage){
            _CaptureImage(captureImage);
        }
    });
}
/**
 *  @author 智奎宇, 16-06-02 12:06:50
 *
 *  视频录制
 *
 *  @param state 视频录制状态
 *  @param msg   信息
 */
- (void)recoredVideo:(RECORDER_VIDEO_STATE) state Msg:(id)msg{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_RecoredResut){
            NSString * tip = nil ;
            switch (state) {
                case RECORDER_VIDEO_STARTED:
                    self.isRecoreding = YES;
                    [RBStat startLogEvent:PD_Video_ScreenVideo message:nil];
                    break;
                case RECORDER_VIDEO_STOPED:
                {
                    [RBStat endLogEvent:PD_Video_ScreenVideo message:nil];

                    self.isRecoreding = NO;
                    [self saveRecoredVideo:^(NSString*  tipString) {
                        _RecoredResut(tipString);
                    }];
                }
                    break;
                case RECORDER_VIDEO_ERROR:{
                    [RBStat endLogEvent:PD_Video_ScreenVideo message:nil];

                    tip = NSLocalizedString( @"video_record_error", nil);
                    self.isRecoreding = NO;

                }
                    break;
            }
            if(tip){
                _RecoredResut(tip);
            }
        }
        
    });
   
}


/**
 *  @author 智奎宇, 16-06-02 12:06:55
 *
 *  登陆视频服务器错误
 *
 *  @param errorEvent 错误事件
 *  @param msg        错误信息
 */
- (void)videoConnectServerError:(CONNECT_SERVER_ERROR)errorEvent Msg:(id)msg{
    switch (errorEvent) {
        case  SERVER_RECONNECT:
            NSLog(@"视频服务器用户信息错误，正在重连");
            break;
        case SERVER_USERINFO_INVALID:
            NSLog(@"视频服务器用户信息错误，登陆信息错误");
            break;
        case SERVER_ADDRESS_INVALID:
            NSLog(@"视频服务器地址错误");
            break;
        case SERVER_CLOSE:
            NSLog(@"视频服务器断开");
            break;
        case SERVER_ERROR:
            NSLog(@"视频服务器断开_错误");
            break;
        case SERVER_LOGIN_ERROR:
            NSLog(@"视频服务器登陆失败");
            break;
        case SERVER_LOGINOUT:
            NSLog(@"视频服务器退出登陆");
            break;
        default:
            break;
    }
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        if(self.CallError){
            self.CallError(nil);
        }
    });
}

/**
 *  @author 智奎宇, 16-06-02 12:06:39
 *
 *  视频服务器登陆状态
 */
- (void)videoConnectServer:(CONNECT_SERVER_STATE)state{
    switch (state) {
        case CONNECT_SERVER_OPENED:
            NSLog(@"视频服务器打开");
            break;
        case CONNECT_SERVER_LOGIN:
            NSLog(@"视频服务器登录成功");
            break;
        default:
            break;
    }
}
/**
 *  @author 智奎宇, 16-06-02 12:06:50
 *
 *  观看视频失败
 *
 *  @param errorEvent 错误类型
 *  @param msg        错误信息
 */
- (void)videoConnectVideoError:(CONNECT_VIDEO_ERROR)errorEvent Msg:(id)msg{
//    if(_RemoteVideoViewChange){
//        _RemoteVideoViewChange([oldClient getVideoView],NO);
//    }
    _connected = NO;
    NSString * errorString = nil;
    switch (errorEvent) {
        case CONNECT_VIDEO_STATE_ERROR:
            errorString =NSLocalizedString( @"video_login_timeout_ps_retry", nil);
            break;
        case CONNECT_VIDEO_FAIL:
            errorString =NSLocalizedString( @"video_login_timeout_ps_retry", nil);
            break;
        case CONNECT_VIDEO_SERVER_ERROR:
            errorString =NSLocalizedString( @"video_login_timeout_ps_retry", nil);
            break;
        case CONNECT_VIDEO_HANGUP:
            break;
        case CONNECT_VIDEO_BUDY:
            errorString =NSLocalizedString( @"parent_interacting_with_baby_ps_later", nil);
            break;
        case CONNECT_VIDEO_OFFLINE:
            errorString =NSLocalizedString( @"pudding_not_connect_net", nil);
            break;
        case CONNECT_VIDEO_PERMISSION:
            [RBDataHandle refreshDeviceList:nil];
            errorString =NSLocalizedString( @"have_not_bind_pudding", nil);
            break;
        case CONNECT_VIDEO_HALLON:
            errorString =NSLocalizedString( @"take_off_the_sleep_paste", nil);
            break;
        default:
            break;
    }
   @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
       @strongify(self)
        if(self.CallError){
            self.CallError(errorString);
        }
    });
    
    
}

/**
 *  @author 智奎宇, 16-06-02 12:06:17
 *
 *  视频连接状态
 *
 *  @param state    状态
 *  @param progress 连接进度，参考进度，由4个状态评估
 */
- (void)videoConnectVideoState:(CONNECT_VIDEO_STATE)state DefaultProgress:(int)progress{
    switch (state) {
        case CONNECT_VIDEO_ACCEPT:
            NSLog(@"同意呼叫");
            break;
        case CONNECT_VIDEO_ANSWER:
            NSLog(@"收到视频连接回复");
            break;
        case CONNECT_VIDEO_INFO:
            NSLog(@"收到视频连接信息");
            break;
        case CONNECT_VIDEO_BYE:
            NSLog(@"收到视频断开消息");
            break;
        case CONNECT_VIDEO_SCUESS:
            NSLog(@"视频连接成功");
            _connected = YES;
            if(_RemoteVideoViewChange){
//                _RemoteVideoViewChange([oldClient getVideoView],YES);
            }
            break;
        default:
            break;
    }
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        if(self.ConnectProgressBlock){
            self.ConnectProgressBlock(progress > 99,progress/100.0);
        }
    });
   
}

#pragma mark - method handle

- (void)saveRecoredVideo:(void(^)(NSString * tipString)) block{
    NSString * path = [[SandboxFile GetDocumentPath] stringByAppendingString:@"/recored.mp4"];
    BOOL isEsit = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if(!isEsit){
        return;
    }
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    for (PHAssetCollection *collection in albums) {
        if ([collection.localizedTitle isEqualToString:R.pudding]) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //请求创建一个Asset
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:path]];
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset ];
                //相册中添加照片
                [collectonRequest addAssets:@[placeHolder]];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(success){
                        [RBVideoClientHelper getFirstVideoFrame:path];
                        if(block){
                            block(NSLocalizedString( @"video_save_in_gallery", nil));
                        }
                    } else {
                        if(block){
                            block(NSLocalizedString( @"save_fail", nil));
                        }
                        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                    }
                });
                
            }];
            
        }
    }
}

/**
 *  @author 智奎宇, 16-04-13 19:04:56
 *
 *  获取第一帧的图片
 *
 *  @param path MPMoviePlayerThumbnailImageRequestDidFinishNotification 通知
 */
+(void)getFirstVideoFrame:(NSString *)path
{
    AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:path] options:nil];
    AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
    generate1.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 2);
    CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
    UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
    
    [UIImagePNGRepresentation(one) writeToFile:[[SandboxFile GetTmpPath] stringByAppendingString:@"\photo.png"] atomically:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetRecoredVideoImage" object:one];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    
    
}

- (void)showMcCallView:(NSString *)deviceID{
    [[RBMessageManager getCurrentVC] videoCallDeviceId:deviceID UserActionBloc:^(BOOL isAccept) {
        if(isAccept){
            [self acceptMcCall];
            [self toVideoController:deviceID];
        }else{
            [self rejectMcCall];
        }
    }];
}


- (void)toVideoController:(NSString *)deviceID{
    RBVideoViewController * vi = (RBVideoViewController *)[RBMessageManager getCurrentVC];
    if([vi isKindOfClass:[RBVideoViewController class]]){
        vi.isFromMctl = YES;
        [vi setCallId:deviceID];
    }else{
        RBVideoViewController * v = [[RBVideoViewController alloc] init];
        v.isFromMctl = YES;
        [v setCallId:deviceID];

        [vi.navigationController pushViewController:v animated:NO];
    }
}

#pragma mark - 中转方法



- (Boolean)working{
    return clientId == nil;
}
/**
 *  @author 智奎宇, 16-11-23 17:11:54
 *
 *  切换摄像头方向
 */
- (void)switchCamera{
    if(!currentIsLiveClient){
        [newClient switchCamera];
    }
    else{
        [_liveClient switchCamera];
    }
}

/**
 *  @author 智奎宇, 16-11-23 17:11:55
 *
 *  连接视频服务器
 */
- (void)connect{
    [newClient  connect];
}

/**
 *  @author 智奎宇, 16-11-23 17:11:55
 *
 *  断开视频服务器
 */
- (void)disConnect{
    [newClient hangup];

}


/**
 *  @author 智奎宇, 16-11-23 19:11:33
 *
 *  断开视频连接
 */
- (void)hangup{
    self.isRecoreding = NO;
    if (_liveClient) {
        [_liveClient stop];
    }
    [_remoteVideoView clearFrame];
    [newClient hangup];
}


/**
 *  @author 智奎宇, 16-11-23 19:11:55
 *
 *  呼叫设备（ios 联调添加）
 *
 *  @param callId 设备id
 */
- (void)mc_call:(NSString *)callId{
    [newClient mc_call:callId];
}

/**
 *  @author 智奎宇, 16-11-23 19:11:25
 *
 *  同意对方呼叫
 */
- (void)acceptMcCall{
    [newClient acceptMcCall];
}

/**
 *  @author 智奎宇, 16-11-23 19:11:38
 *
 *  拒绝对方呼叫
 */
- (void)rejectMcCall{
    [newClient rejectMcCall];
}


/**
 *  @author 智奎宇, 16-11-23 20:11:58
 *
 *  检测对方当前有没有呼叫
 *
 *  @param mcId 对端设备id
 */
- (void)checkMcCalling:(NSString *)mcId{
    LogError(@"checkMcCalling %@ ",mcId);
    LogError(@"newClient %@ ",newClient);
    if(newClient )
        [newClient checkMcCalling:mcId];
    else
        checkClientId = mcId;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - RBEAGLVideoViewDelegate

- (void)videoView:(RBEAGLVideoView*)videoView didChangeVideoSize:(CGSize)size {
    if (videoView == _remoteVideoView) {
        if (videoSize.height == 0) {
            videoSize = size;
            if (self.localAudioEnable) {
                [self setFullScreen];
            }
            else{
                [self exitFullScreen];
            }
        }
    }
}

#pragma mark - RVCLiveClientObserver

- (void)OnClientStarted:(int)error {
}

- (void)OnEvent:(int)type
          code1:(int)code1
          code2:(uint32_t)code2 {
    NSLog(@"OnEvent %d %d", type, code1);
    if (type == NET_EVENT) {
        NSString *str = @"";
        if (code1 == LOGINED) {
            NSLog(@"登录成功");
        } else if (code1 == LOGIN_FAIL) {
            NSLog(@"登录失败"); //比如帐号密码错误
            [_liveClient stop];
            str = @"登录失败";
        } else if (code1 == LOGIN_TIMEOUT) {
            NSLog(@"登录超时");
            [_liveClient stop];
            str = @"登录超时";
        } else if (code1 == CONNECTED) {
            NSLog(@"连接设备成功");
        } else if (code1 == DISCONNECTED) {
            NSLog(@"与设备断开连接");
            [_liveClient stop];
            str = @"与设备断开连接";
        } else if (code1 == DEVICE_OFFLINE) {
            NSLog(@"设备不在线");
            [_liveClient stop];
            str = @"设备不在线";
        } else if (code1 == UID_ERROR) {
            NSLog(@"设备ID错误");
            [_liveClient stop];
            str = @"设备ID错误";
        } else if (code1 == NETWORK_ERROR) {
            NSLog(@"网络错误");
            [_liveClient stop];
            str = @"网络错误";
        } else if (code1 == UNKOWN_ERROR) {
            NSLog(@"未知错误");
            [_liveClient stop];
            str = @"未知错误";
        }
        if (![str isEqualToString:@""]) {
            [self needReconnect];
            [MitLoadingView showErrorWithStatus:str];
        }
    } else if (type == CLIENT_EVENT) {
        if (code1 == REMOTE_BUSY) {
            NSLog(@"设备忙，语音对讲失败");
            [MitLoadingView showErrorWithStatus:@"宝宝正在视频通话中，请稍后再试"];
//            [self needReconnect];
        }else if (code1 == REMOTE_HANGUP) {
            NSLog(@"REMOTE_HANGUP");
            [self needReconnect];
        }else if (code1 == REQUEST_MICROPHONE) {
            NSLog(@"REQUEST_MICROPHONE");
        }else if (code1 == RELEASE_MICROPHONE) {
            NSLog(@"RELEASE_MICROPHONE");
        }else if (code1 == REQUEST_CAMERA) {
            NSLog(@"REQUEST_CAMERA");
        }else if (code1 == RELEASE_CAMERA) {
            NSLog(@"RELEASE_CAMERA");
        }else if (code1 == CLIENTS_NUM_CHANGE) {
            NSLog(@"CLIENTS_NUM_CHANGE");
        }else if (code1 == VIDEORES_LOCKED) {
            NSLog(@"VIDEORES_LOCKED");
        }
    }
}

- (void)OnVideoCanalOpen:(uint32_t)sid {
    NSLog(@"视频连接成功"); //开始接收数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.connected = YES;
    });
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self)
        if(self.ConnectProgressBlock){
            self.ConnectProgressBlock(true,1);
        }
    });

}

- (void)OnVideoCanalClose:(uint32_t)sid {
}

- (void)OnVideoSizeUpdate:(uint32_t)sid
                    width:(int)width
                   height:(int)height {
}

- (void)OnRecorderEvent:(int)msg
                    ext:(int)ext {
    NSLog(@"OnFileRecorderEvent %d", msg);
    if (msg == RECORDER_STARTED) {
        NSLog(@"视频录制开始");
        [RBStat startLogEvent:PD_Video_ScreenVideo message:nil];
        self.isRecoreding = YES;
    } else if (msg == RECORDER_STOPED) {
        NSLog(@"视频录制结束");
        [self saveRecoredVideo:^(NSString*  tipString) {
            if(_RecoredResut)
                _RecoredResut(tipString);
        }];
        [RBStat endLogEvent:PD_Video_ScreenVideo message:nil];
        self.isRecoreding = NO;
    } else if (msg == RECORDER_INIT_ERROR) {
        if (ext == WAITING_VIDEO_TIMEOUT) {
            NSLog(@"等待视频数据超时");
        } else if (ext == CREATE_FILE_ERROR) {
            NSLog(@"创建文件失败"); //路径不对无权限或空间不足
        }
    }
}

- (void)OnClientStoped {
}
- (void)setFullScreen{
    if (!currentIsLiveClient) {
        return;
    }
    int disw = SC_HEIGHT;
    int dish = SC_WIDTH;
    disw = dish/videoSize.height*videoSize.width;
    CGRect frame = CGRectMake(0+(SC_HEIGHT-disw)/2, 0, disw, dish);
    [_remoteVideoView setFrame:(frame)];
}

- (void)exitFullScreen{
    if (!currentIsLiveClient) {
        return;
    }
    int disw = videoViewContainerSize.width;
    int dish = videoViewContainerSize.height;
    disw = dish/videoSize.height*videoSize.width;
    CGRect frame = CGRectMake(0+(SC_WIDTH-disw)/2, 0, disw, dish);
    [_remoteVideoView setFrame:(frame)];
}
- (void)needReconnect{
    if (_isRecoreding) {
        [self stopRecord];
        self.isRecoreding = NO;
    }
    liveLocalAudioEnable = false;
    [_liveClient setEnableAudioSend:liveLocalAudioEnable];
    [MitLoadingView showErrorWithStatus:@"对方断开了视频"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disConnectVideo" object:nil];
}
@end
