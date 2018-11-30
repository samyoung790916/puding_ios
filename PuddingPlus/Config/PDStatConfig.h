//
//  RBStatConfig.h
//
//  Created by MC on 16/4/18.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark - APP
/** 关于 App */
UIKIT_EXTERN NSString * PD_App_Install;//安装 App
UIKIT_EXTERN NSString * PD_App_Start;//打开 App
UIKIT_EXTERN NSString * PD_App_Duration;//App 使用时长


#pragma mark - 配网
/** 配网 */
UIKIT_EXTERN NSString * PD_Config_Enter;//进入配网
UIKIT_EXTERN NSString * PD_Config_Succeed;//配网成功
UIKIT_EXTERN NSString * PD_Config_Failed;//配网失败

#pragma mark - 宝宝成就

UIKIT_EXTERN NSString * PD_HOME_INTO_BABY;//宝宝信息（首页内容点击）
UIKIT_EXTERN NSString * PD_HOME_SCORE_MORE;//更多宝宝成就（更多入口）

#pragma mark - 宝宝动态

UIKIT_EXTERN NSString * PD_HOME_BABY_DYSM;//宝宝动态（首页内容点击）
UIKIT_EXTERN NSString * PD_HOME_BABY_DYSM_MORE;//更多宝宝动态（更多入口）
UIKIT_EXTERN NSString * PD_FamilyDynamic_Video_Click;//通话视频（进入更多宝宝动态）***
UIKIT_EXTERN NSString * PD_FamilyDynamic_Pic_Click;//家庭动态列表-点击大图	120
UIKIT_EXTERN NSString * PD_FamilyDynamic_video_play;//宝宝动态视频
UIKIT_EXTERN NSString * PD_DYSM_BABY_VOICE;//点击音频（宝宝动态查看录音）
UIKIT_EXTERN NSString * PD_SHARE;//分享（宝宝动态视频/照片分享）
UIKIT_EXTERN NSString * PD_SHARE_RESULT;//分享（宝宝动态视频/照片分享）

#pragma mark - 双语课程

UIKIT_EXTERN NSString * PD_HOME_ENGLISH;//双语课程（首页资源点击
UIKIT_EXTERN NSString * PD_HOME_ENGLISH_MORE;//更多双语课程（更多入口）

#pragma mark - 心里模型

UIKIT_EXTERN NSString * PD_BABY_DEVELOP_RESOUSE;//心里模型（首页资源点击）
UIKIT_EXTERN NSString * PD_BABY_DEVELOP_DETAIL;//成长建议详情

#pragma mark - 宝宝必听

UIKIT_EXTERN NSString * PD_HOME_BABY_COLLECTION;//宝宝必听（首页资源点击）
UIKIT_EXTERN NSString * PD_HOME_BABY_COLLECTION_MORE;//更多宝宝必听（更多入口）

#pragma mark - 宝宝喜欢

UIKIT_EXTERN NSString * PD_HOME_BABY_HISTORY;//宝宝喜欢（首页资源点击）
UIKIT_EXTERN NSString * PD_HOME_BABY_HISTORY_MORE;//更多宝宝喜欢（更多入口)

#pragma mark - 布丁优选

UIKIT_EXTERN NSString * PD_HOME_CONTENT_CHOOSE_MORE;//更多布丁优选（首页快捷入口）
UIKIT_EXTERN NSString * PD_HOME_CONTENT_CHOOSE;//布丁优选（ICON入口）

#pragma mark - 扮演布丁

UIKIT_EXTERN NSString * PD_Home_Send;//扮演布丁
UIKIT_EXTERN NSString * PD_Send_Habit;//习惯培养
UIKIT_EXTERN NSString * PD_Send_Face;//布丁表情
UIKIT_EXTERN NSString * PD_Send_Fun;//搞笑逗趣
UIKIT_EXTERN NSString * PD_Send_Voice;//趣味变声
UIKIT_EXTERN NSString * PD_Send_SEND_MEDIA_EXPRSSION;//动画表情（视频通话动画表情发送）
UIKIT_EXTERN NSString * PD_Send_Text;//近场 TTS 点击发送
UIKIT_EXTERN NSString * PD_Send_History;//历史记录
UIKIT_EXTERN NSString * PD_Home_Diy;//调教布丁
UIKIT_EXTERN NSString * PD_Diy_Add;//调教布丁增加
UIKIT_EXTERN NSString * PD_Diy_Delete;//调教布丁删除
UIKIT_EXTERN NSString * PD_Send_SEND_MEDIA_EXPRSSION_SCUESS;//动画表情（发送成功）
UIKIT_EXTERN NSString * PD_Send_VOICE_SCUESS;//语音（发送成功）



