//
//  RBMessageHandle.m
//  RBMessage
//
//  Created by william on 16/10/24.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBMessageHandle.h"
#import "RBMessageHandle+UserData.h"
#import "RBMessageModel.h"
#import "RBVideoViewController.h"
#import "RBUserHeader.h"
#import "RBNetHeader.h"
#import "RBLog.h"
#import "RBHomePageViewController.h"
#import "PDPlayVideo.h"
#import "RBUserDataHandle+Device.h"
#import "PDHtmlViewController.h"
#import "NSObject+RBExtension.h"
#import "RBUserDataHandle+Device.h"
#import "RBVideoClientHelper.h"
#import "RBMessageCenterViewController.h"
#import "PDFamilyDynaMainController.h"
#import "RBMessageDeailModle.h"
#import "RDPuddingContentViewController.h"
#import "PDGeneralSettingsController.h"
#import "RBWeChatListController.h"
//#import "push_manager.h"
@interface RBMessageHandle()<RBUserHandleDelegate>{
//    PushManager * manager;

}


/** 回调字典 */
@property (nonatomic, strong) NSMutableDictionary * msgBlockDict;
@property (nonatomic, strong) NSMutableDictionary * typeBlockDict;
@property (nonatomic, assign) BOOL videoAlterView;
@end


@implementation RBMessageHandle


+(id)sharedManager{
    static RBMessageHandle * handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[RBMessageHandle alloc]init];
    });
    return handle;
}
-(instancetype)init{
    if (self = [super init]) {
        _showAlter = YES;
    }
    return self;
}

/**
 *  启动长连接
 */
- (void)setUpMessageHelper{
    [RBDataHandle setDelegate:self];
    [self RBLoginStatus:@(RBDataHandle.loginData != nil)];
}


#pragma mark - 创建 -> 消息 block 字典
-(NSMutableDictionary *)typeBlockDict{
    if (!_typeBlockDict) {
        NSMutableDictionary * dict  = [NSMutableDictionary dictionaryWithCapacity:0];
        _typeBlockDict = dict;
        [self defaultTypeHandle];
    }
    return _typeBlockDict;
}

#pragma mark - 创建 -> type block 字典
-(NSMutableDictionary *)msgBlockDict{
    if (!_msgBlockDict) {
        NSMutableDictionary * dict  = [NSMutableDictionary dictionaryWithCapacity:0];
        _msgBlockDict = dict;
        [self defaultHandle];
    }
    return _msgBlockDict;
}

static NSString *  const kRBMsgHandleKey =@"kRBMsgHandleKey";
static NSString *  const kRBMsgHandleTypeKey =@"kRBMsgHandleTypeKey";
#pragma mark - action: 为指定的 mt 添加回调
- (void)addBlockForMsgNumber:(CATEGORY_TYPE)type Block:(RBMsgBlock)block{
    NSString * typeKey = [NSString stringWithFormat:@"%lu_%@",(unsigned long)type,kRBMsgHandleKey];
    [self.msgBlockDict setObject:[block copy] forKey:typeKey];
}


#pragma mark - action: 为指定的 type 添加回调
- (void)addBlockForTypeMsgNumber:(int)type Block:(RBMsgBlock)block{
    NSString * typeKey = [NSString stringWithFormat:@"%lu_%@",(unsigned long)type,kRBMsgHandleKey];
    [self.typeBlockDict setObject:[block copy] forKey:typeKey];
}



/**
 *  获取某个类型的回调
 */
- (id)blockForMsg:(RBMessageModel *)msessage{
    


    id typeblick = [self blockForTypeMsgNumber:msessage.type];
    if(typeblick == NULL){
        return [self blockForMsgNumber:[msessage.mt integerValue]];

    }
    if(msessage.mcid){
       RBDeviceModel * deviceModel =  [RBDataHandle fecthDeviceDetail:msessage.mcid];
        if(deviceModel){
            [RBDataHandle updateCurrentDevice:deviceModel];
        }else{
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"no_binding_of_this_pudding", nil)];
            return nil;
        }
    }
    return typeblick;
    
}

