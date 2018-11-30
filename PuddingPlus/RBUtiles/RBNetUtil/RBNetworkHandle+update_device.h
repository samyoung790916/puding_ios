//
//  RBNetworkHandle+update_device.h
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle.h"

@interface RBNetworkHandle (update_device)
#pragma mark 升级：- 强制升级
+(RBNetworkHandle *)forceUpdateDeviceWithMcid:(NSString *)mcid WithBlock:(RBNetworkHandleBlock)block;

#pragma mark 升级：- 版本依赖检查接口
+ (RBNetworkHandle *)versionRelyOnWithVcode:(int)vcode UserId:(NSString *)userId Mcid:(NSString *)mcid Block:(RBNetworkHandleBlock)block;
#pragma mark 升级：- 通用升级检查接口（新的）
+ (RBNetworkHandle *)checkAppUpdateWithIdentifier:(NSString *)iden Vname:(NSString*)vname VersionCode:(int)vcode production:(NSString *)production Userid:(NSString *)userid Block:(RBNetworkHandleBlock)block;
#pragma mark 升级：- 升级主控模块
+(RBNetworkHandle *)updateModulesWithuserId:(NSString *)userId token:(NSString *)token mainctlId:(NSString*)mainctlId data:(NSDictionary*)dict Block:(RBNetworkHandleBlock)block;
#pragma mark 升级：-  获取主控 Rom 版本信息
+ (RBNetworkHandle *)getCtrlRomVersionWithMcid:(NSString *)mcid WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：-  获取主控所有版本信息
+ (RBNetworkHandle *)getCtrlVersionMsgWithMcid:(NSString *)mcid WithBlock:(RBNetworkHandleBlock)block;
+ (RBNetworkHandle *)uploadBabyAvatarImage:(UIImage *)image withBlock:(RBNetworkHandleBlock) block;
@end
