//
//  RBInitialHandle.h
//  RBMiddleLevel
//
//  Created by william on 16/11/3.
//  Copyright © 2016年 mengchen. All rights reserved.
//

/* This is Pudding */
#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, RBInitial_Env_State) {
    RBInitial_Env_State_Develop,
    RBInitial_Env_State_Inhouse,
    RBInitial_Env_State_AdHoc,
    RBInitial_Env_State_Online,
};


@interface RBInitial : NSObject

/**
 *  根据配置环境进行初始化设置
 *
 *  @param state 环境
 */
+ (void)rb_initialWithEnvState:(RBInitial_Env_State)state;
@end
