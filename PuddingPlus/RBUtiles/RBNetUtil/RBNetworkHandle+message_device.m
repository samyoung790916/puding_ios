//
//  RBNetworkHandle+message_device.m
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle+message_device.h"
#import "RBNetwork.h"
#import "RBNetworkHandle+Common.h"
#import "YYCache.h"
#import "YYMemoryCache.h"
@implementation RBNetworkHandle (message_device)
#pragma mark 消息：- 删除消息中心列表
+ (RBNetworkHandle *)deleteMessageList:(NSArray *) messageList :(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"msg/deletemsg",@"data":@{@"midList":messageList,@"mainctl":RB_Current_Mcid}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_DELETE_MESSAGE_LIST];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 消息：- 获取消息列表
+ (RBNetworkHandle *)getMessageWithStartID:(NSNumber*) startid PageCount:(int )count CtrlID:(NSString *)ctid Category:(NSInteger)category WithBlock:(RBNetworkHandleBlock) block{
    NSString * userid = RB_Current_UserId;
    if(userid){
        NSDictionary * dict = nil;
        if([ctid length] > 0) {
            /** 1.如果ctid 长度 >0 是消息中心分类 */
            dict = @{@"action":@"msg/gethistorybytime",@"data":@{@"myid":userid,@"start":startid,@"count":@(count),@"reverse":[NSNumber numberWithBool:true],@"mainctl":ctid}};
        } else {
            /** 2.其他就是布防撤防 */
            dict = @{@"action":@"msg/gethistorybytime",@"data":@{@"myid":userid,@"start":startid,@"count":@(count),@"reverse":[NSNumber numberWithBool:true]}};
        }
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MSG_MESSAGE_MSGLIST];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
    }else{
        return  nil;
    }
}

#pragma mark 消息：- 取消闹钟提醒
+ (RBNetworkHandle *)resignMessageAlertWithMid:(NSNumber*)midString WithBlock:(RBNetworkHandleBlock)block{
    if(midString){
        NSDictionary * dict = @{@"action":@"delremind",@"data":@{@"rid":[NSNumber numberWithInt:[midString intValue]],@"token":RB_Current_Token,@"myid":RB_Current_UserId,@"mainctl":RB_Current_Mcid}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/mainctrls/event"];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
        
    } else {
        if (block) {
            block(nil);
        }
        return nil;
    }
}

#pragma mark 消息：- 获取未读消息列表
+(RBNetworkHandle *)getUnReadMessageCountWithArr:(NSArray *)arr WithBlock:(RBNetworkHandleBlock)block{
    NSDictionary * dict = @{@"action":@"msg/newlycount",@"data":@{@"mcfilter":arr}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_DELETE_MESSAGE_LIST];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark -   获取近期未读视频邀请消息列表
+ (RBNetworkHandle *)getUnReadVideoMessage:(void (^)(id res)) block{
    NSDictionary * dict = @{@"action":@"videoMsg/latest",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_LAST_VIDEO_MESSAGE];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

@end
