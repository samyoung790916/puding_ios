//
//  RBMessageHandle.h
//  RBMessage
//
//  Created by william on 16/10/24.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define RBMessageManager [RBMessageHandle sharedManager]


@class RBMessageModel;
/**
 *  RBError 类的回调代码块
 */
typedef void (^RBMsgBlock)(UIApplicationState state,RBMessageModel * mol);


typedef NS_ENUM(NSUInteger, CATEGORY_TYPE) {

    /**
     *  用户绑定申请(主人收到)
     */
    CATEGORY_ALARM_MEMBER_BIND_REQ = 5,

    /**
     *  摄像头检测到运动
     */
    CATEGORY_MOTION_DTECTED = 9,

    /**
     *  主控没电
     */
    CATEGORY_ALARM_MASTER_NO_POWER = 53,
    /**
     *  主控离线
     */
    CATEGORY_ALARM_MASTER_OFFLINE = 54,

    /**
     *  wifi 断开
     */
    CATEGORY_ALARM_WIFI_BREAK = 56,

    /**
     *  主控增加新成员
     */
    CATEGORY_ALARM_ADD_NEW_MEMBER = 58,

    /**
     *  自动布放关闭
     */
    CATEGORY_ALARM_AUTO_DEFENSE_OFF = 64,

    /**
     *  邀请绑定
     */
    CATEGORY_INVITE = 66,
    /**
     *  绑定请求通过（发送给申请人）
     */
    CATEGORY_BIND_REQ_ACCEPT = 67,
    /**
     *  绑定请求被拒绝（发送给申请人）
     */
    CATEGORY_BIND_REQ_REJECT = 68,
    /**
     *  自己移除绑定（发送给其他家庭成员）
     */
    MSGTYPE_UNBIND = 69,
    /**
     *  通知家庭成员移除某人的绑定关系
     */
    MSGTYPE_REMOVE_MEMBER_NOTIFY_FAMILY = 70,
    /**
     *  通知被删除人接触绑定
     */
    MSGTYPE_REMOVE_MEMBER = 71,
    /**
     *  管理员接受绑定申请（发送给家庭成员）
     */
    MSGTYPE_ADMIN_BIND_REQ_ACCEPT = 72,
    /**
     *  管理员拒绝绑定申请（发送给家庭成员）
     */
    MSGTYPE_ADMIN_BIND_REQ_REJECT = 73,
    /**
     *  用户申请绑定（申请绑定人收到）
     */
    MSGTYPE_USER_BIND_REQ = 74,
    /**
     *  邀请加入（发送给家庭成员）
     */
    MSGTYPE_INVITE_INITIATIVE = 75,

    /**
     *  主控重置
     */
    CATEGORY_RESET = 77,
    /**
     *  定时提醒
     */
    CATEGORY_ALARM_REMIND = 78,


    /**
     *  转移管理员
     */
    MSGTYPE_TRANS_MANAGER = 82,
    /**
     *  wifi连接
     */
    CATEGORY_ALARM_WIFI_CONNECT = 83,
    /**
     *  主控已旋转到最大角度
     */
    CATEGORY_MOTOR_ROTATE_TO_END = 84,


    /**
     *  app点播状态
     */
    CATEGORY_APP_PLAY_STATUS = 87,
    /**
     *  声音播放状态
     */
    CATEGORY_VOICE_PLAY_STATUS = 88,
    /**
     *  低电量
     */
    CATEGORY_POWER_LOW = 89,
    CATEGORY_ALARM_MONITOR_ON = 100,
    CATEGORY_ALARM_MONITOR_OFF = 101,
    // 家庭动态
    CATEGORY_FACK_TRACK = 102,
    CATEGORY_FACK_TRACK_NEW = 105,
    /**
     *  电量低于20%
     */
    CATEGORY_POWER_LOW_2 = 103,

    /**
     *  播放音乐中
     */
    CATEGORY_PLAYING = 1015,

    /**
     *  更新成功
     */
    CATEGORY_UPDATE_SUCCESS = 1020,
    /**
     *  更新失败
     */
    CATEGORY_UPDATE_FAILED = 1021,
    /**
     *  图文消息
     */
    CATEGORY_NEWS = 1030,
    /**
     *  视频消息
     */
    CATEGORY_MESSAGECENTER_VIDEO = 1031,
    /**
     *  活动类型
     */
    CATEGORY_MESSAGECENTER_ACTIVITY = 1032,


    /**
     *  普通文字消息
     */
    CATEGORY_APP_PUSH = 2001,

    /**
     *  开始视频
     */
    CATEGORY_MC_START_VIDEO = 2003,
    CATEGORY_NOT_FOUND_DEV = 2004,
    /**
     *  用户日志开关
     */
    CATEGORY_APP_DIAGNOSIS = 2005,


    CATEGORY_PLUS_CALL = 2008,

    /**
     *  微聊新消息
     */
    CATEGORY_PUDDINGX_WECHAAT_NEW_MESSAGE = 6000,

    /**
     *  批量运营消息
     */
    CATEGORY_BATCH_OPERATION = 201,

};



typedef NS_ENUM(NSInteger, RBRemoteNotificationType) {
    RBRemoteNotificationFetch = 0,
    RBRemoteNotificationLanching = 1,
};



@interface RBMessageHandle : NSObject

@property(nonatomic,assign) RBRemoteNotificationType notificationType;
@property(nonatomic,assign) BOOL  showAlter;


+ (id)sharedManager;

/**
 *  获取某个类型的回调
 */
- (id)blockForMsg:(RBMessageModel *)msessage;

/**
 *  启动长连接
 */
- (void)setUpMessageHelper;


#pragma mark - action: 显示视频界面
- (void)showVideoAlter:(NSString *)mcid;


//显示视频界面
#pragma mark - action: 显示视频界面
- (void)enterVideoController:(NSString *)mcid;

- (UIViewController *)getCurrentTopViewControler;

- (UIViewController *)getCurrentVC;

@end
