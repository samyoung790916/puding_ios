//
//  RBUserDataHandle+Device.m
//  RooboMiddleLevel
//
//  Created by william on 16/10/9.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBUserDataHandle+Device.h"
#import "RBNetHeader.h"
#import "RBUserDataHandle+Delegate.h"
#import "RBUserModel.h"
#import "AppDelegate.h"
#import "RBMessageHandle+UserData.h"

const  char * kUpdateListCallBack = "kUpdateListCallBack";
const  char * kRefreshTime = "kRefreshTime";
@implementation RBUserDataHandle (Device)


/**
 *  刷新当前主控
 */
#pragma mark - 主控：刷新当前主控
- (RBNetworkHandle *)refreshCurrentDevice:(void(^)(void))block{
    RBNetworkHandle *handle = [RBNetworkHandle getCtrlDetailMessageWithBlock:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            RBDeviceModel * pd = [RBDeviceModel modelWithJSON:[res objectForKey:@"data"]];
            [RBDataHandle updateCurrentDevice:pd];
            if(block)
                block();
        }else{
            if(block)
                block();
        }
    }];
    return handle;
}

/**
 *  刷新当前主控
 */
#pragma mark - 主控：刷新当前主控
- (void)refreshCurrentDevicePlayInfo:(void(^)(void))block{
    [RBNetworkHandle getDevicestateWithCtrlID:RB_Current_Mcid Block:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            PDSourcePlayModle *playinfo =[PDSourcePlayModle modelWithJSON:[[res mObjectForKey:@"data"] mObjectForKey:@"playinfo"]];
            RBDeviceModel *deviceModel   = [RBDataHandle fecthDeviceDetail:RB_Current_Mcid];
            deviceModel.playinfo = playinfo;
            [RBDataHandle updateDeviceDetail:deviceModel];
            if(block)
                block();
        }else{
            RBDeviceModel *deviceModel   = [RBDataHandle fecthDeviceDetail:RB_Current_Mcid];
            deviceModel.playinfo = nil;
            [RBDataHandle updateDeviceDetail:deviceModel];
            if(block)
                block();
        }
    }];
}
/**
 *  更新当前播放信息
 *
 */

- (void)updateDevicePlayInfo:(PDSourcePlayModle *)playinfo{
    RBDeviceModel * device = [self currentDevice];
    device.playinfo = playinfo;
    [RBDataHandle updateCurrentDevice:device];
}

-(void)refreshBabyInfo:(Boolean )shouldUpdate Mcid:(NSString *)mcid Block:(void(^)(NSDictionary * babyInfo,NSString * errorString))block{
//    NSString * babyCache = [NSString stringWithFormat:@"%@Baby",mcid];
//
//    NSDictionary *dict  =[PDNetworkCache cacheForKey:babyCache];
//    if([dict count] > 0 && !shouldUpdate){
//        if(block){
//            block(dict,nil);
//        }
//    }else{
//        if(dict.count > 0){
//            if(block){
//                block(dict,nil);
//            }
//        }
//        [RBNetworkHandle getBabyMsgWithDeviceId:mcid Block:^(id res) {
//            if(res && [[res objectForKey:@"result"] intValue] == 0){
//                NSDictionary * dict = [[res objectForKey:@"data"] firstObject];
//                [PDNetworkCache saveCache:dict forKey:babyCache];
//                if(block){
//                    block(dict,nil);
//                }
//            }else{
//                if(block){
//                    block(nil,RBErrorString(res));
//                }
//            }
//        }];
//    }
    

}

/**
 *
 *  刷新当前布丁宝宝信息
 */

-(void)refreshBabyInfo:(Boolean )shouldUpdate Block:(void(^)(NSDictionary * babyInfo,NSString * errorString))block{

    [self refreshBabyInfo:shouldUpdate Mcid:RB_Current_Mcid Block:block];
}

/**
 *  获取当前的设备
 *
 */
#pragma mark - 主控：获取当前设备
-(RBDeviceModel *)currentDevice{
    RBDeviceModel *model  = [RBUserDataCache cacheForKey:[NSString stringWithFormat:@"RB_%@", RBDataHandle.loginData.currentMcid]];
    if (!model) {
        for (RBDeviceModel *currModel in RBDataHandle.loginData.mcids) {
            if ([currModel.mcid isEqualToString:RBDataHandle.loginData.currentMcid]) {
                model = currModel;
                break;
            }
        }
    }
    return model;
}

- (void)wechatHomePageNewMessageUpdate:(RBMessageModel *) chatMessage{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performDelegetMethod:@selector(RBRecoredWeChat:) withObj:chatMessage];
    });
}

