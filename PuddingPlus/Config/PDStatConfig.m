//
//  RBStatConfig.m
//
//  Created by MC on 16/4/18.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "PDStatConfig.h"
//((#pragma mark)[\w+|\s+]-([\w+|\s+]\w+)?)
//(/\*\*[\s\w]+\*/)
//^\n[\s| ]*                     替换空行
//(NSString \* )      {"key":"               修改key
//(=@)      ","value":               修改key
//(;//)      ,"des":"               修改key
//(\n[\s| ]*)      "},              修改key
// 删除后多余的，前后添加[]

#pragma mark - APP
/** 关于 App */
NSString * PD_App_Install=@"2";//安装 App
NSString * PD_App_Start=@"1";//打开 App
NSString * PD_App_Duration=@"3";//App 使用时长


#pragma mark - 配网
/** 配网 */
NSString * PD_Config_Enter=@"4";//进入配网
NSString * PD_Config_Succeed=@"5";//配网成功
NSString * PD_Config_Failed=@"6";//配网失败

#pragma mark - 宝宝成就

NSString * PD_HOME_INTO_BABY=@"200";//宝宝信息（首页内容点击）
NSString * PD_HOME_SCORE_MORE=@"201";//更多宝宝成就（更多入口）

#pragma mark - 宝宝动态

NSString * PD_HOME_BABY_DYSM=@"202";//宝宝动态（首页内容点击）
NSString * PD_HOME_BABY_DYSM_MORE=@"203";//更多宝宝动态（更多入口）
NSString * PD_FamilyDynamic_Video_Click=@"119";//家庭动态列表-进入实时视频119
NSString * PD_FamilyDynamic_Pic_Click=@"120";//家庭动态列表-点击大图120
NSString * PD_FamilyDynamic_video_play=@"164";//宝宝动态视频
NSString * PD_DYSM_BABY_VOICE=@"204";//点击音频（宝宝动态查看录音）
NSString * PD_SHARE=@"165";//分享（宝宝动态视频/照片分享）
NSString * PD_SHARE_RESULT=@"205";//分享（宝宝动态视频/照片分享）

#pragma mark - 双语课程

NSString * PD_HOME_ENGLISH=@"206";//双语课程（首页资源点击
NSString * PD_HOME_ENGLISH_MORE=@"207";//更多双语课程（更多入口）

#pragma mark - 心里模型

NSString * PD_BABY_DEVELOP_RESOUSE=@"188";//心里模型（首页资源点击）
NSString * PD_BABY_DEVELOP_DETAIL=@"189";//成长建议详情

#pragma mark - 宝宝必听

NSString * PD_HOME_BABY_COLLECTION=@"208";//宝宝必听（首页资源点击）
NSString * PD_HOME_BABY_COLLECTION_MORE=@"209";//更多宝宝必听（更多入口）

#pragma mark - 宝宝喜欢

NSString * PD_HOME_BABY_HISTORY=@"210";//宝宝喜欢（首页资源点击）
NSString * PD_HOME_BABY_HISTORY_MORE=@"211";//更多宝宝喜欢（更多入口)

#pragma mark - 布丁优选

NSString * PD_HOME_CONTENT_CHOOSE_MORE=@"212";//更多布丁优选（首页快捷入口）
NSString * PD_HOME_CONTENT_CHOOSE=@"213";//布丁优选（ICON入口）

#pragma mark - 扮演布丁

NSString * PD_Home_Send=@"11";//扮演布丁
NSString * PD_Send_Habit=@"108";//习惯培养
NSString * PD_Send_Face=@"15";//布丁表情
NSString * PD_Send_Fun=@"16";//搞笑逗趣
NSString * PD_Send_Voice=@"17";//趣味变声
NSString * PD_Send_SEND_MEDIA_EXPRSSION=@"214";//动画表情（视频通话动画表情发送）
NSString * PD_Send_Text=@"14";//近场 TTS 点击发送
NSString * PD_Send_History=@"18";//历史记录
NSString * PD_Home_Diy=@"13";//调教布丁
NSString * PD_Diy_Add=@"35";//调教布丁增加
NSString * PD_Diy_Delete=@"37";//调教布丁删除
NSString * PD_Send_SEND_MEDIA_EXPRSSION_SCUESS=@"235";//动画表情（发送成功）
NSString * PD_Send_VOICE_SCUESS=@"236";//语音（发送成功）



