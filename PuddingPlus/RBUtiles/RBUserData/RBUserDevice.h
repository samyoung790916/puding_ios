//
//  RBUserDevice.h
//  PuddingPlus
//
//  Created by baxiang on 2017/2/17.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBBaseModel.h"

/**
 当前用户所用的设备
 */
@interface RBUserDevice : RBBaseModel

@property (nonatomic, strong) NSNumber * manager;           //是否是管理员
@property (nonatomic, strong) NSString * mcid;              //设备号
@property (nonatomic, strong) NSString * name;              //设备名称
@property (nonatomic, strong) NSNumber * isdefense;         //是否是布放状态
@property (nonatomic, strong) NSNumber * online;            //是否在线
@property (nonatomic, strong) NSNumber * power;
@property (nonatomic, strong) NSNumber * power_supply;      // 0:未插电 1:插电
@property (nonatomic, strong) NSNumber * battery;           // 电量（0~100）
@property (nonatomic,strong)  NSNumber *volume;

@end