-(void)updateCurrentDevice:(RBDeviceModel *)currentDevice{
    [RBUserDataCache saveCache:currentDevice forKey:[NSString stringWithFormat:@"RB_%@",currentDevice.mcid]];
    RBUserModel *loginData = RBDataHandle.loginData;
    if (![loginData.currentMcid isEqualToString:currentDevice.mcid]) {
        loginData.currentMcid = currentDevice.mcid;
        [RBDataHandle updateLoginData:loginData];
    }
    [RBMessageHandle updateBabyMessageWithDevice:currentDevice.mcid MessageID:currentDevice.momentID];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performDelegetMethod:@selector(RBDeviceUpdate) withObj:nil];
    });
}
-(void)setCurrentDevice:(RBDeviceModel *)deviceDetail{
    if (deviceDetail.mcid) {
        [RBUserDataCache saveCache:deviceDetail forKey:[NSString stringWithFormat:@"RB_%@",deviceDetail.mcid]];
        [RBMessageHandle updateBabyMessageWithDevice:deviceDetail.mcid MessageID:deviceDetail.momentID];
        
    }
    
}

-(void)updateDeviceDetail:(RBDeviceModel *)deviceDetail{
    if (deviceDetail.mcid) {
        [RBUserDataCache saveCache:deviceDetail forKey:[NSString stringWithFormat:@"RB_%@",deviceDetail.mcid]];
        [RBMessageHandle updateBabyMessageWithDevice:deviceDetail.mcid MessageID:deviceDetail.momentID];

    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performDelegetMethod:@selector(RBDeviceUpdate) withObj:nil];
    });
}
-(RBDeviceModel*)fecthDeviceDetail:(NSString*)mcid{
    RBDeviceModel *model = [RBUserDataCache cacheForKey:[NSString stringWithFormat:@"RB_%@",mcid]];
    if (!model) {
        for (RBDeviceModel *currModel in RBDataHandle.loginData.mcids) {
            if ([currModel.mcid isEqualToString:RBDataHandle.loginData.currentMcid]) {
                model = currModel;
                break;
            }
        }

    }
    return model;
}
-(RBDeviceModel*)fecthDevice:(NSString*)mcid{
    RBDeviceModel *model = [RBUserDataCache cacheForKey:[NSString stringWithFormat:@"RB_%@",mcid]];
    return model;
}

-(RBDeviceModel*)fecthDeviceWithMcid:(NSString*)mcid{
    RBDeviceModel * rModle = [self fecthDeviceDetail:mcid];
    if(rModle != nil){
        return rModle;
    }
    NSArray * mcids = self.loginData.mcids;
    
    for(RBDeviceModel * modle in mcids){
        if([modle.mcid isEqual:mcid]){
            return modle;
        }
    }
    
    return nil;
}

/**
 *  刷新主控状态
 */
#pragma mark - 主控：刷新主控状态
- (void)updateDeviceState{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performDelegetMethod:@selector(RBDeviceUpdate) withObj:nil];
    });
}
/**
 *
 *  刷新当前用户主控列表,不切换主页面，不调用代理
 */
- (void)refreshDeviceListNotSwift{
    [RBNetworkHandle getRooboList:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            RBUserModel * userModel = [RBUserModel modelWithJSON:[res mObjectForKey:@"data"]];
            RBUserModel * loginData = RBDataHandle.loginData;
        
            loginData.mcids = userModel.mcids;
            
            BOOL isNewCurrentMci = YES;
            for (RBDeviceModel *deviceModel in loginData.mcids) {
                RBDeviceModel *deviceDetail = deviceModel.detail;
                if (deviceDetail) {
                    deviceDetail.manager = deviceDetail.manager;// 当前数据结构中没有manager字段
                    [RBDataHandle updateDeviceDetail:deviceDetail];
                }
                if ([deviceModel.mcid isEqualToString:loginData.currentMcid]) {
                    isNewCurrentMci = NO;
                }
            }
            if (isNewCurrentMci) {
                RBDeviceModel *firstModel  = [loginData.mcids objectAtIndexOrNil:0];
                loginData.currentMcid = firstModel.mcid;
            }
            [RBDataHandle updateLoginData:loginData];
        }
    }];
}

#define SupperVersion 84

- (BOOL)checkLoadNet:(NSString *)mcid{
    RBDeviceModel * currentDevice = RBDataHandle.currentDevice;
    NSString * currentMcid = currentDevice.mcid;
    
    if(![currentDevice isPuddingPlus]){
        return NO;
    }
    NSString * keyString = [NSString stringWithFormat:@"RB_VERSION_%@",currentMcid];
    
    NSString * version = [RBUserDataCache cacheForKey:keyString];
    
    if([version intValue] > SupperVersion){
        return NO;
    }
    return YES;
}

