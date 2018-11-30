//
//  RBInitialHandle.m
//  RBMiddleLevel
//
//  Created by william on 16/11/3.
//  Copyright © 2016年 mengchen. All rights reserved.
//

#import "RBInitial.h"
#import "RBNetHeader.h"
#import "RBUserHeader.h"
@implementation RBInitial


/**
 *  根据环境进行初始化配置
 *
 */
+(void)rb_initialWithEnvState:(RBInitial_Env_State)state{
    //设定网络层中，用户操作类的类型
    RBNetConfigManager.rb_userHandleClsName = NSStringFromClass([RBUserDataHandle class]);
    //设置网络类的客户端环境，根据环境会配置不同的参数
    switch (state) {
            case RBInitial_Env_State_Develop:
        {
            RBNetConfigManager.rb_client_env_state = RBClientEnvStateDevelop;
        }
            break;
        case RBInitial_Env_State_AdHoc:
        {
            RBNetConfigManager.rb_client_env_state = RBClientEnvStateAdhoc;

        }
            break;
        case RBInitial_Env_State_Inhouse:
        {
            RBNetConfigManager.rb_client_env_state = RBClientEnvStateInhouse;

        }
            break;
        case RBInitial_Env_State_Online:
        {
            RBNetConfigManager.rb_client_env_state = RBClientEnvStateOnline;
        }
            break;
    }
}

@end