#pragma mark - action: 根据 mt 获取回调
- (id)blockForMsgNumber:(CATEGORY_TYPE)type{
    
    NSString * typeKey = [NSString stringWithFormat:@"%lu_%@",(unsigned long)type,kRBMsgHandleKey];
    id obj = [self.msgBlockDict objectForKey:typeKey];
    if (obj) {
        return obj;
    }else{
        return nil;
    }
}

#pragma mark - action: 根据 type 获取回调
- (id)blockForTypeMsgNumber:(int)type{

    NSString * typeKey = [NSString stringWithFormat:@"%lu_%@",(unsigned long)type,kRBMsgHandleKey];
    id obj = [self.typeBlockDict objectForKey:typeKey];
    if (obj) {
        return obj;
    }else{
        return nil;
    }
}

#pragma mark - action: 添加默认的代码块回调
-(void)addDefaultMsgBlock:(RBMsgBlock)block{
    NSString * key = [NSString stringWithFormat:@"default_%@",kRBMsgHandleKey];
    [self.msgBlockDict setObject:[block copy] forKey:key];
}

#pragma mark - action: 获取默认的代码块回调
-(id)blockForDefault{
    NSString * key = [NSString stringWithFormat:@"default_%@",kRBMsgHandleKey];
    id obj = [self.msgBlockDict objectForKey:key];
    if (obj) {
        return obj;
    }else{
        return nil;
    }
}


#pragma mark - action: 默认的设置
- (void)defaultTypeHandle{
    [RBMessageManager addBlockForTypeMsgNumber:2 Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state == UIApplicationStateInactive)
            [self enterVideoController:mol.mcid];
    }];
    [RBMessageManager addBlockForTypeMsgNumber:9 Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state == UIApplicationStateInactive)
            [self enterSettingControler:mol.mcid];
    }];
    [RBMessageManager addBlockForTypeMsgNumber:15 Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state == UIApplicationStateInactive){
            RBMessageDeailModle * data = mol.data;
            [self openWebPage:data.url];
        }
    }];
    [RBMessageManager addBlockForTypeMsgNumber:11 Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state == UIApplicationStateInactive){
            [self openPlayListController:mol.data];
        }
    }];
    [RBMessageManager addBlockForTypeMsgNumber:12 Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state == UIApplicationStateInactive){
            [self openPlayPageController:mol.data];
        }
    }];
    
    [RBMessageManager addBlockForTypeMsgNumber:14 Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state == UIApplicationStateInactive){
            [self openContentViewController];
        }
    }];
}