///验证布丁豆豆是否支持 扮演布丁 和 视频监控
- (void)checkPuddingPlusSupperFamilyDysm:(void(^)(BOOL,NSString * error))block{
    if(block == nil)
        return;
    
    
    RBDeviceModel * currentDevice = RBDataHandle.currentDevice;
     NSString * currentMcid = currentDevice.mcid;
    NSString * keyString = [NSString stringWithFormat:@"RB_VERSION_%@",currentMcid];
    __block NSString * weakKey = keyString;
    
    if(![self checkLoadNet:currentMcid]){
         block(YES,nil);
        return;
    }
    
    [RBNetworkHandle getUpdateMessage:YES Block:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            NSDictionary *dict = [res mObjectForKey:@"data"];
            if (dict) {
                //是否有更新
                NSString * version = [dict  mObjectForKey:@"vcode"];
                [RBUserDataCache saveCache:version forKey:weakKey];
                if(block){
                    if([version intValue] > SupperVersion){
                        block(YES,nil);
                    }else{
                        block(NO,nil);
                    }
                }
            }
        }else{
            if(block){
                block(NO,RBErrorString(res));
            }
        }
    }];
}


/*

 [{"key":"Clock","name":"闹钟","extras":""},{"key":"KOOLEARNDONUT","name":"多纳学英语","extras":""},{"key":"LEARN_COUNT","name":"数字接龙","extras":""},{"key":"RHYTHM","name":"小鼓手","extras":""},{"key":"NOUI","name":"眼睛界面","extras":""},{"key":"Media","name":"布丁电台","extras":""},{"key":"SMART_EYE","name":"猜猜猜","extras":""},{"key":"VIDEOTALK","name":"视频通话","extras":""},{"key":"RKID","name":"双语课程","extras":""},{"key":"YOUKUCHILD","name":"看动画","extras":""},{"key":"ROOBOCAMERA","name":"照相机","extras":""},{"key":"GALLERY","name":"萌相册","extras":""},{"key":"SETUP","name":"Setup","extras":""},{"key":"RTTranslator","name":"实时翻译","extras":""},{"key":"SETTINGS","name":"设置","extras":""},{"key":"MAINMENU","name":"布丁星球","extras":""},{"key":"USER_GUIDE","name":"新手引导","extras":""}]
 */
//检测当前
- (void)checkConflictPlusApp:(NSString *) current Block:(void(^)(BOOL iscon /* 是否APP冲突*/,NSString * tipString ,NSArray * tipButItem,NSInteger continueIndex,BOOL canContinue))block{
    if(block == nil)
        return;
    if(! [RBDataHandle.currentDevice isPuddingPlus]){
        block(NO,nil,nil,0,YES);
        return;
    }
    
    [RBNetworkHandle getPuddingClintInfo:^(id res) {
        if(res && [[res mObjectForKey:@"result"] intValue] == 0){
            
            NSString * name = [[res mObjectForKey:@"data"] mObjectForKey:@"name"];
            NSString * key = [[res mObjectForKey:@"data"] mObjectForKey:@"key"];
            NSNumber * type = [[res mObjectForKey:@"data"] objectForKey:@"type"];
            if(([type isEqualToNumber:@(0)]|| key  == nil) ){
                block(NO,nil,nil,0,YES);
                return ;
            }
            if([type isEqualToNumber:@(1)] ){
                if([current isEqualToString:@"video"]){ //如果当前正在视频，客户端进入视频，弹窗逻辑交由视频sdk 处理
                    block(NO,nil,nil,0,YES); //视频不允许其他进程打断
                }else{
                    block(YES,NSLocalizedString( @"there_have_parent_is_interacting_with_baby_please_wait", nil),nil,0,NO);
                }
                return;
            }
            if([current isEqualToString:@"videoCall"]){
                block(YES,[NSString stringWithFormat:NSLocalizedString( @"baby_is_using_video_call_cloud_disturb_baby_goon_or_not", nil),name],@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"g_confirm", nil)],1,YES);
            }else if([current isEqualToString:@"video"]){
                block(YES,[NSString stringWithFormat:NSLocalizedString( @"baby_is_using_video_call_cloud_disturb_baby_goon_or_not", nil),name],@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"g_confirm", nil)],1,YES);
            }else if([current isEqualToString:@"play"] ){
                block(YES,[NSString stringWithFormat:NSLocalizedString( @"baby_is_using_act_pudding_could_disturb_baby_go_on", nil),name],@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"g_confirm", nil)],1,YES);
            }else if([current isEqualToString:@"music"] && ![key isEqualToString:@"Media"]){
                block(YES,[NSString stringWithFormat:NSLocalizedString( @"baby_is_using_play_music_could_disturb_baby_go_on", nil),name],@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"g_confirm", nil)],1,YES);
            }else if([current isEqualToString:@"study"] && ![key isEqualToString:@"RKID"]){
                NSString * tipStrin  = [NSString stringWithFormat:NSLocalizedString( @"baby_is_using_start_study_could_disturb_baby_go_on", nil),name];
                block(YES,tipStrin,@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"g_confirm", nil)],1,YES);
                return;
            }else{
                block(NO,nil,nil,0,YES);
            }

        }else{
            block(YES,[NSString stringWithFormat:NSLocalizedString( @"network_connectiong_exception_please_try_again_later", nil),[[res mObjectForKey:@"result"] intValue]],nil,0,NO);
        }
    }];
}

