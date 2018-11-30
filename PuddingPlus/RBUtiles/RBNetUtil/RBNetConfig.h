//
//  RBNetworkConfig.h
//  Roobo
//
//  Created by mengchen on 16/9/28.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  RBNetworkConfig
 *
 *  网络类配置文件
 *
 */


//服务器默认环境
#define RooboDefaultNetEnviroment   RBServerState_Online




//服务器环境类型
typedef NS_ENUM(NSUInteger, RBServerState) {
    RBServerState_custom = 9,   //自定义环境
    RBServerState_Developer = 10,   //开发环境
    RBServerState_Test = 11,        //测试环境
    RBServerState_Online = 12,      //线上环境
};

//客户端环境
typedef NS_ENUM(NSUInteger, RBClientEnvState) {
    //测试
    RBClientEnvStateDevelop = 19,
    //企业
    RBClientEnvStateInhouse = 20,
    //内侧
    RBClientEnvStateAdhoc = 21,
    //线上
    RBClientEnvStateOnline = 22,
};








#pragma mark ------------------- 地址 ------------------------
#pragma mark - 服务器地址
#define RB_URL_HOST    [NSString stringWithFormat:@"%@",[RBNetworkHandle getUrlHost]]
UIKIT_EXTERN NSString * const RB_URL_HOST_Develop;              //开发域名
UIKIT_EXTERN NSString * const RB_URL_HOST_Test;                 //测试域名
UIKIT_EXTERN NSString * const RB_URL_HOST_Online;               //线上域名
#pragma mark - 视频服务器地址
#define RB_VideoSocket [NSString stringWithFormat:@"%@",[RBNetworkHandle getVideoSocket]]
UIKIT_EXTERN NSString * const RB_VIDEOSOCKET_Test;              //视频服务器测试环境
UIKIT_EXTERN NSString * const RB_VIDEOSOCKET_Online;            //视频服务器线上环境

#pragma mark - 升级服务器地址
UIKIT_EXTERN NSString * const RB_UPDATE_Develop;                //升级服务器开发环境
UIKIT_EXTERN NSString * const RB_UPDATE_Test;                   //升级服务器测试环境
UIKIT_EXTERN NSString * const RB_UPDATE_Online;                 //升级服务器线上环境

#pragma mark - 反馈服务器地址
UIKIT_EXTERN NSString * const RB_FEEDBACK_Develop;               //反馈服务器开发环境
UIKIT_EXTERN NSString * const RB_FEEDBACK_Test;                  //反馈服务器测试环境
UIKIT_EXTERN NSString * const RB_FEEDBACK_Online;                //反馈服务器线上环境

#pragma mark - 日志异常日志

UIKIT_EXTERN NSString * const RB_VIDEO_ERROR ;
#pragma mark - 打点服务器地址
UIKIT_EXTERN NSString * const RB_STAT_Develop;                  //打点服务器开发环境
UIKIT_EXTERN NSString * const RB_STAT_Test;                     //打点服务器测试环境
UIKIT_EXTERN NSString * const RB_STAT_Online;                   //打点服务器线上环境

#pragma mark - 崩溃服务器地址
UIKIT_EXTERN NSString * const RB_CRASH_Develop;                  //崩溃服务器开发环境
UIKIT_EXTERN NSString * const RB_CRASH_Test;                     //崩溃服务器测试环境
UIKIT_EXTERN NSString * const RB_CRASH_Online;                   //崩溃服务器线上环境