- (void)defaultHandle{
    //绑定请求通过
    [RBMessageManager addBlockForMsgNumber:CATEGORY_BIND_REQ_ACCEPT Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground)
            [RBDataHandle refreshDeviceList:nil];
    }];
    
    //设备网络中断
    [RBMessageManager addBlockForMsgNumber:CATEGORY_PUDDINGX_WECHAAT_NEW_MESSAGE Block:^(UIApplicationState state, RBMessageModel *mol) {
        [self wechatRecord:mol ApplicationState:state];
    }];
    
    //设备网络中断
    [RBMessageManager addBlockForMsgNumber:CATEGORY_ALARM_WIFI_BREAK Block:^(UIApplicationState state, RBMessageModel *mol) {
        [self setCurrentIsCtrlLive:mol IsLive:false];
        [RBMessageHandle updateMessageCenterWithDevice:mol.mcid MessageID:[NSNumber numberWithLong:1]];
    }];
    
    [RBMessageManager addBlockForMsgNumber:CATEGORY_APP_PUSH Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground)
            [self showMessageCenterAlter:state Modle:mol];
    }];
    [RBMessageManager addBlockForMsgNumber:CATEGORY_NEWS Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground)
            [self showMessageCenterAlter:state Modle:mol];
    }];
    
    //设备网络连接
    [RBMessageManager addBlockForMsgNumber:CATEGORY_ALARM_WIFI_CONNECT Block:^(UIApplicationState state, RBMessageModel *mol) {
        [self setCurrentIsCtrlLive:mol IsLive:true];
        [RBMessageHandle updateMessageCenterWithDevice:mol.mcid MessageID:@(1)];
    }];
    //电源线拔出或者插入
    [RBMessageManager addBlockForMsgNumber:CATEGORY_ALARM_MASTER_NO_POWER Block:^(UIApplicationState state, RBMessageModel *mol) {
        [self getDeviceState:mol];
        [RBMessageHandle updateMessageCenterWithDevice:mol.mcid MessageID:@(1)];
    }];
    //用户日志开关
    [RBMessageManager addBlockForMsgNumber:CATEGORY_APP_DIAGNOSIS Block:^(UIApplicationState state, RBMessageModel *mol) {
        [RBLogManager RBLogResetAfterPush];
    }];
    //设备升级成功
    [RBMessageManager addBlockForMsgNumber:CATEGORY_UPDATE_SUCCESS Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground)
            [RBDataHandle deviceUpdateResult:true deviceId:mol.mcid];
        
    }];
    //设备升级失败
    [RBMessageManager addBlockForMsgNumber:CATEGORY_UPDATE_FAILED Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground)
            [RBDataHandle deviceUpdateResult:false deviceId:mol.mcid];
    }];
    //低电量
    [RBMessageManager addBlockForMsgNumber:CATEGORY_POWER_LOW_2 Block:^(UIApplicationState state, RBMessageModel *mol) {
        [RBMessageHandle updateMessageCenterWithDevice:mol.mcid MessageID:@(1)];
    }];
    //播放状态
    [RBMessageManager addBlockForMsgNumber:CATEGORY_VOICE_PLAY_STATUS Block:^(UIApplicationState state, RBMessageModel *mol) {
        [self getDeviceState:mol];
    }];
    //播放状态
    [RBMessageManager addBlockForMsgNumber:CATEGORY_APP_PLAY_STATUS Block:^(UIApplicationState state, RBMessageModel *mol) {
        [self getDeviceState:mol];
    }];
    
    //收到推送。邀请绑定成功
    [RBMessageManager addBlockForMsgNumber:CATEGORY_INVITE Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground)
            [RBMessageManager showAlter:mol.alert needRefreshList:true];
    }];
    //被移除
    [RBMessageManager addBlockForMsgNumber:MSGTYPE_REMOVE_MEMBER Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground)
            [RBMessageManager showAlter:mol.alert needRefreshList:true];
    }];
    //管理员通过绑定，被绑定人收到(管理员不需要展示)
    [RBMessageManager addBlockForMsgNumber:MSGTYPE_ADMIN_BIND_REQ_ACCEPT Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground)
            [RBMessageManager showAlter:mol.alert needRefreshList:true];
    }];
    //邀请别人加入成功
    [RBMessageManager addBlockForMsgNumber:MSGTYPE_INVITE_INITIATIVE Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground){
            [self showMessageCenterAlter:state Modle:mol];
        }
    }];
    //请求绑定被拒绝(管理员不需要展示)
    [RBMessageManager addBlockForMsgNumber:CATEGORY_BIND_REQ_REJECT Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground)
            [RBMessageManager showAlter:mol.alert needRefreshList:false];
    }];
    //通知家庭成员某人被移除
    [RBMessageManager addBlockForMsgNumber:MSGTYPE_REMOVE_MEMBER_NOTIFY_FAMILY Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground){
            if([mol.alert isNotBlank])
                [RBMessageManager showAlter:mol.alert needRefreshList:true];
        }
    }];
    //发起视频
    [RBMessageManager addBlockForMsgNumber:CATEGORY_MC_START_VIDEO Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground) {
            [self showVideoAlter:mol.mcid];
        }
    }];
    //动态侦测，进入消息中心
    [RBMessageManager addBlockForMsgNumber:CATEGORY_MOTION_DTECTED Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateActive){
            RBDataHandle.loginData.currentMcid = mol.mcid;
            [self showMessageCenterAlter:state Modle:mol];
        }
    }];
    
 
    //添加其他消息默认的处理
    [RBMessageManager addDefaultMsgBlock:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground)
            [self showMessageCenterAlter:state Modle:mol];
    }];
    
    [RBMessageManager addBlockForMsgNumber:CATEGORY_PLUS_CALL Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground) {
            [self enterHomePageController];
            [self showVideoCall:mol];
        }
    }];
    [RBMessageManager addBlockForMsgNumber:CATEGORY_FACK_TRACK Block:^(UIApplicationState state, RBMessageModel *mol) {
        [RBMessageHandle updateBabyMessageWithDevice:mol.mcid MessageID:mol.babyMaxid];
        if (state != UIApplicationStateActive){
            RBDataHandle.loginData.currentMcid = mol.mcid;
            [self showFamilyViewController:state Modle:mol];
        }
    }];
    [RBMessageManager addBlockForMsgNumber:CATEGORY_FACK_TRACK_NEW Block:^(UIApplicationState state, RBMessageModel *mol) {
        [RBMessageHandle updateBabyMessageWithDevice:mol.mcid MessageID:mol.babyMaxid];
        if (state != UIApplicationStateActive){
            RBDataHandle.loginData.currentMcid = mol.mcid;
            [self showFamilyViewController:state Modle:mol];
        }
    }];

    //发起视频
    [RBMessageManager addBlockForMsgNumber:CATEGORY_MOTOR_ROTATE_TO_END Block:^(UIApplicationState state, RBMessageModel *mol) {
        if (state != UIApplicationStateBackground) {
            [MitLoadingView showErrorWithStatus:NSLocalizedString( @"master_it_has_turned_to_the_end", nil)];

        }
    }];
    
    
}