#pragma mark - 视频通话


NSString * PD_Home_Video=@"12";//视频通话
NSString * PD_VIDEO_TALK=@"215";//双向视频（进入视频聊天）,
NSString * PD_Video_Connect_Speak=@"21";//打开语音通话
NSString * PD_Video_Connect_Suc=@"19";//视频连接成功
NSString * PD_Video_Connect_Failed=@"20";//视频连接失败
NSString * PD_Video_ScreenVideo=@"24";//视频录像
NSString * PD_Video_ScreenShot=@"25";//视频截图
NSString * PD_Video_Turn=@"26";//远程旋转
NSString * PD_Video_Send_Habit=@"29";//习惯培养
NSString * PD_Video_Face=@"30";//点击布丁表情 0
NSString * PD_Video_Fun=@"31";//搞笑逗趣 0
NSString * PD_Video_Voice=@"32";//趣味变声 0
NSString * PD_VIDEO_SEND_MEDIA_EXPRSSION=@"216";//动画表情（视频通话动画表情发送）
NSString * PD_VIDEO_SEND_MUSIC=@"217";//点播音乐（视频通话中点播歌曲）
NSString * PD_Video_Send_Text=@"28";//近场 TTS 点击发送 ,TTS（视频通话TTS发送）
NSString * PD_Video_History=@"33";//历史记录 0
NSString * PD_VIDEO_SEND_MEDIA_EXPRSSION_SCUESS=@"237";//动画表情（发送成功）
NSString * PD_VIDEO_VOICE_SCUESS=@"238";//语音（发送成功）

#pragma mark - 侧边栏

NSString * PD_Home_Info=@"7";//进入侧边栏
NSString * PD_SETTING_ACCOUNT=@"218";//我的账户
NSString * PD_SETTING_MESSAGE=@"219";//消息中心
NSString * PD_SETTING_MEMBER=@"220";//成员管理
NSString * PD_SETTING_PUDDING=@"221";//布丁设置
NSString * PD_Home_Setting_Voice=@"62";//布丁音量调节
NSString * PD_Home_Info_Add=@"63";//添加布丁


#pragma mark - 布丁设置


NSString * PD_Setting_Pudding_Name=@"49";//修改布丁名称
NSString * PD_SETTING_PUDDING_VOICE_TYPE=@"225";//布丁音效--怀旧版
NSString * PD_SETTING_BABY_INFO=@"226";//宝宝信息
NSString * PD_Setting_Pudding_Net=@"51";//修改布丁网络
NSString * PD_SETTING_NIGHT_MODLE=@"228";//夜间模式开启
NSString * PD_SETTING_NIGHT_TIME=@"229";//夜间模式时段
NSString * PD_SETTING_LOOK_MODLE=@"230";//看家模式开启
NSString * PD_SETTING_VIDEO_TIP=@"231";//远程视频提示音
NSString * PD_Setting_Pudding_Update=@"60";//布丁系统升级

#pragma mark - 点播
NSString * PD_SOURCE_PLAY=@"232";//点播
NSString * PD_PlayDetail_Play_Collect=@"133";//播放详情页-收藏 133

#pragma mark - 主控发起视频通话
NSString * PD_PUDDING_VIDEO_START=@"181";//立即开启-实时视频
NSString * PD_PUDDING_VIDEO_CANCEL=@"182";//取消-实时视频

#pragma mark - 运营广告
NSString * PD_Operating_Content=@"233";//运营广告弹窗
NSString * PD_Operating_Click=@"234";//运营广告弹窗点击

