//
//  RBPushService.h
//  PuddingPlus
//
//  Created by baxiang on 2017/5/4.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>


typedef NS_ENUM(NSUInteger,RTPrivacyPermissionStatus) {
    RTPrivacyPermissionStatusNotDetermined = 0,//尚未申请
    RTPrivacyPermissionStatusDenied, //拒绝
    RTPrivacyPermissionStatusRestricted,//受限制的
    RTPrivacyPermissionStatusAuthorized, //授权
    RTPrivacyPermissionStatusLocationAlways,//一直可以定位
    RTPrivacyPermissionStatusLocationWhenInUse,// 使用期间可以定位
};

@interface RTPermissionManager : NSObject


+ (void)registerDeviceToken:(NSData *)deviceToken completionBlock:(void (^)(NSString *))completionBlock;

+(NSString*)fetchDeviceToken;

// 推送权限
+ (void) showPushNotificationPermissionsWithTitle:(NSString *)title
                                          message:(NSString *)message
                                  denyButtonTitle:(NSString *)cancelButtonTitle
                                 grantButtonTitle:(NSString *)grantButtonTitle;
// 麦克风权限
+ (void)showMicrophonePermissions:(NSString *)title
                          message:(NSString *)message
                  denyButtonTitle:(NSString *)cancelButtonTitle
                 grantButtonTitle:(NSString *)grantButtonTitle;
+ (RTPrivacyPermissionStatus) remoteNotificationsPermissionStatus;
+ (RTPrivacyPermissionStatus) microphonePermissionStatus;
@end
