//
//  RBNetworkHandle+wechat.h
//  PuddingPlus
//
//  Created by liyang on 2018/6/4.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBNetworkHandle.h"

@interface RBNetworkHandle (wechat)
+ (RBNetworkHandle*)chatList:(NSString*)lastId IsLast:(Boolean)isLoadLast resultBlock:(RBNetworkHandleBlock) block;
+ (RBNetworkHandle*)sendVoice:(NSString *)filePath length:(NSUInteger)length progressBlock:(void(^)(NSProgress *progress))progressBlock  resultBlock:(RBNetworkHandleBlock) block;
+ (RBNetworkHandle*)readReport:(NSString*)messageId resultBlock:(RBNetworkHandleBlock) block;
+ (RBNetworkHandle*)latestMsgResultBlock:(RBNetworkHandleBlock) block;
+ (RBNetworkHandle*)clearMsg:(NSString*)lastId resultBlock:(RBNetworkHandleBlock) block;

@end
