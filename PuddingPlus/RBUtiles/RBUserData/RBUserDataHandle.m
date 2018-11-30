//
//  RBUserDataHandle.m
//  RooboMiddleLevel
//
//  Created by william on 16/9/30.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBUserDataHandle.h"
#import <UIKit/UIKit.h>
#import "RBUserModel+LocalData.h"
#import "RBUserDataHandle+Delegate.h"
#import "RBUserDataHandle+Device.h"
#import "NSObject+RBExtension.h"
#import "AppDelegate.h"
#import "RBVideoClientHelper.h"
@implementation RBUserDataHandle


#pragma mark - 初始化

static RBUserDataHandle *instance = nil;


+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        
    });
    return instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(RBUserModel *)loginData{

 return [RBUserDataCache cacheForKey:@"loginData"];
}
-(void)updateLoginData:(RBUserModel*)userModel{
    RBUserModel * oldModle = self.loginData;
    
   
    if(userModel){
        [RBUserDataCache saveCache:userModel forKey:@"loginData"];
    }else{
        [RBUserDataCache removeObjectForKey:@"loginData"];
    }
    if(![userModel.userid isEqualToString:oldModle.userid]){
        [self performDelegetMethod:@selector(RBLoginStatus:) withObj:@(userModel != nil)];
    }
}

/**
 *  读取本地登录数据
 */
#pragma mark -  用户: 读取本地登陆数据

/**
 *  登出
 *
 *  @param isTimeout 是否超时
 */
#pragma mark -  用户: 用户登出
#pragma mark - action: 退出（是否超时）
- (void)loginOut:(PDLoginOutType)loginoutType{
    if(self.loginData == nil)
        return;
    
    [self updateLoginData:nil];
    [VIDEO_CLIENT freeVideoClient];
    //调用退出登陆回调
    if (self.logOutBack) {
        self.logOutBack();
    }
    
    if(loginoutType == 0){
        [[self currViewController] tipAlter:nil AlterString:NSLocalizedString( @"account_is_logged_in_other_devices", nil) Item:@[NSLocalizedString( @"i_now", nil)] type:0 delay:0 :^(int index) {
           
             [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
        }];
        
    }else if (loginoutType == 1){
        [[self currViewController] tipAlter:nil AlterString:NSLocalizedString( @"the_state_of_login_is_invalid_please_login_again", nil) Item:@[NSLocalizedString( @"i_now", nil)] type:0 delay:0 :^(int index) {
            
            [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
            
        }];
    }else if (loginoutType ==4){
        [[self currViewController] tipAlter:nil AlterString:NSLocalizedString( @"modify_phone_success_ps_login_again", nil) Item:@[NSLocalizedString( @"i_now", nil)] type:0 delay:0 :^(int index) {
            
            [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
            
        }];
        
    }else{
        [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
    }

}

#pragma mark - action: 清空登陆数据


/**
 *  刷新用户数据
 */
#pragma mark -  用户: 刷新用户数据
- (void)updateUserInfo{
    NSLog(@"刷新用户数据");
    NSLog(@"登陆数据 === %@",self.loginData);
   // [self.loginData updateLocalData];
    //[self.loginData updateToDB];
    // [RBUserDataCache saveCache:_loginData forKey:@"loginData"];
}
#pragma mark - 用户：存储用户数据
- (void)saveUserInfo{
    NSLog(@"存储用户数据");
    NSLog(@"登陆数据 === %@",self.loginData);
    //[self.loginData saveLocalData];
   // [RBUserDataCache saveCache:_loginData forKey:@"loginData"];
    //[self.loginData saveToDB];
}


@end
