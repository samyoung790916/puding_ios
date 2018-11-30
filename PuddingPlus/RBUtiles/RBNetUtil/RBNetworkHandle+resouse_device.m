//
//  RBNetworkHandle+resouse_device.m
//  Pods
//
//  Created by Zhi Kuiyu on 2016/12/15.
//
//

#import "RBNetworkHandle+resouse_device.h"
#import "RBNetwork.h"
#import "RBNetworkHandle+Common.h"

#import "YYCache.h"
#import "YYMemoryCache.h"
@implementation RBNetworkHandle (resouse_device)
#pragma mark 收藏：- 获取收藏列表
+(RBNetworkHandle *)getCollectionListWithMainID:(NSString*)mainCtrID type:(NSInteger)type page:(NSInteger)page miniId:(NSString*)miniId andBlock:(RBNetworkHandleBlock) block{
    if (miniId) {
        NSDictionary * dict = @{@"action":@"favorites/rlist",@"data":@{@"mainctl":mainCtrID,@"type":[NSNumber numberWithInteger:type],@"page":[NSNumber numberWithInteger:page],@"minid":miniId}};
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_COLLECTION] Block:block];
        return handle;
    }else{
        NSDictionary * dict = @{@"action":@"favorites/rlist",@"data":@{@"mainctl":mainCtrID,@"type":[NSNumber numberWithInteger:type],@"page":[NSNumber numberWithInteger:page]}};
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:[RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_COLLECTION] Block:block];
        return handle;
        
    }
}

