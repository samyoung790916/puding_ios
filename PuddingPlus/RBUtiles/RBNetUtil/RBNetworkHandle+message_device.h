//
//  RBNetworkHandle+message_device.h
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle.h"

@interface RBNetworkHandle (message_device)
#pragma mark 消息：- 删除消息中心列表
/**
 *  @param messageList 消息mid 数组
 */
+ (RBNetworkHandle *)deleteMessageList:(NSArray *) messageList :(RBNetworkHandleBlock) block;
#pragma mark 消息：- 获取消息列表
+ (RBNetworkHandle *)getMessageWithStartID:(NSNumber*) startid PageCount:(int )count CtrlID:(NSString *)ctid Category:(NSInteger)category WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 消息：- 取消闹钟提醒
+ (RBNetworkHandle *)resignMessageAlertWithMid:(NSNumber*)midString WithBlock:(RBNetworkHandleBlock)block;

#pragma mark 消息：- 获取未读消息数量
+ (RBNetworkHandle *)getUnReadMessageCountWithArr:(NSArray *)arr WithBlock:(RBNetworkHandleBlock)block;

#pragma mark -   获取近期未读视频邀请消息列表
+ (RBNetworkHandle *)getUnReadVideoMessage:(void (^)(id res)) block;
@end
