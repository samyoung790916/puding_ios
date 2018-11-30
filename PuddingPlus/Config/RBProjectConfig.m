//
//  RBProjectConfig.m
//  PuddingPlus
//
//  Created by kieran on 2017/1/12.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBProjectConfig.h"
#import "RBInitial.h"
#import "RBError.h"
//#import "RBHotfixKit.h"
#import "UMMobClick/MobClick.h"
#import "RBLogManager.h"
#import <AVFoundation/AVFoundation.h>
#import "NSObject+RBGetViewController.h"
#import "RBNetworkHandle+Common.h"
#import "RBVideoClientHelper.h"
#import "AppDelegate.h"



@implementation RBProjectConfig

+ (RBProjectConfig *)getInstanse{
    
    static RBProjectConfig * helper;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [RBProjectConfig new];
    });
    return helper;
}


- (void)loadConfig{
    [self loadHotFix];
    [self loadNetConfig] ;
    [self setupUMConfig] ;
    [self loadStat];
    [self keyboordCoverSetiting];
    [self logControlSetting];
    [self loadSpekerConfig];
    [self loadPublicNetErrorTip];
   
}


- (void)loadLoginOut{
    [RBDataHandle setLogOutBack:^(){
        [VIDEO_CLIENT disConnect];
        [VIDEO_CLIENT freeVideoClient];
    }];
}



- (void)loadHotFix{
//    [RBHotfixKit startEngine];
//    [RBHotfixKit checkHotfixWithProduction:@"pudding"];
}

- (void)loadStat{
    [RBStat setChannelId:[NSString stringWithFormat:@"%@",[RBNetworkHandle getChannelId]]];
    
    [RBStat getMcid:^NSString *{
        return RBDataHandle.currentDevice.mcid;
    }];
    
    [RBStat getUserId:^NSString *{
        return RBDataHandle.loginData.userid;
    }];
    /** 判断用户是不是安装 */
    NSUserDefaults *userDault =[NSUserDefaults  standardUserDefaults];
    if (![userDault boolForKey:@"PD_App_Install"]) {
        [RBStat logEvent:PD_App_Install message:nil];
        [userDault setBool:YES forKey:@"PD_App_Install"];
    }
    
}

/**
 *  键盘遮挡管理 baxiang
 */
-(void)keyboordCoverSetiting{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

    
}

-(void)logControlSetting{
    if (TESTMODLE) {
        [RBLogManager RBLogInDebugEnv];
    }else{
        [RBLogManager RBLogInReleaseEnv];
    }
}

/**
 设置友盟统计
 */
-(void)setupUMConfig{
    if(TESTMODLE){
        UMConfigInstance.appKey = @"5b4c5edca40fa3583200005e";
    }else{
        UMConfigInstance.appKey = @"5b4c5e9ff43e4804a900012f";

    }
    [MobClick startWithConfigure:UMConfigInstance];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if(TESTMODLE){
        [MobClick setAppVersion:[NSString stringWithFormat:@"%@",version]];
    }else{
        [MobClick setAppVersion:[NSString stringWithFormat:@"%@",version]];
    }

}

/**
 *  @author 智奎宇, 16-01-14 16:01:35
 *
 *  设置声音播放配置
 */
- (void)loadSpekerConfig{
    /** 6.设置后台播放声音 */
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: nil];
    [self routeChange:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)loadNetConfig{
    [RBErrorManager setDeviceName:R.pudding];
    
    RBNetConfigManager.rb_url_host_Test = @"http://pd1s.roobo.net";

    RBNetworkConfig *config  = [RBNetworkConfig defaultConfig];
    config.defaultURL = RB_URL_HOST;
    config.defaultRequestSerializer = RBRequestSerializerTypeJSON;
    config.defaultResponseSerializer = RBResponseSerializerTypeJSON;
    [config setupEnableDebug:TESTMODLE];
    
    NSString * devName = nil;
    
    
#ifdef DEBUG
    NSString * bundleId  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleIdentifierKey];

    devName = @"ios" ;
    [RBInitial rb_initialWithEnvState:RBInitial_Env_State_Develop];
#else
    NSString * bundleId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    if([bundleId isEqualToString:@"com.roobo.pudding1s"]){
        [RBInitial rb_initialWithEnvState:RBInitial_Env_State_Online];
        devName = @"ios" ;
    }else if([bundleId isEqualToString:@"com.roo.bo.Pudding1s"]){
        [RBInitial rb_initialWithEnvState:RBInitial_Env_State_Inhouse];
        devName = @"ios-enterprise" ;
    }else{
        devName = @"ios" ;
        [RBInitial rb_initialWithEnvState:RBInitial_Env_State_Online];

    }
#endif
    
    NSString * version  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString * appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSLog(@"version%@",version);
    NSLog(@"appversion%@",appversion);
    config.defaultParameters =@{@"data":@{
                                        @"app":@{@"app":bundleId,
                                                 @"aver":appversion,
                                                 @"ch":@"10000",
                                                 @"cver":@([version intValue]),
                                                 @"local":@"zh_CN",
                                                 @"osver":@"0",
                                                 @"via":devName
                                                 }
                                        },
                                @"from":@"ios",
                                
                                };
}



- (void)loadPublicNetErrorTip{
    [RBErrorManager addBlockForErrorNumber:-102  Block:^(NSString *errorString){
        [RBDataHandle loginOut:PDLoginOutRemote];
    }];
    [RBErrorManager addBlockForErrorNumber:-602  Block:^(NSString *errorString){
        [RBDataHandle loginOut:PDLoginOutExpire];
    }];
    [RBErrorManager addBlockForErrorNumber:-312  Block:^(NSString *errorString){
        [RBDataHandle refreshDeviceList:nil];
    }];
    
}


#pragma mark 监听声道的改变
- (void)routeChange:(NSNotification*)notify{
    if(notify){
        NSLog(@"声音声道改变%@",notify);
    }
    NSLog(@"%s",__FUNCTION__);

    AVAudioSessionRouteDescription*route = [[AVAudioSession sharedInstance]currentRoute];
    for (AVAudioSessionPortDescription * desc in [route outputs]) {
        NSLog(@"当前声道%@",[desc portType]);
        NSLog(@"输出源名称%@",[desc portName]);
        if ([[desc portType] isEqualToString:@"Headphones"] || [[desc portType] isEqualToString:@"BluetoothHFP"] || [[desc portType] isEqualToString:@"BluetoothA2DPOutput"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
            });
        }else{
            NSLog(@"设置为扬声器");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            });
        }
    }
}

@end