#pragma mark 收藏：- 添加收藏列表
+(RBNetworkHandle *)addCollectionData:(NSArray*)idsArr andMainID:(NSString*)mainCtrID andBlock:(RBNetworkHandleBlock) block{
    if(!mainCtrID || !idsArr){
        block(nil);
        return nil;
    }
    
    NSDictionary * dict = @{@"action":@"favorites/radd",@"data":@{@"mainctl":mainCtrID,@"ids":idsArr}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_COLLECTION];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark 收藏：- 删除收藏列表
+(RBNetworkHandle *)deleteCollectionDataIds:(NSArray *)idsArr andMainID:(NSString*)mainCtrID andBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"favorites/rdel",@"data":@{@"mainctl":mainCtrID,@"ids":idsArr}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_COLLECTION];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 家庭动态：- 删除家庭动态数据
+(RBNetworkHandle *)deleteFamlilyDynaList:(NSString*)deletArray andMainID:(NSString*)mainCtrID andBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"moment/del",@"data":@{@"myid":[NSString stringWithFormat:@"%@",RB_Current_UserId],@"ids":deletArray,@"mainctl":mainCtrID}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_FAMILY_MOMENT];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 上传：- 兴趣培养文件
+ (RBNetworkHandle *)uploadUserCustom:(NSString *)xingqu UserCustonID:(NSNumber *)cid WithBlock:(RBNetworkHandleBlock) block{
    if(xingqu){
        if ([RBNetworkHandle isLegal]) {
            NSDictionary * dict ;
            if(cid){
                dict = @{@"action":@"custom/save",@"data":@{@"mainctl":RB_Current_Mcid,@"content":xingqu,@"id":cid}};
            } else {
                dict = @{@"action":@"custom/save",@"data":@{@"mainctl":RB_Current_Mcid,@"content":xingqu}};
            }
            NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:@"users/custom"];
            RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
            return handle;
        }else{
            return  nil;
        }
    }else{
        return nil;
    }
}
#pragma mark 家庭动态：- 获取家庭动态列表
static NSString * kFamilyCache_Name = @"FamilyCache_Name";
+(RBNetworkHandle *)fetchFamilyDynaWithStartID:(NSString*)startID  andMainID:(NSString*)mainCtrID andBlock:(RBNetworkHandleBlock) block{
    NSMutableDictionary * resultDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * dataDict = [[NSMutableDictionary alloc] init];
    if (startID) {
        [dataDict setObject:[NSNumber numberWithLongLong:startID.longLongValue] forKey:@"maxid"];
    }
    [dataDict setObject:mainCtrID forKey:@"mainctl"];
    NSString * devName = [RBNetworkHandle getDevName];
    NSString * bundleId  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleIdentifierKey];
    NSString * version  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString * appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary * appinfo = @{@"via":devName,@"app":[NSString stringWithFormat:@"%@.ios",bundleId],@"cver":@([version intValue]),@"aver":appversion,@"osver":@(0),@"local":@"zh_CN",@"ch":[RBNetworkHandle getChannelId]};
    [dataDict setObject:appinfo forKey:@"app"];
    [dataDict setObject:[NSString stringWithFormat:@"%@",RB_Current_UserId] forKey:@"myid"];
    
    
    [dataDict setObject:@"ios" forKey:@"from"];
    if(RB_Current_Token){
        [dataDict setObject:RB_Current_Token forKey:@"token"];
    }
    
    [resultDict setObject:dataDict forKey:@"data"];
    [resultDict setObject:@"moment/list" forKey:@"action"];
    YYCache *cache = [[YYCache alloc] initWithName:kFamilyCache_Name];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
   
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_FAMILY_MOMENT];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:resultDict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark 家庭相册：- 获取家庭动态图片（根据 Page）
+(RBNetworkHandle *)fetchFamilyPhotosWithPage:(NSUInteger)startID  andMainID:(NSString*)mainCtrID andBlock:(RBNetworkHandleBlock) block{
    NSMutableDictionary * resultDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setObject:[NSNumber numberWithUnsignedInteger:startID] forKey:@"page"];
    [dataDict setObject:mainCtrID forKey:@"mainctl"];
    NSString * devName = [RBNetworkHandle getDevName];
    NSString * bundleId  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleIdentifierKey];
    NSString * version  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString * appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary * appinfo = @{@"via":devName,@"app":[NSString stringWithFormat:@"%@.ios",bundleId],@"cver":@([version intValue]),@"aver":appversion,@"osver":@(0),@"local":@"zh_CN",@"ch":[RBNetworkHandle getChannelId]};
    [dataDict setObject:appinfo forKey:@"app"];
    [dataDict setObject:[NSString stringWithFormat:@"%@",RB_Current_UserId] forKey:@"myid"];
    [dataDict setObject:@"ios" forKey:@"from"];
    if (RB_Current_Token) {
        [dataDict setObject:RB_Current_Token forKey:@"token"];
    }
    [resultDict setObject:dataDict forKey:@"data"];
    [resultDict setObject:@"favorites/mlist" forKey:@"action"];
    YYCache *cache = [[YYCache alloc] initWithName:kFamilyCache_Name];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_COLLECTION];

    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:resultDict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 家庭相册：- 保存家庭相册列表