#pragma mark ------------------- 进入消息中心 ------------------------

#pragma mark -

- (void)wechatRecord:(RBMessageModel *)messageModle ApplicationState:(UIApplicationState) state{
    
    
    NSString * mcid = messageModle.mcid;
    if ([mcid mStrLength] == 0) {
        mcid = messageModle.data.sender;
    }
    RBDeviceModel * deviceModel =  [RBDataHandle fecthDevice:mcid];
    if (deviceModel == nil || ![deviceModel isStorybox]) {
        LogError(@"wechatRecord mcid=%@____devicetype=%@" ,deviceModel.mcid,deviceModel.device_type);
        return;
    }
    messageModle.mcid = mcid;
    
    if (state == UIApplicationStateActive) {
        [RBDataHandle wechatHomePageNewMessageUpdate:messageModle];
    }else{
        [RBDataHandle updateCurrentDevice:deviceModel];
        __block UIViewController *viewController = nil;
        UINavigationController *navigation  = [[self currViewController] navigationController];
        [navigation.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[RBWeChatListController class]]){
                viewController = obj;
                *stop = YES;
            }
        }];
        if (viewController == nil) {
            viewController = [RBWeChatListController new];
            [navigation pushViewController:viewController animated:YES];
        }else{
            [navigation popToViewController:viewController animated:YES];
        }

        
    }
}


#pragma mark - action: 设置当前主控是否在线
- (void)setCurrentIsCtrlLive:(RBMessageModel *)modle IsLive:(BOOL)isLive{
    for(RBDeviceModel * ctmodle in RBDataHandle.loginData.mcids){
        if([ctmodle.mcid isEqualToString:modle.mcid]){
            ctmodle.online = @(isLive);
            [RBDataHandle updateUserInfo];
            [RBDataHandle updateDeviceState];
            break;
        }
    }
}

