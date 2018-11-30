//
//  RBLong_Live_Handle.h
//  Domgo
//
//  Created by william on 16/11/14.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import <Foundation/Foundation.h>


//长连接状态
typedef NS_ENUM(NSInteger, RBLongliveConnectState) {
    RBLongliveConnectState_Invalid = -1,        //未连接
    RBLongliveConnectState_DISCONNECTED = 0,    //断开连接
    RBLongliveConnectState_CONNECTING = 1,      //正在连接服务器
    RBLongliveConnectState_AUTHENTICATING = 2,  //就行握手验证
    RBLongliveConnectState_ESTABLISHED = 3,     //建立连接
};


@protocol RBLong_Live_Handle_Delegate <NSObject>

/**
 *  收到发送数据的回包
 *
 *  @param result 数据包
 */
-(void)rb_FeedBackPacket:(NSString *)result;



/**
 *  收到推送过来的包
 *
 *  @param result 数据包
 */
- (void)rb_ReceivePushPacket:(NSString *)result;


/**
 *  状态改变代理
 *
 *  @param oldState 旧状态
 *  @param newState 新状态
 */
-(void)rb_StateChangeNewState:(NSNumber *)newState oldState:(NSNumber *)oldState;


@end



@interface RBLong_Live_Handle : NSObject


/** 代理 */
@property (nonatomic, assign) id<RBLong_Live_Handle_Delegate> delegate;


- (void)startWithClientId:(NSString *)clientId token:(NSString *)tokenStr;

- (void)sendMsg:(NSString *)str;

- (void)shutUp;



@end
