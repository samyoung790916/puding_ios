//
//  RBLong_Live_Handle.m
//  Domgo
//
//  Created by william on 16/11/14.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBLong_Live_Handle.h"
#import "LongLiveConniOSMainApi.h"
#import "RBLong_live_Delegate.h"

@interface RBLong_Live_Handle ()<RBLongLiveDelegate>
{
    LongLiveConniOSMainApi * _api;
    
}

@end

@implementation RBLong_Live_Handle

+(instancetype)sharedHandle{
    return [[self alloc]init];
    
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static RBLong_Live_Handle * handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [super allocWithZone:zone];
    });
    return handle;
}



#pragma mark - action: 开始
-(void)startWithClientId:(NSString *)clientId token:(NSString *)tokenStr{
    if (!_api) {
        _api = [LongLiveConniOSMainApi new];
        [_api startWithClientId:clientId token:tokenStr];
        [RBLong_live_Delegate sharedManager].delegate  = self;
    }
    

}


#pragma mark - action: 发送
-(void)sendMsg:(NSString *)str{
    [_api sendMsg:str];
}

#pragma mark - action: 断开连接
-(void)shutUp{
    [_api shutDown];
    _api = nil;
}

#pragma mark ------------------- RBLongLiveDelegate ------------------------

#pragma mark - 收到发送的数据包返回的回包
-(void)rb_OnPacketResult:(NSString *)result{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rb_FeedBackPacket:)]) {
        [self.delegate performSelector:@selector(rb_FeedBackPacket:) withObject:result];
    }
}

#pragma mark - 收到主动 push 的消息
-(void)rb_OnPacket:(NSString *)result{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rb_ReceivePushPacket:)]) {
        [self.delegate performSelector:@selector(rb_ReceivePushPacket:) withObject:result];
    }
    
}
#pragma mark - 状态改变
-(void)rb_OnStateChangeOld:(NSInteger)oldState NewState:(NSInteger)newState{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(rb_StateChangeNewState:oldState:)]) {
        [self.delegate performSelector:@selector(rb_StateChangeNewState:oldState:) withObject:[NSNumber numberWithInteger:newState] withObject:[NSNumber numberWithInteger:oldState]];
    }
}

@end
