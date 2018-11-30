//
//  RTPushMessManager.m
//  StoryToy
//
//  Created by baxiang on 2017/11/29.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import "RTPushMessManager.h"
#import <ReactiveCocoa.h>
@implementation RTPushMessage
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"alert": @"aps.alert",
             @"pID" : @"id",
             @"content" : @"data.content",
             @"size" : @"data.size",
            };
}
@end


@implementation RTPushMessManager
+ (instancetype)defaultManager{
    static RTPushMessManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}

-(instancetype)init
{
    if (self = [super init]) {
         _wechatSignal = [RACSubject subject];
         _playSignal = [RACSubject subject];
    }
    return self;
}

-(void)receivePushNotification:(NSDictionary*)notification
{
    RTPushMessage *messModel = [RTPushMessage modelWithJSON:notification];
    if (messModel.mt == 6000) { //微聊消息
        [_wechatSignal sendNext:messModel];
    }
}


@end
