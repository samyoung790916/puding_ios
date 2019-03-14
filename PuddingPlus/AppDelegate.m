#import "AppDelegate.h"
#import "RBNetworkConfig.h"
#import "RBInitial.h"
#import <AVFoundation/AVFoundation.h>
#import "RBHomePageViewController.h"
#import "PDFirstPageViewController.h"
#import "RBProjectConfig.h"
#import "XHLaunchAd.h"
#import "PDNavtionController.h"
#import "PDHtmlViewController.h"
#import "RBMessageHandle+UserData.h"
#import "PDLaunchAdModel.h"
#import "RBSelectPuddingTypeViewController.h"
#import "RBPushService.h"
#import "ZYDeivceInfoView.h"
#import "RTPushMessManager.h"

@import UserNotifications;
@import Firebase;

@interface AppDelegate () <XHLaunchAdDelegate,UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate

NSString *const kGCMMessageIDKey = @"gcm.message_id";

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    LogWarm(@"kjfskdjf");

    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;

    if ([UNUserNotificationCenter class] != nil)
    {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
             // ...
         }];
    }
    else {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    [application registerForRemoteNotifications];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[[UIApplication sharedApplication]valueForKey:@"statusBar"]setValue:[UIColor blackColor] forKey:@"foregroundColor"];
    
    [[RBProjectConfig getInstanse] loadConfig];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES] ;
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    [self trackAppDayLive];
    [RBStat startLogEvent:PD_App_Duration message:nil];
    [self setupShortcutItems];
    [self switchRootViewController];
//    [self loadPushConfig:launchOptions]; // 이거 주석풀면 푸쉬 안온다...
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UIViewController * nav = self.window.rootViewController.navigationController;
    
    
    if(TESTMODLE == true){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[ZYDeivceInfoView sharedInstance] setHidden:NO];
            [nav.view  addSubview:[ZYDeivceInfoView sharedInstance]];
        });
    }
    [[RBMessageHandle sharedManager] setUpMessageHelper];
 //   [self setupXHLaunchAd];

    return YES;
}


-(void)trackAppDayLive
{
    NSString * lastTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"appsetup"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSInteger currentDay = [[dateFormatter stringFromDate:[NSDate date] ] integerValue];
    
    if(currentDay > [lastTime integerValue])
    {
        [RBStat logEvent:PD_App_Start message:nil];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)currentDay] forKey:@"appsetup"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)setupShortcutItems {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"video_shortcut"];
        NSDictionary *userinfo = @{@"itemId":@"video"};
        UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:@"" localizedTitle:NSLocalizedString( @"video_call_", nil) localizedSubtitle:nil icon:icon userInfo:userinfo];
        [UIApplication sharedApplication].shortcutItems = @[item];
    }
}

-(void)switchRootViewController{
    
    if (RBDataHandle.loginData && [RBDataHandle.loginData.mcids count] > 0) {
        [RBMessageManager setShowAlter:YES];
        
        self.window.rootViewController = [[PDNavtionController alloc] initWithRootViewController:[RBHomePageViewController new]];// 检测更新
        [self performSelector:@selector(checkUpdate) withObject:nil afterDelay:.2];
        [RBMessageManager checkUnreadVideoMessage];
        
    }else if (RBDataHandle.loginData && [RBDataHandle.loginData.mcids count] ==0){
        RBSelectPuddingTypeViewController *vc = [RBSelectPuddingTypeViewController new];
        vc.configType = PDAddPuddingTypeFirstAdd;
        self.window.rootViewController = [[PDNavtionController alloc] initWithRootViewController:vc];
    }
    else{
        [RBMessageManager setShowAlter:NO];
        PDFirstPageViewController *vc = [PDFirstPageViewController new];
        self.window.rootViewController = [[PDNavtionController alloc] initWithRootViewController:vc];
    }
}

