//
//  RBPushService.h
//  PuddingPlus
//
//  Created by baxiang on 2017/5/4.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UserNotifications/UserNotifications.h>
//#import

typedef NS_OPTIONS(NSUInteger, RBPushAuthorization) {
    RBPushAuthorizationNone    = 0,   // the application may not present any UI upon a notification being received
    RBPushAuthorizationBadge   = (1 << 0),    // the application may badge its icon upon a notification being received
    RBPushAuthorizationSound   = (1 << 1),    // the application may play a sound upon a notification being received
    RBPushAuthorizationAlert   = (1 << 2),    // the application may display an alert upon a notification being received
};


@protocol RBPushServiceDelegate <NSObject>

- (void)rbpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler;

- (void)rbpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler;

@end



/**
 注册配置类
 */
@interface RBRegisterConfig : NSObject

/**
 通知支持的类型 默认三种都支持
 badge,sound,alert
 */
@property (nonatomic, assign) NSInteger types;

/**
 通知类别
 iOS10 UNNotificationCategory
 iOS8-iOS9 UIUserNotificationCategory
 */
@property (nonatomic, strong) NSSet *categories;

@end

@interface RBPushService : NSObject
/**
 单例对象
 */
+ (instancetype)sharedManager;

/**
 代理
 */
@property (nonatomic,weak)id<RBPushServiceDelegate> delegate;


/**
 注册通知，并且设置处理通知的代理
 
 @param config 注册通知配置，包括注册通知类别以及通知展示类型
 @param delegate 处理通知代理
 */
+ (void)registerForRemoteNotificationConfig:(RBRegisterConfig *)config delegate:(id<RBPushServiceDelegate>)delegate;

+ (void)registerDeviceToken:(NSData *)deviceToken completionHandler:(void (^)(NSString *))completionHandler;


/**
 重置脚标(为0)
 */
+ (void)resetBadge;
@end
