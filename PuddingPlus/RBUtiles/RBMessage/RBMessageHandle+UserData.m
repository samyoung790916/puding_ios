//
//  RBMessageHandle+UserData.m
//  RBMiddleLevel
//
//  Created by william on 16/10/24.
//  Copyright © 2016年 mengchen. All rights reserved.
//

#import "RBMessageHandle+UserData.h"
#import "RBMessageModel.h"
#import "RBUserHeader.h"
#import "RBDeviceModel.h"
#import "RBLog.h"
#import "RBNetworkHandle.h"
#import "AppDelegate.h"
#import <objc/runtime.h>
#import "RBNetHeader.h"
#import "RBUserDataHandle+Device.h"

@interface RBMessageHandle(){

}
/** 错误弹窗代码处理 */
@property (nonatomic, copy) RBMessageErrorBlock errorBlock;
@end


@implementation RBMessageHandle (UserData)



#pragma mark ------------------- Action ------------------------
#pragma mark - action: 消息到来
- (void)mesageArrive:(NSDictionary *)dict ApplicationActive:(UIApplicationState) appState messageType:(RBRemoteNotificationType) type{
    NSLog(@"收到推送的消息 = %@ 状态 = %ld",dict,(long)appState);
    if (RBDataHandle.loginData == nil) {
        return;
    }
    RBMessageModel * model = [RBMessageModel modelWithJSON:dict];
    self.notificationType = type;
    id block = [self blockForMsg:model];
    if (block) {
        RBMsgBlock(a) = block;
        a(appState,model);
        return;
    }
}

#pragma mark - action: 设置消息中心最后的消息 id

+(void)updateMessageCenterWithDevice:(NSString *)deviceID MessageID:(NSNumber *)messageID{
    if(deviceID == nil)
        return;
     [RBUserDataCache saveCache:messageID forKey:[NSString stringWithFormat:@"RBMess_%@",deviceID]];
     [RBDataHandle performDelegetMethod:@selector(unReadMessageCountChange) withObj:nil];
}

+ (BOOL)fetchWechatNewMessage:(NSString *)deviceID{
    BOOL isNew =  [[RBUserDataCache cacheForKey:[NSString stringWithFormat:@"RBMess_wechat_%@",deviceID]] boolValue];
    return isNew;
}

+ (void)newWechatMessagereceive:(NSString *)deviceID isNew:(BOOL) isNew{
    if (deviceID) {
        [RBUserDataCache saveCache:@(isNew) forKey:[NSString stringWithFormat:@"RBMess_wechat_%@",deviceID]];
    }
}

+(NSString*)fetchMessageCenterDevice:(NSString *)deviceID{
    if (deviceID == nil) {
        return nil;
    }
    
   return  [RBUserDataCache cacheForKey:[NSString stringWithFormat:@"RBMess_%@",deviceID]];
}

+(void)updateBabyMessageWithDevice:(NSString *)deviceID MessageID:(NSNumber *)messageID{
    [RBUserDataCache saveCache:messageID forKey:[NSString stringWithFormat:@"RBBabyMess_%@",deviceID]];
}

+(NSNumber*)fetchBabyMessageDevice:(NSString *)deviceID{
    return  [RBUserDataCache cacheForKey:[NSString stringWithFormat:@"RBBabyMess_%@",deviceID]];
}

+(void)updateOldBabyMessageWithDevice:(NSString *)deviceID MessageID:(NSNumber *)messageID{
    [RBUserDataCache saveCache:messageID forKey:[NSString stringWithFormat:@"RBBabyMess_Old_%@",deviceID]];
}

+(NSNumber*)fetchOldBabyMessageDevice:(NSString *)deviceID{          
    return  [RBUserDataCache cacheForKey:[NSString stringWithFormat:@"RBBabyMess_Old_%@",deviceID]];
}

#pragma mark - action: 显示提示框
- (void)showAlter:(NSString * )detail needRefreshList:(BOOL)needRefreshList{
    if(self.showAlter){
        [[RBMessageManager getCurrentVC] tipAlter:detail ItemsArray:@[NSLocalizedString( @"i_now", nil)] :^(int index) {
            if (needRefreshList) {
                [RBDataHandle refreshDeviceList:nil];
            }
        }];
    }else{
        if(needRefreshList){
            [RBDataHandle refreshDeviceListNotSwift];
        }
    }
}

// 获取最近未读视频邀请消息
- (void)checkUnreadVideoMessage {
    NSLog(@"开始检测是否有最近的未读视频消息");
    [RBNetworkHandle getUnReadVideoMessage:^(id res) {
        if (res && [[res objectForKey:@"result"] integerValue] == 0) {
            NSDictionary *modelDict = [[res mObjectForKey:@"data"] mObjectForKey:@"videoMsg"];
            if ([modelDict isKindOfClass:[NSNull class]]) {
                return;
            }
            NSString *mcid   =  [modelDict mObjectForKey:@"mcid"];
            if (mcid.length>0) {
                [self showVideoAlter:mcid];
            }
        }
    }];
}

#pragma mark ------------------- LazyLoad ------------------------


-(void)addHandleOfErrMsg:(RBMessageErrorBlock)block{
    if (block) {
        self.errorBlock = [block copy];
    }
}

-(void)setErrorBlock:(RBMessageErrorBlock)errorBlock{
    objc_setAssociatedObject(self,@selector(errorBlock), errorBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(RBMessageErrorBlock)errorBlock{
    return objc_getAssociatedObject(self, @selector(errorBlock));
}


@end