+(RBNetworkHandle *)saveFamlilyPhotoList:(NSArray*)deletArray andMainID:(NSString*)mainCtrID andBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"favorites/madd",@"data":@{@"myid":[NSString stringWithFormat:@"%@",RB_Current_UserId],@"ids":deletArray,@"mainctl":mainCtrID}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_COLLECTION];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark 家庭相册：- 删除家庭照片列表
+(RBNetworkHandle *)deleteFamlilyPhotoList:(NSArray*)deletArray andMainID:(NSString*)mainCtrID andBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"favorites/mdel",@"data":@{@"myid":[NSString stringWithFormat:@"%@",RB_Current_UserId],@"ids":deletArray,@"mainctl":mainCtrID}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_COLLECTION];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark 获取布丁优选数据
+(RBNetworkHandle *)fetchPuddingResWithSearch:(NSString *)keyword controlID:(NSString *)mcid Type:(int)type Page:(int)page block:(void(^)(id res))block{
    NSString * action = @"resource/search";
    
    NSDictionary * dict = @{@"action":action,@"data":@{@"mainctl":mcid,@"keyword":keyword,@"count":@20,@"type":@(type),@"page":@(page)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_USER_RESOURCE];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
    
}

#pragma mark - 获取搜索数据
+(RBNetworkHandle *)fetchPuddingContentWithAge:(NSInteger)age controlID:(NSString *)mcid IsPlus:(BOOL)isPlus block:(void(^)(id res))block{
    NSString * action = @"resource/good";
    
    NSDictionary * dict = @{@"action":action,@"data":@{@"age":[NSString stringWithFormat:@"%zd",age],@"mainctl":mcid}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_HOME_INDEX];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
    
}

#pragma mark 获取首页面配置
+(RBNetworkHandle *)fetchMainModulesWithAge:(NSInteger)age controlID:(NSString *)mcid IsPlus:(BOOL)isPlus block:(void(^)(id res))block{
    NSString * action = @"index/modules_v4";
    NSDictionary * dict = nil;
    if(isPlus){
        action = @"index/app_plus_v4";
        dict = @{@"action":action,@"data":@{@"age":[NSString stringWithFormat:@"%zd",age],@"mainctl":mcid,@"version":@2}};
    }else{
        dict = @{@"action":action,@"data":@{@"age":[NSString stringWithFormat:@"%zd",age],@"mainctl":mcid}};
    }
    
   
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_HOME_INDEX];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;

}
+(RBNetworkHandle *)fetch_XMainModulesWithAge:(NSInteger)age controlID:(NSString *)mcid block:(void(^)(id res))block{
    NSString * action = @"index/app_pdx";
    NSDictionary * dict = nil;
    dict = @{@"action":action,@"data":@{@"age":[NSString stringWithFormat:@"%zd",age],@"mainctl":mcid}};
    
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_HOME_INDEX];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
    
}

#pragma mark - 获取TTS 锁定资源
+(RBNetworkHandle *)fetchPuddingLockResouse:(void(^)(id res))block{

    NSString * action = @"wallow/list";
    NSDictionary * dict = nil;
    dict = @{@"action":action,@"data":@{@"mainctl":RBDataHandle.currentDevice.mcid}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_DIY];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;

}
#pragma mark -解锁布丁
+ (RBNetworkHandle *)unlockPudding:(int) lock_id Modle_type:(int)modletype lock_time:(int)lock_time block:(void(^)(id res))block{
    NSString * action = @"SYSTEM/unlock";
    NSDictionary * dict = nil;
    dict = @{@"action":action,@"data":@{@"mainctl":RBDataHandle.currentDevice.mcid,@"wid":@(lock_id),@"mode_type":@(modletype),@"lock_time":@(lock_time)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark - 锁定布丁
+ (RBNetworkHandle *)lockPudding:(int) lock_id Modle_type:(int)modletype lock_time:(int)lock_time tts:(NSString *)ttsString block:(void(^)(id res))block{
    if([ttsString length] == 0){
        
        return nil;
    }
    NSString * action = @"SYSTEM/lock";
    NSDictionary * dict = nil;
    dict = @{@"action":action,@"data":@{@"mainctl":RBDataHandle.currentDevice.mcid,@"wid":@(lock_id),@"mode_type":@(modletype),@"lock_time":@(lock_time),@"tts":ttsString}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_MASTER_CMD];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}



+(RBNetworkHandle *)fetchMenuCategoryWithID:(NSInteger)ID type:(NSString*) type page:(NSInteger)page andBlock:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"index/categorys",@"data":@{@"id":[NSString stringWithFormat:@"%zd",ID],@"page":[NSNumber numberWithInteger:page],@"type":type,@"mainctl":[NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.mcid]}};
    
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_HOME_INDEX];
    return [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
}


+(RBNetworkHandle *)fetchFilterMenuBlock:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"index/menu"};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_HOME_INDEX];
    return [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
}

#pragma mark - 英语教育

/**
 *  闹钟与资源展示  http://wiki.365jiating.com/pages/viewpage.action?pageId=3966255#morning&bedtime-设置morning/bedtime
 *
 *  @param type  1 morning 2bedtime
 *  @param block <#block description#>
 */
