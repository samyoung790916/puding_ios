//
//  RBNetworkHandle+Common.h
//  Domgo
//
//  Created by william on 16/9/30.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBNetworkHandle.h"
/**
 *  作为与 设备中间层 和 用户数据中间层 的交互层
 */


//获取当前用户的 UserId
#define RB_Current_UserId [RBNetworkHandle UserId]
//获取当前用户的 Token
#define RB_Current_Token [RBNetworkHandle Token]
//获取当前设备的 mcid
#define RB_Current_Mcid [RBNetworkHandle currentMcid]


//devName
static NSString * const kRB_DevName_Develop = @"ios-dev";
static NSString * const kRB_DevName_Inhouse = @"ios-enterprise";
static NSString * const kRB_DevName_AppStore = @"ios";
static NSString * const kRB_DevName_AdHoc = @"ios";

//渠道号
//企业
static const NSInteger kRB_ChannelId_Inhouse = 11000;
//内侧
static const NSInteger kRB_ChannelId_AdHoc   = 10000;
//开发
static const NSInteger kRB_ChannelId_Develop = 10000;
//线上
static const NSInteger kRB_ChannelId_Online  = 10000;


@interface RBNetworkHandle (Common)
/**
 *  创建共有参数
 *
 *  @param dict 字典
 *
 *  @return
 */
+ (NSDictionary *)getCommonDict:(NSDictionary *)dict NeedAppid:(Boolean) needAppid;

/**
 *  获取 devName 参数
 *
 */
+ (NSString *)getDevName;

/**
 *  获取渠道号
 *
 */
+ (NSNumber*)getChannelId;

/**
 *  检验是否满足发送请求条件
 *
 */
+ (BOOL)isLegal;
/**
 *  获取 UserId
 *
 */
+ (NSString *)UserId;

/**
 *  获取 Token
 *
 */
+ (NSString *)Token;

/**
 *  获取当前设备的 Mcid
 *
 */
+ (NSString *)currentMcid;
+ (NSString *)getPD_XAppId;
@end
