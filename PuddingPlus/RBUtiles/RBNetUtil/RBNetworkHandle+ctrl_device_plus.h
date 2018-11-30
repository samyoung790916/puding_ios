//
//  RBNetworkHandle+ctrl_device_plus.h
//  PuddingPlus
//
//  Created by kieran on 2017/5/16.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBNetworkHandle.h"

@interface RBNetworkHandle (ctrl_device_plus)
#pragma mark 主控：- 发送多媒体表情
+ (RBNetworkHandle *)sendMultimediaExpressionType:(NSString *)content  WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 进入或退出多媒体表情模式
+ (RBNetworkHandle *)enterMultimediaExpression:(BOOL) isEnter :(RBNetworkHandleBlock) block;

#pragma mark 主控：- 发送多媒体TTS
+ (RBNetworkHandle *)sendMultiTTSString:(NSString *)content  WithBlock:(RBNetworkHandleBlock) block;
#pragma mark 主控：- 发送多媒体TTS
+ (RBNetworkHandle *)sendMultiVoice:(NSString *)urlstring  WithBlock:(RBNetworkHandleBlock) block;
@end
