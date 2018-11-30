//
//  LongLiveConniOSApi.h
//
//  Created by zhouyuanjiang on 16/9/1.
//  Copyright © 2016年 zhouyuanjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "long_live_conn_ios_api.h"
#import "RBLong_live_Delegate.h"





@interface LongLiveConniOSMainApi : NSObject {
@private
    LongLiveConniOSApi * api_;
    RBLong_live_Delegate * delegate;
}

/**
 *  clientId: 用户 Id
 *  token:  token
 */
- (void)startWithClientId:(NSString *)clientId token:(NSString *)tokenStr;
/**
 *  str： 消息体
 */
- (void)sendMsg:(NSString *)str;
/**
 *  关闭长连接方法
 */
- (void)shutDown;

@end