#pragma mark - action: 展示视频呼叫界面

- (void)showVideoCall:(RBMessageModel *)modle{
    [VIDEO_CLIENT checkMcCalling:modle.mcid];
}

/**
 *  进入宝宝动态界面
 *
 *  @param appState
 */
-(void)showFamilyViewController:(UIApplicationState)appState Modle:(RBMessageModel *)modle{

    if ((self.notificationType ==RBRemoteNotificationLanching)||(self.notificationType == RBRemoteNotificationFetch&&appState!=UIApplicationStateActive)) {
        UIViewController *currViewController   = [self getCurrentVC];
        if ([currViewController isKindOfClass:[PDFamilyDynaMainController class]]) {
            PDFamilyDynaMainController *controller = (PDFamilyDynaMainController*)[self getCurrentVC];
            controller.currMainID = [NSString stringWithFormat:@"%@",modle.mcid];
            [controller refreshFamilyPhotoData];
            return;
        }
        PDFamilyDynaMainController * controller = [[PDFamilyDynaMainController alloc] init];
        controller.currMainID = [NSString stringWithFormat:@"%@",modle.mcid];
        [currViewController.navigationController pushViewController:controller animated:YES];
    }
}



//进入消息中心
#pragma mark - action: 进入消息中心
- (void)showMessageCenterAlter:(UIApplicationState)state Modle:(RBMessageModel *)model{
    
    if ((self.notificationType ==RBRemoteNotificationLanching)||(self.notificationType == RBRemoteNotificationFetch&&state!=UIApplicationStateActive)) {
        UIViewController *currViewController   = [self getCurrentVC];
        if ([currViewController isKindOfClass:[RBMessageCenterViewController class]]) {
            RBMessageCenterViewController *messVC = (RBMessageCenterViewController*)currViewController;
            messVC.currentLoadId = model.mcid;
            [messVC refreshNewMessageData];
            return;
        }
        RBMessageCenterViewController * controller = [[RBMessageCenterViewController alloc] init];
        controller.currentLoadId = model.mcid;
        [currViewController.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - 消息功能界面

- (void)enterSettingControler:(NSString *)mcid{
    if([mcid mStrLength] > 0){
        RBDeviceModel * deviceModel =  [RBDataHandle fecthDeviceDetail:mcid];
        if(deviceModel){
            [RBDataHandle updateCurrentDevice:deviceModel];
        }
    }
    
    UIViewController *currViewController   = [self getCurrentVC];
    if ([currViewController isKindOfClass:[PDGeneralSettingsController class]]) {
        return;
    }
    
    PDGeneralSettingsController *vc = [[PDGeneralSettingsController alloc] init];
    UINavigationController *navigation  = [[self currViewController] navigationController];

    [navigation pushViewController:vc animated:YES];
}

//进入首页
- (void)enterHomePageController{
    __block UIViewController *viewController = nil;
    UINavigationController *navigation  = [[self currViewController] navigationController];
    [navigation.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[RBHomePageViewController class]]){
            viewController = obj;
            *stop = YES;
        }
    }];
    if (viewController) {
        [navigation popToViewController:viewController animated:YES];
    }
    
}
//打开网页
- (void)openWebPage:(NSString *)url{
    if(url){
        UINavigationController *navigation  = [[self currViewController] navigationController];
        PDHtmlViewController *vc = [[PDHtmlViewController alloc]init];
        vc.urlString = url;
        [navigation pushViewController:vc animated:YES];
        
    }else{
        [MitLoadingView showErrorWithStatus:NSLocalizedString( @"open_link_fail", nil)];
        
    }
    
}

