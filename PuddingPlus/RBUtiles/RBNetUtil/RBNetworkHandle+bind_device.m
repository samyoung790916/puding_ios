//
//  RBNetworkHandle+bind_device.m
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle+bind_device.h"
#import "RBNetwork.h"
#import "RBNetworkHandle+Common.h"

#import "YYCache.h"
#import "YYMemoryCache.h"

@implementation RBNetworkHandle (bind_device)
#pragma mark 用户：- 绑定主控
+ (RBNetworkHandle *)bindCtrlWithCtrl:(NSString *) ctrl PsString:(NSString *)psString WithBlock:(RBNetworkHandleBlock) block{
    if(ctrl){
        NSDictionary * dict = 0;
        if(psString){
            dict= @{@"action":@"reqbind",@"data":@{@"reqmainctl":ctrl,@"ps":psString}};
        }else{
            dict= @{@"action":@"reqbind",@"data":@{@"reqmainctl":ctrl}};
        }
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_BIND_MASTER];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
    }else{
        if (block) {
            block(nil);
        }
        return  nil;
    }
}

#pragma mark 用户：- 获取二维码
+ (RBNetworkHandle *)getQRCodeMsgWithMainctl:(NSString *)snId andBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"qrcode/create",@"data":@{@"myid":[NSString stringWithFormat:@"%@",RB_Current_UserId],@"mainctl":snId,@"token":[NSString stringWithFormat:@"%@",RB_Current_Token]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_GETQRCODE];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark 用户：- 扫描二维码
+ (RBNetworkHandle *)scanQRCodeMsgWithRequestUrl:(NSString *)urlString andBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"qrcode/bind",@"data":@{@"myid":[NSString stringWithFormat:@"%@",RB_Current_UserId],@"request_url":urlString,@"token":[NSString stringWithFormat:@"%@",RB_Current_Token]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_GETQRCODE];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}




#pragma mark 用户：- 解除绑定
+ (RBNetworkHandle *)deleteCtrlInitState:(NSString *) ctrl isClearData:(BOOL)isClear WithBlock:(RBNetworkHandleBlock) block{
    if(ctrl){
       NSDictionary * dict = @{@"action":@"delmctl",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",ctrl],@"clear_moment":[NSNumber numberWithBool:isClear]}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_BIND_MASTER];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
    }else{
        if (block) {
            block(nil);
        }
        return nil;
    }
}

#pragma mark 用户：- 踢出其他用户
+ (RBNetworkHandle *)deleteUserBind:(NSString *)userid  WithBlock:(RBNetworkHandleBlock) block {
    
        NSDictionary * dict = @{@"action":@"deluser",@"data":@{@"userid":userid,@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};;
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_BIND_MASTER];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
   
}

#pragma mark 用户：- 邀请绑定
+ (RBNetworkHandle *)invitationUserBind:(NSString *)userPhone  pcode:(NSString*)pcode  WithBlock:(RBNetworkHandleBlock) block{
    if(userPhone){
        NSDictionary * dict = @{@"action":@"invite",@"data":@{@"phonenum":userPhone,@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid],@"token":RB_Current_Token,@"myid":RB_Current_UserId,@"pcode":[NSString stringWithFormat:@"%@",pcode]}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_BIND_MASTER];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
    }else{
        if (block) {
            block(nil);
        }
        return nil;
    }
}

#pragma mark 用户：- 允许用户绑定
+ (RBNetworkHandle *)allowbindDeviceWithDeviceID:(NSString *)deviceID RequstIDString:(NSString *)reqid Mcid:(NSString *)mcid WithBlock:(RBNetworkHandleBlock) block{
    NSString * myid = [NSString stringWithFormat:@"%@",mcid];
    int req = [reqid intValue];
    if(reqid){
        NSDictionary * dict = @{@"action":@"allowbind",@"data":@{@"myid":myid,@"reqid":[NSNumber numberWithInt:req]}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_BIND_MASTER];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
    } else {
        if (block) {
            block(nil);
        }
        return nil;
    }
}
#pragma mark 用户：- 拒绝用户绑定
+ (RBNetworkHandle *)denybindDeviceWithDeviceID:(NSString *)deviceID RequstIDString:(NSString *)reqid Mcid:(NSString *)mcid WithBlock:(RBNetworkHandleBlock) block{
    NSString * myid = [NSString stringWithFormat:@"%@",mcid];
    int req = [reqid intValue];
    if(reqid ){
        NSDictionary * dict = @{@"action":@"denybind",@"data":@{@"myid":myid,@"reqid":[NSNumber numberWithInt:req]}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_BIND_MASTER];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
    } else {
        if (block) {
            block(nil);
        }
        return nil;
    }
}


