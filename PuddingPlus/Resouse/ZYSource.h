#import <Foundation/Foundation.h>

#define R [ZYSource getInstanse]
@interface ZYSource : NSObject

+ (ZYSource *)getInstanse;


/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:about_pudding
 *  
 *  
 *  Value:关于布丁;lan:en
 */
@property (nonatomic, strong, readonly) NSString * about_pudding ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:add_new_pudding
 *  
 *  
 *  Value:添加新布丁;lan:en
 */
@property (nonatomic, strong, readonly) NSString * add_new_pudding ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:add_pudding
 *  
 *  
 *  Value:添加布丁;lan:en
 */
@property (nonatomic, strong, readonly) NSString * add_pudding ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:already_bind_tip
 *  
 *  
 *  Value:这台布丁已被%@绑定，请联系他邀请你。;lan:en
 */
@property (nonatomic, strong, readonly) NSString * already_bind_tip ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:already_bind_tip_contact
 *  
 *  
 *  Value:这台布丁已被其他人绑定，请联系他邀请你.;lan:en
 */
@property (nonatomic, strong, readonly) NSString * already_bind_tip_contact ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:baby_dynamic
 *  
 *  
 *  Value:当宝宝出现在布丁镜头前时，将为您自动拍摄影像，并推送至宝宝动态中;lan:en
 */
@property (nonatomic, strong, readonly) NSString * baby_dynamic ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:big_voice_tip
 *  
 *  
 *  Value:我们会调大您手机的音量，方便布丁更好的接收到您发送的WiFi信息;lan:en
 */
@property (nonatomic, strong, readonly) NSString * big_voice_tip ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:bind_scuess
 *  
 *  
 *  Value:布丁绑定成功;lan:en
 */
@property (nonatomic, strong, readonly) NSString * bind_scuess ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:buding
 *  
 *  
 *  Value:布丁;lan:en
 */
@property (nonatomic, strong, readonly) NSString * buding ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:config_net_error_tip
 *  
 *  
 *  Value:1.请确认WiFi密码正确\n2.请将手机尽量靠近布丁\n3.请查看其它解决办法;lan:en
 */
@property (nonatomic, strong, readonly) NSString * config_net_error_tip ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:config_net_scuess
 *  
 *  
 *  Value:布丁网络配置成功;lan:en
 */
@property (nonatomic, strong, readonly) NSString * config_net_scuess ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:config_net_wait_tip
 *  
 *  
 *  Value:布丁正在连接网络\n连接过程大约需要1-2分钟，请耐心等待;lan:en
 */
@property (nonatomic, strong, readonly) NSString * config_net_wait_tip ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:connet_power
 *  
 *  
 *  Value:请将布丁连接电源线;lan:en
 */
@property (nonatomic, strong, readonly) NSString * connet_power ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:content_select
 *  
 *  
 *  Value:布丁优选;lan:en
 */
@property (nonatomic, strong, readonly) NSString * content_select ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:funny_story
 *  
 *  
 *  Value:趣味双语互动，布丁陪宝宝练口语，起床不在困难。;lan:en
 */
@property (nonatomic, strong, readonly) NSString * funny_story ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:near_pudding
 *  
 *  
 *  Value:请将手机按图示方式靠近布丁，\n给布丁发送语音指令;;lan:en
 */
@property (nonatomic, strong, readonly) NSString * near_pudding ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:night_tip
 *  
 *  
 *  Value:小贴士：布丁在开机状态且未贴休眠帖时才能为宝宝讲晚安故事;lan:en
 */
@property (nonatomic, strong, readonly) NSString * night_tip ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:not_hear_tip
 *  
 *  
 *  Value:没听到布丁提示，重新发送;lan:en
 */
@property (nonatomic, strong, readonly) NSString * not_hear_tip ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:not_hear_tip_say
 *  
 *  
 *  Value:没有听到布丁说“布丁收到了” 重新发送;lan:en
 */
@property (nonatomic, strong, readonly) NSString * not_hear_tip_say ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:not_support_5g_net
 *  
 *  
 *  Value:布丁暂不支持5G频段的WiFi，请选择2.4G的WiFi后重试;lan:en
 */
@property (nonatomic, strong, readonly) NSString * not_support_5g_net ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:open_power
 *  
 *  
 *  Value:长按开机键开启布丁;lan:en
 */
@property (nonatomic, strong, readonly) NSString * open_power ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:other_config_network
 *  
 *  
 *  Value:如布丁一直不提示布丁已准备好连接网络，请点击“其他方法“试一试;lan:en
 */
@property (nonatomic, strong, readonly) NSString * other_config_network ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:play_pudding
 *  
 *  
 *  Value:扮演布丁;lan:en
 */
