//
// RBNetworkConfig.m
// Roobo
//
// Created by mengchen on 16/9/28.
// Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBNetConfig.h"
#import "NSString+RBExtension.h"
#pragma mark - 服务器地址
NSString * const RB_URL_HOST_Develop = @"http://dev.roobo.com.cn/pd1s-api-search-weekage";//开发服务器
NSString * const RB_URL_HOST_Test = @"http://t1.roobo.net";                 //测试服务器
NSString * const RB_URL_HOST_Online = @"https://pds-api.roo.bo";             //线上服务器

#pragma mark - 视频服务器地址
NSString * const RB_VIDEOSOCKET_Test = @"wss://v3-test.roobo.net:8080/ws";  //视频服务器测试环境
NSString * const RB_VIDEOSOCKET_Online = @"wss://v3.roo.bo/ws";             //视频服务器线上环境

#pragma mark - 升级服务器地址
NSString * const RB_UPDATE_Develop = @"http://dev.roobo.com.cn/update";     //升级服务器开发环境
NSString * const RB_UPDATE_Test = @"http://update.roobo.net";               //升级服务器测试环境
NSString * const RB_UPDATE_Online = @"http://update.roo.bo/v1";             //升级服务器线上环境

#pragma mark - 反馈服务器地址
NSString * const RB_FEEDBACK_Develop = @"http://dev.roobo.com.cn/pudding1s/feedback";   //反馈服务器开发环境
NSString * const RB_FEEDBACK_Test = @"http://pd1s.roobo.net/feedback";                  //反馈服务器测试环境
NSString * const RB_FEEDBACK_Online = @"http://feedback.roo.bo/v1/feedback";            //反馈服务器线上环境

#pragma mark - 打点服务器地址
NSString * const RB_STAT_Develop = @"http://dev.roobo.com.cn/pudding1s/logger";     //打点服务器开发环境
NSString * const RB_STAT_Test = @"http://pd1s.roobo.net/logger";                    //打点服务器测试环境
NSString * const RB_STAT_Online = @"http://st.roo.bo/logger";                       //打点服务器线上环境

#pragma mark - 日志异常日志

NSString * const RB_VIDEO_ERROR = @"http://logger.roo.bo/logger";


#pragma mark - 崩溃服务器地址
NSString * const RB_CRASH_Develop = @"http://dev.roobo.com.cn/pudding1s/logger";   //崩溃服务器开发环境
NSString * const RB_CRASH_Test = @"http://pd1s.roobo.net/mainctrls/logger";        //崩溃服务器测试环境
NSString * const RB_CRASH_Online = @"http://crash.roo.bo/logger";                  //崩溃服务器线上环境

