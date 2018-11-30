//
//  RBHotfixNetHandle.m
//  HotfixSDK
//
//  Created by Zhi Kuiyu on 16/6/21.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBHotfixNetHandle.h"
#import <UIKit/UIKit.h>
//#import "NSString+RBEncryption.h"
#import "RBNetHeader.h"
@interface RBHotfixNetHandle (){
    NSMutableData * receivedData;
}
@property(nonatomic,strong) NSURLConnection * connection;
@property (nonatomic,copy) void(^RecoredDataBlock)(id);
@end

@implementation RBHotfixNetHandle


#pragma mark - 下载热修复代码
- (void)downloadFixData:(NSString *)urlString  Block:(void (^)(NSData * res)) block{

    NSURL *downloadURL=[NSURL URLWithString:urlString];//不需要传递参数
    if(downloadURL == nil){
        if(block){
            block(nil);
        }
        return;
    }
    self.RecoredDataBlock = block;

    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:downloadURL];//默认为get请求
    [self startRequest:request];
}


#pragma mark - 获取 url 地址
NSString * getTotfixurl(){
    NSString * host = nil;
    switch (RBNetConfigManager.rb_client_env_state) {
            case RBClientEnvStateAdhoc:
        {
            host  = @"http://update.roo.bo/v1/check";
        }
            break;
            case RBClientEnvStateOnline:
        {
            host  = @"http://update.roo.bo/v1/check";
        }
            break;
            case RBClientEnvStateDevelop:
        {
            host  = @"http://update.roo.bo/v1/check";
        }
            break;
            case RBClientEnvStateInhouse:
        {
            host  = @"http://update.roo.bo/v1/check";
        }
            break;
    }
    
    host = [NSString stringWithFormat:@"%@?*reqid*=%@",host,RBNetConfigManager.rb_net_once_Identifier];
    return host;
}


#pragma mark - 获取热修复数据
- (void)getHotFixDataWithProduction:(NSString *)production block:(void (^)(NSData * res)) block{
    self.RecoredDataBlock = block;
    // 1.设置请求路径
    NSURL *URL=[NSURL URLWithString:getTotfixurl()];//不需要传递参数
    //    2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    NSString * appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * version  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString * Identifier  = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleIdentifierKey];
    
    //设置请求体
    NSString * osver = [UIDevice currentDevice].systemVersion;
    //@"pudding1s.ios_hotfix"
    NSDictionary *dict = @{@"action":@"common/updateinfo"
                           ,@"data":@{@"production":production,
                                      @"app":@{
                                              @"via":@"ios",
                                              @"app":Identifier,
                                              @"aver":appversion,
                                              @"cver":@([version intValue]),
                                              @"osver":@([osver intValue]),
                                              @"local":@"zh_CN",
                                              @"ch":[RBNetworkHandle getChannelId]},
                                      @"clientId":@"",
                                      @"modules":@[@{@"name":Identifier,
                                                     @"vname":appversion,
                                                     @"vcode":@([version intValue])}],
                                      @"net":@"wifi",
                                      @"location":@{@"lng":@(0),
                                                    @"lat":@(0),
                                                    @"addr":@""}
                                      }};
    NSError *error = nil;
    NSData *data =
    [NSJSONSerialization dataWithJSONObject:dict
                                    options:NSJSONWritingPrettyPrinted
                                      error:&error];
    if (error) {
        NSLog(@"Error serializing JSON: %@", error);
    }
    //把拼接后的字符串转换为data，设置请求体
    request.HTTPBody=data;
    [self startRequest:request];


}

#pragma mark - action: 开始请求
- (void)startRequest:(NSURLRequest *)request{
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];

    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [_connection scheduleInRunLoop:loop forMode:NSRunLoopCommonModes];
    [_connection start];
    [loop run];

    
    
}


- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    //1)获取trust object
    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    SecTrustResultType result;
    
    //2)SecTrustEvaluate对trust进行验证
    OSStatus status = SecTrustEvaluate(trust, &result);
    if (status == errSecSuccess &&
        (result == kSecTrustResultProceed ||
         result == kSecTrustResultUnspecified)) {
            
            //3)验证成功，生成NSURLCredential凭证cred，告知challenge的sender使用这个凭证来继续连接
            NSURLCredential *cred = [NSURLCredential credentialForTrust:trust];
            [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
            
        } else {
            //5)验证失败，取消这次验证流程
            [challenge.sender cancelAuthenticationChallenge:challenge];
        }
}


-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    receivedData = [[NSMutableData alloc] init]; // _data being an ivar
 
    [receivedData setLength:0];
    
}
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [receivedData appendData:data];
}
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    [_connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    if(_RecoredDataBlock){
        _RecoredDataBlock(nil);
    }

}
-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    [_connection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    if(_RecoredDataBlock){
        _RecoredDataBlock(receivedData);
    }
    
}

@end
