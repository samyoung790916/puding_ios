//
//  RBLiveVideoClient.h
//  player_demo
//
//  Created by Zhi Kuiyu on 16/6/24.
//  Copyright © 2016年 tcp china. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBLiveVideoDelegate.h"
#import <UIKit/UIKit.h>

@interface RBLiveVideoClient : NSObject

/**
 *  @author 智奎宇, 16-06-02 13:06:58
 *
 *  视频录制的视频默认输出路径
 */
@property(nonatomic,strong) NSString * recordVideoOutputPath;


/**
 *  连接失败的日志
 */
@property(nonatomic,strong) NSString * failConnectLogPath;

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
@property(nonatomic,assign) BOOL  localAudioEnable;

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

/**
 *  @author 智奎宇, 16-12-19 19:12:11
 *
 *  是否允许视频滤镜
 */
@property(nonatomic,assign) BOOL enableVideoFilter;


@property(nonatomic,weak) id <RBLiveVideoDelegate> delegate;

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
 *  @author 智奎宇, 16-11-04 20:11:42
 *
 *  0.1     start call
 *  0.2     server open
 *  0.4     server login sucess
 *  0.6     accetp
 *  0.8     open media
 *  1.0     recored data
 */
@property(nonatomic,assign) float   connectProgress;

/**
 *  @author 智奎宇, 16-11-04 20:11:42
 *
 *  0.1     start call
 *  0.2     server open
 *  0.4     server login sucess
 *  0.6     accetp
 *  0.8     open media
 *  1.0     recored data
 */
@property(nonatomic,assign) BOOL   connected;


/**
 *  @author 智奎宇, 16-11-04 20:11:42
 *  视频的发送效率
 */
@property(nonatomic,assign) int   videoMTU;
/**
 *  @author 智奎宇, 16-11-29 20:11:57
 *
 *  摄像头方向是横向 模式是yes
 */
@property(nonatomic,assign) BOOL    cameraIsLandscape;

/**
 *  @author 智奎宇, 16-12-02 16:12:20
 *
 *  后台连接视频时间，默认CGFLOAT_MAX
 */
@property(nonatomic,assign) NSTimeInterval backgroundTime;
/**
 *  @author 智奎宇, 16-11-23 17:11:38
 *
 *  获取视频实例
 *
 *  @param appkey     roobo 账号 AppKey
 *  @param appId      roobo 账号 AppKey
 *  @param clientType 产品类型
 *
 *  @return 视频实例
 */
+ (RBLiveVideoClient *)getInstanse:(NSString *)appkey AppID:(NSString *)appId Client:(NSString *)clientType;






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
 *  @author 智奎宇, 16-11-23 17:11:23
 *
 *  创建房间（ios 调试添加）
 */
- (void)createRoom;

/**
 *  @author 智奎宇, 16-11-23 17:11:36
 *
 *  呼叫
 *
 *  @param clientID 呼叫端id
 */
- (void)call:(NSString *)clientID;

/**
 *  @author 智奎宇, 16-11-23 19:11:33
 *
 *  断开视频连接
 */
- (void)hangup;

/**
 *  @author 智奎宇, 16-11-23 19:11:42
 *
 *  是否视频实例
 */
- (void)free;

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
 *  @author 智奎宇, 16-11-23 20:11:47
 *
 *   取消呼叫设备（ios 联调添加）
 */
- (void)cancleMcCall;

/**
 *  @author 智奎宇, 16-11-23 20:11:58
 *
 *  检测对方当前有没有呼叫
 *
 *  @param mcId 对端设备id
 */
- (void)checkMcCalling:(NSString *)mcId;

/**
 *  @author 智奎宇, 16-11-23 20:11:11
 *
 *  获取所有正在连接视频的view
 *
 *  @return 连接视频的所有view
 */
- (NSArray *)getAllRemoteVideos;
@end

