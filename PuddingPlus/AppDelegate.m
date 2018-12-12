//
//  AppDelegate.m
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/9/22.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

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

@import Firebase;


@interface AppDelegate ()<XHLaunchAdDelegate,RBPushServiceDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [[[UIApplication sharedApplication]valueForKey:@"statusBar"]setValue:[UIColor blackColor] forKey:@"foregroundColor"];
    

    
    
    // samyoung79
    // FireBase 세팅
    [FIRApp configure];
    
    
    
    
    [[RBProjectConfig getInstanse] loadConfig];

    /** 设置状态栏 */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES] ;
    // Override point for customization after application launch.
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    /**  开始打点*/
    [self trackAppDayLive];
    [RBStat startLogEvent:PD_App_Duration message:nil];
    [self setupShortcutItems];
    [self switchRootViewController];
    [self loadPushConfig:launchOptions];
    
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
    [self setupXHLaunchAd];
    
    
    // samyoung79
    NSString *libraryCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]; // Caches目录，需要清空目录下的内容
    NSString *tempPath = NSTemporaryDirectory();// temp目录
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pdlogsPath = [libraryPath stringByAppendingPathComponent:@"/PDLogs"];
    NSLog(@"缓存清空的目录：%@、%@、%@",libraryCachePath,tempPath,pdlogsPath);
    [self cleanFolderArray:@[libraryCachePath,tempPath,pdlogsPath]];
    
    return YES;
}

- (void)cleanFolderArray:(NSArray *)folderArr {
    for (NSString *folderPath in folderArr) {
        [self clearCache:folderPath];
    }
}

- (void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            if ([fileManager fileExistsAtPath:absolutePath]) {
                NSError *err = nil;
                BOOL result = [fileManager removeItemAtPath:absolutePath error:&err];
                if (!result) {
                    NSLog(@"删除出错了:%@",err);
                }
            }
            
        }
    }
}




- (void)trackAppDayLive{
    NSString * lastTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"appsetup"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSInteger currentDay = [[dateFormatter stringFromDate:[NSDate date] ] integerValue];
    
    if( currentDay > [lastTime integerValue]){
        [RBStat logEvent:PD_App_Start message:nil];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)currentDay] forKey:@"appsetup"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void)setupShortcutItems {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"video_shortcut"];
        NSDictionary *userinfo = @{@"itemId":@"video"};
        UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:@"" localizedTitle:NSLocalizedString( @"video_call_", nil) localizedSubtitle:nil icon:icon userInfo:userinfo];
        [UIApplication sharedApplication].shortcutItems = @[item];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
   
    
    [[RBMessageHandle sharedManager] mesageArrive:userInfo ApplicationActive:[[UIApplication sharedApplication] applicationState] messageType:RBRemoteNotificationFetch];
    completionHandler(UIBackgroundFetchResultNewData);
    [RTPushMgr receivePushNotification:userInfo];


}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //[application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:@"baidupushid"] ;
    [[NSUserDefaults standardUserDefaults] synchronize];
    RBDataHandle.pushID = deviceTokenStr;
    NSLog(@"push id %@",deviceToken);
    if([RBDataHandle.loginData.userid length] > 0)
        [RBNetworkHandle updatePushID:deviceTokenStr];
}

-(void)switchRootViewController{

    if (RBDataHandle.loginData&&[RBDataHandle.loginData.mcids count] > 0) {
        [RBMessageManager setShowAlter:YES];

        self.window.rootViewController = [[PDNavtionController alloc] initWithRootViewController:[RBHomePageViewController new]];// 检测更新
        [self performSelector:@selector(checkUpdate) withObject:nil afterDelay:.2];
        [RBMessageManager checkUnreadVideoMessage];

    }else if (RBDataHandle.loginData&&[RBDataHandle.loginData.mcids count] ==0){
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


// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
     [RBPushService resetBadge];
    [RBStat endLogEvent:PD_App_Duration message:nil];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self trackAppDayLive];
    [self performSelector:@selector(checkUpdate) withObject:nil afterDelay:.2];
    [RBStat startLogEvent:PD_App_Duration message:nil];
    //每次来到前台，校验上传时间，上传
    [RBStat upLoadFileWithSendInterval];
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.13 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        if([[AppDelegate windowTopViewController:self.window] isKindOfClass:[RBHomePageViewController class]]){
            [RBDataHandle refreshCurrentDevice:nil];
            [RBMessageManager checkUnreadVideoMessage];
        }

    });
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [RBStat endLogEvent:PD_App_Duration message:nil];

}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    NSDictionary *userinfo = shortcutItem.userInfo;
    NSString *itemId = [userinfo objectForKey:@"itemId"];
    if ([itemId isEqualToString:@"video"]) {
        [RBMessageManager enterVideoController:RB_Current_Mcid];
    }
}
#pragma mark - 3D touch 
/**
 *  @author 智奎宇, 16-01-14 16:01:48
 *
 *  加载push 配置和点击push 启动应用
 *
 */