+ (RBNetworkHandle *)fetchEnglishAlarmWith:(NSInteger) type Block:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"alarm/clockshowV2",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid],@"type":[NSNumber numberWithInteger:type]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_REMIND];
    return [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
}
+ (RBNetworkHandle *)deleteEnglishAlarmWithID:(NSInteger) alarmID Block:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"alarm/delclock",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid],@"id":[NSNumber numberWithInteger:alarmID]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_REMIND];
    return [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
}
+(RBNetworkHandle *)setupEnglishWithType:(NSInteger)type week:(NSArray*)weeks time:(NSInteger)time alarmID:(NSInteger )alarmID state:(NSInteger)state bell_id:(NSInteger)bellID block:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"alarm/set",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid],@"id":[NSNumber numberWithInteger:alarmID],@"type":[NSNumber numberWithInteger:type],@"state":[NSNumber numberWithInteger:state],@"week":weeks,@"timer":[NSNumber numberWithInteger:time],@"bell_id":[NSNumber numberWithLong:bellID]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_REMIND];
    return [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    
}
// 获取英语历史记录
+ (RBNetworkHandle *)getEnglishHistoryInfoWithType:(NSNumber *)type Page:(NSInteger)page andBlock:(void(^)(id res))block {
    NSDictionary * dict = @{@"action":@"remind/history",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid],@"type":type,@"page":@(page)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:RB_URL_PATH_REMIND];
    return [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
}

#pragma makr - 获取收藏页面的历史记录
+ (RBNetworkHandle *)getCollectionPageHistoryInfoWithFrom:(NSInteger)from andBlock:(void(^)(id res))block {
    NSDictionary * dict = @{@"action":@"history/get",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid],@"from":@(from)}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_USERS_HISTORY];
    return [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    
}
// 删除收藏历史记录中的数据
+ (RBNetworkHandle *)deleteCollectionPageHistoryInfoWithIds:(NSArray *)ids andBlock:(void(^)(id res))block {
    NSDictionary * dict = @{@"action":@"history/del",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid],@"ids":ids}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_USERS_HISTORY];
    return [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];

}

+ (RBNetworkHandle *)getStoryDemoMessage :(void (^)(id res)) block{
    
    NSDictionary * dict = @{@"action":@"interstory/demo",@"data":@{@"mainctl":RB_Current_Mcid}};
    
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_USERS_INTERSTORY];
    return [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    
}

+(RBNetworkHandle *)fetchBabyPlanInfo:(void (^)(id))block{
    NSDictionary * dictPara = @{@"action":@"baby/plansnew",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST Path:URL_PATH_USERS_BABY];
    return [RBNetworkHandle getNetDataWihtPara:dictPara URLStr:urlStr Block:block];
    
}
#pragma mark -   获取宝贝信息
+ (RBNetworkHandle *)getBabyBlock:(void(^)(id res))block{
    NSString * actionStr = @"users/getbaby";
    NSString * mainctl = [NSString stringWithFormat:@"%@",RB_Current_Mcid];
    NSString * userid = [NSString stringWithFormat:@"%@",RB_Current_UserId];
    NSString * token = [NSString stringWithFormat:@"%@",RB_Current_Token];
    NSDictionary * dict = @{@"action":actionStr,@"data":@{@"mainctl":mainctl,@"myid":userid,@"token":token}};
    
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:RB_URL_PATH_UPDATE_USER_INFO];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
    
}
+ (RBNetworkHandle *)getBabyMcid:(NSString*)mcid Block:(void(^)(id res))block{
    NSString * actionStr = @"users/getbaby";
    NSString * mainctl = [NSString stringWithFormat:@"%@",mcid];
    NSString * userid = [NSString stringWithFormat:@"%@",RB_Current_UserId];
    NSString * token = [NSString stringWithFormat:@"%@",RB_Current_Token];
    NSDictionary * dict = @{@"action":actionStr,@"data":@{@"mainctl":mainctl,@"myid":userid,@"token":token}};
    
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:RB_URL_PATH_UPDATE_USER_INFO];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
    
}
#pragma mark -   修改 DIY 回答
+ (RBNetworkHandle *)updateDIYModle:(NSNumber *)quesionId Question:(NSString *)question Response:(NSString *)response WithBlock:(void (^)(id res)) block{
    NSDictionary * dict;
    
    if(question == nil || response == nil){
        return nil;
    }
    
    if([quesionId intValue] < 0 || !quesionId){
        dict = @{@"action":@"response/save",@"data":@{@"mainctl":RB_Current_Mcid,@"question":question,@"response":response}};
    }else{
        dict = @{@"action":@"response/save",@"data":@{@"mainctl":RB_Current_Mcid,@"question":question,@"response":response,@"id":@([quesionId intValue])}};
    }
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:RB_URL_PATH_DIY];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;

}