//打开资源列表
- (void)openPlayListController:(RBMessageDeailModle *)data{
    PDFeatureModle *model = [PDFeatureModle new];
    model.mid = data.did;
    model.act = @"tag";
    model.img = data.img;
    model.title = data.title;
    model.thumb = data.img;

    UINavigationController *navigation  = [[self currViewController] navigationController];

    [navigation pushFetureList:model];
//    [viewController.navigationController pushFetureDetail:modle SourceModle:nil];

}
//进入播放界面，如果没有播放，进行播放
- (void)openPlayPageController:(RBMessageDeailModle *)data{
    PDFeatureModle *model = [PDFeatureModle new];
    model.mid = data.did;
    model.act = @"res";
    model.img = data.img;
    model.name = data.name;
    model.thumb = data.img;

    UINavigationController *navigation  = [[self currViewController] navigationController];
    
    [navigation pushFetureDetail:model SourceModle:nil];
    
}


//进入布丁优选
- (void)openContentViewController{
    RDPuddingContentViewController * vc = [RDPuddingContentViewController new];
    UINavigationController *navigation  = [[self currViewController] navigationController];
    [navigation pushViewController:vc animated:YES];
    
}

//显示视频界面
#pragma mark - action: 显示视频界面
- (void)enterVideoController:(NSString *)mcid {
    if (RBDataHandle.loginData == nil || mcid == nil) {
        return;
    }
    
    UIViewController * currentvc = [self getCurrentVC];
    if(currentvc.presentationController){
        [currentvc dismissViewControllerAnimated:NO completion:nil];
    }
    
    
    NSMutableArray * newControllers = [[NSMutableArray alloc] init];
    
    RBVideoViewController * videoViewControler = nil;
    for(UIViewController * con in currentvc.navigationController.viewControllers){
        [newControllers addObject:con];
        if([con isKindOfClass:[RBVideoViewController class]]){
            videoViewControler = (RBVideoViewController *)con;
            break;
        }
    }
    if(videoViewControler == nil){
        videoViewControler = [[RBVideoViewController alloc] init];
        [newControllers addObject:videoViewControler];
    }
    [videoViewControler setCallId:mcid];
    [currentvc.navigationController setViewControllers:newControllers animated:YES];
}

- (void)showVideoAlter:(NSString *)mcid{
    if(RBDataHandle.loginData == nil)
        return;
    if (_videoAlterView) {
        // 已有弹窗则不再提示
        return;
    }
    NSString * urlStr = [[NSBundle mainBundle]pathForResource:@"RooboVideoCall" ofType:@"mp3"];
    [PDPlayVideo playMusic:urlStr];
    NSString *content = NSLocalizedString( @"baby_miss_you_open_the_video_quickly", nil);
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    @weakify(self)
    _videoAlterView = YES;
    [[self getCurrentTopViewControler] tipAlter:NSLocalizedString( @"video_invitation", nil) AlterString:content Item:@[NSLocalizedString( @"g_cancel", nil),NSLocalizedString( @"accept", nil)] type:0 delay:0 :^(int index) {
        @strongify(self)
        _videoAlterView = NO;
        [PDPlayVideo stopMusic:urlStr];
        if(index == 1){
            [RBStat logEvent:PD_PUDDING_VIDEO_START message:nil];
            if([mcid length] == 0){
                return ;
            }
            
            [self enterVideoController:mcid];
        } else {
            [RBStat logEvent:PD_PUDDING_VIDEO_CANCEL message:nil];
        }
        
    }];
}

#pragma mark - Socket Helper

