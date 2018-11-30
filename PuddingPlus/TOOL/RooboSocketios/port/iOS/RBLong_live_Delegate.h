//
//  RBLong_live_Delegate.h
//  RBLongConnectDemoTwo
//
//  Created by william on 16/11/14.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RBLongLiveDelegate <NSObject>

//收包
-(void)rb_OnPacket:(NSString *)result;
//发送包的结果
- (void)rb_OnPacketResult:(NSString *)result;
//状态改变
- (void)rb_OnStateChangeOld:(NSInteger)oldState NewState:(NSInteger)newState;
@end

@interface RBLong_live_Delegate : NSObject

/** 代理 */
@property (nonatomic, assign)id<RBLongLiveDelegate> delegate;


+(instancetype)sharedManager;
+ (void)rb_LongOnPacket:(NSString *)str;
+ (void)rb_LongOnPacketResult:(NSString *)str;
+ (void)rb_LongOnStateChangeOld:(NSInteger)oldState newState:(NSInteger)newState;

@end
