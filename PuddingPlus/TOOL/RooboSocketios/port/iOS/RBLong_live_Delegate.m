//
//  RBLong_live_Delegate.m
//  RBLongConnectDemoTwo
//
//  Created by william on 16/11/14.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBLong_live_Delegate.h"

@implementation RBLong_live_Delegate

+(instancetype)sharedManager{
    
    return [[self alloc]init];
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static RBLong_live_Delegate * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager  = [super allocWithZone:zone];
    });
    return manager;
}


+(void)rb_LongOnPacket:(NSString *)str{
    if ([RBLong_live_Delegate sharedManager].delegate && [[RBLong_live_Delegate sharedManager].delegate respondsToSelector:@selector(rb_OnPacket:)]) {
        [[RBLong_live_Delegate sharedManager].delegate rb_OnPacket:str];
    }
}
+(void)rb_LongOnPacketResult:(NSString *)str{
    if ([RBLong_live_Delegate sharedManager].delegate && [[RBLong_live_Delegate sharedManager].delegate respondsToSelector:@selector(rb_OnPacketResult:)]) {
        [[RBLong_live_Delegate sharedManager].delegate rb_OnPacketResult:str];
    }
}
+(void)rb_LongOnStateChangeOld:(NSInteger)oldState newState:(NSInteger)newState{
    if ([RBLong_live_Delegate sharedManager].delegate && [[RBLong_live_Delegate sharedManager].delegate respondsToSelector:@selector(rb_OnStateChangeOld:NewState:)]) {
        [[RBLong_live_Delegate sharedManager].delegate rb_OnStateChangeOld:oldState NewState:newState];
    }
}




@end