- (void)setUpSocket{
//    RBDeviceInfo * deviceInfo = [[RBDeviceInfo alloc] init];
//    deviceInfo.device_type = TYPE_APP;
//    deviceInfo.platform_type = PLATFORM_IOS;
//    deviceInfo.encode_type = ENCODE_PROTOBUF;
//    deviceInfo.network_type = NETWORK_WIFI;
//    deviceInfo.encrypt_type = ENCRYPT_AES_CFB;
//    deviceInfo.production = @"pudding1s.app";
//    deviceInfo.channel = @"00";
//    deviceInfo.app_id = @"com.roobo.puddingplus";
//    deviceInfo.app_name = @"puddingplus";
//    deviceInfo.app_version = @"1.0.0.0";
//    deviceInfo.client_id = RBDataHandle.loginData.userid;
//    deviceInfo.app_token = RBDataHandle.loginData.token;
//
//    deviceInfo.secret =@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDSSwvej3JDqhN23fki0gDaNqDE\nD1g6ox+OhETOnIALCo1KIImTjy9zpZPYLAmWuqPZV+X1aAPs56tvD9m1h1wNDmqV\nlM0Tj9QlywEZX3/FKggoH5VBDlB6fCfjp+iI40eThzTGHPBI7Rj0kr10atE3WOdq\nPQFn+ZXzzjz2U/35gQIDAQAB";
//    deviceInfo.ip_addr = @"";
//    
//    HeartbeatInfo *info = calloc(1, sizeof(HeartbeatInfo));
//    manager = [[PushManager alloc] init:@"netlink.roobo.net" ServerPort:7080 DeviceInfo:deviceInfo HeartBeatInfo:*info Delegate:self];
//    free(info);
//    [manager connect];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBack:) name:UIApplicationDidEnterBackgroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomActive:) name:UIApplicationWillEnterForegroundNotification object:nil];
}


- (void)applicationEnterBack:(id)sender{
//    [manager disconnect];

}

- (void)applicationBecomActive:(id)sender{
    
//    [manager connect];
}

- (void)hangeSocket{
//    [manager disconnect];
//    [manager uninit];
//    manager = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark - RBUserHandleDelegate
/**
 *  登录状态变更
 */
- (void)RBLoginStatus:(NSNumber *)isOnLine{
    if([isOnLine boolValue]){
    
        [self setUpSocket];
    }else{
    
        [self hangeSocket];
    }

}

#pragma mark - action: 获取设备的状态
- (void)getDeviceState:(RBMessageModel *)mo{
    if(mo && mo.mcid){
        [RBNetworkHandle getDevicestateWithCtrlID:mo.mcid Block:^(id res) {
            if(res && [[res objectForKey:@"result"] intValue] == 0){
                PDSourcePlayModle *playinfo =[PDSourcePlayModle modelWithJSON:[[res mObjectForKey:@"data"] mObjectForKey:@"playinfo"]];
                RBDeviceModel *deviceModel   = [RBDataHandle fecthDeviceDetail:mo.mcid];
                deviceModel.playinfo = playinfo;
                [RBDataHandle updateDeviceDetail:deviceModel];
            }
        }];
    }
}

//#pragma mark -  MessageDelegate
//- (void) OnConnected {
//    [manager sendMessage:@"pudding-plus" Clientid:@"1011000000200C0D" appID:@"" action:@"VoiceServer/changeMasterVolume" MessageType:TYPE_REALTIME MessageData:@"{\"volume\":26.0,\"mainctl\":\"1011000000101060\",\"myid\":\"ps:58cb4143bbdfe51eceb4bfe4ea2c27b1\",\"production\":\"pudding-plus\",\"token\":\"40a6af06474f87fa32ace42d89e85988\"}" SendResultBlock:^(enum SendStatus state) {
//        NSLog(@"");
//    }];
//
//}
//- (void) OnDisconnected: (const int) code Message:(NSString *) message{
//
//}
//- (void) OnMessageArrived:(enum MessageType)type  MessageInfo:(RBMessageInfoModle *) info ShouldAckBlock:(RBSendAckBlock) ackBlock{
//    ackBlock(nil);
//}

#pragma mark -

- (UIViewController *)getCurrentTopViewControler{
    UIViewController *result = [self getCurrentVC];
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    
    return result;
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    if([result isKindOfClass:[UINavigationController class]]){
        result =  ((UINavigationController *)result).topViewController;
    }

    return result;
}

@end
