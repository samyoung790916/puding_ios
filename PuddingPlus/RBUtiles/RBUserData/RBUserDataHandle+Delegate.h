//
//  RBUserDataHandle+Delegate.h
//  RooboMiddleLevel
//
//  Created by william on 16/10/9.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBUserDataHandle.h"
@class RBChatGroupModel;
@class RBMessageModel;
@protocol RBUserHandleDelegate <NSObject>
@optional

/**
 *  wifi 变化
 */
- (void)RBWifiChange:(id)change;
/**
 *  设备更新
 */
- (void)RBDeviceUpdate;
/**
 *  更新设备列表
 */
- (void)updateDevicesList;
/**
 *
 *  当前设备移除
 */
- (void)removeCurrentDeviceHandle;
/**
 *
 *  未读消息数变化
 */
- (void)unReadMessageCountChange;

/**
 *  获取升级结果
 */
- (void)RBDeviceUpgrade:(NSDictionary *)dict;

/**
 *  收到微聊信息
 */
- (void)RBRecoredWeChat:(RBMessageModel *)message;
/**
 *  登录状态变更
 */
- (void)RBLoginStatus:(NSNumber *)isOnLine;
@end

@interface RBUserDataHandle (Delegate)
/** 代理 */
@property (nonatomic, assign) id<RBUserHandleDelegate> delegate;
/** 代理列表 */
@property (nonatomic, strong) NSHashTable * delegateHashTable;
/**
 *  执行代理方法
 *
 *  @param seleter 方法
 *  @param obj     对象
 */
- (void)performDelegetMethod:(SEL)seleter withObj:(id)obj;
@end
