//
//  RBNetworkHandle+Account.m
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle+Account.h"
#import "RBNetwork.h"
#import "RBNetworkHandle+Common.h"
#import "NSString+RBExtension.h"
#import "YYCache.h"
#import "YYMemoryCache.h"
NSString * const md5hex = @"geG^_s[3Kl";
@implementation RBNetworkHandle (Account)

#pragma mark ------------------- 用户相关 ------------------------
#pragma mark 用户：- 登陆
+ (RBNetworkHandle *)userloginWithPhone:(NSString *)phone PsdNumber:(NSString *)psdNumber pcode:(NSString*)pcode WithBlock:(RBNetworkHandleBlock) block{
        NSString * macAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"macAddress"];
        if(!macAddress){
            macAddress = @"";
        }
        NSString * psd = [[NSString stringWithFormat:@"%@%@",md5hex,psdNumber] md5String];
        NSString * pushID = [[NSUserDefaults standardUserDefaults] objectForKey:@"baidupushid"];
        NSDictionary * dict;
        if(!pushID){
            pushID = @"";
        }
        
        NSString *lang = @"zh";
        if (![pcode isEqualToString:@"+86"]) {
            lang = @"en";
        }
        dict = @{@"action":@"login",@"data":@{@"phonenum":phone,@"pushid":pushID,@"tm":[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]],@"passwd":psd,@"wifimac":macAddress,@"lang":lang,@"pcode":pcode}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_LOGIN];
        [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr RemoveAppidInfo:YES  Block:block];
         return nil;
}

#pragma mark 用户：- 注册
+ (RBNetworkHandle *)registerWithPhone:(NSString *)phone  PsdNumber:(NSString *)psdNumber IdenCode:(NSString *)code NickName:(NSString *)nickName pcode:(NSString*)pcode WithBlock:(RBNetworkHandleBlock) block{
    
    
        NSString * psd = [[NSString stringWithFormat:@"%@%@",md5hex,psdNumber] md5String];
        NSString * pushID = [[NSUserDefaults standardUserDefaults] objectForKey:@"baidupushid"];
        if(!pushID){
            pushID = @"";
        }
        
        NSDictionary * dict = @{@"action":@"quickregist",@"data":@{@"phonenum":phone,@"validcode":code,@"pushid":pushID,@"tm":[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]],@"passwd":psd,@"name":[NSString stringWithFormat:@"%@",nickName],@"pcode":pcode}};
        
        [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_REGIST] RemoveAppidInfo:YES  Block:block];
        return nil;
    
}

#pragma mark 用户：- 修改密码
+ (RBNetworkHandle *)changeUserPsd:(NSString *)oldPsd newPsd:(NSString *)newPsd WithBlock:(RBNetworkHandleBlock) block{
    
    NSString * opsd = [[NSString stringWithFormat:@"%@%@",md5hex,oldPsd] md5String];
    NSString * npsd = [[NSString stringWithFormat:@"%@%@",md5hex,newPsd] md5String];
    NSDictionary * dict = @{@"action":@"setpasswd",@"data":@{@"oldpasswd":opsd,@"newpasswd":npsd}};
    RBNetworkHandle * handle =  [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_UPDATE_USER_PASSWORD] RemoveAppidInfo:YES  Block:block];
    return handle;
}


