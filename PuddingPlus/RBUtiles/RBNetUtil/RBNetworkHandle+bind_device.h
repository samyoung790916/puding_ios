//
//  RBNetworkHandle+bind_device.h
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle.h"

@interface RBNetworkHandle (bind_device)

#pragma mark 用户：- 获取二维码
+ (RBNetworkHandle *)getQRCodeMsgWithMainctl:(NSString *)snId andBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 扫描二维码
+ (RBNetworkHandle *)scanQRCodeMsgWithRequestUrl:(NSString *)urlStr andBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 绑定主控
+ (RBNetworkHandle *)bindCtrlWithCtrl:(NSString *) ctrl PsString:(NSString *)psString WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 解除绑定
+ (RBNetworkHandle *)deleteCtrlInitState:(NSString *) ctrl isClearData:(BOOL)isClear WithBlock:(RBNetworkHandleBlock) block ;
#pragma mark 用户：- 踢出其他用户
+ (RBNetworkHandle *)deleteUserBind:(NSString *)userid  WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 邀请绑定
+ (RBNetworkHandle *)invitationUserBind:(NSString *)userPhone  pcode:(NSString*)pcode  WithBlock:(RBNetworkHandleBlock) blockk;
#pragma mark 用户：- 允许用户绑定
+ (RBNetworkHandle *)allowbindDeviceWithDeviceID:(NSString *)deviceID RequstIDString:(NSString *)reqid Mcid:(NSString *)mcid WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 用户：- 拒绝用户绑定
+ (RBNetworkHandle *)denybindDeviceWithDeviceID:(NSString *)deviceID RequstIDString:(NSString *)reqid Mcid:(NSString *)mcid WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 绑定新主控
+ (RBNetworkHandle *)bindNewRooboWelcome:(RBNetworkHandleBlock)block;
#pragma mark 主控：- 根据主控的 Id 获得主控的成员信息
+ (RBNetworkHandle *)getRooboInfoWithCtrlID:(NSString *)  ctrlid :(RBNetworkHandleBlock) block;
#pragma mark - 配网：- 语言配网轮询
+ (RBNetworkHandle *)VoiceConfigNetGetResult:(NSString *)settingID WithBlock:(RBNetworkHandleBlock) block;
#pragma mark - 配网：- 打开声波配网
+(RBNetworkHandle *)openVoiceConfigBlock:(RBNetworkHandleBlock)block;
#pragma mark 主控：- 获取扫描二维码的主控信息
+ (RBNetworkHandle *)getCtrlInfoWithURL:(NSString *)scanURL WithBlock:(RBNetworkHandleBlock)block;
+ (void)changeCtrlManager:(NSString *)otherUserId WithBlock:(void (^)(id res)) block;
#pragma mark - 配网：- 打开声波配网 - 布丁X
+(void)getSoundWave:(NSString *)wifiName wifiPsd:(NSString *)wifiPwd block:(RBNetworkHandleBlock) block;

@end
