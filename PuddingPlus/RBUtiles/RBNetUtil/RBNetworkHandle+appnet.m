//
//  RBNetworkHandle+appnet.m
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle+appnet.h"
#import "RBNetwork.h"
#import "RBNetworkHandle+Common.h"
#import "UIDevice+RBExtension.h"
#import "YYCache.h"
#import "YYMemoryCache.h"
@implementation RBNetworkHandle (appnet)
#pragma mark 运营：- 获取运营数据
+ (RBNetworkHandle *)getOperateDataWithBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"index/guide",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_OPERATE];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 运营：- 获取专辑下收藏数据
+ (RBNetworkHandle *)getAblumCollectData:(NSString *)catid mainctl:(NSString *)mainctl andBlock:(RBNetworkHandleBlock)block{
    NSDictionary *dict = @{@"action":@"favorites/album",@"data":@{@"mainctl":mainctl,@"catid":@([catid intValue])}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_COLLECTION];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 运营：- 获取分享信息
+ (RBNetworkHandle *)getShareVideoMessage:(NSString *)videoURL ThumbURL:(NSString *)url Type:(NSString *)type VideoLength:(NSNumber *)length WithBlock:(RBNetworkHandleBlock)block{
    NSNumber * vlentth = length;
    if(vlentth == nil)
        vlentth = @(0);
    
    NSDictionary * dict = @{@"action":@"share/make",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid],@"img":[NSString stringWithFormat:@"%@",url],@"content":[NSString stringWithFormat:@"%@",videoURL],@"length":vlentth,@"type":[NSString stringWithFormat:@"%@",type]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_SHARE];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}


#pragma mark 上传：- 视频错误日志

+ (RBNetworkHandle *)uploadVideoErrorLogWithFileURL:(NSString *)fileURL Block:(RBNetworkHandleBlock)block{
    NSMutableDictionary * resultDict = [NSMutableDictionary new];
    [resultDict setObject:@"uplogger" forKey:@"action"];
    NSMutableDictionary * dataDict = [NSMutableDictionary dictionary];
    NSString * version  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString * appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * devName = [RBNetworkHandle getDevName];
    NSDictionary * appinfo = @{@"via":devName,@"app":[NSString stringWithFormat:@"%@_IOS",@"pudding1s"],@"cver":@([version intValue]),@"aver":appversion,@"osver":@(0),@"local":@"zh_CN",@"ch":[RBNetworkHandle getChannelId]};
    [dataDict setObject:appinfo forKey:@"app"];
    NSString * userid = [NSString stringWithFormat:@"%@",RB_Current_UserId];
    [dataDict setObject:userid forKey:@"clientId"];
    [dataDict setObject:@"video-failed" forKey:@"type"];
    [dataDict setObject:@"v1" forKey:@"version"];
    [dataDict setObject:@"file" forKey:@"content"];
    [dataDict setObject:@(0) forKey:@"start"];
    [dataDict setObject: [NSString stringWithFormat:@"%@",RB_Current_Mcid]forKey:@"mainctl"];

    NSFileManager* fileManager = [NSFileManager defaultManager];
    [dataDict setObject:@([[fileManager attributesOfItemAtPath:fileURL error:nil] fileSize]) forKey:@"size"];
    if ([fileManager fileExistsAtPath:fileURL]){
        NSLog(@"有这个文件");
        [dataDict setObject:@([[fileManager attributesOfItemAtPath:fileURL error:nil] fileSize]) forKey:@"fullsize"];
    }else{
        NSLog(@"没有这个文件");
        [dataDict setObject:@(10) forKey:@"fullsize"];
    }
    //随机文件名
    NSString *newFileName = @"";
    NSString * timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    newFileName = [NSString stringWithFormat:@"video_error_%@.zip",timeSp];
    NSMutableData * data = [NSMutableData dataWithContentsOfFile:fileURL];
    [dataDict setObject:newFileName forKey:@"file"];
    [resultDict setObject:dataDict forKey:@"data"];
    NSDictionary * resDict = [RBNetworkHandle getCommonDict:resultDict NeedAppid:NO];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:resDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString * json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //url
    NSString*urlStr = RB_VIDEO_ERROR;
    [RBNetworkEngine sendRequest:^(RBNetworkRequest * _Nullable request) {
        request.url = urlStr;
        request.parameters = @{@"json":json};
        request.type = RBRequestUpload;
        request.method = RBRequestMethodPost;
        [request addFormDataWithName:@"file" fileName:newFileName mimeType:@"application/x-zip-compressed" fileData:data];
    } onSuccess:^(id  _Nullable responseObject) {
        [RBNetworkHandle handleResponse:responseObject Error:nil Block:block];
    } onFailure:^(NSError * _Nullable error) {
        [RBNetworkHandle handleResponse:nil Error:error Block:block];
    }];
    
    
    return nil;
}




