//
//  RBVideoClient.h
//  video
//
//  Created by tcp china on 16/3/27.
//  Copyright © 2016年 tcp china. All rights reserved.
//

#ifndef RBVideoClient_h
#define RBVideoClient_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "RBVideoEvent.h"


@interface RBVideoClient : NSObject

/**
 *  @author 智奎宇, 16-05-18 11:05:12
 *
 *  视频连接状态的回调
 */
@property (nonatomic,weak) id<RBVideoEventDelegate> delegate;
/**
 *  @author 智奎宇, 16-05-18 11:05:27
 *
 *  展示远程画面的View   默认是
        NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path=[[Paths objectAtIndex:0] stringByAppendingString:@"/recored.mp4"];
 */
@property (nonatomic,readonly,strong) UIView * remoteRendererView;

/**
 *  @author 智奎宇, 16-06-02 13:06:58
 *
 *  视频录制的视频默认输出路径
 */
@property(nonatomic,strong) NSString * recordVideoOutputPath;
/**
 *  @author 智奎宇, 16-06-02 13:06:46
 *
 *  远程视频声音
 */
@property(nonatomic,assign) BOOL  remoteAudioEnable;
/**
 *  @author 智奎宇, 16-06-02 13:06:46
 *
 *  远程视频声音
 */
@property(nonatomic,assign) RBViewModle  viewModle;
/**
 *  @author 智奎宇, 16-06-02 13:06:46
 *
 *  本地视频声音
 */
@property(nonatomic,assign) BOOL  localAudioEnable;

/**
 *  @author 智奎宇, 16-06-02 13:06:46
 *
 *  当前进度
 */
@property(nonatomic,assign,readonly) float  progress;


-(instancetype)init  __attribute__((
                                    unavailable("init is not a supported initializer for this class.")));

/**
 *  @author 智奎宇, 16-06-02 13:06:47
 *
 *  获取视屏sdk 的实例
 *
 *  @param userid    用户id
 *  @param token     用户token
 *  @param psd       视频密码
 *  @param apikey    sdk appkey
 *  @param appid     sdk appid
 *  @param serverURL 视频服务器的url
 *
 *  @return 视屏sdk 的实例
 */
+ (RBVideoClient *)getClient:(NSString *)userid Token:(NSString * )token Psd:(NSString *)psd APIKEY:(NSString *)apikey APPID:(NSString *)appid ServerURL:(NSString *)serverURL;

/**
 *  @author 智奎宇, 16-05-25 11:05:28
 *
 *  获取视频View
 *
 */
- (UIView *)getVideoView;

/**
 *  @author 智奎宇, 16-05-18 12:05:10
 *
 *  开始连接视频服务器（必须设置 connectAddress 视频连接地址，videoCredential 视频的认证信息）
 */
- (void)connect;

/**
 *  @author 智奎宇, 16-05-20 14:05:09
 *
 *  呼叫视频设备
 *
 *  @param clientId 设备id
 */
- (void)call:(NSString *)clientId;

/**
 *  @author 智奎宇, 16-05-18 12:05:22
 *
 *  断开视频连接，如果想重新连接必须 调用begin
 */
- (void)hangup;

/**
 *  @author 智奎宇, 16-05-18 12:05:26
 *
 *  视频视频里面的资源
 */
- (void)free;
/**
 *  @author 智奎宇, 16-05-26 20:05:13
 *
 *  视频截图
 *
 */
- (void)screenCapture;

/**
 *  @author 智奎宇, 16-05-26 20:05:03
 *
 *  开始录制视频
 */
- (void)startRecoredVideo;


/**
 *  @author 智奎宇, 16-05-26 20:05:03
 *
 *  停止录制视频
 */
- (void)stopRecoredVideo;

/**
 *  @author 智奎宇, 16-06-14 20:06:23
 *
 *  关闭声音
 *
 *  @param disableAudio 禁止本地音频
 */
- (void)setDisableAudio:(BOOL)disableAudio;

@end

#endif /* RBVideoClient_h */
