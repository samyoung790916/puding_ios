//
//  RBPuddingPlayHandle.m
//  TestNSInvocation
//
//  Created by kieran on 2017/2/14.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBPuddingPlayHandle.h"
#import "NSTimer+YYAdd.h"
#import "RBMessageHandle+UserData.h"
typedef NS_ENUM(int ,RBPlayControl) {
    RBPlayControlCurrent, //播发当前
    RBPlayControlUp,      //播放上一首
    RBPlayControlNext,    //播发下一首
};



@interface RBPlayHandleTarget : NSObject

@property(nonatomic,assign) PBPuddingEvent event;

@property(nonatomic,weak) id target;

@property(nonatomic,strong) void(^block)(NSUInteger event);

- (Boolean)shouldClean;

- (void)invoke;

@end

@implementation RBPlayHandleTarget

- (Boolean)shouldClean{
    if(self.target == nil)
        return YES;
    return NO;
}

- (void)invoke{
   
    
    if(self.block){
        if(self.event == PBPuddingEventPuddingStateChange){
            self.block(self.puddingState);
        }else{
            self.block(self.playingState);
        }
    }
    
}


- (id)copyWithZone:(NSZone *)zone{
    RBPlayHandleTarget * ta = [[RBPlayHandleTarget alloc] init];
    ta.target = self.target;
    ta.block = self.block;
    return ta;
}

@end


@interface RBPuddingPlayHandle()
{
    int     loadCount;
    NSTimer * loadTimer;
    @public
    NSMutableArray * tagsArray;
    BOOL    videoPlay;
    PDSourcePlayModle * lastPlayInfo;

}

@end


@implementation RBPuddingPlayHandle

+ (id)instance{
    return [RBPuddingPlayHandle new];
}



+(instancetype)allocWithZone:(struct _NSZone *)zone{
    BOOL beginAlloc = YES;
    
    static RBPuddingPlayHandle * manager = nil;
    if(manager != nil){
        beginAlloc = NO;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
        manager->tagsArray = [NSMutableArray new];
    });
    if(beginAlloc){
        [RBDataHandle setDelegate:manager];
    }
    
    return  manager;
}

- (void)addListen:(id)target PuddingEvent:(PBPuddingEvent)event Action:(void(^)(NSUInteger status))Block{
    [self checkTarget];
    RBPlayHandleTarget * handleTarget = [[RBPlayHandleTarget alloc] init];
    [handleTarget setTarget:target];
    handleTarget.event = event;
    [handleTarget setBlock:Block];
    [tagsArray addObject:handleTarget];
}


#pragma mark - set get
- (void)setPuddingState:(RBPuddingStatus)puddingState{
    if(_puddingState == puddingState)
        return;
    _puddingState = puddingState;
    switch (puddingState) {
        case RBPuddingNone: {
            LogError(@"puddingState =======> RBPuddingNone");
            break;
        }
        case RBPuddingOffline: {
            LogError(@"puddingState =======> RBPuddingOffline");
            break;
        }
        case RBPuddingPlaying: {
            LogError(@"puddingState =======> RBPuddingPlaying");
            break;
        }
        case RBPuddingMessage: {
            LogError(@"puddingState =======> RBPuddingMessage");
            break;
        }
    }
    
    [self updateStatus:PBPuddingEventPuddingStateChange];
}


- (void)setPlayingState:(RBPuddingPlayStatus)playingState{

    switch (playingState) {
        case RBPlayNone: {
            LogError(@"playingState =======> RBPlayNone");
            break;
        }
        case RBPlayLoading: {
            LogError(@"playingState =======> RBPlayLoading");
            break;
        }
        case RBPlayReady: {
            LogError(@"playingState =======> RBPlayReady");
            break;
        }
        case RBPlayPlaying: {
            LogError(@"playingState =======> RBPlayPlaying");
            break;
        }
        case RBPlayPause: {
            LogError(@"playingState =======> RBPlayPause");
            break;
        }
    }
    _playingState = playingState;
    [self updateStatus:PBPuddingEventPlayingStateChange];

}

