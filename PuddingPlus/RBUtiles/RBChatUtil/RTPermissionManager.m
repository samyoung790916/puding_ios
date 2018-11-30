//
//  RBPushService.m
//  PuddingPlus
//
//  Created by baxiang on 2017/5/4.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RTPermissionManager.h"
#import <AVFoundation/AVFoundation.h>
NSString *const RTPermissionsDidAskForPushNotifications = @"RTPermissionsDidAskForPushNotifications";
@interface RTPermissionManager()<UNUserNotificationCenterDelegate>
@end
@implementation RTPermissionManager
//+ (instancetype)sharedManager {
//    static RTPermissionManager *shared = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        shared = [[self alloc]init];
//    });
//    return shared;
//}


+ (void)registerRemoteNotification:(id)delegate
{
    if (@available(iOS 10.0, *)){
        [UNUserNotificationCenter currentNotificationCenter].delegate = delegate;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound| UNAuthorizationOptionAlert  completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] registerForRemoteNotifications];
                        });
                    }
                }
            }];
    }else if ([[ [UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        }
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:RTPermissionsDidAskForPushNotifications];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (RTPrivacyPermissionStatus) remoteNotificationsPermissionStatus
{
        if (@available(iOS 10.0, *)) {
             UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
             dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            __block RTPrivacyPermissionStatus status = RTPrivacyPermissionStatusAuthorized;
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *  settings) {
                if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                     status = RTPrivacyPermissionStatusNotDetermined;
                }else if (settings.authorizationStatus== UNAuthorizationStatusDenied){
                      status = RTPrivacyPermissionStatusDenied;
                }
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            return status;
        } else {
            BOOL didAskForPermission = [[NSUserDefaults standardUserDefaults] boolForKey:RTPermissionsDidAskForPushNotifications];
            if (didAskForPermission) {
                if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
                    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
                        return RTPrivacyPermissionStatusAuthorized;
                    } else {
                        return RTPrivacyPermissionStatusDenied;
                    }
                }
            }
            
    }
    return RTPrivacyPermissionStatusNotDetermined;
}

+ (RTPrivacyPermissionStatus) microphonePermissionStatus{
     AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusAuthorized) {
        return RTPrivacyPermissionStatusAuthorized;
    }
    else if (status == AVAuthorizationStatusDenied) {
        return RTPrivacyPermissionStatusDenied;
    }else if (status == AVAuthorizationStatusDenied){
        return RTPrivacyPermissionStatusRestricted;
    }
    return RTPrivacyPermissionStatusNotDetermined;
}


+ (void)showMicrophonePermissions:(NSString *)title
                           message:(NSString *)message
                   denyButtonTitle:(NSString *)cancelButtonTitle
                  grantButtonTitle:(NSString *)grantButtonTitle{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:grantButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [[RTPermissionManager topViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (void) showPushNotificationPermissionsWithTitle:(NSString *)title
                                         message:(NSString *)message
                                 denyButtonTitle:(NSString *)cancelButtonTitle
                                grantButtonTitle:(NSString *)grantButtonTitle{
    RTPrivacyPermissionStatus status = [RTPermissionManager remoteNotificationsPermissionStatus];
    if (status == RTPrivacyPermissionStatusNotDetermined) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
         
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:grantButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [RTPermissionManager registerRemoteNotification:[UIApplication sharedApplication].delegate];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [[RTPermissionManager topViewController] presentViewController:alertController animated:YES completion:nil];
    }
}

+(UIViewController*)topViewController{
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([rootViewController isKindOfClass:[UINavigationController class]])
    {
        rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
    }
    if([rootViewController isKindOfClass:[UITabBarController class]])
    {
        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }
    return rootViewController;
}


#pragma mark - device token


+(NSString*)fetchDeviceToken
{
   return [[NSUserDefaults standardUserDefaults] objectForKey:@"RToyDeviceToken"];
}

+ (void)registerDeviceToken:(NSData *)deviceToken completionBlock:(void (^)(NSString *))completionBlock
{
//    NSString * deviceTokenStr = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"--------registerDeviceToken------%@",deviceTokenStr);
//    if ([RBDataHandle.loginData.userid isNotBlank]) {
//        [RBDeviceApi setPushToken:deviceTokenStr block:nil];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:@"RToyDeviceToken"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    if (completionBlock){
//        completionBlock(deviceTokenStr);
//    }
}
#pragma mark - badge
+ (void)setBadgeToZero
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

@end
