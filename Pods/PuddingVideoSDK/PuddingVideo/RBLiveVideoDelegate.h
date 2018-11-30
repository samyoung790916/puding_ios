//
//  RBLiveVideoDelegate.h
//  player_demo
//
//  Created by Zhi Kuiyu on 16/6/24.
//  Copyright © 2016年 tcp china. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    RBVideoFill,
    RBVideoAspectFit,
    RBVideoAspectFill,
} RBVideoViewModle;

//服务器错误状态
typedef enum {
    RB_TOKEN_INVALID ,//用户登录信息token超时
    RB_LOGIN_OFFLINE ,//视频socket 断开
    RB_UNKON_FAIL,//未知错误
}RBLOGIN_ERROR;


typedef enum {
    RB_NO_LOGIN,       //对方或者服务器断开
    RB_CLOSE,       //服务器断开连接
    RB_ERROR,       //对方或者服务器断开
    RB_NOLOGIN,     //服务器显示当前账号没有登录
    RB_OFFLINE ,    //对方端没有在线或没有创建房间
    RB_HALLON ,     //对方休眠贴打开
    RB_BUSY,        //对方忙
    RB_USER_INVALID, //用户信息错误
    RB_TIMEOUT,     //呼叫超时
    RB_UNKNOW ,      //其他错误
    RB_SERVER_ERROR, // 网络不稳定（异常断开，提示信息，会自动重连）


}RB_CALL_ERROR;

typedef enum {
    RB_PASV_ERROR_NONE , 
    RB_PASV_ERROR_BUSY ,    // 呼叫对方 ，对方不在线
    RB_PASV_ERROR_OFFLINE , // 呼叫对方 ，对方不在线
}RB_PASV_CALL_ERROR;


typedef enum {
    RB_RECORD_STARTED,  //开始录制视频
    RB_RECORD_STOPED,   //结束录制视频
    RB_RECORD_ERROR,    //录制视频错误
} RB_RECORD;

typedef enum {
    RB_RECORD_NONE,
    RB_RECORD_INIT_ERROR,   //录制视频初始化错误
    RB_RECORD_OUTPUT_ERROR, //录制视频输出文件错误
    RB_RECORD_CREATE_ERROR, //录制创建文件错误
    RB_RECORD_TIMEOUT_ERROR, //录制视频超时
    
}RECORD_ERROR;

typedef enum {
    RB_PASV_REJECT, //呼叫对方，对方拒绝
    RB_PASV_ACCETP, //呼叫对方，对方同意
    RB_PASV_ERROR,  //呼叫对方，发生错误
    RB_PASV_NONE,  //呼叫对方，对方收到
}PASV_STATE_STATE;


@protocol RBLiveVideoDelegate <NSObject>
/**
 *  @author 智奎宇, 16-11-23 17:11:43
 *
 *  视频连接进度
 *
 *  @param progress 连接进度（0 - 1）
 */
- (void)connectProgress:(float)progress;

@optional

/**
 *  @author 智奎宇, 16-11-23 17:11:16
 *
 *  视频连接出错错误
 *
 *  @param error 错误码
 */
- (void)connectVideoStateError:(RB_CALL_ERROR)error;

/**
 *  @author 智奎宇, 16-11-23 17:11:14
 *
 *  视频截图
 *
 *  @param img 图片
 */
- (void)onCaptureImage:(UIImage *)img;

/**
 *  @author 智奎宇, 16-11-23 17:11:00
 *
 *  视频录制状态回调
 *
 *  @param event 视频状态
 *  @param error 错误码
 *  @param videoOutPutPath 视频要输出的路径
 */
- (void)onRecored:(RB_RECORD)event ERROR:(RECORD_ERROR)error OutPutPath:(NSString *)videoOutPutPath;

/**
 *  @author 智奎宇, 16-11-23 17:11:02
 *
 *  呼叫对方，对方呼叫状态回调（ios 调试需要添加，主要需求是布丁端 端呼叫ios。ios 直接连接布丁，不需要确认）
 *
 *  @param state 对方状态
 *  @param error 错误码
 */
- (void)pasvCallState:(PASV_STATE_STATE) state Error:(RB_PASV_CALL_ERROR) error;

/**
 *  @author 智奎宇, 16-11-23 17:11:22
 *
 *  对方呼叫
 *
 *  @param callid 呼叫端id
 */
- (void)pasvCall:(NSString *)callid;

/**
 *  @author 智奎宇, 16-11-23 17:11:28
 *
 *  对方是否在呼叫状态
 *
 *  @param inOnline 是否在呼叫状态
 *  @param callID   对方id
 */
- (void)checkPasvCall:(BOOL)inOnline CallerID:(NSString *)callID;

/**
 *  @author 智奎宇, 16-11-23 17:11:52
 *
 *  对方停止呼叫
 */
- (void)pasvDisconnectCall;

/**
 *  @author 智奎宇, 16-11-23 17:11:06
 *
 *  有端人加入视频会话
 *
 *  @param sid  对方会话的id
 *  @param view 对方数据的view
 */
- (void)onVideoRendering:(uint64_t )sid View:(UIView *)view;

/**
 *  @author 智奎宇, 16-11-23 17:11:46
 *
 *  有端离开会话
 *
 *  @param sid  对方会话的id
 *  @param view 对方数据的view
 */
- (void)onVideoDismiss:(uint64_t )sid View:(UIView *)view;

/**
 *  @author 智奎宇, 16-11-23 17:11:48
 *
 *  进入对话模式
 */
- (void)enterCallModle;

/**
 *  @author 智奎宇, 16-11-23 17:11:10
 *
 *  进入控制模式
 */
- (void)enterRemoteModle;

@optional
/**
 视频错误日志

 @param errorLog 日志路径
 */
- (void)errorLogPath:(NSString *)errorLog;

/**
 视频连接状态统计
 
 @param errorLog 日志路径
 */
- (void)videoConnectStateLog:(NSString *)log;
@end