-(void)checkUpdate
{
    NSTimeInterval time = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastCheckUpdateTime"] doubleValue];
    BOOL shouleCheck = ([[NSDate date] timeIntervalSince1970] - time ) > 60 * 60 * 8;
    
    if(shouleCheck)
    {
        NSString * Identifier  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleIdentifierKey];
        NSString * versionName  =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString * vcode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        if (!RB_Current_UserId) {
            return;
        }
        
        [RBNetworkHandle checkAppUpdateWithIdentifier:Identifier Vname:versionName VersionCode:[vcode intValue] production:@"pudding1s.ios" Block:^(id res) {
            if([[res mObjectForKey:@"result"] intValue] == 0){
                NSMutableDictionary * infodict = [[[res mObjectForKey:@"data"] firstObject] mutableCopy];
                NSMutableArray * operateArr = [NSMutableArray array];
                if ([[infodict mObjectForKey:@"operation"] count]>0) {
                    operateArr = [NSMutableArray arrayWithArray:[infodict mObjectForKey:@"operation"]];
                }
                BOOL isUpdate = NO;
                BOOL isForce = NO;
                for (NSInteger i = 0; i<operateArr.count; i++) {
                    NSString *operateStr = [operateArr mObjectAtIndex:i];
                    if ([operateStr isEqualToString:@"update"]) {
                        isUpdate = YES;
                        if ([[infodict mObjectForKey:@"force"] intValue] == 1) {
                            isForce = YES;
                        }
                        break;
                    }
                }
                //如果升级
                if (isUpdate) {
                    NSString * messageInfo = [infodict mObjectForKey:@"feature"];
                    if ([messageInfo isKindOfClass:[NSNull class]]||messageInfo == nil) {
                        messageInfo = @"Update";
                        [infodict setValue:@"update" forKey:@"feature"];
                        
                    }else{
                        messageInfo = [infodict mObjectForKey:@"feature"];
                    }
                    LogWarm(@"升级信息 = %@",messageInfo);
                    
                    NSArray * item =  isForce?@[NSLocalizedString( @"g_confirm", nil)]:@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"g_confirm", nil)];
                    ZYAlterView * vi = [self.window.rootViewController tipAlter:nil TitleString:NSLocalizedString( @"version_update", nil) DescribeString:messageInfo Items:item :^(int index) {
                        if (item.count== 1) {
                            LogError(@"更新项目");
                            [self openAppstoreToUpdate];
                        }else{
                            if(index == 1){
                                [self openAppstoreToUpdate];
                            }else{
                                LogWarm(@"取消更新");
                            }
                        }
                    }];
                    vi.describeLable.textAlignment = NSTextAlignmentLeft;
                    
                    NSDictionary *dataDict = [infodict copy];
                    if (!isForce)
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:dataDict forKey:@"lastCheckUpdateData"];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"lastCheckUpdateTime"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    else
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:dataDict forKey:@"lastCheckUpdateData"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    return;
                }
            }
        }];
    }
    
}