#pragma mark - 视频通话


UIKIT_EXTERN NSString * PD_Home_Video;//视频通话
UIKIT_EXTERN NSString * PD_VIDEO_TALK;//双向视频（进入视频聊天）,
UIKIT_EXTERN NSString * PD_Video_Connect_Speak;//打开语音通话
UIKIT_EXTERN NSString * PD_Video_Connect_Suc;//视频连接成功
UIKIT_EXTERN NSString * PD_Video_Connect_Failed;//视频连接失败
UIKIT_EXTERN NSString * PD_Video_ScreenVideo;//视频录像
UIKIT_EXTERN NSString * PD_Video_ScreenShot;//视频截图
UIKIT_EXTERN NSString * PD_Video_Turn;//远程旋转
UIKIT_EXTERN NSString * PD_Video_Send_Habit;//习惯培养
UIKIT_EXTERN NSString * PD_Video_Face;//点击布丁表情 0
UIKIT_EXTERN NSString * PD_Video_Fun;//搞笑逗趣 0
UIKIT_EXTERN NSString * PD_Video_Voice;//趣味变声 0
UIKIT_EXTERN NSString * PD_VIDEO_SEND_MEDIA_EXPRSSION;//动画表情（视频通话动画表情发送）
UIKIT_EXTERN NSString * PD_VIDEO_SEND_MUSIC;//点播音乐（视频通话中点播歌曲）
UIKIT_EXTERN NSString * PD_Video_Send_Text;//近场 TTS 点击发送 ,TTS（视频通话TTS发送）
UIKIT_EXTERN NSString * PD_Video_History;//历史记录 0
UIKIT_EXTERN NSString * PD_VIDEO_SEND_MEDIA_EXPRSSION_SCUESS;//动画表情（发送成功）
UIKIT_EXTERN NSString * PD_VIDEO_VOICE_SCUESS;//语音（发送成功）

#pragma mark - 侧边栏

UIKIT_EXTERN NSString * PD_Home_Info;//进入侧边栏
UIKIT_EXTERN NSString * PD_SETTING_ACCOUNT;//我的账户
UIKIT_EXTERN NSString * PD_SETTING_MESSAGE;//消息中心
UIKIT_EXTERN NSString * PD_SETTING_MEMBER;//成员管理
UIKIT_EXTERN NSString * PD_SETTING_PUDDING;//布丁设置
UIKIT_EXTERN NSString * PD_Home_Setting_Voice;//布丁音量调节
UIKIT_EXTERN NSString * PD_Home_Info_Add;//添加布丁


#pragma mark - 布丁设置


UIKIT_EXTERN NSString * PD_Setting_Pudding_Name;//修改布丁名称
UIKIT_EXTERN NSString * PD_SETTING_PUDDING_VOICE_TYPE;//布丁音效--怀旧版
UIKIT_EXTERN NSString * PD_SETTING_BABY_INFO;//宝宝信息
UIKIT_EXTERN NSString * PD_Setting_Pudding_Net;//修改布丁网络
UIKIT_EXTERN NSString * PD_SETTING_NIGHT_MODLE;//夜间模式开启
UIKIT_EXTERN NSString * PD_SETTING_NIGHT_TIME;//夜间模式时段
UIKIT_EXTERN NSString * PD_SETTING_LOOK_MODLE;//看家模式开启（人数）
UIKIT_EXTERN NSString * PD_SETTING_VIDEO_TIP;//远程视频提示音开启
UIKIT_EXTERN NSString * PD_Setting_Pudding_Update;//布丁系统升级

#pragma mark - 点播
UIKIT_EXTERN NSString * PD_SOURCE_PLAY;//点播
UIKIT_EXTERN NSString * PD_PlayDetail_Play_Collect;//播放详情页-收藏 133

