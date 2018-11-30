//
//  RBUserDataHandle+Device.h
//  RooboMiddleLevel
//
//  Created by william on 16/10/9.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBUserDataHandle.h"
#import "PDSourcePlayModle.h"
@interface RBUserDataHandle (Device)



#pragma mark - 主控：刷新当前主控
- (void)refreshCurrentDevicePlayInfo:(void(^)(void))block;
/**
 *  刷新当前主控
 */
- (RBNetworkHandle *)refreshCurrentDevice:(void(^)(void))block;

-(void)updateCurrentDevice:(RBDeviceModel *)currentDevice;

- (void)wechatHomePageNewMessageUpdate:(RBMessageModel *) chatMessage;

-(void)setCurrentDevice:(RBDeviceModel *)currentDevice;

-(void)updateDeviceDetail:(RBDeviceModel *)deviceDetail;

-(RBDeviceModel*)fecthDeviceDetail:(NSString*)mcid;

-(RBDeviceModel*)fecthDeviceWithMcid:(NSString*)mcid;

-(RBDeviceModel*)fecthDevice:(NSString*)mcid;
/**
 *  刷新主控状态
 */
- (void)updateDeviceState;


/**
 *  更新当前播放信息
 *
 */

- (void)updateDevicePlayInfo:(PDSourcePlayModle *)playinfo;

/**
 *
 *  刷新当前用户主控列表
 */

-(void)refreshDeviceList:(void(^)())block;
/**
 *
 *  刷新当前用户主控列表,不切换主页面，不调用代理
 */
- (void)refreshDeviceListNotSwift;

- (BOOL)checkLoadNet:(NSString *)mcid;

- (void)checkPuddingPlusSupperFamilyDysm:(void(^)(BOOL,NSString * error))block;


- (void)checkPuddingIsVideo:(void(^)(BOOL isVideo,NSString * error))block;

//检测当前
- (void)checkConflictPlusApp:(NSString *) current Block:(void(^)(BOOL iscon /* 是否APP冲突*/,NSString * tipString ,NSArray * tipButItem,NSInteger continueIndex,BOOL canContinue))block;

/**
 *
 *  刷新当前布丁宝宝信息
 */

//-(void)refreshBabyInfo:(Boolean )shouldUpdate Block:(void(^)(NSDictionary * babyInfo,NSString * errorString))block;


//-(void)refreshBabyInfo:(Boolean )shouldUpdate Mcid:(NSString *)mcid Block:(void(^)(NSDictionary * babyInfo,NSString * errorString))block;
#pragma mark - 主控：检测主控列表是否有刷新
//- (void)checkDeviceList:(NSArray *)array;



/**
 *  移除当前主控
 */
- (void)removeCurrentDevice;


#pragma - mark 提示布丁需要升级
/**
 *  布丁升级结果
 *
 */
- (void)deviceUpdateResult:(BOOL)result deviceId:(NSString *)deviceId;



@end