- (NSString *)playDeviceId{
    if(videoPlay){
        return _playDeviceId;
    }
    return RBDataHandle.currentDevice.mcid;
}

#pragma mark - action


- (void)checkTarget{
    for(int i = 0 ; i < tagsArray.count ; i++){
        RBPlayHandleTarget * target = [tagsArray objectAtIndex:i];
        if([target shouldClean]){
            [tagsArray removeObjectAtIndex:i];
            i --;
        }
    }
}
- (void)updateStatus:(PBPuddingEvent)event{
    if(self.playingState != RBPlayLoading && self.playingState != RBPlayReady){
        if(loadTimer){
            [loadTimer invalidate];
            loadTimer = nil;
        }
    }
    
    [self checkTarget];
    for(int i = 0 ; i < tagsArray.count ; i++){
        RBPlayHandleTarget * target = [tagsArray objectAtIndex:i];
        if(![target shouldClean] && (target.event & event)){
            [target invoke];
        }
    }
}

#pragma mark - play control 
- (void)play_type:(RBSourceType)sourceType CatId:(NSString *)catid SourceId:(NSString *)sourceId Error:(void(^)(NSString *)) block{
    PDSourcePlayModle * playmodle = [[PDSourcePlayModle alloc] init];
    playmodle.sid = [NSString stringWithFormat:@"%@",sourceId];
    playmodle.catid = [NSString stringWithFormat:@"%@",catid];
 
    NSString * stauts = nil;
    switch (sourceType) {
        case RBSourceMorning:
            stauts = @"morning";
            break;
        case RBSourceNight:
            stauts = @"bedtime";
            break;
        case RBSourceStory:
            stauts = @"interstory";
            break;
        default:
            break;
    }
    [RBDataHandle updateDevicePlayInfo:playmodle];
    [self sendPlay:RBPlayControlCurrent Block:block];
    
}
- (void)play:(PDFeatureModle *)playInfoModle IsVideo:(BOOL)isVideo Error:(void(^)(NSString *)) block{
    videoPlay = isVideo;
    if([playInfoModle.act isEqualToString:@"play"]){
        [self sendQuickPlay:playInfoModle.mid Block:block];
    }else{
        if(playInfoModle){
            PDSourcePlayModle * playmodle = [[PDSourcePlayModle alloc] init];
            playmodle.sid = playInfoModle.mid;
            playmodle.catid = playInfoModle.pid;
            playmodle.title = playInfoModle.name;
            playmodle.ressrc = playInfoModle.src;
            playmodle.fav_able = playInfoModle.favAble;
            playmodle.type = playInfoModle.type;
            playmodle.resourcesKey = playInfoModle.resourcesKey;
            [RBDataHandle updateDevicePlayInfo:playmodle];
        }
        [self sendPlay:RBPlayControlCurrent Block:block];
    }

}


- (void)stop:(void(^)(NSString *)) block{
    [self sendStop:block];
    
}

- (void)next:(void(^)(NSString *)) block{
    [self sendPlay:RBPlayControlNext Block:block];
}

- (void)up:(void(^)(NSString *)) block{
    [self sendPlay:RBPlayControlUp Block:block];
}