#pragma mark - 目录
UIKIT_EXTERN NSString * const RB_URL_PATH_MASTER_CMD;           //主控命令
UIKIT_EXTERN NSString * const RB_URL_PATH_MASTER_INFO;          //主控信息（初始化状态，主控详情）
UIKIT_EXTERN NSString * const RB_URL_PATH_MASTER_LIST;          //主控列表
UIKIT_EXTERN NSString * const RB_URL_PATH_MCTL_INFO;            //修改主控备注
UIKIT_EXTERN NSString * const RB_URL_PATH_CONFIG_DEFENSE;       //自动布放
UIKIT_EXTERN NSString * const RB_URL_PATH_NIGHT_MODE;           //夜间模式
UIKIT_EXTERN NSString * const RB_URL_PATH_ZBAR_CTRL;            //二维码查询主控
UIKIT_EXTERN NSString * const RB_URL_PATH_LOGIN;                //登陆
UIKIT_EXTERN NSString * const RB_URL_PATH_LOGOUT;               //登出
UIKIT_EXTERN NSString * const RB_URL_PATH_REGIST;               //注册、检查用户是否注册
UIKIT_EXTERN NSString * const RB_URL_PATH_VERIFY;               //校验密码是否正确
UIKIT_EXTERN NSString * const RB_URL_PATH_AUTHCODE;             //发送验证码
UIKIT_EXTERN NSString * const RB_URL_PATH_UPDATE_USER_INFO;     //用户信息、修改头像、更新 PushId、修改手机号、修改名称。修改他人备注
UIKIT_EXTERN NSString * const RB_URL_PATH_UPDATE_USER_PASSWORD; //修改密码、重置密码
UIKIT_EXTERN NSString * const RB_URL_PATH_ENTER_LEAVE_HOME;     //回家离家
UIKIT_EXTERN NSString * const RB_URL_PATH_DELETE_MESSAGE_LIST;  //删除消息列表
UIKIT_EXTERN NSString * const RB_URL_PATH_LAST_VIDEO_MESSAGE;  //视频消息

UIKIT_EXTERN NSString * const RB_URL_PATH_BIND_MASTER;          //绑定主控，邀请绑定，管理员删除他人绑定，自己退出绑定，拒绝绑定，同意绑定
UIKIT_EXTERN NSString * const RB_URL_PATH_UPLOAD_IMAGE;         //上传头像
UIKIT_EXTERN NSString * const RB_URL_PATH_EVENT_RESPONSE;       //主控快速回复
UIKIT_EXTERN NSString * const RB_URL_PATH_MSG_MESSAGE_MSGLIST;  //获取消息列表
UIKIT_EXTERN NSString * const RB_URL_ACTION_BIND_ACCEPT;        //同意绑定
UIKIT_EXTERN NSString * const RB_URL_ACTION_BIND_REJECT;        //拒绝绑定
UIKIT_EXTERN NSString * const RB_URL_PATH_DIY;                  //用户 DIY 主控回答
UIKIT_EXTERN NSString * const RB_URL_PATH_REMIND;               //用户定时提醒
UIKIT_EXTERN NSString * const RB_URL_FAMILY_MOMENT;             //家庭动态
UIKIT_EXTERN NSString * const RB_URL_PATH_COLLECTION;           //收藏列表
UIKIT_EXTERN NSString * const RB_URL_PATH_OPERATE;              //图片运营
UIKIT_EXTERN NSString * const RB_URL_GETQRCODE;                 //获取二维码
UIKIT_EXTERN NSString * const RB_URL_PATH_SETTING;              //设置
UIKIT_EXTERN NSString * const RB_URL_PATH_SHARE;                //分享
UIKIT_EXTERN NSString * const URL_PATH_HOME_INDEX;              //模块列表 专辑列表
UIKIT_EXTERN NSString * const URL_PATH_HOME_SCREEN;              //闪屏
UIKIT_EXTERN NSString * const URL_PATH_USERS_HISTORY;              // 收藏列表中的历史记录
UIKIT_EXTERN NSString * const URL_PATH_USERS_INTERSTORY;              //  互动故事
UIKIT_EXTERN NSString * const URL_PATH_USERS_BABY;              //成长计划
UIKIT_EXTERN NSString * const URL_PATH_DEVICE_VERSION;              //
UIKIT_EXTERN NSString * const URL_PATH_DEVICE_UPDATE;
UIKIT_EXTERN NSString * const URL_PATH_CHECK;
UIKIT_EXTERN NSString * const URL_PATH_USER_LESSON;
UIKIT_EXTERN NSString * const URL_PATH_DEV_INFO;
UIKIT_EXTERN NSString * const URL_PATH_USER_RESOURCE;
UIKIT_EXTERN NSString * const URL_PATH_USER_FANGCHENMI;
UIKIT_EXTERN NSString * const URL_PATH_COURSE;                      // 课程表
UIKIT_EXTERN NSString * const URL_PATH_VIDEO;                       //视频
UIKIT_EXTERN NSString * const URL_PATH_CHAT;                //微聊
UIKIT_EXTERN NSString * const URL_PATH_WAVES;            //布丁X声波配网