@property (nonatomic, strong, readonly) NSString * play_pudding ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:prepare_pudding
 *  
 *  
 *  Value:准备布丁S;lan:en
 */
@property (nonatomic, strong, readonly) NSString * prepare_pudding ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding
 *  
 *  
 *  Value:布丁机器人;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_album
 *  
 *  
 *  Value:布丁相册;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_album ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_alter_sleep
 *  
 *  
 *  Value:布丁会准时提醒宝宝睡觉并送上双语晚安故事和摇篮曲;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_alter_sleep ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_current_new
 *  
 *  
 *  Value:布丁当前无版本更新;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_current_new ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_info
 *  
 *  
 *  Value:布丁信息;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_info ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_is_status
 *  
 *  
 *  Value:布丁已处于此状态;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_is_status ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_new_skills
 *  
 *  
 *  Value:布丁新技能;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_new_skills ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_new_version
 *  
 *  
 *  Value:布丁现在有新版本了，是否立即更新？;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_new_version ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_offline
 *  
 *  
 *  Value:布丁不在线;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_offline ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_score
 *  
 *  
 *  Value:给布丁机器人评个分吧;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_score ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_setting
 *  
 *  
 *  Value:布丁设置;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_setting ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_story_online
 *  
 *  
 *  Value:布丁互动故事独家上线;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_story_online ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_system_upgrade
 *  
 *  
 *  Value:布丁系统升级;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_system_upgrade ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_version
 *  
 *  
 *  Value:布丁版本;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_version ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_version_low
 *  
 *  
 *  Value:目前布丁固件版本过低，无法支持小视频拍摄，快去升级吧;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_version_low ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:pudding_voice
 *  
 *  
 *  Value:布丁音量;lan:en
 */
@property (nonatomic, strong, readonly) NSString * pudding_voice ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:remove_binding
 *  
 *  
 *  Value:解除与布丁的绑定关系;lan:en
 */
@property (nonatomic, strong, readonly) NSString * remove_binding ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:restart_pudding
 *  
 *  
 *  Value:您确定要重新启动布丁?;lan:en
 */
@property (nonatomic, strong, readonly) NSString * restart_pudding ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:say_baby_name
 *  
 *  
 *  Value:让布丁叫出宝宝的名字;lan:en
 */
@property (nonatomic, strong, readonly) NSString * say_baby_name ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:say_pudding
 *  
 *  
 *  Value:有什么话，让布丁来说吧;lan:en
 */
@property (nonatomic, strong, readonly) NSString * say_pudding ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:send_voice
 *  
 *  
 *  Value:请将手机按图示靠近布丁，\n给布丁发送声波;lan:en
 */
@property (nonatomic, strong, readonly) NSString * send_voice ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:send_voice_scuess
 *  
 *  
 *  Value:布丁接收声波后，\n会提示“声波接收成功”;lan:en
 */
@property (nonatomic, strong, readonly) NSString * send_voice_scuess ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:setting_allow_system_album
 *  
 *  
 *  Value:在设置-隐私中允许布丁使用您的相册;lan:en
 */
@property (nonatomic, strong, readonly) NSString * setting_allow_system_album ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:setup_pudding_state
 *  
 *  
 *  Value:小贴士：布丁在开机状态且未贴休眠帖时才能叫醒宝宝;lan:en
 */
@property (nonatomic, strong, readonly) NSString * setup_pudding_state ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:setup_pudding_tip
 *  
 *  
 *  Value:设置时间后布丁将自动按照以上三步科学唤醒宝宝;lan:en
 */
@property (nonatomic, strong, readonly) NSString * setup_pudding_tip ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:start_play
 *  
 *  
 *  Value:布丁开始播放;lan:en
 */
@property (nonatomic, strong, readonly) NSString * start_play ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:teach_pudding
 *  
 *  
 *  Value:调教布丁;lan:en
 */
@property (nonatomic, strong, readonly) NSString * teach_pudding ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:update_nickname
 *  
 *  
 *  Value:修改布丁昵称;lan:en
 */
@property (nonatomic, strong, readonly) NSString * update_nickname ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:voice_scuess
 *  
 *  
 *  Value:已听到提示，声波接收成功;lan:en
 */
@property (nonatomic, strong, readonly) NSString * voice_scuess ;

/**
 *  @author kenny , 2017-04-14 02:37:36 +0000
 *  
 *  Key:you_advice
 *  
 *  
 *  Value:请填写你对布丁产品的任何建议,我们将不断改进;lan:en
 */
@property (nonatomic, strong, readonly) NSString * you_advice ;
@end