#pragma mark - 主控发起视频通话
UIKIT_EXTERN NSString * PD_PUDDING_VIDEO_START;//立即开启-实时视频
UIKIT_EXTERN NSString * PD_PUDDING_VIDEO_CANCEL;//取消-实时视频

#pragma mark - 运营广告
UIKIT_EXTERN NSString * PD_Operating_Content;//运营广告弹窗
UIKIT_EXTERN NSString * PD_Operating_Click;//运营广告弹窗点击

#pragma mark - 首页通知栏

UIKIT_EXTERN NSString * PD_Home_Talk;//状态气泡

#pragma mark - 闪屏

UIKIT_EXTERN NSString * PD_LAUNCH_SPLASH_SHOW;//闪屏页展示
UIKIT_EXTERN NSString * PD_LAUNCH_SPLASH_SKIP;//闪屏跳过


#pragma mark -闹钟
UIKIT_EXTERN NSString * PD_MORNING_ALARM_VIEW;//早安闹钟（ICON点击）
UIKIT_EXTERN NSString * PD_MORNING_ALARM_SET;//设置早安闹钟（点击闹钟设置）
UIKIT_EXTERN NSString * PD_MORNING_ALARM_MUSIC;//早安轻音乐试听
UIKIT_EXTERN NSString * PD_MORNING_ALARM_SONG;//英语儿歌试听
UIKIT_EXTERN NSString * PD_MORNING_ALARM_HABIT;//生活习惯儿歌试听
UIKIT_EXTERN NSString * PD_MORNING_ALARM_VOICE;//更改默认闹钟声音
UIKIT_EXTERN NSString * PD_MORNING_ALARM_SAVE;//早安闹钟保存设置
UIKIT_EXTERN NSString * PD_NIGHT_ALARM_HABIT;//晚安闹钟（ICON点击）
UIKIT_EXTERN NSString * PD_NIGHT_ALARM_SET;//设置晚安闹钟（点击闹钟设置）
UIKIT_EXTERN NSString * PD_NIGHT_ALARM_STORY;//晚安故事试听
UIKIT_EXTERN NSString * PD_NIGHT_ALARM_MUSIC;//晚安轻音乐试听
UIKIT_EXTERN NSString * PD_NIGHT_ALARM_SAVE;//晚安故事保存设置

#pragma mark - 消息提示
UIKIT_EXTERN NSString * PD_MAIN_MESS_ALTER;//主控信息通知条
#pragma mark - 绘本
UIKIT_EXTERN NSString * PD_MAIN_BOOK_MORE;//宝宝书架更多
UIKIT_EXTERN NSString * PD_BOOK_CASE_READ_MORE;//最近阅读更多
UIKIT_EXTERN NSString * PD_BOOK_CASE_ALL_MORE;//全部书籍更多
UIKIT_EXTERN NSString * PD_BOOK_CLICK;//书籍打点
#pragma mark - 视频连接信息
UIKIT_EXTERN NSString * PD_VIDEO_CONNECT_INFO;//主控信息通知条
#pragma mark -搜索
UIKIT_EXTERN NSString * PD_SEARCH_ALL_SINGLE_CLICK;//搜索单曲点播次数
UIKIT_EXTERN NSString * PD_SEARCH_ALL_ALBUM_CLICK;//搜索专辑点播次数
UIKIT_EXTERN NSString * PD_SEARCH_ALL_ALBUM_CLICK_MORE;//搜索“专辑更多”按钮点击次数
UIKIT_EXTERN NSString * PD_SEARCH_ALL_SINGLE_CLICK_MORE;//搜索“单曲更多”按钮点击次数
UIKIT_EXTERN NSString * PD_SEARCH_ALL_SEARCH_TIMES;//搜索次数
UIKIT_EXTERN NSString * PD_SEARCH_SINGLE_SEARCH_TIMES;//搜索更多单曲次数
UIKIT_EXTERN NSString * PD_SEARCH_SINGLE_ALBUM_TIMES;//搜索更多专辑次数
UIKIT_EXTERN NSString * PD_SEARCH_MORE_SINGLE_CLICK;//搜索更多单曲点播次数
UIKIT_EXTERN NSString * PD_SEARCH_MORE_ALBUM_CLICK;//搜索更多专辑点播次数
NSString * loadDesTxt(NSString * str);