#pragma mark -  获取 DIY 回答列表
+ (RBNetworkHandle *)getDIYList:(int)start Count:(int)count WithBlock:(void (^)(id res)) block{
    NSDictionary * dict = @{@"action":@"response/list",@"data":@{@"mainctl":RB_Current_Mcid,@"start":@(start),@"count":@(count),@"key":@""}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:RB_URL_PATH_DIY];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark -   删除 DIY 回答
+ (RBNetworkHandle *)deleteDIYModle:(NSArray *)ids WithBlock:(void (^)(id res)) block{
    NSDictionary * dict;
    
    if([ids count] == 0){
        if(block)
            block(nil);
        return nil;
    }else{
        dict = @{@"action":@"response/del",@"data":@{@"mainctl":RB_Current_Mcid,@"id":ids}};
        NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:RB_URL_PATH_DIY];
        RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
        return handle;
    }
 
}
#pragma mark ------------------- 版本更新 ------------------------
#pragma mark - 获取版本信息接口（新）
+ (RBNetworkHandle *)getUpdateMessage:(BOOL) isPlus Block:(void (^)(id))block{
    NSString *production = @"";
    if (RBDataHandle.currentDevice.isPuddingPlus) {
        production = @"pudding-plus.appupdate";
    }else if (RBDataHandle.currentDevice.isStorybox){
        production = [RBNetworkHandle getPD_XAppId];
    }else{
        production = @"pudding1s.appupdate";
    }
    NSDictionary * dict = @{@"action":@"common/max_version",@"data":@{@"production":production,@"clientId":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:[RBNetworkHandle getAppUpdataURLHost]  Path:URL_PATH_DEVICE_VERSION];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
   
}
#pragma mark - 获取当前布丁的进程
+ (RBNetworkHandle *)getPuddingClintInfo:(void (^)(id))block{
    NSDictionary * dict = @{@"action":@"scene/get",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:[RBNetworkHandle getUrlHost]  Path:URL_PATH_DEV_INFO];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
    
}


+ (RBNetworkHandle *)setFangchenmiModle:(int) state Duration:(NSUInteger)duration :(void (^)(id res)) block{
    
    if(RB_Current_UserId == nil || RB_Current_Mcid == nil)
        if(block)
            block(nil);
    
    NSDictionary * dict = @{@"action":@"fangchenmi/set",@"data":@{@"type":@1,@"duration":@(duration),@"state":@(state)}};
    
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:URL_PATH_USER_FANGCHENMI];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

+ (RBNetworkHandle *)forceUpdatePudding:(void (^)(id res)) block{
    
    if(RB_Current_UserId == nil || RB_Current_Mcid == nil)
        if(block)
            block(nil);
    
    NSDictionary * dict = @{@"action":@"update/forcedev",@"data":@{@"mainctl":RB_Current_Mcid,@"myid":RB_Current_UserId,@"production":@"pudding1s.appupdate"}};

    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:URL_PATH_DEVICE_UPDATE];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
+(RBNetworkHandle *)fetchVideoResoucesList:(NSInteger)age page:(NSInteger) page block:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"resouces/video",@"data":@{@"age":[NSNumber numberWithInteger:age],@"page":[NSNumber numberWithInteger:page],@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:URL_PATH_HOME_INDEX];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}