#define RBNetConfigManager [RBNetConfig sharedManager]
@interface RBNetConfig : NSObject
/** 客户端当前环境 */
@property (nonatomic, assign) RBClientEnvState rb_client_env_state;

/** 网络链接唯一标识 */
@property (nonatomic, strong) NSString * rb_net_once_Identifier;


/** 测试的唯一标示 */
@property (nonatomic, strong) NSString * rb_Identifier_Develop;
/** 企业的唯一标示 */
@property (nonatomic, strong) NSString * rb_Identifier_Inhouse;
/** 内侧的唯一标识 */
@property (nonatomic, strong) NSString * rb_Identifier_AdHoc;
/** 线上的唯一标识 */
@property (nonatomic, strong) NSString * rb_Identifier_Online;

/** 用户类名称 */
@property (nonatomic, strong) NSString * rb_userHandleClsName;

/** 开发服务器地址 */
@property (nonatomic, strong) NSString * rb_url_host_develop;
/** 测试服务器地址 */
@property (nonatomic, strong) NSString * rb_url_host_Test;
/** 线上服务器地址 */
@property (nonatomic, strong) NSString * rb_url_host_Online;


/** 测试视频服务器地址 */
@property (nonatomic, strong) NSString * rb_url_video_Test;
/** 线上视频服务器地址 */
@property (nonatomic, strong) NSString * rb_url_video_Online;

/** 开发升级服务器地址 */
@property (nonatomic, strong) NSString * rb_url_update_develop;
/** 测试升级服务器地址 */
@property (nonatomic, strong) NSString * rb_url_update_Test;
/** 线上升级服务器地址 */
@property (nonatomic, strong) NSString * rb_url_update_Online;

/** 开发反馈服务器地址 */
@property (nonatomic, strong) NSString * rb_url_feedback_develop;
/** 测试反馈服务器地址 */
@property (nonatomic, strong) NSString * rb_url_feedback_Test;
/** 线上反馈服务器地址 */
@property (nonatomic, strong) NSString * rb_url_feedback_Online;

/** 开发打点服务器地址 */
@property (nonatomic, strong) NSString * rb_url_stat_develop;
/** 测试打点服务器地址 */
@property (nonatomic, strong) NSString * rb_url_stat_Test;
/** 线上打点服务器地址 */
@property (nonatomic, strong) NSString * rb_url_stat_Online;

/** 开发崩溃服务器地址 */
@property (nonatomic, strong) NSString * rb_url_crash_develop;
/** 测试崩溃服务器地址 */
@property (nonatomic, strong) NSString * rb_url_crash_Test;
/** 线上崩溃服务器地址 */
@property (nonatomic, strong) NSString * rb_url_crash_Online;




/** 企业版本渠道号 */
@property (nonatomic, assign) NSInteger rb_channelId_Inhouse;
/** 内侧版本渠道号 */
@property (nonatomic, assign) NSInteger rb_channelId_AdHoc;
/** 线上版本渠道号 */
@property (nonatomic, assign) NSInteger rb_channelId_Online;
/** 测试版本渠道号 */
@property (nonatomic, assign) NSInteger rb_channelId_Develop;






+(instancetype)sharedManager;

@end
