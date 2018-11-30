//
//  RBNetworkHandle.h
//  Roobo
//
//  Created by mengchen on 16/9/28.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBNetConfig.h"

/**
 *  RBNetworkHandle
 *
 *  接口类
 *
 *  网络的配置信息在 RBNetworkConfig 类中
 */
#import "RBNetwork.h"

//发送验证码类型
typedef NS_ENUM(NSUInteger, RBSendCodeType) {
    RBSendCodeTypeNewAccount = 1,//注册新账号发送
    RBSendCodeTypeResetPhone = 2,//修改手机号发送
    RBSendCodeTypeResetPsd = 3,  //修改其他发送
};
@class RBNetworkHandle;

//回调
typedef  void (^RBNetworkHandleBlock)(id res);
@interface RBNetworkHandle : NSObject
@property (nonatomic, strong) RBNetworkRequest *task;

#pragma mark ------------------- Action ------------------------
#pragma mark - 停止请求
- (void)stopRequest;
#pragma mark ------------------- 环境相关 ------------------------
#pragma mark - 服务器地址
+(NSString *)getUrlHost;
#pragma mark - 获取视频 Socket 地址
+(NSString *)getVideoSocket;
#pragma mark 环境：- 升级服务器地址
+ (NSString *)getAppUpdataURLHost;
#pragma mark 环境：- 打点服务器地址
+ (NSString *)getStatURLHost;
#pragma mark 环境：- 反馈服务器地址
+ (NSString *)userFeedbackURL;
#pragma mark 环境：-崩溃服务器地址
+(NSString*)getCrashURLHost;
#pragma mark - 切换环境
+ (void)changeHttpURL:(RBServerState)flag;
#pragma mark 环境：- 获取默认环境
+ (RBServerState)getDefaultEviroment;
#pragma mark - action: 拼接地址路径，添加唯一标识
+ (NSString *)getInterUrl:(NSString *)host Path:(NSString * )path;

#pragma mark ------------------- 基础网络请求 ------------------------
#pragma mark Base：-  基础网络请求
+ (RBNetworkHandle *)getNetDataWihtPara:(NSDictionary *)dict URLStr:(NSString *)url Block:(RBNetworkHandleBlock) block;
+ (RBNetworkHandle *)getNetDataWihtPara:(NSDictionary *)dict URLStr:(NSString *)url RemoveAppidInfo:(BOOL)removeAppid Block:(RBNetworkHandleBlock) block;
+ (RBNetworkHandle *)uploadNetDataWihtPara:(NSDictionary *)dict URLStr:(NSString *)url filePath:(NSString*)filePath Block:(RBNetworkHandleBlock) block;
+ (RBNetworkHandle *)downDataWihtPara:(NSDictionary *)dict URLStr:(NSString *)url toFilePath:(NSString*)filePath Block:(void (^)(bool)) block;
#pragma mark - 处理回包
+ (void)handleResponse:(id)response Error:(NSError*)error Block:(RBNetworkHandleBlock)block;

@end
