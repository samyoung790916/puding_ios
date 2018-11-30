//
//  RBMessageHandle+UserData.h
//  RBMiddleLevel
//
//  Created by william on 16/10/24.
//  Copyright © 2016年 mengchen. All rights reserved.
//

#import "RBMessageHandle.h"

typedef void (^RBMessageErrorBlock)(id res);
@interface RBMessageHandle (UserData)

/**
 *  消息到达处理方法
 *
 *  @param dict     消息字典
 *  @param appState app 状态
 */
- (void)mesageArrive:(NSDictionary *)dict ApplicationActive:(UIApplicationState) appState messageType:(RBRemoteNotificationType) type;

//消息中心推送消息的存储
+ (void)updateMessageCenterWithDevice:(NSString *) deviceID MessageID:(NSNumber * )messageID;

+(NSString*)fetchMessageCenterDevice:(NSString *)deviceID;

+ (BOOL)fetchWechatNewMessage:(NSString *)deviceID;

+ (void)newWechatMessagereceive:(NSString *)deviceID isNew:(BOOL) isNew;

//宝宝动态推送消息的处理
+(void)updateBabyMessageWithDevice:(NSString *)deviceID MessageID:(NSNumber *)messageID;

+(void)updateOldBabyMessageWithDevice:(NSString *)deviceID MessageID:(NSNumber *)messageID;

+(NSNumber*)fetchBabyMessageDevice:(NSString *)deviceID;

+(NSNumber*)fetchOldBabyMessageDevice:(NSString *)deviceID;

/**
 *  显示通用提示框
 *  isNeed:是否需要刷新列表
 */
- (void)showAlter:(NSString * )detail needRefreshList:(BOOL)isNeed;

/**
 *  添加错误的代码处理
 *
 *  block：中会返回网络回包，客户端可以根据自己的 UI 逻辑进行错误的显示。
 */
- (void)addHandleOfErrMsg:(RBMessageErrorBlock)block;


// 获取最近未读视频邀请消息
- (void)checkUnreadVideoMessage;
@end
