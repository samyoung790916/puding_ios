//
//  RBNetworkHandle+Common.m
//  Domgo
//
//  Created by william on 16/9/30.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBNetworkHandle+Common.h"
#import "RBNetConfig.h"
#import <objc/runtime.h>

@implementation RBNetworkHandle (Common)


#pragma mark - 创建共有参数列表
+ (NSDictionary *)getCommonDict:(NSDictionary *)dict NeedAppid:(Boolean) needAppid{
    NSMutableDictionary * resultDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [resultDict removeObjectForKey:@"data"];
    NSMutableDictionary * dataDict = [[NSMutableDictionary alloc] initWithDictionary:[dict mObjectForKey:@"data"]];
    NSString * devName = [RBNetworkHandle getDevName];
    NSString * bundleId  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleIdentifierKey];
    NSString * version  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString * appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary * appinfo = @{@"via":devName,@"app":[NSString stringWithFormat:@"%@.ios",bundleId],@"cver":@([version intValue]),@"aver":appversion,@"osver":@(0),@"local":@"zh_CN",@"ch":[RBNetworkHandle getChannelId]};
    dataDict[@"app"] = appinfo;
    NSString * userid = RBDataHandle.loginData.userid;
    if(userid){
        dataDict[@"myid"] = userid;
    }
    if([dataDict mObjectForKey:@"from"] == nil){
        dataDict[@"from"] = @"ios";
    }
    NSString *mainctl = [dataDict mObjectForKey:@"mainctl"];
    if(![mainctl isNotBlank])
        mainctl = RB_Current_Mcid;
    if ([mainctl isNotBlank]) {
        RBDeviceModel *deviceModel  = [RBDataHandle fecthDeviceDetail:mainctl];
        if (needAppid) {
            if ([deviceModel isPuddingPlus]) {
                dataDict[@"appid"] = @"PLUSUN3xtyON74KY";
            }
            else if ([deviceModel isStorybox]) {
                dataDict[@"appid"] = [self getPD_XAppId];
            }
        }       
        if([[deviceModel device_type] length] > 0 && [[dataDict mObjectForKey:@"production"] mStrLength] == 0)
            dataDict[@"production"] = [deviceModel device_type];
        dataDict[@"mainctl"] = mainctl;


    }
    if(![[dict objectForKey:@"action"] isEqualToString:@"login"]){
        if(RBDataHandle.loginData.token){
            [dataDict setObject:RBDataHandle.loginData.token forKey:@"token"];
        }
    }
    
    [resultDict setObject:dataDict forKey:@"data"];
    return [resultDict copy];
}


#pragma mark - action: 获取 devName 参数
+ (NSString *)getDevName{
    NSString * devName = nil;
    switch (RBNetConfigManager.rb_client_env_state) {
            case RBClientEnvStateDevelop:
        {
            devName = kRB_DevName_Develop;
        }
            break;
            case RBClientEnvStateInhouse:
        {
            devName = kRB_DevName_Inhouse;
        }
            break;
            case RBClientEnvStateAdhoc:
        {
            devName = kRB_DevName_AppStore;
        }
            break;
            case RBClientEnvStateOnline:
        {
            devName = kRB_DevName_AppStore;
        }
            break;
    }
    return  devName;
}

#pragma mark - action: 获取渠道号
+ (NSNumber*)getChannelId{
    NSInteger num = 0;
    switch (RBNetConfigManager.rb_client_env_state) {
        case RBClientEnvStateDevelop:
        {
            if (RBNetConfigManager.rb_channelId_Develop) {
                num = RBNetConfigManager.rb_channelId_Develop;
            }else{
                num = kRB_ChannelId_Develop;
            }
        }
            break;
        case RBClientEnvStateAdhoc:
        {
            if (RBNetConfigManager.rb_channelId_AdHoc) {
                num = RBNetConfigManager.rb_channelId_AdHoc;
            }else{
                num = kRB_ChannelId_AdHoc;
            }
        }
            break;
        case RBClientEnvStateInhouse:
        {
            if (RBNetConfigManager.rb_channelId_Inhouse) {
                num = RBNetConfigManager.rb_channelId_Inhouse;
            }else{
                num = kRB_ChannelId_Inhouse;
            }
        }
            break;
        case RBClientEnvStateOnline:
        {
            if (RBNetConfigManager.rb_channelId_Online) {
                num = RBNetConfigManager.rb_channelId_Online;
            }else{
                num = kRB_ChannelId_Online;
            }
        }
            break;
    }
    return [NSNumber numberWithInteger:num];
}


#pragma mark - 检测当前环境是否可以继续发送网络请求
+ (BOOL)isLegal{
    //获取用户单利
    if (RBDataHandle.loginData && RB_Current_UserId && RB_Current_Token && RB_Current_Mcid ) {
        return true;
    }else{
        return false;
    }
}

/**
 *  获取 Userid
 *
 */
+(NSString *)UserId{
//    Class cls = NSClassFromString(RBNetConfigManager.rb_userHandleClsName);
//    id manager = [[cls alloc]init];
//    return  [[manager valueForKey:@"loginData"] valueForKey:@"userid"];
    return RBDataHandle.loginData.userid;
}

/**
 *  获取 token
 *
 */
+(NSString *)Token{
//    Class cls = NSClassFromString(RBNetConfigManager.rb_userHandleClsName);
//    id manager = [[cls alloc]init];
    return RBDataHandle.loginData.token;

//    return  [[manager valueForKey:@"loginData"] valueForKey:@"token"];
}

/**
 *  获取当前主控的 sn 号
 *
 */
+(NSString *)currentMcid{
//    Class cls = NSClassFromString(RBNetConfigManager.rb_userHandleClsName);
//    id manager = [[cls alloc]init];
//    return  [[manager valueForKey:@"currentDevice"] valueForKey:@"mcid"];
  return  [NSString stringWithFormat:@"%@",RBDataHandle.loginData.currentMcid];
}
#pragma mark - action: 获取 appId 参数
+ (NSString *)getPD_XAppId{
    NSString * appId = nil;
    NSUInteger flag = [RBNetworkHandle getDefaultEviroment];
    if(flag == RBServerState_Test){
        //测试
        appId = @"NWU3YWE4YmQ1NmQ4";
    }else if(flag == RBServerState_Online){
        //线上
        appId = @"TlkOTQ1Y2FjYWNiY";
    }else if(flag == RBServerState_custom){
        //线上
        appId = @"TlkOTQ1Y2FjYWNiY";
    }
    return  appId;
}

@end