#pragma mark - 首页通知栏

NSString * PD_Home_Talk=@"10";//状态气泡

#pragma mark - 闪屏

NSString * PD_LAUNCH_SPLASH_SHOW=@"183";//闪屏页展示
NSString * PD_LAUNCH_SPLASH_SKIP=@"184";//闪屏跳过

#pragma mark -闹钟
NSString * PD_MORNING_ALARM_VIEW=@"152";//早安闹钟（ICON点击）
NSString * PD_MORNING_ALARM_SET=@"153";//设置早安闹钟（点击闹钟设置）
NSString * PD_MORNING_ALARM_MUSIC=@"154";//早安轻音乐试听
NSString * PD_MORNING_ALARM_SONG=@"155";//英语儿歌试听
NSString * PD_MORNING_ALARM_HABIT=@"241";//生活习惯儿歌试听
NSString * PD_MORNING_ALARM_VOICE=@"242";//更改默认闹钟声音
NSString * PD_MORNING_ALARM_SAVE=@"243";//早安闹钟保存设置
NSString * PD_NIGHT_ALARM_HABIT=@"159";//晚安闹钟（ICON点击）
NSString * PD_NIGHT_ALARM_SET=@"160";//设置晚安闹钟（点击闹钟设置）
NSString * PD_NIGHT_ALARM_STORY=@"161";//晚安故事试听
NSString * PD_NIGHT_ALARM_MUSIC=@"244";//晚安轻音乐试听
NSString * PD_NIGHT_ALARM_SAVE=@"245";//晚安故事保存设置

#pragma mark - 消息提示
NSString * PD_MAIN_MESS_ALTER=@"240";//主控信息通知条

#pragma mark - 绘本
NSString * PD_MAIN_BOOK_MORE=@"246";//宝宝书架更多
NSString * PD_BOOK_CASE_READ_MORE=@"247";//最近阅读更多
NSString * PD_BOOK_CASE_ALL_MORE=@"248";//全部书籍更多
NSString * PD_BOOK_CLICK=@"250";//书籍打点


#pragma mark - 视频连接信息
NSString * PD_VIDEO_CONNECT_INFO=@"300";//主控信息通知条
#pragma mark -

#pragma mark - 搜索
NSString * PD_SEARCH_ALL_SINGLE_CLICK=@"301";//搜索单曲点播次数
NSString * PD_SEARCH_ALL_ALBUM_CLICK=@"302";//搜索专辑点播次数
NSString * PD_SEARCH_ALL_ALBUM_CLICK_MORE=@"303";//搜索“专辑更多”按钮点击次数
NSString * PD_SEARCH_ALL_SINGLE_CLICK_MORE=@"304";//搜索“单曲更多”按钮点击次数
NSString * PD_SEARCH_ALL_SEARCH_TIMES=@"305";//搜索次数
NSString * PD_SEARCH_SINGLE_SEARCH_TIMES=@"306";//搜索更多单曲次数
NSString * PD_SEARCH_SINGLE_ALBUM_TIMES=@"307";//搜索更多专辑次数
NSString * PD_SEARCH_MORE_SINGLE_CLICK=@"308";//搜索更多单曲点播次数
NSString * PD_SEARCH_MORE_ALBUM_CLICK=@"309";//搜索更多专辑点播次数

NSString * loadDesTxt(NSString * str){
    static NSArray * contentInfo ;
    if(contentInfo== nil){
      NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Statconfig" ofType:@"json"];
      contentInfo=[[NSData dataWithContentsOfFile:dataPath] jsonValueDecoded];
    }
    
    if(contentInfo){
        for(NSDictionary * dict in contentInfo){
            if([[dict objectForKey:@"value"] isEqualToString:str]){
                return [NSString stringWithFormat:@"track -->%@ ,id-->%@",[dict objectForKey:@"des"],str];
            }
        }
    }
    return @"";
}