- (void)openAppstoreToUpdate{
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastCheckUpdateData"];
    NSArray *urlArr = [dict mObjectForKey:@"url"];
    NSURL * url = [NSURL URLWithString:[urlArr firstObject]];
    if(url&&[[UIApplication sharedApplication]canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
    else if (urlArr.count>1)
    {
        NSURL * secondUrl = [NSURL URLWithString:[[dict objectForKey:@"url"] lastObject]];
        if ([[UIApplication sharedApplication] canOpenURL:secondUrl]) {
            [[UIApplication sharedApplication] openURL:secondUrl];
        }
    }
    else{
        if (urlArr.count == 0) {
        }
        else{
        }
    }
}

- (void)loadPushConfig:(NSDictionary *)launchOptions{
    
    [RBPushService registerForRemoteNotificationConfig:[RBRegisterConfig new] delegate:self];
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo) {
        [[RBMessageHandle sharedManager] mesageArrive:userInfo ApplicationActive:[[UIApplication sharedApplication] applicationState] messageType:RBRemoteNotificationLanching];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
    {
        UIApplicationShortcutItem *shortCutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
        if (shortCutItem) {
            NSDictionary *userinfo = shortCutItem.userInfo;
            NSString *itemId = [userinfo objectForKey:@"itemId"];
            if ([itemId isEqualToString:@"video"]) {
                [RBMessageManager enterVideoController:RB_Current_Mcid];
            }
        }
    }
}

-(void)setupXHLaunchAd{
    [XHLaunchAd setWaitDataDuration:1.0];
    [self requestImageData:^(NSString *imgUrl, NSInteger duration, NSString *openUrl, NSInteger pict_id)
     {
         XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
         imageAdconfiguration.duration = duration;
         imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
         imageAdconfiguration.imageNameOrURLString = imgUrl;
         imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
         imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
         imageAdconfiguration.openURLString = openUrl;
         imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
         imageAdconfiguration.skipButtonType = SkipTypeTimeText;
         imageAdconfiguration.showEnterForeground = NO;
         
         [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
         [RBStat logEvent:PD_LAUNCH_SPLASH_SHOW message:nil];
     }];
}

-(void)requestImageData:(void(^)(NSString *imgUrl,NSInteger duration,NSString *openUrl,NSInteger pict_id))imageData{
    [RBNetworkHandle fetchLanchAdWithBlock:^(id res) {
        PDLaunchAdModel *model = [PDLaunchAdModel modelWithJSON:res];
        if ([model.pictures count]>0) {
            NSDate *currDate = [NSDate date];
            [model.pictures enumerateObjectsUsingBlock:^(PDPictures * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.start compare:currDate]!=NSOrderedDescending&&[obj.end compare:currDate]!= NSOrderedAscending) {
                    NSArray *sortedArray = [obj.imgs sortedArrayUsingComparator:^NSComparisonResult(PDPicture *obj1, PDPicture *obj2){
                        if (obj1.size > obj2.size){
                            return NSOrderedAscending;
                        }
                        if (obj1.size < obj2.size){
                            return NSOrderedDescending;
                        }
                        return NSOrderedSame;
                    }];
                    if(imageData){
                        PDPicture * currPict = nil;
                        CGFloat screenScale = [UIScreen mainScreen].scale;
                        if (screenScale==2) {
                            currPict = [sortedArray objectAtIndex:1];
                        }
                        if (screenScale==1) {
                            currPict = [sortedArray objectAtIndex:2];
                        }
                        if (!currPict) {
                            currPict = [sortedArray objectAtIndex:0];
                        }
                        imageData(currPict.url,obj.duration,obj.weburl,obj.pict_id);
                        
                    }
                    *stop = YES;
                }
            }];
        }
    }];
}










// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}
// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"푸쉬왔오");
    
    
    
    NSDictionary *userInfo = notification.request.content.userInfo;

    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    // Change this to your preferred presentation option
  //  completionHandler(UNNotificationPresentationOptionNone);
    // UNNotificationPresentationOptionBadge
    completionHandler(UNNotificationPresentationOptionAlert);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler();
}

// [END ios_10_message_handling]

// [START refresh_token]
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {

    
    
        NSString *deviceTokenStr = [[[[fcmToken description]
                                      stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                     stringByReplacingOccurrencesOfString: @">" withString: @""]
                                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    
    self.strDeviceToken = deviceTokenStr;
}


// [END refresh_token]

// [START ios_10_data_message]
// Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
// To enable direct data messages, you can set [Messaging messaging].shouldEstablishDirectChannel to YES.
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"Received data message: %@", remoteMessage.appData);
}
// [END ios_10_data_message]

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs device token can be paired to
// the FCM registration token.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APNs device token retrieved: %@", deviceToken);
    
    // With swizzling disabled you must set the APNs device token here.
    // [FIRMessaging messaging].APNSToken = deviceToken;
}
@end






