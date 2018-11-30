//
//  RBVideoEvent.h
//  video
//
//  Created by Zhi Kuiyu on 16/5/17.
//  Copyright © 2016年 tcp china. All rights reserved.
//

#ifndef RBVideoEvent_h
#define RBVideoEvent_h
#import <UIKit/UIKit.h>

typedef enum {
    RBViewScaleToFill,
    RBViewScaleAspectFit,
    RBViewAspectFill,
    
} RBViewModle;


typedef enum {
    SERVER_USERINFO_INVALID,//视频服务器用户信息错误，登陆信息错误
    SERVER_ADDRESS_INVALID,//视频服务器地址错误
    SERVER_CLOSE,//视频服务器断开
    SERVER_ERROR,//
    SERVER_LOGIN_ERROR,//视频服务器登陆失败
    SERVER_LOGINOUT,//视频服务器退出
    SERVER_RECONNECT,//视频服务重新登陆
} CONNECT_SERVER_ERROR; //登陆视频服务器错误

typedef enum {
    CONNECT_SERVER_OPENED,//视频服务器打开
    CONNECT_SERVER_LOGIN,//视频服务器登录
} CONNECT_SERVER_STATE;

typedef enum {
    CONNECT_VIDEO_STATE_ERROR,//视频服务器状态错误 ，本地状态错误
    CONNECT_VIDEO_FAIL, //视频连接失败 call 服务器状态错误 是 error 状态
    CONNECT_VIDEO_SERVER_ERROR, //视频服务错误，call 返回异常
    CONNECT_VIDEO_HANGUP, //视频断开
    CONNECT_VIDEO_BUDY, //对方正忙
    CONNECT_VIDEO_OFFLINE, //布丁端不在线
    CONNECT_VIDEO_PERMISSION,//没有绑定布丁
    CONNECT_VIDEO_HALLON,//霍尔开关打开
} CONNECT_VIDEO_ERROR; //视频连接错误


typedef enum {
    CONNECT_VIDEO_ACCEPT,//同意呼叫
    CONNECT_VIDEO_ANSWER,//收到视频连接回复
    CONNECT_VIDEO_INFO,//收到视频连接信息
    CONNECT_VIDEO_BYE,//收到视频断开消息
    CONNECT_VIDEO_SCUESS,//视频连接成功
} CONNECT_VIDEO_STATE; 

typedef enum {
    RECORDER_VIDEO_STARTED,//开始录制视频
    RECORDER_VIDEO_STOPED,//暂停录制视频
    RECORDER_VIDEO_ERROR, //视频录制出错
}RECORDER_VIDEO_STATE;


typedef enum {
    CAPTURE_VIDEO_SCUESS,//截屏成功
    CAPTURE_VIDEO_ERROR, //截屏失败
}CAPTURE_VIDEO_STATE;//视频截屏

@protocol RBVideoEventDelegate <NSObject>

/**
 *  @author 智奎宇, 16-06-02 12:06:05
 *
 *  视频截图
 *
 *  @param state 截图状态
 *  @param msgInfo   信息
 */
- (void)captureVideo:(CAPTURE_VIDEO_STATE) state ResultImage:(UIImage *)captureImage Msg:(NSString *)msgInfo;
/**
 *  @author 智奎宇, 16-06-02 12:06:50
 *
 *  视频录制
 *
 *  @param state 视频录制状态
 *  @param msg   信息
 */
- (void)recoredVideo:(RECORDER_VIDEO_STATE) state Msg:(id)msg;
/**
 *  @author 智奎宇, 16-06-02 12:06:55
 *
 *  登陆视频服务器错误
 *
 *  @param errorEvent 错误事件
 *  @param msg        错误信息
 */
- (void)videoConnectServerError:(CONNECT_SERVER_ERROR)errorEvent Msg:(id)msg;

/**
 *  @author 智奎宇, 16-06-02 12:06:39
 *
 *  视频服务器登陆状态
 */
- (void)videoConnectServer:(CONNECT_SERVER_STATE)state;
/**
 *  @author 智奎宇, 16-06-02 12:06:50
 *
 *  观看视频失败
 *
 *  @param errorEvent 错误类型
 *  @param msg        错误信息
 */
- (void)videoConnectVideoError:(CONNECT_VIDEO_ERROR)errorEvent Msg:(id)msg;

/**
 *  @author 智奎宇, 16-06-02 12:06:17
 *
 *  视频连接状态
 *
 *  @param state    状态
 *  @param progress 连接进度，参考进度，由4个状态评估
 */
- (void)videoConnectVideoState:(CONNECT_VIDEO_STATE)state DefaultProgress:(int)progress;
@end



#endif /* RBVideoEvent_h */
