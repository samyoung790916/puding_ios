//
//  RBUserDataHandle.h
//  RooboMiddleLevel
//
//  Created by william on 16/9/30.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBDeviceModel.h"
#import "RBUserModel.h"

#define RBDataHandle [RBUserDataHandle sharedManager]


typedef NS_ENUM(NSInteger,PDLoginOutType){
    PDLoginOutRemote = 0, // 异地登录
    PDLoginOutExpire = 1, // token 过期
    PDLoginOutUserAction = 3, // 用户主动退出
    PDLoginOutUpdateIphone = 4 // 用户更改手机号码
};

typedef void (^RBLoginOutCallBack)();


@interface RBUserDataHandle : NSObject
/** 登陆用户数据 */
@property (nonatomic, strong,readonly) RBUserModel *loginData ;
/**
 当前设备数据
 */
@property (nonatomic, strong,readonly) RBDeviceModel * currentDevice;

/** 推送ID pushID */
@property (nonatomic,strong) NSString * pushID;
/** 退出登陆回调 */
@property (nonatomic, copy) RBLoginOutCallBack logOutBack;
/** 课程表储存记录 */
@property (nonatomic,strong) NSDictionary * classTableStoreDic;


-(void)updateLoginData:(RBUserModel*)userModel;

/**
 *  初始化
 *
 */
+ (instancetype)sharedManager;

/**
 *  登出
 *
 *  @param isTimeout 是否超时
 */
- (void)loginOut:(PDLoginOutType)loginoutType;

/**
 *  刷新用户信息
 */
- (void)updateUserInfo;

@end