- (void)refreshPuddingState{
    
    RBDeviceModel * deviceModle = RBDataHandle.currentDevice;
    
    if(deviceModle.playinfo == nil || ![deviceModle.playinfo isvalid]){
        lastPlayInfo.status = @"stop";
        deviceModle.playinfo = lastPlayInfo;
        [RBDataHandle setCurrentDevice:deviceModle];
    }else{
        lastPlayInfo = [RBDataHandle.currentDevice.playinfo copy];
    }
    
    
    if([[deviceModle.playinfo status] isEqualToString:@"start"]){
        self.playingState = RBPlayPlaying;
    }else  if([[deviceModle.playinfo status] isEqualToString:@"pause"]){
        self.playingState = RBPlayPause;
    }else  if([[deviceModle.playinfo status] isEqualToString:@"ready"] || [[deviceModle.playinfo status] isEqualToString:@"readying"]){
        self.playingState = RBPlayReady;
    }else  if(deviceModle && ([[deviceModle.playinfo status] isEqualToString:@"load"])){
        self.playingState = RBPlayLoading;
    }else{
        self.playingState = RBPlayNone;
    }
    NSString *unReadMessage  = [RBMessageHandle fetchMessageCenterDevice:deviceModle.mcid];
    if([deviceModle.online boolValue]){
        BOOL locked = [deviceModle.lock_status boolValue];
        BOOL isChildLockOn = [deviceModle.isChildLockOn boolValue];
        if(locked){
            self.puddingState = RBPuddingLocked;
        }else{
            if(self.playingState ==  RBPlayPlaying || self.playingState == RBPlayReady || self.playingState == RBPlayLoading){
                self.puddingState = RBPuddingPlaying;
            }else if([deviceModle.battery integerValue] < 20){
                self.puddingState = RBPuddingLowPower;
            }else if(isChildLockOn){
                self.puddingState = RBPuddingChildLockOn;
            }else if(self.playingState == RBPlayPause){
                if (RBDataHandle.currentDevice.isStorybox) {
                    self.puddingState = RBPuddingPause;
                }
                else{
                    self.puddingState = RBPuddingPlaying;
                }
            }else if([unReadMessage longLongValue]<[deviceModle.msgMaxid longLongValue]){
                self.puddingState = RBPuddingMessage;
            }else{
                self.puddingState = RBPuddingNone;
            }
        }
     
    }else{
        self.puddingState = RBPuddingOffline;
    }
}

- (void)changeCurrentState:(RBPuddingPlayStatus) state{
    RBDeviceModel *deviceModel   = [RBDataHandle fecthDeviceDetail:RB_Current_Mcid];
    if(deviceModel.playinfo){
        switch (state) {
            case RBPlayNone:
                deviceModel.playinfo.status = nil;
                break;
            case RBPlayLoading:
                deviceModel.playinfo.status = @"load";
                break;
            case RBPlayReady:
                deviceModel.playinfo.status = @"ready";
                break;
            case RBPlayPlaying:
                deviceModel.playinfo.status = @"start";
                break;
            case RBPlayPause:
                deviceModel.playinfo.status = @"pause";
                break;
        }
    }
    [RBDataHandle updateDeviceDetail:deviceModel];
    [self refreshPuddingState];

}

#pragma mark - method 

- (void)loadingPlay:(void(^)(NSString *)) block{
    loadCount = 0;
    @weakify(self)
    //轮训播放信息，
    if(loadTimer){
        [loadTimer invalidate];
        loadTimer = nil;
    }
    loadTimer =  [NSTimer scheduledTimerWithTimeInterval:2.5 block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        loadCount ++;
        if(loadCount > 10){
            if(timer != nil){
                [timer invalidate];
                timer = nil;
            }
            [self changeCurrentState:RBPlayNone];
            if(block){
                block(NSLocalizedString( @"play_timeout_ps_later", nil));
            }
        }
        [RBDataHandle refreshCurrentDevicePlayInfo:nil];
    } repeats:YES];
    
    //为了尽快获取播放所在资源
    RBDeviceModel * deviceModle = RBDataHandle.currentDevice;
    if([deviceModle.playinfo.cname mStrLength] == 0)
        [ loadTimer fireDate];
    
}