- (void)loadPushConfig:(NSDictionary *)launchOptions{
    /** 4.推送设置 */
    /*********************** 4.推送试设置 ******************************/

    
    [RBPushService registerForRemoteNotificationConfig:[RBRegisterConfig new] delegate:self];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [[RBMessageHandle sharedManager] mesageArrive:userInfo ApplicationActive:[[UIApplication sharedApplication] applicationState] messageType:RBRemoteNotificationLanching];
    }
    // 是用户点击3DTouch启动应用
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        
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
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
//    [application registerForRemoteNotifications];
//}


- (void)rbpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    [[RBMessageHandle sharedManager] mesageArrive:userInfo ApplicationActive:[[UIApplication sharedApplication] applicationState] messageType:RBRemoteNotificationLanching];
    
}

- (void)rbpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (userInfo) {
        [[RBMessageHandle sharedManager] mesageArrive:userInfo ApplicationActive:[[UIApplication sharedApplication] applicationState] messageType:RBRemoteNotificationLanching];
    }

}

#pragma mark -

#pragma mark - Split view
#pragma mark - 检查更新

/**
 *  @author 智奎宇, 16-01-14 15:01:01
 *
 *  检测版本更新
 */
- (void)checkUpdate{
    NSTimeInterval time = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastCheckUpdateTime"] doubleValue];
    BOOL shouleCheck = ([[NSDate date] timeIntervalSince1970] - time ) > 60 * 60 * 8;
  
    if(shouleCheck){
        //检测 App 升级
        NSString * Identifier  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleIdentifierKey];
        NSString * versionName  =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        NSString *vcode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        
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
                    
                    
                    
                    //字典数据
                    NSDictionary *dataDict = [infodict copy];
                    if (!isForce) {
                        //如果不是强制升级
                        [[NSUserDefaults standardUserDefaults] setObject:dataDict forKey:@"lastCheckUpdateData"];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"lastCheckUpdateTime"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        //如果是强制升级
                        [[NSUserDefaults standardUserDefaults] setObject:dataDict forKey:@"lastCheckUpdateData"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    return;
                }
            }
        }];
    }
    
}

#pragma mark - action: 跳转 AppStore
/**
 *  @author 智奎宇, 16-01-14 15:01:24
 *
 *  跳转到AppStroe
 */
- (void)openAppstoreToUpdate{
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastCheckUpdateData"];
    NSArray *urlArr = [dict mObjectForKey:@"url"];
    NSURL * url = [NSURL URLWithString:[urlArr firstObject]];
    if(url&&[[UIApplication sharedApplication]canOpenURL:url]){
        LogWarm(@"如果能打开第一个链接，打开第一个链接");
        [[UIApplication sharedApplication] openURL:url];
    }else if (urlArr.count>1) {
        LogWarm(@"如果打不开第一个链接，那么看是否有第二个链接是否可用，可用则打开第二个链接");
        NSURL * secondUrl = [NSURL URLWithString:[[dict objectForKey:@"url"] lastObject]];
        if ([[UIApplication sharedApplication] canOpenURL:secondUrl]) {
            [[UIApplication sharedApplication] openURL:secondUrl];
        }
    }else{
        if (urlArr.count == 0) {
            LogError(@"没有链接");
        }else{
            LogError(@"链接不可用");
        }
    }
}

//- (void)loadPushConfig{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        UIUserNotificationType myTypes =  UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    }else {
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
//        //此方法可能过期
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    }
//}
-(void)setupXHLaunchAd{
    [XHLaunchAd setWaitDataDuration:1.0];
    [self requestImageData:^(NSString *imgUrl, NSInteger duration, NSString *openUrl, NSInteger pict_id) {
        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
        //广告停留时间
        imageAdconfiguration.duration = duration;
        //广告frame
        imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
        imageAdconfiguration.imageNameOrURLString = imgUrl;
        //缓存机制(仅对网络图片有效)
        imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
        //图片填充模式
        imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
        //广告点击打开链接
        imageAdconfiguration.openURLString = openUrl;
        //广告显示完成动画
        imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
        //跳过按钮类型
        imageAdconfiguration.skipButtonType = SkipTypeTimeText;
        //后台返回时,是否显示广告
        imageAdconfiguration.showEnterForeground = NO;
        //显示开屏广告
        [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
        
        [RBStat logEvent:PD_LAUNCH_SPLASH_SHOW message:nil];
    }];

}


- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenURLString:(NSString *)openURLString{
    if ([openURLString isNotBlank]) {
        PDHtmlViewController * vc=  [[PDHtmlViewController alloc]init];
        vc.showJSTitle = YES;
        vc.urlString = openURLString;
        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    }

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    return YES;
}
/**
 *
 *  @param imageData 回调imageUrl,及停留时间,跳转链接
 */
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

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler NS_AVAILABLE_IOS(10_0){
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"%@---%@",NSStringFromSelector(_cmd),userInfo);
    [RTPushMgr receivePushNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler NS_AVAILABLE_IOS(10_0){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"%@----%@",NSStringFromSelector(_cmd),userInfo);
    [RTPushMgr receivePushNotification:userInfo];
}
@end