#pragma mark 用户：- 重置密码
+ (RBNetworkHandle *)resetPsd:(NSString *)phone :(NSString *)checkCode NewPsdWord:(NSString *)newPsd pcode:(NSString*)pcode  WithBlock:(RBNetworkHandleBlock) block{
    
    NSString * str = [NSString stringWithFormat:@"%@",phone];
    NSString * psd = [[NSString stringWithFormat:@"%@%@",md5hex,newPsd] md5String];
    if(str && psd){
        NSDictionary * dict = @{@"action":@"resetpasswd",@"data":@{@"phonenum":str,@"validcode":[NSString stringWithFormat:@"%@",checkCode],@"newpasswd":psd,@"pcode":pcode}};
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_UPDATE_USER_PASSWORD] RemoveAppidInfo:YES  Block:block];
        return handle;
        
    }else{
        if (block) {
            block(nil);
        }
        return nil;
    }
}
#pragma mark 用户：- 获取验证码
+ (RBNetworkHandle *)sendIdenCodeWithPhone:(NSString *)phone SendType:(RBSendCodeType )type pcode:(NSString*)pcode WithBlock:(RBNetworkHandleBlock) block{
    
        NSString * typeStr = nil;
        switch (type) {
            case RBSendCodeTypeNewAccount:
                typeStr = @"regist-phone";
                break;
            case RBSendCodeTypeResetPhone:
                typeStr = @"modify-phone";
                break;
            case RBSendCodeTypeResetPsd:
                typeStr = @"password";
                break;
            default:
                break;
        }
        NSString *lang = @"zh";
        if (![pcode isEqualToString:@"+86"]) {
            lang = @"en";
        }
        NSDictionary * dict = @{@"action":@"newcode",@"data":@{@"phonenum":phone,@"usage":typeStr,@"pcode":pcode,@"lang":lang}};
        [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_AUTHCODE] RemoveAppidInfo:YES  Block:block];
        return nil;

}
#pragma mark 用户：- 根据旧密码修改新密码
+ (RBNetworkHandle *)resetUserPsdWithOldPsd:(NSString *)oldPsd NewPsd:(NSString *)newPsd WithBlock:(RBNetworkHandleBlock) block{
    NSString * userId = [NSString stringWithFormat:@"%@",RB_Current_UserId];
    if(oldPsd  && newPsd ){
        NSDictionary * dict = @{@"action":@"setpasswd",@"data":@{@"oldpasswd":[[NSString stringWithFormat:@"%@%@",md5hex,oldPsd] md5String],@"newpasswd":[[NSString stringWithFormat:@"%@%@",md5hex,newPsd] md5String],@"myid":userId}};
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_UPDATE_USER_PASSWORD] RemoveAppidInfo:YES  Block:block];
        return handle;
        
    }else{
        if (block) {
            block(nil);
        }
        return nil;
    }
}


#pragma mark 用户：- 修改手机号
+ (RBNetworkHandle *)updateUserPhoeWithPhoneNum:(NSString *)phone checkCode:(NSString *)checkCode Pwd:(NSString *)pwd  pcode:(NSString*)pcode WithBlock:(void (^)(id res)) block{
        NSString * str = [NSString stringWithFormat:@"%@",phone];
        NSString * password = [[NSString stringWithFormat:@"%@%@",md5hex,pwd] md5String];
        NSDictionary * dict = @{@"action":@"resetphone",@"data":@{@"newphone":str,@"validcode":checkCode,@"password":password,@"validnp":[NSNumber numberWithBool:true],@"pcode":pcode}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_UPDATE_USER_INFO];
        return [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr RemoveAppidInfo:YES  Block:block];
}
#pragma mark 用户：- 检测用户密码是否正确
+ (RBNetworkHandle *)checkUserPsdIsRight :(NSString *)phone IsSendCode:(BOOL)isSend WithBlock:(RBNetworkHandleBlock) block{
    NSString * str = [NSString stringWithFormat:@"%@",phone];
    if(str ){
        NSString * psd = [[NSString stringWithFormat:@"%@%@",md5hex,str] md5String];;
        NSDictionary * dict = @{@"action":@"verify",@"data":@{@"passwd":psd,@"sendsms":[NSNumber numberWithBool:isSend]}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_VERIFY];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr RemoveAppidInfo:YES  Block:block];
        return handle;
    }else{
        if (block) {
            block(nil);
        }
        return nil;
    }
}
#pragma mark 用户：- 用户登出
+ (RBNetworkHandle *)userLoginOut:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"logout",@"data":@{}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_LOGOUT];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr RemoveAppidInfo:YES  Block:block];
    return handle;
}
#pragma mark 用户：- 上传头像url 路径
+ (RBNetworkHandle *)updateUserHeaderWithHeaderPath:(NSString *)headerPath WithBlock:(RBNetworkHandleBlock) block{
    NSString * str = [NSString stringWithFormat:@"%@",headerPath];
    NSDictionary * dict = @{@"action":@"users/modifyheadimg",@"data":@{@"imgpath":str}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_UPDATE_USER_INFO];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr RemoveAppidInfo:YES  Block:block];
    return handle;
    
}
#pragma mark 用户：- 上传照片返回 URL 路径
+ (RBNetworkHandle *)uploadImage:(UIImage *)image withBlock:(RBNetworkHandleBlock) block{
    NSMutableDictionary * resultDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"uploadimg",@"data":@{}}];
    NSMutableDictionary * dataDict = [NSMutableDictionary dictionary];
    NSString * userid = RB_Current_UserId;
    if(userid){
        dataDict[@"myid"] = userid;
        dataDict[@"file"] = @"file";
    }
    dataDict[@"from"] = @"ios";
    if(RB_Current_Token){
        dataDict[@"token"] = RB_Current_Token;
    }
    resultDict[@"data"] = dataDict;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:resultDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString * json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_UPLOAD_IMAGE];
    [RBNetworkEngine sendRequest:^(RBNetworkRequest * _Nullable request) {
        request.url = urlStr;
        request.parameters = @{@"json":json};
        request.type = RBRequestUpload;
        request.method = RBRequestMethodPost;
        [request addFormDataWithName:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg" fileData:UIImageJPEGRepresentation(image, 0.5)];
    } onSuccess:^(id  _Nullable responseObject) {
        [RBNetworkHandle handleResponse:responseObject Error:nil Block:block];
    } onFailure:^(NSError * _Nullable error) {
        [RBNetworkHandle handleResponse:nil Error:error  Block:block];

    }];
    return nil;
}
#pragma mark 用户：- 上传 PushID
+ (RBNetworkHandle *)updatePushID:(NSString *)pushID{
    NSDictionary * dict = @{@"action":@"resetpushid",@"data":@{@"pushid":pushID}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_UPDATE_USER_INFO];
    [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            NSLog(@"上传 pushID 成功");
        }else{
            NSLog(@"上传 pushID 失败");
        }
    }];
    return  nil;
}