- (int)getPlayAct:(RBPlayControl)control{
    
    if(control == RBPlayControlCurrent){
        NSString *flag = RBDataHandle.currentDevice.playinfo.flag;
        int actID = 0;
        if (flag != nil && ![flag isEqualToString:@""]) {
            if ([flag isEqualToString:@"morning"]) {
                actID = 9;
            } else if ([flag isEqualToString:@"bedtime"]) {
                actID = 10;
            }  else if ([flag isEqualToString:@"alarmhistory"]) {
                actID = 11;
            }else if([flag isEqualToString:@"interstory"]){
                actID = 12;
            }
        }else if(RBDataHandle.currentDevice.playinfo.isFromeCollection){
            actID = 8;
        }else if(RBDataHandle.currentDevice.playinfo.isFromSearch){
            actID = 15;
        }else if(RBDataHandle.currentDevice.playinfo.isFromHistory){
            actID = 14;
        }else {
            actID = 0;
        }
        return actID;
    }else{
        RBDeviceModel * deviceModle = RBDataHandle.currentDevice;
        BOOL isAppCmd = [deviceModle.playinfo.type isEqualToString:@"app"];
        if(control == RBPlayControlUp){
            return isAppCmd ? 1 : 3;
        }else if(control == RBPlayControlNext){
            return isAppCmd ? 2 : 4;
        }
        return -1;
    }
}


#pragma mark - RBUserHandleDelegate

- (void)RBDeviceUpdate{
    [self refreshPuddingState];
}


- (void)unReadMessageCountChange{
    [self refreshPuddingState];
}




#pragma mark - net work


- (void)sendQuickPlay:(NSString *)mid Block:(void(^)(NSString *)) block{
  
    [RBNetworkHandle mainQuickPlay:mid WithBlock:^(id res) {
        if(res && [[res objectForKey:@"result"] intValue] == 0){
        }else{
            block(RBErrorString(res));
        }
    }];
}

- (void)sendPlay:(RBPlayControl)control Block:(void(^)(NSString *)) block{
    [RBStat logEvent:PD_SOURCE_PLAY message:nil];
    RBDeviceModel * devide = [RBDataHandle fecthDeviceDetail:self.playDeviceId];
    PDSourcePlayModle * playModle = devide.playinfo;
    @weakify(self)
    
    __block RBPuddingPlayStatus currentState = self.playingState;
    [self changeCurrentState:RBPlayLoading];
    __block typeof(videoPlay) weakPlay = videoPlay;
    __block BOOL  isPlus= devide.isPuddingPlus;
    
    
    [RBNetworkHandle mainPlaySourceActID:[self getPlayAct:control] Catid:playModle.catid Mcid:self.playDeviceId SourceID:playModle.sid Type:videoPlay ? @"idle":@"" ResourcesKey:playModle.resourcesKey WithBlock:^(id res) {
        @strongify(self)
        if(res){
            if([[res objectForKey:@"result"] intValue] == 0){
                if(!(isPlus && weakPlay)){
                    [self changeCurrentState:RBPlayLoading];
                    [self loadingPlay:block];
                }
                if(block == nil)
                    return ;
                block(nil);
            }else if([[res objectForKey:@"result"] intValue] == -535){
                [self changeCurrentState:currentState];
                if(block == nil)
                    return ;
                if(control == RBPlayControlUp){
                    block(NSLocalizedString( @"current_is_first", nil));
                }else if(control == RBPlayControlNext){
                    block(NSLocalizedString( @"current_is_last", nil));
                }else{
                    block(NSLocalizedString( @"not_found_play_resource", nil));
                }
            }else{
                [self changeCurrentState:RBPlayNone];
                if(block == nil)
                    return ;
                block(RBErrorString(res));
            }
        }
    }];

}

- (void)sendStop:(void(^)(NSString *)) block{
    RBPuddingPlayStatus currentStatus = self.playingState;
    [self changeCurrentState:RBPlayLoading];

    @weakify(self)
    [RBNetworkHandle mainStopPlaySourceID:[NSString stringWithFormat:@"%@",RBDataHandle.currentDevice.playinfo.sid] Mcid:self.playDeviceId WithBlock:^(id res) {
        @strongify(self)
        if(res && [[res objectForKey:@"result"] intValue] == 0){
            [self changeCurrentState:RBPlayNone];
            if(block)
                block(nil);
        }else{
            [self changeCurrentState:currentStatus];
            if(block)
                block(RBErrorString(res));
        }
    }];
}


@end
