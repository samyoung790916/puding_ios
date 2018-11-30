//
//  RBNetworkHandle+wechat.m
//  PuddingPlus
//
//  Created by liyang on 2018/6/4.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBNetworkHandle+wechat.h"

@implementation RBNetworkHandle (wechat)
+ (RBNetworkHandle*)chatList:(NSString*)lastId IsLast:(Boolean)isLoadLast resultBlock:(RBNetworkHandleBlock) block{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:@{@"count":@(20)}];
    if (!isLoadLast&&lastId) {
        dataDict[@"oldestId"] = lastId;
    }
    if (isLoadLast&&lastId) {
        dataDict[@"lastId"] = lastId;
    }
    NSDictionary * paraDict = @{@"action":@"message/list",@"data":dataDict};
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:paraDict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_CHAT] Block:block];
    return handle;
}
+ (RBNetworkHandle*)sendVoice:(NSString *)filePath length:(NSUInteger)length progressBlock:(void(^)(NSProgress *progress))progressBlock  resultBlock:(RBNetworkHandleBlock) block
{
    NSDictionary *bodyDict = @{@"file":@"file",@"length":[NSNumber numberWithLong:length]};
    NSDictionary *paraDict = @{@"action":@"message/send",@"data":@{@"type":@"sound",@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid],@"body":bodyDict}};
    RBNetworkHandle * handle = [RBNetworkHandle uploadNetDataWihtPara:paraDict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_CHAT] filePath:filePath Block:block];
    return handle;
}
+ (RBNetworkHandle*)readReport:(NSString*)messageId resultBlock:(RBNetworkHandleBlock) block{
    NSDictionary * paraDict = @{@"action":@"message/readreport",@"data":@{@"messageId":messageId,@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:paraDict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_CHAT] Block:block];
    return handle;
}
+ (RBNetworkHandle*)latestMsgResultBlock:(RBNetworkHandleBlock) block{
    NSDictionary * paraDict = @{@"action":@"message/latest",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:paraDict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_CHAT] Block:block];
    return handle;
}
+ (RBNetworkHandle*)clearMsg:(NSString*)lastId resultBlock:(RBNetworkHandleBlock) block{
    NSDictionary * paraDict = @{@"action":@"message/clear",@"data":@{@"lastId":lastId,@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:paraDict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_CHAT] Block:block];
    return handle;
}
@end