+(RBNetworkHandle *)fetchAllEnglishCallResoucesList:(NSInteger) page block:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"bilingual/topic",@"data":@{@"pagesize":@(20),@"page":[NSNumber numberWithInteger:page],@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:URL_PATH_USER_LESSON];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

+(RBNetworkHandle *)fetchAllEnglishSessionList:(int)sessionId Page:(NSInteger) page block:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"topic/detail",@"data":@{@"pagesize":@(20),@"page":[NSNumber numberWithInteger:page],@"id":@(sessionId),@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:URL_PATH_USER_LESSON];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

+(RBNetworkHandle *)fetchEnglishChapter:(int)sessionId  block:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"lesson/detail",@"data":@{@"id":@(sessionId),@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:URL_PATH_USER_LESSON];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

+(RBNetworkHandle *)studyEnglishChapter:(int)sessionId block:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"lesson/play",@"data":@{@"stage":@(-1),@"id":@(sessionId),@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:URL_PATH_USER_LESSON];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

+(RBNetworkHandle *)babyStudyScoreblock:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"baby/score",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:@"/users/baby"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

+(RBNetworkHandle *)babyStudyDetail:(NSString *)detail page:(NSInteger) page block:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"score/detail",@"data":@{@"type":detail, @"pagesize":@(20),@"page":[NSNumber numberWithInteger:page],@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:@"/users/baby"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}


#pragma mark - 书架
#pragma mark 获取书本详情
+(RBNetworkHandle *)fetchBookDetail:(NSString *)bookID result:(void(^)(id res))block{
    if ([bookID mStrLength] == 0) {
        if (block) {
            block(nil);
        }
        return nil;
    }
    NSDictionary * dict = @{@"action":@"book/info",@"data":@{@"id":@([bookID intValue])}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:@"/reading/partner"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark 获取书架详情
+(RBNetworkHandle *)fetchBookCase:(void(^)(id res))block{
    NSDictionary * dict = @{@"action":@"bookshelf/mult"};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:@"/reading/partner"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}

#pragma mark 获取书籍列表
+(RBNetworkHandle *)fetchBookList:(NSString *) listType PageNumber:(int)page block:(void(^)(id res))block{
    if ([listType mStrLength] == 0) {
        if (block) {
            block(nil);
        }
        return nil;
    }
    
    NSDictionary * dict = @{@"action":@"bookshelf/mult/content",@"data":@{@"pageSize":@(20),@"page":[NSNumber numberWithInteger:page],@"type":listType}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:@"/reading/partner"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;

}
#pragma mark 自定义歌单- 创建歌单
+(RBNetworkHandle *)createAlbumresource:(NSString*)name ParentId:(NSString*)parentId andBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"resource/adduseralbum",@"data":@{@"parentId":parentId,@"name":name,@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:@"/users/resource"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark 自定义歌单- 获取歌单
+(RBNetworkHandle *)getAlbumresourceAndBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = @{@"action":@"resource/albumlist",@"data":@{@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:@"/users/resource"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
#pragma mark 自定义歌单- 添加删除歌单
+(RBNetworkHandle *)addOrDelAlbumresource:(BOOL)add SourceID:(NSString*)sourceID AlbumId:(NSNumber*)albumId andBlock:(RBNetworkHandleBlock) block{
    NSDictionary * dict = [NSDictionary dictionary];
    if (add) {
        dict = @{@"action":@"resource/editalbumresource",@"data":@{@"albumId":albumId,@"add":@[sourceID],@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    }
    else{
       dict = @{@"action":@"resource/editalbumresource",@"data":@{@"albumId":albumId,@"remove":@[sourceID],@"mainctl":[NSString stringWithFormat:@"%@",RB_Current_Mcid]}};
    }
    NSString * urlStr = [RBNetworkHandle getInterUrl:RB_URL_HOST  Path:@"/users/resource"];
    RBNetworkHandle * handle = [RBNetworkHandle getNetDataWihtPara:dict URLStr:urlStr Block:block];
    return handle;
}
@end
