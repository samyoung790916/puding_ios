//
//  RBNetworkHandle.m
//  Roobo
//
//  Created by mengchen on 16/9/28.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBNetworkHandle.h"
#import "RBNetworkHandle+Common.h"
#import "YYCache.h"
#import "YYMemoryCache.h"
#import "RBErrorHandle.h"
#import "RBErrorHandle+AddError.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface RBNetworkHandle()
/** 任务 */

@end

@implementation RBNetworkHandle

#pragma mark ------------------- Action ------------------------
#pragma mark - action: 停止请求
-(void)stopRequest{

    
}

#pragma mark ------------------- 基础网络请求 ------------------------
#pragma mark Base：-  基础网络请求
+ (RBNetworkHandle *)getNetDataWihtPara:(NSDictionary *)dict URLStr:(NSString *)url Block:(RBNetworkHandleBlock) block{
    return [RBNetworkHandle getNetDataWihtPara:dict URLStr:url RemoveAppidInfo:NO Block:block];
}

+ (RBNetworkHandle *)getNetDataWihtPara:(NSDictionary *)dict URLStr:(NSString *)url RemoveAppidInfo:(BOOL)removeAppid Block:(RBNetworkHandleBlock) block{
   
    //参数
    NSDictionary * resultDict = nil;
    resultDict =  [RBNetworkHandle getCommonDict:dict NeedAppid:!removeAppid];

    
    //地址
    NSString * urlStr = [NSString stringWithFormat:@"%@",url];
    //生成请求
    
    [RBNetworkEngine sendRequest:^(RBNetworkRequest * _Nullable request) {
        request.url = urlStr;
        request.parameters = resultDict;
        request.method = RBRequestMethodPost;
    } onSuccess:^(id  _Nullable responseObject) {
        RBErrorBlock filterblock = [[RBErrorHandle sharedHandle] getBlockWithErrorNumber:[[responseObject objectForKey:@"result"] intValue]];
        if(filterblock){
            filterblock(nil);
            if(block){
                block(responseObject);
            }
        }else{
            if(block){
                block(responseObject);
            }

        }
        
    } onFailure:^(NSError * _Nullable error) {
        int code = (int)error.code;
        NSLog(@"网络请求错误码是 = %d",code);
        NSLog(@"网络请求错误详情 = %@",[dict objectForKey:NSLocalizedDescriptionKey]);
        //如果是-999 证明是主动取消任务，底层默认不会将错误抛出
        if (code == -999) {
            //手动取消
            return;
        }
        if(block)
        {
            block(@{@"result":[NSNumber numberWithInt:code]});
        }
    }];
    
    return nil;
    

}

+ (RBNetworkHandle *)downDataWihtPara:(NSDictionary *)dict URLStr:(NSString *)url toFilePath:(NSString*)filePath Block:(void (^)(bool)) block{
    //参数
    NSDictionary * resultDict = [RBNetworkHandle getCommonDict:dict NeedAppid:NO];
    //地址
    NSString * urlStr = [NSString stringWithFormat:@"%@",url];
    //生成请求
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:resultDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString * json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [RBNetworkEngine sendRequest:^(RBNetworkRequest * _Nullable request) {
        request.url = urlStr;
        request.parameters = @{@"json":json};
        request.method = RBRequestMethodPost;
        request.type = RBRequestDownload;
        request.downloadSavePath = filePath;
    } onSuccess:^(id  _Nullable responseObject) {
        if (block){
            block(true);
        }
        NSLog(@"");
        
    } onFailure:^(NSError * _Nullable error) {
        if (block){
            block(false);
        }
        NSLog(@"");
    }];
    return nil;
}


+ (RBNetworkHandle *)uploadNetDataWihtPara:(NSDictionary *)dict URLStr:(NSString *)url filePath:(NSString*)filePath Block:(RBNetworkHandleBlock) block
{
    
    //参数
    NSDictionary * resultDict = [RBNetworkHandle getCommonDict:dict NeedAppid:NO];
    //地址
    NSString * urlStr = [NSString stringWithFormat:@"%@",url];
    //生成请求
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:resultDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString * json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [RBNetworkEngine sendRequest:^(RBNetworkRequest * _Nullable request) {
        request.url = urlStr;
        request.parameters = @{@"json":json};
        request.method = RBRequestMethodPost;
        request.type = RBRequestUpload;
        NSString *mineType = @"application/octet-stream";
        CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[filePath pathExtension], NULL);
        CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
        CFRelease(UTI);
        if (MIMEType) {
            mineType = (__bridge NSString *)(MIMEType);
        }
        [request addFormDataWithName:@"file" fileName:[filePath lastPathComponent] mimeType:mineType fileData:fileData];
    } onSuccess:^(id  _Nullable responseObject) {
        RBErrorBlock filterblock = [[RBErrorHandle sharedHandle] getBlockWithErrorNumber:[[responseObject objectForKey:@"result"] intValue]];
        if(filterblock){
            filterblock(nil);
            if(block){
                block(responseObject);
            }
        }else{
            if(block){
                block(responseObject);
            }
            
        }
        
    } onFailure:^(NSError * _Nullable error) {
        int code = (int)error.code;
        NSLog(@"网络请求错误码是 = %d",code);
        NSLog(@"网络请求错误详情 = %@",[dict objectForKey:NSLocalizedDescriptionKey]);
        //如果是-999 证明是主动取消任务，底层默认不会将错误抛出
        if (code == -999) {
            //手动取消
            return;
        }
        if(block)
        {
            block(@{@"result":[NSNumber numberWithInt:code]});
        }
    }];
    
    return nil;
    

}
#pragma mark - 处理回包
+ (void)handleResponse:(id)response Error:(NSError*)error Block:(RBNetworkHandleBlock)block{
    if (error) {
        if (block) {
            block(nil);
        }
    }else{
        if (block) {
            block(response);
        }
    }
}

