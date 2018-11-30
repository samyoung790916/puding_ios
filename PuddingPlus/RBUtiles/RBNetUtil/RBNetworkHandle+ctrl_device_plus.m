//
//  RBNetworkHandle+ctrl_device_plus.m
//  PuddingPlus
//
//  Created by kieran on 2017/5/16.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBNetworkHandle+ctrl_device_plus.h"

@implementation RBNetworkHandle (ctrl_device_plus)
#pragma mark 主控：- 进入或退出多媒体表情模式
+ (RBNetworkHandle *)enterMultimediaExpression:(BOOL) isEnter :(RBNetworkHandleBlock) block{
    NSString * userid = RB_Current_UserId;

    if(!RB_Current_Mcid || !userid){
        block(nil);
        return nil;
    }
    
    NSString * content = nil;
    if(isEnter){
        content = @"{\"action\":\"EnterActor\",\"version\":1}";
    }else{
        content = @"{\"action\":\"ExitActor\",\"version\":1}";
    }
    
    NSDictionary * dict = @{@"action":@"DeviceManage/sendCommand",@"data":@{@"todo":content,@"mainctl":RB_Current_Mcid,@"myid":[NSString stringWithFormat:@"%@",userid],@"token":(RB_Current_Token)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark 主控：- 发送多媒体表情
+ (RBNetworkHandle *)sendMultimediaExpressionType:(NSString *)content  WithBlock:(RBNetworkHandleBlock) block{
    NSString * userid = RB_Current_UserId;
    NSDictionary * dict = @{@"action":@"DeviceManage/sendCommand",@"data":@{@"todo":content,@"mainctl":RB_Current_Mcid,@"myid":[NSString stringWithFormat:@"%@",userid],@"token":(RB_Current_Token)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
    
}


#pragma mark 主控：- 发送多媒体TTS
+ (RBNetworkHandle *)sendMultiTTSString:(NSString *)content  WithBlock:(RBNetworkHandleBlock) block{
    NSString * userid = RB_Current_UserId;
    if(content== nil){
        if(block){
            block(nil);
        }
        return nil;
    }
    NSString * contentStr = [NSString stringWithFormat:@"{\"action\":\"PlayAction\",\"version\":1,\"data\":[{\"action\":\"emotion\",\"sequence\":1,\"param\":\"face_smile\",\"receive\":\"tts_end\",\"execute_on_receive\":\"stop\",\"repeat\":1},{\"action\":\"tts\",\"sequence\":1,\"param\":\"%@\",\"dispatch\":\"tts_end\",\"dispatch_when\":\"stopped\"}]}",content];
    NSDictionary * dict = @{@"action":@"DeviceManage/sendCommand",@"data":@{@"todo":contentStr,@"mainctl":RB_Current_Mcid,@"myid":userid,@"token":(RB_Current_Token)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
    
}

#pragma mark 主控：- 发送多媒体TTS
+ (RBNetworkHandle *)sendMultiVoice:(NSString *)urlstring  WithBlock:(RBNetworkHandleBlock) block{
    NSString * userid = RB_Current_UserId;
    if(urlstring== nil){
        if(block){
            block(nil);
        }
        return nil;
    }
//    NSString * contentStr = [NSString stringWithFormat:@"{\"action\":\"PlayAction\",\"version\":1,\"data\":[{\"action\":\"url\",\"sequence\":0,\"param\":{\"audio\":\"%@\"}}]}",urlstring];
//    NSDictionary * dict = @{@"action":@"DeviceManage/sendCommand",@"data":@{@"todo":contentStr,@"mainctl":RB_Current_Mcid,@"myid":userid,@"token":(RB_Current_Token)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
//    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
//    return handle;
    
    
    NSMutableDictionary * resultDict = [NSMutableDictionary new];
    [resultDict setObject:@"DeviceManage/sendCommand" forKey:@"action"];
    NSMutableDictionary * dataDict = [NSMutableDictionary dictionary];
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
    NSMutableData *data = [NSMutableData dataWithContentsOfURL:[NSURL fileURLWithPath:urlstring]];
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


@end
