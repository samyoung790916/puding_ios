//
//  RBNetworkHandle+setting_device.h
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle.h"

@interface RBNetworkHandle (setting_device)
#pragma mark 用户：- 转移管理员
+ (RBNetworkHandle *)changeCtrlManagerWithMcid:(NSString *)mcid  OtherUserId:(NSString *)otherUserId WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 绑定宝贝信息
+ (RBNetworkHandle *)bindBabyMsgWithBirthday:(NSString*)birthDay Sex:(NSString*)sex NickName:(NSString*)nickName Mcid:(NSString *)mcid WithBlock:(RBNetworkHandleBlock)block;
#pragma mark 用户：- 获取宝贝信息
+ (RBNetworkHandle *)getBabyMsgWithMcid:( NSString *)mcid WithBlock:(RBNetworkHandleBlock)block;
#pragma mark 用户：- 修改备注名
+ (RBNetworkHandle *)updateCtrlUserName:(NSString *)userID NewName:(NSString *)newName WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 修改主控备注名
+ (RBNetworkHandle *)updateCtrlName:(NSString *)newName WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 获取主控列表
+ (RBNetworkHandle *)getRooboList:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 获取初始化的设备信息
+ (RBNetworkHandle *)getInitDeviceMsgWithMcid:(NSString *)mcid andBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 根据主控 id 获取主控信息
+ (RBNetworkHandle *)getDevicestateWithCtrlID:(NSString *) mcid Block:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 获取主控详情(霍尔开关)
+ (RBNetworkHandle *)getCtrlDetailMessageWithBlock:(RBNetworkHandleBlock)block;
#pragma mark 主控：- 重新启动主控
+ (RBNetworkHandle *)restartCtrlWithBlock:(RBNetworkHandleBlock)block;
#pragma mark 主控：- 修改主控音量
+ (RBNetworkHandle *)changeMctlVoice:(int)voiceLeave WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 改变布防模式
+ (RBNetworkHandle *)changeProtectionState:(BOOL)state WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 设置手动布放开始结束时间
+ (RBNetworkHandle *)setProtectionTime:(NSString * )startTime EndTime:(NSString *)endTime WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 设置夜间模式
+(RBNetworkHandle *)setNightModeWithType:(BOOL)isToggleType isToggleState:(BOOL)isOpen  startTime:(NSString * )startTime EndTime:(NSString *)endTime WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 视频：- 开启远程提示音
+ (RBNetworkHandle *)masterEnterVideoAlter:(BOOL) isOn WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 家庭动态：- 设置家庭动态状态
+(RBNetworkHandle *)setupFamlilyDynaWithType:(NSString*)type andMainID:(NSString*)mainCtrID openType:(NSString*)openType andBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 定时关机
+(RBNetworkHandle *)setCloseTime:(int)minute WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 童锁
+(RBNetworkHandle *)setLockDevice:(BOOL)lock WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 获取闹钟列表
+(RBNetworkHandle *)getClockWithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 删除自动关机
+ (RBNetworkHandle *)deleteAlarmWithID:(NSString*) alarmID Block:(void(^)(id res))block;
#pragma mark 主控：-立即关机
+ (RBNetworkHandle *)shutDownCtrlWithBlock:(RBNetworkHandleBlock)block;
/**
 获取布丁信息

 @param block <#block description#>
 */
+ (void)getPuddingMsgInfoBlock:(void(^)(id res))block;

/**
 设置布丁音效

 @param role <#role description#>
 @param block <#block description#>
 */
+ (void)setupCurrCtltimbre:(NSString*)role andBlock:(void(^)(id res))block;
/// 获取当前用户的所有设备列表
+ (RBNetworkHandle *)fetchUserListWithMcid:(NSString*)mcid block: (RBNetworkHandleBlock) block;
@end
