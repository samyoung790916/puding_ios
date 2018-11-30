//
//  RBVideoClientHelper.h
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/11/5.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBLiveVideoClient.h"
#import "RBVideoClient.h"
#import "RBEAGLVideoView.h"
#import "RBLiveObserver.h"
#import "RBLiveClient.h"
#import "RBLiveTypes.h"

#define VIDEO_CLIENT [RBVideoClientHelper getInstanse]

UIKIT_EXTERN NSString * mNewRecoredVideoImage ; //录制视频后第一针图片通知

@interface RBVideoClientHelper : NSObject<RBLiveVideoDelegate,RBVideoEventDelegate,RBEAGLVideoViewDelegate, RBLiveObserver>

@property(nonatomic,assign) BOOL  isRecoreding;

@property(nonatomic,assign) BOOL  connected;

@property(nonatomic,assign) int recoredTime;

@property(nonatomic,assign) RBServerState environment;

@property(nonatomic,assign) int   videoMTU;

@property (nonatomic,copy) void(^RecoredState)(BOOL);

@property (nonatomic,copy) void(^RemoteVideoViewChange)(UIView * view,BOOL isAdd);

@property (nonatomic,copy) void(^ConnectProgressBlock)(BOOL isDone,float progress);

@property (nonatomic,copy) void(^CallError)(NSString * error);

@property (nonatomic,copy) void(^CaptureImage)(UIImage *);

@property (nonatomic,copy) void(^RecoredResut)(NSString * tipString);

@property (nonatomic,copy) void(^EnterRemoteModleBlock)();

@property (nonatomic,copy) void(^EnterCallModleBlock)();



/**
 *  @author 智奎宇, 16-11-23 16:11:34
 *
 *  本地视频显示view 的适应模式
 */
@property(nonatomic,assign) RBVideoViewModle  localViewFitModle;

/**
 *  @author 智奎宇, 16-11-23 16:11:34
 *
 *  远程视频显示view 的适应模式
 */
@property(nonatomic,assign) RBVideoViewModle  remoteViewFitModle;
/**
 *  @author 智奎宇, 16-11-23 16:11:37
 *
 *  本地摄像头View
 */
@property(nonatomic,strong) UIView * localView;

/**
 *  @author 智奎宇, 16-11-23 16:11:58
 *
 *  是否发送本地音频
 */
@property(nonatomic,assign,readonly) BOOL  localAudioEnable;

/**
 *  @author 智奎宇, 16-11-23 16:11:58
 *
 *  是否发送本地视频频
 */
@property(nonatomic,assign) BOOL  localVideoEnable;

/**
 *  @author 智奎宇, 16-11-23 16:11:46
 *
 *  是否播放对端音频
 */
@property(nonatomic,assign) BOOL  remoteAudioEnable;

/**
 *  @author 智奎宇, 16-11-23 16:11:46
 *
 *  是否播放对端视频
 */
@property(nonatomic,assign) BOOL  remoteVideoEnable;

- (void)setLocalAudioEnable:(BOOL)localAudioEnable ResultBlock:(void(^)(Boolean flag)) result;

+ (RBVideoClientHelper *)getInstanse;

- (void)freeVideoClient;

- (void)setUpVideoClient;
- (void)setupClientId:(NSString*)aClientId auth:(NSString*)account password:(NSString*)password;
- (void)createVideoView:(UIView*)view;
/**
 *  @author 智奎宇, 16-11-23 17:11:36
 *
 *  呼叫
 *
 *  @param clientID 呼叫端id
 */
- (void)call:(NSString *)aclientID OldVideoEnable:(BOOL)enable;


- (void)setEnvironment:(RBServerState)Environment;

#pragma mark - 中转方法

- (Boolean)working;
/**
 *  @author 智奎宇, 16-11-23 17:11:54
 *
 *  切换摄像头方向
 */
- (void)switchCamera;

/**
 *  @author 智奎宇, 16-11-23 17:11:55
 *
 *  连接视频服务器
 */
- (void)connect;

/**
 *  @author 智奎宇, 16-11-23 17:11:55
 *
 *  断开视频服务器
 */
- (void)disConnect;


/**
 *  @author 智奎宇, 16-11-23 19:11:33
 *
 *  断开视频连接
 */
- (void)hangup;

/**
 *  @author 智奎宇, 16-11-23 19:11:05
 *
 *  截屏
 */
- (void)captureImage;

/**
 *  @author 智奎宇, 16-11-23 19:11:27
 *
 *  开始录制视频
 */
- (void)recordVideo;

/**
 *  @author 智奎宇, 16-11-23 19:11:44
 *
 *  停止录制视频
 */
- (void)stopRecord;

/**
 *  @author 智奎宇, 16-11-23 19:11:55
 *
 *  呼叫设备（ios 联调添加）
 *
 *  @param callId 设备id
 */
- (void)mc_call:(NSString *)callId;

/**
 *  @author 智奎宇, 16-11-23 19:11:25
 *
 *  同意对方呼叫
 */
- (void)acceptMcCall;

/**
 *  @author 智奎宇, 16-11-23 19:11:38
 *
 *  拒绝对方呼叫
 */
- (void)rejectMcCall;


/**
 *  @author 智奎宇, 16-11-23 20:11:58
 *
 *  检测对方当前有没有呼叫
 *
 *  @param mcId 对端设备id
 */
- (void)checkMcCalling:(NSString *)mcId;

/**
 设置全屏
 */
- (void)setFullScreen;

/**
 退出全屏
 */
- (void)exitFullScreen;
/**
 释放TUTK视频
 */
- (void)freeTutkVideoClient;
@end