#pragma mark 上传：- Log文件
+ (RBNetworkHandle *)uploadUserLogWithFileURL:(NSURL *)fileURL Block:(RBNetworkHandleBlock)block{
    NSMutableData *data = [NSMutableData dataWithContentsOfURL:fileURL];
    if (!data) {
        return nil;
    }
    NSMutableDictionary * resultDict = [NSMutableDictionary new];
    [resultDict setObject:@"uplogger" forKey:@"action"];
    NSMutableDictionary * dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:@"file" forKey:@"content"];
    NSString *fileName = [NSString stringWithFormat:@"PDLog_%f.zip",[[NSDate date] timeIntervalSince1970]];
    [dataDict setObject:fileName forKey:@"file"];
    [dataDict setObject:[NSString stringWithFormat:@"%@",RB_Current_UserId] forKey:@"clientId"];
    [dataDict setObject: [NSString stringWithFormat:@"%@",RB_Current_Mcid]forKey:@"mainctl"];
    [dataDict setObject:[NSNumber numberWithInteger:data.length]forKey:@"size"];
    [dataDict setObject:[NSString stringWithFormat:@"%llu",(unsigned long long)data.length]forKey:@"fullsize"];
    [dataDict setObject:[NSNumber numberWithInteger:0] forKey:@"start"];
    [dataDict setObject:@"v1" forKey:@"version"];
    [dataDict setObject:@"app-diagnosis" forKey:@"type"];
    NSMutableDictionary *appDict = [NSMutableDictionary dictionary];
    [appDict setObject:@"pudding1s_ios" forKey:@"app"];
    [appDict setObject:[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] forKey:@"aver"];
    [appDict setObject:[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]] forKey:@"cver"];
    [appDict setObject:[UIDevice currentDevice].systemVersion forKey:@"osver"];
    [appDict setObject:[NSString stringWithFormat:@"%@",[UIDevice systemDeviceTypeFormatted:YES]] forKey:@"via"];
    [appDict setObject:[NSString stringWithFormat:@"%@",[RBNetworkHandle getChannelId]] forKey:@"ch"];
    [appDict setObject:@"zh_CN" forKey:@"local"];
    [dataDict setObject:appDict forKey:@"app"];
    [resultDict setObject:dataDict forKey:@"data"];
    NSDictionary * resDict = [RBNetworkHandle getCommonDict:resultDict NeedAppid:NO];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString * json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * urlStr = [NSString stringWithFormat:@"%@",[RBNetworkHandle getCrashURLHost]];
 
    [RBNetworkEngine sendRequest:^(RBNetworkRequest * _Nullable request) {
        request.url = urlStr;
        request.parameters = @{@"json":json};
        [request addFormDataWithName:fileName fileName:@"file" mimeType:@"application/x-zip-compressed" fileData:data];
        [request addFormDataWithName:@"file" fileData:data];
        request.type = RBRequestUpload;
        request.method = RBRequestMethodPost;
    } onSuccess:^(id  _Nullable responseObject) {
        [RBNetworkHandle handleResponse:responseObject Error:nil Block:block];
    } onFailure:^(NSError * _Nullable error) {
        [RBNetworkHandle handleResponse:nil Error:error Block:block];
    }];
    
    
    
    return nil;
}

#pragma mark 上传： - 打点文件
+ (RBNetworkHandle *)uploadStatFile:(NSString *)fileURL fileName:(NSString *)fileName Block:(RBNetworkHandleBlock)block{
    NSMutableDictionary * resultDict = [NSMutableDictionary new];
    [resultDict setObject:@"uplogger" forKey:@"action"];
    NSMutableDictionary * dataDict = [NSMutableDictionary dictionary];
    NSString * version  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString * appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * devName = [RBNetworkHandle getDevName];
    NSDictionary * appinfo = @{@"via":devName,@"app":[NSString stringWithFormat:@"%@_IOS",@"pudding1s"],@"cver":@([version intValue]),@"aver":appversion,@"osver":@(0),@"local":@"zh_CN",@"ch":[RBNetworkHandle getChannelId]};
    [dataDict setObject:appinfo forKey:@"app"];
    NSString * userid = [NSString stringWithFormat:@"%@",RB_Current_UserId];
    [dataDict setObject:userid forKey:@"clientId"];
    [dataDict setObject:@"app" forKey:@"type"];
    [dataDict setObject:@"v1" forKey:@"version"];
    [dataDict setObject:@"file" forKey:@"content"];
    [dataDict setObject:@(0) forKey:@"start"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [dataDict setObject:@([[fileManager attributesOfItemAtPath:fileURL error:nil] fileSize]) forKey:@"size"];
    if ([fileManager fileExistsAtPath:fileURL]){
        NSLog(@"有这个文件");
        [dataDict setObject:@([[fileManager attributesOfItemAtPath:fileURL error:nil] fileSize]) forKey:@"fullsize"];
    }else{
        NSLog(@"没有这个文件");
        [dataDict setObject:@(10) forKey:@"fullsize"];
    }
    //随机文件名
    NSString *newFileName = @"";
    NSString * timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSArray *arr = [fileName componentsSeparatedByString:@"."];
    newFileName = [NSString stringWithFormat:@"%@%@.%@",[arr firstObject],timeSp,[arr lastObject]];
    NSMutableData * data = [NSMutableData dataWithContentsOfFile:fileURL];
    [dataDict setObject:newFileName forKey:@"file"];
    [resultDict setObject:dataDict forKey:@"data"];
    NSDictionary * resDict = [RBNetworkHandle getCommonDict:resultDict NeedAppid:NO];

    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:resDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString * json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //url
    NSString*urlStr = [self getStatURLHost];
    [RBNetworkEngine sendRequest:^(RBNetworkRequest * _Nullable request) {
        request.url = urlStr;
        request.parameters = @{@"json":json};
        request.type = RBRequestUpload;
        request.method = RBRequestMethodPost;
        [request addFormDataWithName:@"file" fileName:newFileName mimeType:@"application/x-zip-compressed" fileData:data];
    } onSuccess:^(id  _Nullable responseObject) {
        [RBNetworkHandle handleResponse:responseObject Error:nil Block:block];
    } onFailure:^(NSError * _Nullable error) {
        [RBNetworkHandle handleResponse:nil Error:error Block:block];
    }];
    
    
    return nil;
}

#pragma mark - 

+ (RBNetworkHandle *)fetchLanchAdWithBlock:(RBNetworkHandleBlock)block{
    NSDictionary * dict = @{@"action":@"index/screen",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_HOME_SCREEN];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;

}

@end
