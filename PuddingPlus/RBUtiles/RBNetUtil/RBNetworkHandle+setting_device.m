//
//  RBNetworkHandle+setting_device.m
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle+setting_device.h"
#import "RBNetwork.h"
#import "RBNetworkHandle+Common.h"
#import "YYCache.h"
#import "YYMemoryCache.h"
@implementation RBNetworkHandle (setting_device)
#pragma mark 用户：- 改变管理员
+ (RBNetworkHandle *)changeCtrlManagerWithMcid:(NSString *)mcid  OtherUserId:(NSString *)otherUserId WithBlock:(RBNetworkHandleBlock) block{
    if(otherUserId){
        NSDictionary * dict = @{@"action":@"transmgr",@"data":@{@"mainctl":mcid,@"otherid":otherUserId}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_BIND_MASTER];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
    }else{
        if(block){
            block(nil);
        }
        return nil;
    }
}

#pragma mark 用户：- 绑定宝贝信息
+ (RBNetworkHandle *)bindBabyMsgWithBirthday:(NSString*)birthDay Sex:(NSString*)sex NickName:(NSString*)nickName Mcid:(NSString *)mcid WithBlock:(RBNetworkHandleBlock)block{
    NSString * userid = [NSString stringWithFormat:@"%@",RB_Current_UserId];
    NSString * actionStr = @"users/bindbaby";
    NSString * token = [NSString stringWithFormat:@"%@",RB_Current_Token];
    NSString * mainctl = [NSString stringWithFormat:@"%@",mcid];
    NSString * name = [NSString stringWithFormat:@"%@",nickName];
    NSString * date = [NSString stringWithFormat:@"%@",birthDay];
    NSString * sexMsg = [NSString stringWithFormat:@"%@",sex];
    NSDictionary * dict = @{@"action":actionStr,@"data":@{@"mainctl":mainctl,@"myid":userid,@"token":token,@"nickname":name,@"birthday":date,@"sex":sexMsg}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_UPDATE_USER_INFO];
   
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}


#pragma mark 用户：- 获取宝贝信息
+ (RBNetworkHandle *)getBabyMsgWithMcid:( NSString * )mcid WithBlock:(RBNetworkHandleBlock)block{
    NSString * actionStr = @"users/getbaby";
    NSString * mainctl = [NSString stringWithFormat:@"%@",mcid];
    NSString * userid = [NSString stringWithFormat:@"%@",RB_Current_UserId];
    NSString * token = [NSString stringWithFormat:@"%@",RB_Current_Token];
    NSDictionary * dict = @{@"action":actionStr,@"data":@{@"mainctl":mainctl,@"myid":userid,@"token":token}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_UPDATE_USER_INFO];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 用户：- 修改备注名
+ (RBNetworkHandle *)updateCtrlUserName:(NSString *)userID NewName:(NSString *)newName WithBlock:(RBNetworkHandleBlock) block{
    NSString * userid = RB_Current_UserId;
    if(userid){
        NSDictionary * dict = @{@"action":@"users/modifyremark",@"data":@{@"otherid":userID,@"newname":newName}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_UPDATE_USER_INFO];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
    }else{
        return nil;
    }
    
}

#pragma mark 主控：- 修改主控备注名
+ (RBNetworkHandle *)updateCtrlName:(NSString *)newName WithBlock:(RBNetworkHandleBlock) block{
    NSString * userid = RB_Current_UserId;
    if(userid){
        NSDictionary * dict = @{@"action":@"mctlname",@"data":@{@"mainctl":RB_Current_Mcid,@"newname":newName}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MCTL_INFO];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
    }else{
        return  nil;
    }
}
+ (RBNetworkHandle *)fetchUserListWithMcid:(NSString*)mcid block:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"getmclistV2",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",mcid]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_LIST];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark 主控：- 获取主控列表
+ (RBNetworkHandle *)getRooboList:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"getmclistV2",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_LIST];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 主控：- 获取初始化的设备信息
+ (RBNetworkHandle *)getInitDeviceMsgWithMcid:(NSString *)mcid andBlock:(RBNetworkHandleBlock) block{
    NSString * token = RB_Current_Token;
    NSString * myid = [NSString stringWithFormat:@"%@",mcid];
    NSDictionary * dict = @{@"action":@"getinitpasttm",@"data":@{@"toke":token,@"myid":myid,@"mainctl":mcid}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_INFO];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 主控：- 根据主控 id 获取主控状态
+ (RBNetworkHandle *)getDevicestateWithCtrlID:(NSString *) mcid Block:(RBNetworkHandleBlock) block{
    if(!mcid || !RB_Current_UserId || !RB_Current_Token){
        if(block){
            block(nil);
        }
        return nil;
    }
    
    
    NSDictionary * dict = @{@"action":@"status",@"data":@{@"mainctl":mcid,@"myid":RB_Current_UserId,@"token":RB_Current_Token}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_INFO];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
  
}

+ (void)getPuddingMsgInfoBlock:(void(^)(id res))block {
    NSDictionary *dict = @{@"action":@"puddinfo",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_INFO] Block:block];
}


