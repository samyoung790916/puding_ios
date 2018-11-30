//
//  RBUserModel.h
//  Domgo
//
//  Created by william on 16/9/28.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBBaseModel.h"

/**
 *  Roobo 用户数据模型
 */
@interface RBUserModel : NSObject<NSCoding>
@property (nonatomic, strong) NSArray <RBDeviceModel*>  * mcids;       //设备数组
@property (nonatomic, strong) NSString  * headimg;     //头像图片链接
@property (nonatomic, strong) NSString  * name;        //姓名
@property (nonatomic, strong) NSString  * phone;       //手机号
@property (nonatomic, strong) NSString  * token;       //token
@property (nonatomic, strong) NSString  * userid;      //用户id
@property (nonatomic, strong) NSString  * mytm;        //时间
@property (nonatomic, strong) NSNumber  * userleave;   //用户是否离线
@property (nonatomic, strong) NSString  * currentMcid; //当前主控的 Mcid
@property (nonatomic, strong) NSArray * requests;    //正在请求绑定的主控
@property (nonatomic, assign) BOOL      isLoginUser; //是否是登陆用户：为了区分登陆用户与设置用户
@property (nonatomic,strong) NSNumber       *manager;//是否是管理员
@property (nonatomic,assign) BOOL           isAddModle;//是否是添加的 Modle
@property (nonatomic,strong) NSNumber       *isStartControl;//是否展开操纵

@end
