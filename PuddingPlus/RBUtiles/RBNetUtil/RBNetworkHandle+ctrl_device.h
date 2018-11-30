//
//  RBNetworkHandle+ctrl_device.h
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle.h"

@interface RBNetworkHandle (ctrl_device)
#pragma mark 主控：- 获取主控快速回复
+ (RBNetworkHandle *)changeCtrlRespose:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 旋转主控
+ (RBNetworkHandle *)RotateDevice:(NSString *)ctrlID Angle:(NSInteger)angle actionDetail:(NSString *)actionDetail WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 传递 TTS 心跳类型
+ (RBNetworkHandle *)configRooboWithSSLType:(NSInteger)sslType ctrlId:(NSString *)ctrlID Block:(RBNetworkHandleBlock) block;
#pragma mark 主控：-  发送 TTS
+ (RBNetworkHandle *)sendTTS:(NSString *)text WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 发送表情
+ (RBNetworkHandle *)sendExpressionType:(int) type WithBlock:(RBNetworkHandleBlock) block;

#pragma mark 主控：- 发送主控回复
+ (RBNetworkHandle *)sendCtrlRecordCmd:(NSString *)content  WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 视频：- 发送控制命令
+ (RBNetworkHandle *)sendActionCmd:(NSString *)cmd WithBlock:(RBNetworkHandleBlock)block;
#pragma mark 上传：- 变声录音文件
+ (RBNetworkHandle *)uploadVoiceChangeWithFileURL:(NSURL *)fileURL Block:(RBNetworkHandleBlock)block;
#pragma mark - 主页面快捷图标播放
+ (RBNetworkHandle *)mainQuickPlay:(NSString *)rid WithBlock:(RBNetworkHandleBlock) block;
#pragma mark - 播放功能列表—s_cls
+ (RBNetworkHandle *)mainClsFeatureList:(NSString *)cid PageIndex:(int)page WithBlock:(RBNetworkHandleBlock) block;
#pragma mark - 主页面功能列表
+ (RBNetworkHandle *)mainFeatureList:(NSString *)cid KeyWord:(NSString *)keyWord PageIndex:(int)page WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 停止播放
+ (RBNetworkHandle *)mainStopPlaySourceID:(NSString *)sourceID  Mcid:(NSString *)mcid  WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 播放音乐从视频中播放
+ (RBNetworkHandle *)mainPlaySourceActID:(int)actid Catid:(NSString *)catid  Mcid:(NSString *)mcid SourceID:(NSString *)sourceID Type:(NSString *)type ResourcesKey:(NSString *)resourcesKey WithBlock:(RBNetworkHandleBlock) block;

#pragma mark 主控：- 播放音乐普通播放
+ (RBNetworkHandle *)mainPlaySourceActID:(int)actid Catid:(NSString *)catid  Mcid:(NSString *)mcid SourceID:(NSString *)sourceID Src:(NSString *)src WithBlock:(RBNetworkHandleBlock) block;
+(RBNetworkHandle *)fetchTTSListBlock:(void(^)(id res))block;
@end