#pragma mark 主控：- 获取主控详情

+ (RBNetworkHandle *)getCtrlDetailMessageWithBlock:(RBNetworkHandleBlock)block{
    NSString * userid = RB_Current_UserId;
    
    if ([RBNetworkHandle isLegal]) {
        NSDictionary * dict = @{@"action":@"detail",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid],@"myid":userid,@"token":(RB_Current_Token)}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/mainctrls/mctlgetter"];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
    }else{
        if(block){
            block(nil);
        }
        return nil;
    }
     return nil;
}

#pragma mark 主控：- 重新启动主控

+ (RBNetworkHandle *)restartCtrlWithBlock:(RBNetworkHandleBlock)block{
    NSDictionary * dict = @{@"action":@"DeviceManager/Shutdown",@"data":@{@"restart":@"true",@"timer":@"0",@"slient":@"false",@"token":RB_Current_Token,@"myid":RB_Current_UserId,@"mainctl":RB_Current_Mcid}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
   
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 主控：- 修改主控音量

+ (RBNetworkHandle *)changeMctlVoice:(int)voiceLeave WithBlock:(RBNetworkHandleBlock) block{
    NSString * userid = RB_Current_UserId;
    NSDictionary * dict = @{@"action":@"VoiceServer/changeMasterVolume",@"data":@{@"volume":[NSNumber numberWithFloat:voiceLeave],@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid],@"myid":userid,@"token":(RB_Current_Token)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    
//    [RBNetworkEngine sendRequest:^(RBNetworkRequest * _Nullable request) {
//        request.url = urlStr;
//        request.parameters = dict;
//        request.method = RBRequestMethodPost;
//    } onSuccess:^(id  _Nullable responseObject) {
//        [RBNetworkHandle handleResponse:responseObject Error:nil Block:block];
//    } onFailure:^(NSError * _Nullable error) {
//        [RBNetworkHandle handleResponse:nil Error:error Block:block];
//    }];
    
     return nil;
}

#pragma mark 主控：- 改变布防模式
+ (RBNetworkHandle *)changeProtectionState:(BOOL)state WithBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"autodefense",@"data":@{@"enable":[NSNumber numberWithBool:state],@"mainctl":RB_Current_Mcid}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_CONFIG_DEFENSE];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}


#pragma mark 主控：- 设置手动布放开始结束时间
+ (RBNetworkHandle *)setProtectionTime:(NSString * )startTime EndTime:(NSString *)endTime WithBlock:(RBNetworkHandleBlock) block{
    if(startTime && endTime){
        NSDictionary * dict = @{@"action":@"securitytime",@"data":@{@"start":startTime,@"end":endTime,@"mainctl":RB_Current_Mcid}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_CONFIG_DEFENSE];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
    }else{
        block(@{@"result":@(80001)});
        return nil;
    }
}


#pragma mark 主控：- 设置夜间模式
+(RBNetworkHandle *)setNightModeWithType:(BOOL)isToggleType isToggleState:(BOOL)isOpen  startTime:(NSString * )startTime EndTime:(NSString *)endTime WithBlock:(RBNetworkHandleBlock) block{
    if(!startTime || !endTime){
        if(block){
            block(nil);
        }
        return nil;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"nightmode/set" forKey:@"action"];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:[NSString stringWithFormat:@"%@",RB_Current_Mcid] forKey:@"mainctl"];
    [dataDict setObject:@[@{@"start":startTime,@"end":endTime}] forKey:@"timerang"];
    if (isToggleType) {
        [dataDict setObject:@"toggle" forKey:@"type"];
    }else{
        [dataDict setObject:@"settime" forKey:@"type"];
    }
    [dict setObject:dataDict forKey:@"data"];
    [dataDict setObject:[NSString stringWithFormat:@"%d",isOpen] forKey:@"state"];
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_NIGHT_MODE];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 视频：- 开启远程提示音
+ (RBNetworkHandle *)masterEnterVideoAlter:(BOOL) isOn WithBlock:(RBNetworkHandleBlock) block{
    NSString * userid = RB_Current_UserId;
    NSNumber*number;
    if (isOn ==YES) {
        number = @1;
    }else{
        number = @0;
    }
    NSDictionary * dict = @{@"action":@"VideoMaster/userEnterRemind",@"data":@{@"status":number,@"mainctl":RB_Current_Mcid,@"myid":userid,@"token":(RB_Current_Token)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 家庭动态：- 设置家庭动态状态
+(RBNetworkHandle *)setupFamlilyDynaWithType:(NSString*)type andMainID:(NSString*)mainCtrID openType:(NSString*)openType andBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"moment/setup",@"data":@{@"myid":[NSString stringWithFormat:@"%@",RB_Current_UserId],@"type":type,@"state":openType,@"mainctl":mainCtrID}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_FAMILY_MOMENT];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
+ (void)setupCurrCtltimbre:(NSString*)role andBlock:(void(^)(id res))block {
    NSDictionary * dict = @{@"action":@"mctlcmd/timbre",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.mcid],@"role":role}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/users/mctlcmd"];
    [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
}

#pragma mark 主控：- 定时关机
+(RBNetworkHandle *)setCloseTime:(int)minute WithBlock:(RBNetworkHandleBlock) block{
    int timer = [[NSDate date] timeIntervalSince1970] - [self getCurrentTimeInterval] + minute*60;
    NSDictionary * dict = @{@"action":@"alarm/autoshutdown",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.mcid],@"name":@"定时关机",@"repeat":@"-1",@"status":@(1),@"timer":@(timer)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/users/alarm"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark 主控：- 童锁
+(RBNetworkHandle *)setLockDevice:(BOOL)lock WithBlock:(RBNetworkHandleBlock) block{
    NSDictionary *lockDic = @{@"isChildLockOn":[NSNumber numberWithBool:lock]};
    NSDictionary * dict = @{@"action":@"setdevice",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.mcid],@"params":lockDic}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/mainctrls/mctlcmd"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark 主控：- 获取闹钟列表
+(RBNetworkHandle *)getClockWithBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"alarm/list",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.mcid]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/users/alarm"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark 主控：- 删除自动关机
+ (RBNetworkHandle *)deleteAlarmWithID:(NSString*) alarmID Block:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"alarm/del",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid],@"alarmIds":@[alarmID]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/users/alarm"];
    return [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
}
#pragma mark 主控：-立即关机
+ (RBNetworkHandle *)shutDownCtrlWithBlock:(RBNetworkHandleBlock)block{
    NSDictionary * dict = @{@"action":@"DeviceManager/Shutdown",@"data":@{@"restart":@"false",@"timer":@"0",@"slient":@"false",@"mainctl":RB_Current_Mcid}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
@end
