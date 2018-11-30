//
//  RBPushService.m
//  PuddingPlus
//
//  Created by baxiang on 2017/5/4.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBPushService.h"
@implementation RBRegisterConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _types = RBPushAuthorizationBadge|RBPushAuthorizationSound|RBPushAuthorizationAlert;
    }
    return self;
}
@end

@interface RBPushService()<UNUserNotificationCenterDelegate>

@property (nonatomic ,strong) RBRegisterConfig *config;
@end
@implementation RBPushService
+ (instancetype)sharedManager {
    
    static RBPushService *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

- (instancetype)init {
    if (self = [super init]) {

        [UNUserNotificationCenter currentNotificationCenter].delegate = self;

    }
    return self;
}
+ (void)registerForRemoteNotificationTypes:(NSUInteger)types categories:(NSSet *)categories
{
    
    if ([[ [UIDevice currentDevice] systemVersion] floatValue] >= 10.0){
       
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    dispatch_async_on_main_queue(^{
                        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
                            [[UIApplication sharedApplication] registerForRemoteNotifications];
                        }
                        if ([[UNUserNotificationCenter currentNotificationCenter] respondsToSelector:@selector(setNotificationCategories:)]) {
                            [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];
                        }
                    });
                    
                }
            }];
        
    }else if ([[ [UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:types categories:categories]];
        }
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotificationTypes:)]) {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
        }
#pragma clang diagnostic pop
    }
    
}
#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )

+ (void)registerForRemoteNotificationConfig:(RBRegisterConfig *)config delegate:(id<RBPushServiceDelegate>)delegate
{
    [[self class] registerForRemoteNotificationTypes:config.types categories:config.categories];
    [RBPushService sharedManager].delegate = delegate;
    [RBPushService sharedManager].config = config;
    
}
#endif

#pragma mark - device token


+ (void)registerDeviceToken:(NSData *)deviceToken completionHandler:(void (^)(NSString *))completionHandler
{
    NSString * tokenVal = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenVal = [tokenVal stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (completionHandler) {
        completionHandler(tokenVal);
    }
    
}
#pragma mark - badge
+ (void)setBadgeToZero
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

+ (void)resetBadge {
    [RBPushService setBadge:0];
}

+ (void)setBadge:(NSInteger)badge {
    
    //只对角标大于0，修改为0
    if ([UIApplication sharedApplication]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            [self setBadgeToZero];
        }else{
            //是否已经注册角标
            if ([self checkNotificationType:UIRemoteNotificationTypeBadge]){
                [self setBadgeToZero];
            }else{
                RBRegisterConfig *config = [RBPushService sharedManager].config;
                if (config == nil) {
                    config = [[RBRegisterConfig alloc] init];
                    if (config.types == 0) {
                        config.types = 7;
                    }
                }
                [[self class] registerForRemoteNotificationTypes:config.types categories:config.categories];
                [self setBadgeToZero];
            }
        }
        
    }
}

+ (BOOL)checkNotificationType:(UIRemoteNotificationType)type
{
    if ( ([UIApplication sharedApplication])) {
        NSUInteger notiType = 0;
     if ([[ [UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
                UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
                notiType = currentSettings.types;
            }
        }else{
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(enabledRemoteNotificationTypes)]) {
                notiType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
            }
        }
        return (notiType & type);
    }else{
        return NO;
    }
}

# pragma mark - UNUserNotificationCenterDelegate

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000) )

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rbpushNotificationCenter:willPresentNotification:withCompletionHandler:)] ) {
        [self.delegate rbpushNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rbpushNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:)]) {
        [self.delegate rbpushNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
    }
}
#endif


@end