#pragma mark 用户：- 用户反馈
/**
 *  用户反馈
 *
 *  @param contact        联系方式
 *  @param description    详情
 *  @param block          回调
 */
+ (RBNetworkHandle *)userFeedBackWithContact:(NSString *)contact description:(NSString *)description WithBlock:(RBNetworkHandleBlock) block{
    NSString *actionStr = @"report";
    NSString * userId = RB_Current_UserId;
    NSDictionary * dict = @{@"action":actionStr,@"data":@{@"clientId":userId,@"type":@(0),@"contract": contact,@"title": NSLocalizedString( @"advice_feedback", nil),@"description":description,@"model":[UIDevice currentDevice].machineModelName,@"sver":[UIDevice currentDevice].systemVersion}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:[RBNetworkHandle userFeedbackURL] Path:nil];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr RemoveAppidInfo:YES  Block:block];
    return handle;
}


#pragma mark 用户：- 修改用户名
+ (RBNetworkHandle *)updateUserName:(NSString *)name :(RBNetworkHandleBlock) block{
    if(name){
        NSDictionary * dict = @{@"action":@"username",@"data":@{@"name":name}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_UPDATE_USER_INFO];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr RemoveAppidInfo:YES  Block:block];
        return handle;
    }else{
        return nil;
    }
}


#pragma mark 用户：- 检查手机号是否注册过

+ (RBNetworkHandle *)checkPhoneIsRegist:(NSString *)phone  pcode:(NSString*)pcode WithBlock:(RBNetworkHandleBlock) block{
    if(phone){
        NSDictionary * dict = @{@"action":@"user/isregist",@"data":@{@"phonenum":phone,@"key":@"",@"pcode":pcode}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_REGIST];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr RemoveAppidInfo:YES  Block:block];
        return handle;
    }else{
        return  nil;
    }
}

/**
 *  验证手机号是否注册过
 */
+ (RBNetworkHandle *)checkPhoneIsRegist:(NSString *)phone WithBlock:(RBNetworkHandleBlock) block{
    return nil;
}


+ (RBNetworkHandle *)getUserCustomDataWith:(void (^)(id res)) block{
    NSDictionary * dict = @{@"action":@"custom/list",@"data":@{@"mainctl":RB_Current_Mcid,@"key":@""}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:RB_URL_PATH_DIY];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr RemoveAppidInfo:YES  Block:block];
    return handle;
}


#pragma mark -   通用升级检查
+ (RBNetworkHandle *)checkAppUpdateWithIdentifier:(NSString *)iden Vname:(NSString*)vname VersionCode:(int)vcode production:(NSString *)production Block:(void(^)(id res))block{
    if(iden == nil || vname == nil){
        LogError(@" iden is nil");
        return nil;
    }
    NSDictionary *dict = @{@"action":@"common/updateinfo",@"data":@{@"clientId":[NSString stringWithFormat:@"%@",RB_Current_UserId],@"modules":@[@{@"name":iden,@"vcode":@(vcode),@"vname":vname}],@"net":@"wifi",@"production":production}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:[RBNetworkHandle getAppUpdataURLHost]  Path:URL_PATH_CHECK];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr RemoveAppidInfo:YES  Block:block];
    return handle;
}

@end