#pragma mark - 目录
NSString * const RB_URL_PATH_MASTER_CMD = @"/mainctrls/mctlcmd";            //主控命令
NSString * const RB_URL_PATH_MASTER_INFO = @"/mainctrls/mctlgetter";        //主控信息,获取主控初始化状态，获取主控详情
NSString * const RB_URL_PATH_MASTER_LIST = @"/users/getbindmcs";            //主控列表
NSString * const RB_URL_PATH_MCTL_INFO = @"/mainctrls/mctlinfo";            //修改主控备注
NSString * const RB_URL_PATH_CONFIG_DEFENSE = @"/mainctrls/defense";        //开启/关闭自动布防
NSString * const RB_URL_PATH_NIGHT_MODE  = @"/users/nightmode";             //开启夜间模式
NSString * const RB_URL_PATH_ZBAR_CTRL = @"/factory/info";                  //二维码查询主控
NSString * const RB_URL_PATH_LOGIN = @"/users/login";                       //登录
NSString * const RB_URL_PATH_LOGOUT = @"/users/logout";                     //登出
NSString * const RB_URL_PATH_REGIST = @"/users/regist";                     //注册,检查用户是否注册
NSString * const RB_URL_PATH_VERIFY = @"/users/verify";                     //校验密码是否正确
NSString * const RB_URL_PATH_AUTHCODE = @"/users/authcode";                 //发送验证码
NSString * const RB_URL_PATH_UPDATE_USER_INFO = @"/users/info";             //用户信息，修改头像，更新pushId，修改手机号，修改自己名，修改他人备注
NSString * const RB_URL_PATH_UPDATE_USER_PASSWORD = @"/users/password";     //修改密码，修改密码，重置密码
NSString * const RB_URL_PATH_ENTER_LEAVE_HOME = @"/users/enterleave";       //回家，离家
NSString * const RB_URL_PATH_DELETE_MESSAGE_LIST = @"/messages/msglist";    //删除消息列表
NSString * const RB_URL_PATH_LAST_VIDEO_MESSAGE = @"/users/video";    //视频消息
NSString * const RB_URL_PATH_BIND_MASTER = @"/mainctrls/mcbind";            //绑定主控，绑定主控，邀请绑定，管理员删除他人绑定，自己退出绑定，拒绝绑定，同意绑定
NSString * const RB_URL_PATH_UPLOAD_IMAGE = @"/users/upload";               //上传头像
NSString * const RB_URL_PATH_EVENT_RESPONSE = @"/mainctrls/response";       //主控回复
NSString * const RB_URL_PATH_MSG_MESSAGE_MSGLIST = @"/messages/msglist";    //获取消息列表
NSString * const RB_URL_ACTION_BIND_ACCEPT = @"allowbind";                  //同意绑定
NSString * const RB_URL_ACTION_BIND_REJECT = @"denybind";                   //拒绝绑定
NSString * const RB_URL_PATH_DIY = @"/users/custom";                        //用户DIY 主控回答
NSString * const RB_URL_PATH_REMIND = @"/users/remind";                     //用户定时提醒
NSString * const RB_URL_FAMILY_MOMENT  = @"/mainctrls/moment";              //家庭动态
NSString * const RB_URL_PATH_COLLECTION = @"/users/favorites";              //收藏列表
NSString * const RB_URL_PATH_OPERATE = @"/home/guide";                      //图片运营
NSString * const RB_URL_GETQRCODE = @"/qrcode";                             //获取二维码
NSString * const RB_URL_PATH_SETTING = @"/mainctrls/settings";              //设置
NSString * const RB_URL_PATH_SHARE = @"/users/share";                       //分享
NSString * const URL_PATH_HOME_INDEX = @"/home/index";                       //模块列表 专辑列表
NSString * const URL_PATH_HOME_SCREEN = @"/home/screen";                       //闪屏
NSString * const URL_PATH_USERS_HISTORY = @"/users/history";                       // 收藏列表中的历史记录
NSString * const URL_PATH_USERS_INTERSTORY = @"/mainctrls/interstory";                       // 互动故事
NSString * const URL_PATH_USERS_BABY = @"/users/baby" ;//成长计划
NSString * const URL_PATH_DEVICE_VERSION = @"/version" ;
NSString * const URL_PATH_DEVICE_UPDATE = @"/update" ;
NSString * const URL_PATH_CHECK = @"/check" ;
NSString * const URL_PATH_DEV_INFO = @"/mainctrls/devinfo" ;
NSString * const URL_PATH_USER_LESSON = @"/users/lesson" ;
NSString * const URL_PATH_USER_RESOURCE = @"/users/resource" ;
NSString * const URL_PATH_USER_FANGCHENMI = @"/users/fangchenmi" ;
NSString * const URL_PATH_COURSE = @"/course" ;                 // 课程表
NSString * const URL_PATH_VIDEO = @"/video/app/getdev" ;                 // 视频
NSString * const URL_PATH_CHAT = @"/users/chat";        //微聊
NSString * const URL_PATH_WAVES = @"/wifi/waves";            //布丁X声波配网
@implementation RBNetConfig



+(instancetype)sharedManager{
    return [[self alloc]init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static RBNetConfig * config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [super allocWithZone:zone];
    });
    return config;
}


#pragma mark - action: 获取当前客户端环境状态
-(RBClientEnvState)rb_client_env_state{
    if (!_rb_client_env_state) {
        _rb_client_env_state = RBClientEnvStateInhouse;
    }
    return _rb_client_env_state;
}

static NSString * const kRB_Net_OnceIdentifier = @"Roobo";
-(NSString *)rb_net_once_Identifier{
    NSString * fromString = [[NSString stringWithFormat:@"%@%.0f",kRB_Net_OnceIdentifier,[[NSDate date] timeIntervalSince1970]] md5String];
    return fromString;
}

@end
