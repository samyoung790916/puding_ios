//
//  RTDeviceManager.m
//  StoryToy
//
//  Created by baxiang on 2017/10/30.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import "RTDeviceManager.h"
#import "YYCache.h"
@interface RTDeviceManager()
@property(nonatomic,strong) YYCache *deviceCache;
@property(nonatomic,strong) RACDisposable *playInfoSignal;
@end

@implementation RTDeviceManager

+ (instancetype)defaultManager{
    
    static RTDeviceManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}

-(instancetype)init
{
    if (self = [super init]) {
        NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [cacheFolder stringByAppendingPathComponent:@"RTDeviceManager"];
        _deviceCache = [YYCache cacheWithPath:path];
        _babySignal = [RACSubject subject];
        _playSignal = [RACSubject subject];
    }
    return self;
}

-(void)savaDeviceDetail:(RBDevicesDetail*)deviceDetail
{
    [_deviceCache setObject:deviceDetail forKey:[NSString stringWithFormat:@"RBDevicesDetail_%@",deviceDetail.deviceID]];
}

-(void)saveGrowPlan:(RBBabyModel*)babyModel
{
    RBBabyModel *currBaby = ( RBBabyModel *)[_deviceCache objectForKey:[NSString stringWithFormat:@"RTBabyInfo_%@",babyModel.babyId]];
    if (!currBaby) {
        currBaby = [babyModel copy];
    }else{
        currBaby.babyId = babyModel.babyId;
        currBaby.img =  babyModel.img;
        currBaby.nickname = babyModel.nickname;
        currBaby.tags =  babyModel.tags;
        currBaby.tips =  babyModel.tips;
        currBaby.age =  babyModel.age;
    }
    [_deviceCache setObject:currBaby forKey:[NSString stringWithFormat:@"RTBabyInfo_%@",babyModel.babyId]];
}

-(void)saveBabyInfo:(RBBabyModel*)babyModel updateType:(RTBabyUpdateType)updateType{
    RBBabyModel *currBaby = ( RBBabyModel *)[_deviceCache objectForKey:[NSString stringWithFormat:@"RTBabyInfo_%@",babyModel.babyId]];
    if (!currBaby) {
        currBaby = [babyModel copy];
    }else{
        currBaby.babyId = babyModel.babyId;
        currBaby.img =  babyModel.img;
        currBaby.nickname = babyModel.nickname;
        currBaby.birthday =  babyModel.birthday;
        currBaby.gender =  babyModel.gender;
    }
    [_deviceCache setObject:currBaby forKey:[NSString stringWithFormat:@"RTBabyInfo_%@",babyModel.babyId]];
    [_babySignal sendNext:RACTuplePack(@(updateType),currBaby)];
}
-(RBDevicesDetail*)fetchDeviceDetail:(NSString*)deviceID{
   RBDevicesDetail *deviceDetail =(RBDevicesDetail*)[_deviceCache objectForKey:[NSString stringWithFormat:@"RBDevicesDetail_%@",deviceID]];
   return deviceDetail;
}

-(void)updateDeviceDetail:(void (^)(RBDevicesDetail *detail,NSError *error))block{
    @weakify(self);
    [RBDeviceApi getDeviceDetail:^(RBDevicesDetail *detailModel, NSError *error) {
        @strongify(self);
        if ([detailModel.deviceID isNotBlank]) {
            [self savaDeviceDetail:detailModel];
            [self saveGrowPlan:detailModel.growplan];
            detailModel.playinfo.online = detailModel.online;// 播放信息中的在线状态需要从详情中补充进来
            [self savePlayInfo:detailModel.playinfo];
        }
        if (block) {
            block(detailModel,error);
        }
    }];
}

-(void)savePlayInfo:(RBPlayInfoModel*)playInfo
{
     _playinfo = playInfo;
     [_playSignal sendNext:playInfo];
}
-(void)updatePlayState{
    @weakify(self);
    [RBPlayerApi getPlayState:^(RBPlayInfoModel*playModel, NSError * error) {
         @strongify(self);
         [self savePlayInfo:playModel];
    }];
}
-(void)pollingPlayState
{
    _playInfoSignal = [[RACSignal interval:60 onScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault]] subscribeNext:^(NSDate * _Nullable x) {
        [self updatePlayState];
    }];
}
-(void)stopPollingPlayState{
    if (!self.playInfoSignal.isDisposed) [self.playInfoSignal dispose];
}
@end