#pragma mark 主控：- 绑定新主控
+ (RBNetworkHandle *)bindNewRooboWelcome:(RBNetworkHandleBlock)block{
    NSString * userid = RB_Current_UserId;
    NSDictionary * dict = @{@"action":@"VoiceServer/ceremony",@"data":@{@"mainctl":RB_Current_Mcid,@"myid":userid,@"token":(RB_Current_Token)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
    
}

#pragma mark 主控：- 根据主控的 Id 获得主控的成员信息
+ (RBNetworkHandle *)getRooboInfoWithCtrlID:(NSString *)  ctrlid :(RBNetworkHandleBlock) block{
    if(ctrlid){
        NSDictionary * dict = @{@"action":@"detail",@"data":@{@"mainctl":ctrlid}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_INFO];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return  handle;
    }else{
        if (block) {
            block(nil);
        }
        return nil;
    }
}

#pragma mark - 配网：- 语言配网轮询
+ (RBNetworkHandle *)VoiceConfigNetGetResult:(NSString *)settingID WithBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"mc/getWifiResult",@"data":@{@"from":settingID,@"token":[NSString stringWithFormat:@"%@",RB_Current_Token]}};
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:[NSString stringWithFormat:@"%@%@",RB_URL_HOST,RB_URL_PATH_DIY] Block:block];
    return handle;
}


#pragma mark - 配网：- 打开声波配网
+(RBNetworkHandle *)openVoiceConfigBlock:(RBNetworkHandleBlock)block{
    NSString * urlActionStr = @"VoiceServer/startSoundWaveMode";
    NSString * userid = RB_Current_UserId;
    
    if ([RBNetworkHandle isLegal]) {
        NSDictionary * dict = @{@"action":urlActionStr,@"data":@{@"mainctl":RB_Current_Mcid,@"myid":userid,@"token":(RB_Current_Token),@"uid":userid}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];

        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
        
         return nil;
    }else{
        if (block) {
            block(nil);
        }
        return nil;
    }
}

#pragma mark 主控：- 获取扫描二维码的主控信息

+ (RBNetworkHandle *)getCtrlInfoWithURL:(NSString *)scanURL WithBlock:(RBNetworkHandleBlock)block{
    if(scanURL == nil){
        if(block){
            block(nil);
        }
        return nil;
    }
    NSString * myid = [NSString stringWithFormat:@"%@",RB_Current_UserId];
    
    NSDictionary * dict = @{@"action":@"qrcode/appbind",@"data":@{@"request_url":scanURL,@"myid":myid,@"token":RB_Current_Token}};
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_GETQRCODE] Block:block];
    
    return handle;
}

+ (void)changeCtrlManager:(NSString *)otherUserId WithBlock:(void (^)(id res)) block{
    NSDictionary * dict = @{@"action":@"transmgr",@"data":@{@"mainctl":RB_Current_Mcid,@"otherid":[NSString stringWithFormat:@"%@",otherUserId]}};
    [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_BIND_MASTER] Block:block];
    
    
}

#pragma mark ------------------- 声波配网 ------------------------

+(void)getSoundWave:(NSString *)wifiName wifiPsd:(NSString *)wifiPwd block:(RBNetworkHandleBlock) block
{
    NSString *waveStr = [NSString stringWithFormat:@"v1#%@#%@#%@##",wifiName,wifiPwd,RB_Current_UserId];
    NSDictionary * dictPara = @{@"action":@"tools/wave",@"data":@{@"mode":@"v3",@"myid":[NSString stringWithFormat:@"%@",RB_Current_UserId],@"str":waveStr}};
    [RBNetworkHandle getNetDataWihtPara:dictPara URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_WAVES] Block:block];
}

@end
