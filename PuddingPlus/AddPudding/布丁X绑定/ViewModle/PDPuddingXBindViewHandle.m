//
//  PDPuddingXBindViewHandle.m
//  PuddingPlus
//
//  Created by kieran on 2018/6/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDPuddingXBindViewHandle.h"
#import "GCDAsyncUdpSocket.h"
@interface PDPuddingXBindViewHandle()<GCDAsyncUdpSocketDelegate>{
    NSString * _wifiName;
    NSString * _wifiPsd;
    void(^SendResultBlock)(bool);
}
@property (strong, nonatomic)GCDAsyncUdpSocket * udpSocket;

@end

/**
 * 对此ip发送广播
 */
#define BROADCAST_IP  @"224.0.0.1";
/**
 * 广播对应的端口
 */
#define BROADCAST_PORT 12811



@implementation PDPuddingXBindViewHandle

- (instancetype)init
{
    self = [super init];
    if (self) {

        //创建udp socket
        self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];

    }
    return self;
}


- (void)free{
    [self.udpSocket close];
    self.udpSocket = nil;
}



- (void)sendWifiName:(NSString *)wifiName WifiPsd:(NSString *)wifiPsd  block:(void(^)(bool))sendResult{
   
    SendResultBlock = sendResult;
    [self sendWifiName:wifiName WifiPsd:wifiPsd Tag:100];
}

- (void)sendWifiName:(NSString *)wifiName WifiPsd:(NSString *)wifiPsd Tag:(int) tagValue{
    _wifiName= wifiName;
    _wifiPsd = wifiPsd;
    
    //banding一个端口(可选),如果不绑定端口,那么就会随机产生一个随机的电脑唯一的端口
    NSError * error = nil;
    [self.udpSocket bindToPort:BROADCAST_PORT error:&error];
    
    if (error != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (SendResultBlock) {
                SendResultBlock(YES);
            }
            SendResultBlock = nil;
        });
        return;
    }
    
    
    //启用广播
    [self.udpSocket enableBroadcast:YES error:&error];
    
    NSString *str = createWifiStr(wifiName, wifiPsd, RBDataHandle.loginData.userid, @"", @"");
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //此处如果写成固定的IP就是对特定的server监测
    NSString *host = BROADCAST_IP;
    
    //发送数据（tag: 消息标记）
    [self.udpSocket sendData:data toHost:host port:BROADCAST_PORT withTimeout:-1 tag:tagValue];
}

NSString * createWifiStr(NSString * wifiName ,NSString * wifiPsd,NSString * myid,NSString * security ,NSString * hidden){
    NSMutableString * builder = [NSMutableString new];
    [builder appendString:@"v1#"];
    if (wifiName != NULL) {
        [builder appendString:encode(wifiName)];
    }
    
    [builder appendString:@"#"];
    if (wifiPsd != NULL) {
        [builder appendString:encode(wifiPsd)];
    }
    
    [builder appendString:@"#"];
    if (myid != NULL) {
        [builder appendString:encode(myid)];
    }
    
    [builder appendString:@"#"];
    if (security != NULL) {
        [builder appendString:encode(security)];
    }
    [builder appendString:@"#"];
    if (hidden != NULL) {
        [builder appendString:encode(hidden)];
    }
    return builder;
    
}
NSString* encode(NSString* str) {
    NSMutableString * builder = [NSMutableString new];
    for (int i = 0; i < str.length; ++i) {
        NSString *temp = nil;
        temp = [str substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString: @"#"]) {
            [builder appendString:@"\\"];
        } else if ([temp isEqualToString: @"\\"]) {
            [builder appendString:@"\\"];
        }
        [builder appendFormat:@"%@",temp];
        
    }
    return builder;
}

#pragma mark GCDAsyncUdpSocketDelegate
//发送数据成功
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    [self.udpSocket close];

    if (tag == 100) {
        NSLog(@"标记为100的数据发送完成了");
        [self sendWifiName:_wifiName WifiPsd:_wifiPsd Tag:101];
    }else if (tag == 101) {
        NSLog(@"标记为101的数据发送完成了");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (SendResultBlock) {
                SendResultBlock(YES);
            }
            SendResultBlock = nil;
        });

    }
}

//发送数据失败
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"标记为%ld的数据发送失败，失败原因：%@",tag, error);
}

//接收到数据
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到服务端的响应 [%@:%d] %@", ip, port, str);
}


@end
