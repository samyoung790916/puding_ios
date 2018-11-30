//
//  RBNetworkHandle+update_device.m
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle+update_device.h"
#import "RBNetwork.h"
#import "RBNetworkHandle+Common.h"
@implementation RBNetworkHandle (update_device)

#pragma mark 升级：- 强制升级
+(RBNetworkHandle *)forceUpdateDeviceWithMcid:(NSString *)mcid WithBlock:(RBNetworkHandleBlock)block{
    __block RBNetworkHandle * handle =  [[RBNetworkHandle alloc]init];
    if ([RBNetworkHandle isLegal]) {
        NSDictionary * dict = @{@"action":@"update/forcedev",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",mcid],@"myid":RB_Current_UserId,@"production":@"pudding1s.appupdate"}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/update"];
        handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    }else{
        if(block){
            block(nil);
        }
    }
    return  handle;
}



#pragma mark 升级：- 版本依赖检查接口
+ (RBNetworkHandle *)versionRelyOnWithVcode:(int)vcode UserId:(NSString *)userId Mcid:(NSString *)mcid Block:(RBNetworkHandleBlock)block{
    NSString * version  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString * appId  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleIdentifierKey];
    NSString * production = @"pudding1s.ios";
    NSString * romId = @"com.roobo.coreserver";
    if ([RBNetworkHandle isLegal]) {
        if (appId == nil || version == nil) {
            return nil;
        }
        NSString * urlStr = [RBNetworkHandle getInterUrl:[RBNetworkHandle getAppUpdataURLHost] Path:@"/check"];
        //mid 主控 id
        //clientId userid
        NSDictionary *dict = @{@"action":@"common/association",@"data":@{@"production":production,@"module":appId,@"vcode":@(vcode),@"clientId":[NSString stringWithFormat:@"%@",userId],@"mId":[NSString stringWithFormat:@"%@",mcid],@"modules":@[@{@"production":@"pudding1s.appupdate",@"module":romId}]}};
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
    }else{
        return nil;
    }
}

#pragma mark 升级：- 通用升级检查接口（新的）
+ (RBNetworkHandle *)checkAppUpdateWithIdentifier:(NSString *)iden Vname:(NSString*)vname VersionCode:(int)vcode production:(NSString *)production Userid:(NSString *)userid Block:(RBNetworkHandleBlock)block{
    
    if(iden == nil || vname == nil){
        NSLog(@" iden is nil");
        return nil;
    }
    NSString * urlStr = [RBNetworkHandle getInterUrl:[RBNetworkHandle getAppUpdataURLHost] Path:@"/check"];
    NSDictionary *dict = @{@"action":@"common/updateinfo",@"data":@{@"clientId":[NSString stringWithFormat:@"%@",userid],@"modules":@[@{@"name":iden,@"vcode":@(vcode),@"vname":vname}],@"net":@"wifi",@"production":production}};
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}


#pragma mark 升级：- 升级主控模块
+(RBNetworkHandle *)updateModulesWithuserId:(NSString *)userId token:(NSString *)token mainctlId:(NSString*)mainctlId data:(NSDictionary*)dict Block:(RBNetworkHandleBlock)block{
    NSString * urlActionStr = nil;
    urlActionStr = @"AppUpdater/updateApp";
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [jsonDict setValue:mainctlId forKey:@"mainctl"];
    [jsonDict setValue:userId forKey:@"myid"];
    [jsonDict setValue:(token) forKey:@"token"];
    [jsonDict setValue:userId forKey:@"uid"];
    NSDictionary * newdict = @{@"action":urlActionStr,@"data":jsonDict};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:newdict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 主控：- 获取主控 rom 版本信息
+ (RBNetworkHandle *)getCtrlRomVersionWithMcid:(NSString *)mcid WithBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"mc/versions",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",mcid]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/mainctrls/version"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
    
}

#pragma mark 主控：-  获取主控所有版本信息
+ (RBNetworkHandle *)getCtrlVersionMsgWithMcid:(NSString *)mcid WithBlock:(RBNetworkHandleBlock)block{
    
    NSDictionary * dict = @{@"action":@"mc/verlist",@"data":@{@"myid":RB_Current_UserId,@"token":RB_Current_Token,@"mainctl":RB_Current_Mcid}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"/mainctrls/version"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 用户：- 上传照片返回 URL 路径
+ (RBNetworkHandle *)uploadBabyAvatarImage:(UIImage *)image withBlock:(RBNetworkHandleBlock) block{
    NSMutableDictionary * resultDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"baby/upimg",@"data":@{}}];
    NSMutableDictionary * dataDict = [NSMutableDictionary dictionary];
    NSString * userid = RB_Current_UserId;
    if(userid){
        [dataDict setObject:userid forKey:@"myid"];
        [dataDict setObject:@"file" forKey:@"file"];
    }
    [dataDict setObject:@"ios" forKey:@"from"];
    if(RB_Current_Token){
        [dataDict setObject:RB_Current_Token forKey:@"token"];
    }
    if(RB_Current_Mcid){
        [dataDict setObject:RB_Current_Mcid forKey:@"mainctl"];
    }
    
    [resultDict setObject:dataDict forKey:@"data"];
    NSDictionary * resDict = [RBNetworkHandle getCommonDict:resultDict NeedAppid:NO];

    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:resDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString * json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_UPDATE_USER_INFO];
    [RBNetworkEngine sendRequest:^(RBNetworkRequest * _Nullable request) {
        request.url = urlStr;
        request.parameters = @{@"json":json};
        request.method = RBRequestMethodPost;
        request.type = RBRequestUpload;
        [request addFormDataWithName:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg" fileData:UIImageJPEGRepresentation(image, 0.5)];
    
    } onSuccess:^(id  _Nullable responseObject) {
        [RBNetworkHandle handleResponse:responseObject Error:nil Block:block];
    } onFailure:^(NSError * _Nullable error) {
        [RBNetworkHandle handleResponse:nil Error:error Block:block];
    }];
    return nil;
}

@end