#pragma mark - action: 拼接地址路径，添加唯一标识
+ (NSString *)getInterUrl:(NSString *)host Path:(NSString * )path{
    NSString * str = @"";
    if(path){
        str = [NSString stringWithFormat:@"%@%@?*reqid*=%@",host,path,RBNetConfigManager.rb_net_once_Identifier];
    }else{
        str = [NSString stringWithFormat:@"%@?*reqid*=%@",host,RBNetConfigManager.rb_net_once_Identifier];
    }
    return str;
}




#pragma mark ------------------- 服务器环境 ------------------------
//环境 Key
static NSString * const kRooboNetEnviromentKey = @"RooboNetEnviromentKey";
#pragma mark 环境：- 服务器地址
+ (NSString *)getUrlHost{
    NSUInteger flag = [RBNetworkHandle getDefaultEviroment];
    NSString * host = nil;
    if(flag == RBServerState_Developer){
        //开发
        if (RBNetConfigManager.rb_url_host_develop.length>0) {
            host = RBNetConfigManager.rb_url_host_develop;
        }else{
            host  = RB_URL_HOST_Develop;
        }
    }else if(flag == RBServerState_Test){
        //测试
        if (RBNetConfigManager.rb_url_host_Test.length>0) {
            host = RBNetConfigManager.rb_url_host_Test;
        }else{
            host = RB_URL_HOST_Test;
        }
    }else if(flag == RBServerState_Online){
        //线上
        if (RBNetConfigManager.rb_url_host_Online.length>0) {
            host = RBNetConfigManager.rb_url_host_Online;
        }else{
            host = RB_URL_HOST_Online;
        }
    }else if(flag == RBServerState_custom){
        //线上
        NSString * str = [PDNetworkCache cacheForKey:@"test_url"];
        if (str.length>0) {
            host = str;
        }else{
            host = RB_URL_HOST_Online;
        }
    }
    return host;
}

#pragma mark 环境：- 视频服务器地址
+ (NSString *)getVideoSocket{
    NSUInteger flag = [RBNetworkHandle getDefaultEviroment];
    NSString * host = nil;
    if(flag == RBServerState_Developer){
        //视频：开发（视频服务器只有测试环境和线上环境，开发使用测试环境）
        if (RBNetConfigManager.rb_url_video_Test.length>0) {
            host = RBNetConfigManager.rb_url_video_Test;
        }else{
            host  = RB_VIDEOSOCKET_Test;
        }
    }else if(flag == RBServerState_Test){
        //视频：测试
        if (RBNetConfigManager.rb_url_video_Test.length>0) {
            host = RBNetConfigManager.rb_url_video_Test;
        } else {
            host  = RB_VIDEOSOCKET_Test;
        }
    }else if(flag == RBServerState_Online){
        //视频：线上
        if (RBNetConfigManager.rb_url_video_Online.length>0) {
            host = RBNetConfigManager.rb_url_video_Online;
        } else {
            host  = RB_VIDEOSOCKET_Online;
        }
    }else if(flag == RBServerState_custom){
        //视频：线上
        if (RBNetConfigManager.rb_url_video_Online.length>0) {
            host = RBNetConfigManager.rb_url_video_Online;
        } else {
            host  = RB_VIDEOSOCKET_Online;
        }
    }
    return host;
}

#pragma mark 环境：- 升级服务器地址
+ (NSString *)getAppUpdataURLHost{
    NSUInteger flag = [RBNetworkHandle getDefaultEviroment];
    NSString * host = nil;
    if(flag == RBServerState_Developer){
        //升级：开发
        if (RBNetConfigManager.rb_url_update_develop.length>0) {
            host = RBNetConfigManager.rb_url_update_develop;
        }else{
            host  = RB_UPDATE_Develop;
        }
    } else if (flag == RBServerState_Test){
        //升级：测试
        if (RBNetConfigManager.rb_url_update_Test.length>0) {
            host = RBNetConfigManager.rb_url_update_Test;
        }else{
            host  = RB_UPDATE_Test;
        }
    } else if (flag == RBServerState_Online){
        //升级：线上
        if (RBNetConfigManager.rb_url_update_Online.length>0) {
            host = RBNetConfigManager.rb_url_update_Online;
        } else {
            host  = RB_UPDATE_Online;
        }
    }else if (flag == RBServerState_custom){
        //升级：线上
        if (RBNetConfigManager.rb_url_update_Online.length>0) {
            host = RBNetConfigManager.rb_url_update_Online;
        } else {
            host  = RB_UPDATE_Online;
        }
    }
    return host;
}

