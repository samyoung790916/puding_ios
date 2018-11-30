//
//  RTPushMessManager.h
//  StoryToy
//
//  Created by baxiang on 2017/11/29.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#define RTPushMgr [RTPushMessManager defaultManager]

@interface RTPushMessage : NSObject
@property(nonatomic,strong)NSString*alert;
@property(nonatomic,strong)NSString*content;
@property(nonatomic,strong)NSNumber *pID;
@property(nonatomic,strong)NSString *mcid;
@property(nonatomic,assign)NSInteger mt;
@property(nonatomic,assign)float size;
@end

@interface RTPushMessManager : NSObject
+ (instancetype)defaultManager;
@property(nonatomic,strong) RACSubject *wechatSignal;
@property(nonatomic,strong) RACSubject *playSignal;
-(void)receivePushNotification:(NSDictionary*)notification;
@end