- (void)checkPuddingIsVideo:(void(^)(BOOL isVideo,NSString * error))block{


}
/**
 *
 *  刷新主控列表
 */

-(void)refreshDeviceList:(void(^)())block{
    
    [RBNetworkHandle getRooboList:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            RBUserModel * userModel = [RBUserModel modelWithJSON:[res mObjectForKey:@"data"]];
            RBUserModel * loginData = RBDataHandle.loginData;
            BOOL shouldSwith = NO;
            if (loginData.mcids.count==0) {
                shouldSwith = YES;
            }
            loginData.mcids = userModel.mcids;
            BOOL isRemoved = YES;
            for (RBDeviceModel *deviceModel in loginData.mcids) {
                RBDeviceModel *deviceDetail = deviceModel.detail;
                if (deviceDetail) {
                    deviceDetail.manager = deviceDetail.manager;// 当前数据结构中没有manager字段
                    [RBDataHandle updateDeviceDetail:deviceDetail];
                }
                if ([deviceModel.mcid isEqualToString:loginData.currentMcid]) {
                    isRemoved = NO;
                }
            }
            if (isRemoved) {
                RBDeviceModel *firstModel  = [loginData.mcids objectAtIndexOrNil:0];
                loginData.currentMcid = firstModel.mcid;
            }
            [RBDataHandle updateLoginData:loginData];
            if (loginData.mcids.count==0) {
                shouldSwith = YES;
            }
            if (shouldSwith) {
                [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
                return;
            }
            @weakify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self performDelegetMethod:@selector(updateDevicesList) withObj:nil];
                if (isRemoved) {
                    [self performDelegetMethod:@selector(removeCurrentDeviceHandle) withObj:nil];
                }
            });
        }
        if (block) {
            block();
        }
    }];
}


//#pragma mark - 主控：检测主控列表是否有刷新
- (void)checkDeviceList:(NSArray *)array{
    NSMutableArray * ctrlListArray = [NSMutableArray array];
    
    for(int i = 0 ; i < array.count ; i++){
        RBDeviceModel * newCtrl = [RBDeviceModel modelWithDictionary:[array objectAtIndex:i]];
        BOOL oldCtrl = NO;
        for(RBDeviceModel * ctrl in RBDataHandle.loginData.mcids){
            if([ctrl.mcid isEqualToString:newCtrl.mcid]){

                [ctrlListArray addObject:ctrl] ;
                oldCtrl = YES;
            }
        }
        if(!oldCtrl){
            RBDeviceModel * modle = [RBDeviceModel modelWithDictionary:[array objectAtIndex:i]];
            [ctrlListArray addObject:modle];
        }
    }
}


/**
 *  移除当前主控
 */
#pragma mark - 主控：移除当前主控
- (void)removeCurrentDevice{
    RBUserModel *userModel = RBDataHandle.loginData;
    NSMutableArray * array = [NSMutableArray arrayWithArray:userModel.mcids];
    for(RBDeviceModel * ctrl in array){
    if([ctrl.mcid isEqualToString:userModel.currentMcid]){
        [array removeObject:ctrl];
        break;
      }
    }
    RBDeviceModel *firstModel  = [array objectAtIndexOrNil:0];
    userModel.currentMcid = firstModel.mcid;
    userModel.mcids = array;
    [RBDataHandle updateLoginData:userModel];
    if (userModel.mcids.count==0) {
        [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
        return;
    }
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        [self performDelegetMethod:@selector(updateDevicesList) withObj:nil];
        if (array.count>0) {
            [self performDelegetMethod:@selector(removeCurrentDeviceHandle) withObj:nil];
        }
      
    });
}

/**
 *  设备升级结果
 */
- (void)deviceUpdateResult:(BOOL)result deviceId:(NSString *)deviceId{
    if(deviceId){
        NSDictionary * dict = @{@"result":@(result),@"mcid":deviceId};
        [self performDelegetMethod:@selector(RBDeviceUpgrade:) withObj:dict];
    }
}



@end