#pragma mark 环境：- 反馈服务器地址
+ (NSString *)userFeedbackURL{
    NSUInteger flag = [RBNetworkHandle getDefaultEviroment];
    NSString * host = nil;
    if(flag == RBServerState_Developer){
        //反馈：开发
        if (RBNetConfigManager.rb_url_feedback_develop.length>0) {
            host = RBNetConfigManager.rb_url_feedback_develop;
        } else {
            host  = RB_FEEDBACK_Develop;
        }
    }else if(flag == RBServerState_Test){
        //反馈：测试
        if (RBNetConfigManager.rb_url_feedback_Test.length>0) {
            host = RBNetConfigManager.rb_url_feedback_Test;
        } else {
            host  = RB_FEEDBACK_Test;
        }
    }else if(flag == RBServerState_Online){
        //反馈：线上
        if (RBNetConfigManager.rb_url_feedback_Online.length>0) {
            host = RBNetConfigManager.rb_url_feedback_Online;
        } else {
            host  = RB_FEEDBACK_Online;
        }
    }else if(flag == RBServerState_custom){
        //反馈：线上
        if (RBNetConfigManager.rb_url_feedback_Online.length>0) {
            host = RBNetConfigManager.rb_url_feedback_Online;
        } else {
            host  = RB_FEEDBACK_Online;
        }
    }
    return host;
    
}

#pragma mark 环境：- 打点服务器地址
+ (NSString *)getStatURLHost{
    NSUInteger flag = [RBNetworkHandle getDefaultEviroment];
    NSString * host = nil;
    if(flag == RBServerState_Developer){
        if (RBNetConfigManager.rb_url_stat_develop.length>0) {
            host = RBNetConfigManager.rb_url_stat_develop;
        }else{
            host  = RB_STAT_Develop;
        }
    }else if(flag == RBServerState_Test){
        if (RBNetConfigManager.rb_url_stat_Test.length>0) {
            host = RBNetConfigManager.rb_url_stat_Test;
        }else{
            host  = RB_STAT_Test;
        }
    }else if(flag == RBServerState_Online){
        if (RBNetConfigManager.rb_url_stat_Online.length>0) {
            host = RBNetConfigManager.rb_url_stat_Online;
        }else{
            host  = RB_STAT_Online;
        }
    }else if(flag == RBServerState_custom){
        if (RBNetConfigManager.rb_url_stat_Online.length>0) {
            host = RBNetConfigManager.rb_url_stat_Online;
        }else{
            host  = RB_STAT_Online;
        }
    }
    
    
    return host;
}


#pragma mark 环境：-崩溃服务器地址
+(NSString*)getCrashURLHost{
    NSUInteger flag = [RBNetworkHandle getDefaultEviroment];
    NSString * host = nil;
    if(flag == RBServerState_Developer){
        //崩溃：开发
        if (RBNetConfigManager.rb_url_crash_develop.length>0) {
            host = RBNetConfigManager.rb_url_crash_develop;
        }else{
            host  = RB_CRASH_Develop;
        }
    }else if(flag == RBServerState_Test){
        //崩溃：测试
        if (RBNetConfigManager.rb_url_crash_Test.length>0) {
            host = RBNetConfigManager.rb_url_crash_Test;
        }else{
            host  = RB_CRASH_Test;
        }
    }else if(flag == RBServerState_Online){
        //崩溃：线上
        if (RBNetConfigManager.rb_url_crash_Online.length>0) {
            host = RBNetConfigManager.rb_url_crash_Online;
        } else {
            host  = RB_CRASH_Online;
        }
    }else if(flag == RBServerState_custom){
        //崩溃：线上
        if (RBNetConfigManager.rb_url_crash_Online.length>0) {
            host = RBNetConfigManager.rb_url_crash_Online;
        } else {
            host  = RB_CRASH_Online;
        }
    }
    return host;
}


#pragma mark 环境：- 获取默认环境
+ (RBServerState)getDefaultEviroment{
    NSUInteger flag = [[NSUserDefaults standardUserDefaults] integerForKey:kRooboNetEnviromentKey];
    if(flag > RBServerState_Online || flag < RBServerState_custom){
        [RBNetworkHandle changeHttpURL:RooboDefaultNetEnviroment];
        flag = RooboDefaultNetEnviroment;
    }
    return flag;
}
#pragma mark 环境：- 改变环境
+ (void)changeHttpURL:(RBServerState)flag{
    [[NSUserDefaults standardUserDefaults] setInteger:flag forKey:kRooboNetEnviromentKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
