//
//  RBNetworkHandle+ctrl_device.m
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle+ctrl_device.h"
#import "RBNetworkHandle+ctrl_device_plus.h"

#import "RBNetwork.h"
#import "RBNetworkHandle+Common.h"
//#import "NSString+RBEncryption.h"
//#import "NSObject+RBFilterNull.h"
//#import "UIDevice+RBHardwareMsg.h"
#import "YYCache.h"
#import "YYMemoryCache.h"
@implementation RBNetworkHandle (ctrl_device)

#pragma mark 主控：- 获取主控快速回复
+ (RBNetworkHandle *)changeCtrlRespose:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"getchatresponse",@"data":@{@"type":@(0),@"count":@(10)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_EVENT_RESPONSE];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 主控：- 旋转主控
+ (RBNetworkHandle *)RotateDevice:(NSString *)ctrlID Angle:(NSInteger)angle actionDetail:(NSString *)actionDetail WithBlock:(RBNetworkHandleBlock) block{
    
    NSString * userid = RB_Current_UserId;
    NSString * token = RB_Current_Token;
    NSDictionary * dict = nil;
    if(ctrlID == nil || userid == nil || token == nil){
        if(block){
            block(nil);
        }
        return nil;
    }
    
    if ([actionDetail isNotBlank]) {
         dict = @{@"action":@"DeviceManage/motorRotate",@"data":@{@"angle":[NSNumber numberWithInteger:angle],@"act2":[NSString stringWithFormat:@"%@",actionDetail],@"mainctl":ctrlID,@"myid":userid,@"token":(token)}};
    }else {
         dict = @{@"action":@"DeviceManage/motorRotate",@"data":@{@"angle":[NSNumber numberWithInteger:angle],@"mainctl":ctrlID,@"myid":userid,@"token":(token)}};
    }
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 主控：- 传递 TTS 心跳类型
+ (RBNetworkHandle *)configRooboWithSSLType:(NSInteger)sslType ctrlId:(NSString *)ctrlID Block:(RBNetworkHandleBlock) block{
    NSString*urlActionStr = nil;
    switch (sslType) {
        case 0:
            urlActionStr = @"VoiceServer/closeRangeTTSHeartbeat";
            break;
        case 1:
            urlActionStr = @"VoiceServer/closeRangeTTSHeartbeat";
            break;
        default:
            urlActionStr = @"VoiceServer/exitCloseRangeTTS";
            break;
    }
    NSString * userid = RB_Current_UserId;
    NSDictionary * dict = @{@"action":urlActionStr,@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",ctrlID],@"myid":[NSString stringWithFormat:@"%@",userid],@"token":[NSString stringWithFormat:@"%@",RB_Current_Token],@"uid":[NSString stringWithFormat:@"%@",userid]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
   
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 主控：-  发送 TTS
+ (RBNetworkHandle *)sendTTS:(NSString *)text WithBlock:(RBNetworkHandleBlock) block{
    if(([text length] == 0 || [RB_Current_Mcid length]== 0) || [RB_Current_UserId length] == 0){
        if(block)
            block(nil);
        return nil;
        
    }
    NSString * userid = RB_Current_UserId;
    NSDictionary * dict = @{@"action":@"VoiceServer/textToSpeech",@"data":@{@"text":text,@"mainctl":RB_Current_Mcid,@"myid":userid,@"token":(RB_Current_Token)}};
    NSString * urlStr =[RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 主控：- 发送表情
+ (RBNetworkHandle *)sendExpressionType:(int) type WithBlock:(RBNetworkHandleBlock) block{
    if(RB_Current_Token == nil || RB_Current_UserId == nil){
        block(nil);
        return nil;
    }
    NSString * userid = RB_Current_UserId;
    NSDictionary * dict = @{@"action":@"LedControl/showExpression",@"data":@{@"type":[NSNumber numberWithInt:type],@"mainctl":RB_Current_Mcid,@"myid":userid,@"token":(RB_Current_Token)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}


#pragma mark 主控：- 发送主控回复
+ (RBNetworkHandle *)sendCtrlRecordCmd:(NSString *)content  WithBlock:(RBNetworkHandleBlock) block{
    NSString * userid = RB_Current_UserId;
    NSDictionary * dict = @{@"action":@"VoiceServer/aiActions",@"data":@{@"todo":content,@"mainctl":RB_Current_Mcid,@"myid":userid,@"token":(RB_Current_Token)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 视频：- 发送控制命令
+ (RBNetworkHandle *)sendActionCmd:(NSString *)cmd WithBlock:(RBNetworkHandleBlock)block{
    NSString * action = @"DeviceManage/motorRotate";
    NSString * userId = RB_Current_UserId;
    NSDictionary * dict = @{@"action":action,@"data":@{@"cmd":[NSString stringWithFormat:@"%@",cmd],@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid],@"myid":userId,@"state": [NSNumber numberWithBool:true],@"token":[NSString stringWithFormat:@"%@",RB_Current_Token]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 上传：- 变声录音文件
+ (RBNetworkHandle *)uploadVoiceChangeWithFileURL:(NSURL *)fileURL Block:(RBNetworkHandleBlock)block{
    NSMutableDictionary * resultDict = [NSMutableDictionary new];
    [resultDict setObject:@"voice/fun" forKey:@"action"];
    NSMutableDictionary * dataDict = [NSMutableDictionary dictionary];
    NSString * userid = RB_Current_UserId;
    if(userid){
        [dataDict setObject:userid forKey:@"myid"];
        [dataDict setObject:@"file" forKey:@"file"];
        if(RB_Current_Token){
            [dataDict setObject:RB_Current_Token forKey:@"token"];
            
        }
        if (RB_Current_Mcid) {
            [dataDict setObject:RB_Current_Mcid forKey:@"mainctl"];
        }
    }
    [resultDict setObject:dataDict forKey:@"data"];
    NSDictionary * resDict = [RBNetworkHandle getCommonDict:resultDict NeedAppid:YES];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString * json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonValue = %@",json);
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_DIY];
    NSMutableData *data = [NSMutableData dataWithContentsOfURL:fileURL];

    
    [RBNetworkEngine sendRequest:^(RBNetworkRequest * _Nullable request) {
        request.url = urlStr;
        request.parameters = @{@"json":json};
        request.type = RBRequestUpload;
        [request addFormDataWithName:@"file" fileName:@"file.amr" mimeType:@"audio/amr" fileData:data];
        request.method = RBRequestMethodPost;
    } onSuccess:^(id  _Nullable responseObject) {
        [RBNetworkHandle handleResponse:responseObject Error:nil Block:block];
    } onFailure:^(NSError * _Nullable error) {
        [RBNetworkHandle handleResponse:nil Error:error Block:block];
    }];
    
    
    return nil;
}

#pragma mark - 主页面快捷图标播放
+ (RBNetworkHandle *)mainQuickPlay:(NSString *)rid WithBlock:(RBNetworkHandleBlock) block{
    NSString * userid = RB_Current_UserId;
    NSDictionary * dict = @{@"action":@"user/shortcut",@"data":@{@"mainctl":RB_Current_Mcid,@"actid":[NSString stringWithFormat:@"%d",[rid intValue]],@"myid":userid,@"token":RB_Current_Token}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/users/mctlcmd"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark - 播放功能列表—s_cls
+ (RBNetworkHandle *)mainClsFeatureList:(NSString *)cid PageIndex:(int)page WithBlock:(RBNetworkHandleBlock) block{
    if(RB_Current_Mcid == nil){
        block(nil);
        return nil;
    }
    NSDictionary * dict = @{@"action":@"resource/search_list",@"data":@{@"cid":@([cid intValue]),@"page":@(page),@"mainctl":RB_Current_Mcid,@"type":@"cls"}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/users/resource"] ;
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark - 主页面功能列表
+ (RBNetworkHandle *)mainFeatureList:(NSString *)cid KeyWord:(NSString *)keyWord PageIndex:(int)page WithBlock:(RBNetworkHandleBlock) block{
    if(RB_Current_Mcid == nil || keyWord == nil){
        block(nil);
        return nil;
    }
    NSDictionary * dict = @{@"action":@"resource/list",@"data":@{@"cid":@([cid intValue]),@"name":keyWord,@"page":@(page),@"mainctl":RB_Current_Mcid}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/users/resource"] ;
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

+ (RBNetworkHandle *)mainFeatureClsList:(NSString *)cid  PageIndex:(int)page WithBlock:(RBNetworkHandleBlock) block{
    if(RB_Current_Mcid == nil){
        block(nil);
        return nil;
    }
    NSDictionary * dict = @{@"action":@"resource/search_list",@"data":@{@"cid":@([cid intValue]),@"page":@(page),@"mainctl":RB_Current_Mcid}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/users/resource"] ;
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark 主控：- 停止播放
+ (RBNetworkHandle *)mainStopPlaySourceID:(NSString *)sourceID Mcid:(NSString *)mcid  WithBlock:(RBNetworkHandleBlock) block{
    if(mcid == nil){
        block(nil);
    }
    NSDictionary * dict = nil;
    if(sourceID){
        dict = @{@"action":@"resource/stop",@"data":@{@"type":@"idle",@"id":@(sourceID.integerValue),@"mainctl":mcid}};
    }else{
        dict = @{@"action":@"resource/stop",@"data":@{@"type":@"idle",@"mainctl":mcid}};
    }
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/users/resource"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 主控：- 播放音乐从视频中播放
+ (RBNetworkHandle *)mainPlaySourceActID:(int)actid Catid:(NSString *)catid Mcid:(NSString *)mcid SourceID:(NSString *)sourceID  Type:(NSString *)type ResourcesKey:(NSString *)resourcesKey WithBlock:(RBNetworkHandleBlock) block{
    if(mcid == nil){
        block(nil);
        return nil;
    }
    if(type == nil)
        type = @"";

    NSDictionary *preDict = @{@"type" : type,@"act":@(actid),@"catid":@([catid intValue]),@"mainctl":mcid};
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:preDict];
    if(sourceID){
        [dict setObject:@(sourceID.intValue) forKey:@"id"];
    }
    if (resourcesKey) {
        [dict setObject:resourcesKey forKey:@"resourcesKey"];
    }
    NSDictionary *finalDict = @{@"action":@"resource/play",@"data":dict};
  
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/users/resource"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:finalDict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 主控：- 播放音乐普通播放
+ (RBNetworkHandle *)mainPlaySourceActID:(int)actid Catid:(NSNumber *)catid Mcid:(NSString *)mcid SourceID:(NSString *)sourceID Src:(NSString *)src WithBlock:(RBNetworkHandleBlock) block{
    if(mcid == nil){
        block(nil);
    }
    NSDictionary * dict = nil;
    
    NSDictionary *dataDict = @{@"act":@(actid),@"catid":@([catid intValue]),@"mainctl":mcid};
    if (sourceID) {
        dataDict = @{@"act":@(actid),@"catid":@([catid intValue]),@"id":@(sourceID.intValue),@"mainctl":mcid};
    }
    NSMutableDictionary *lastDataDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [lastDataDict setDictionary:dataDict];
    if (src) {
        [lastDataDict setObject:src forKey:@"src"];
    }
    dict = @{@"action":@"resource/play",@"data":lastDataDict};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/users/resource"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return  handle;
}
+(RBNetworkHandle *)fetchTTSListBlock:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"ttslist",@"data":@{@"mainctl":@""}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_INFO];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return  handle;
}

@end
