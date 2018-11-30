//
//  RBDeviceModel.h
//  Roobo
//
//  Created by william on 16/9/28.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDGrowplan.h"
#import "RBDeviceUser.h"
#import "PDSourcePlayModle.h"
#import "PDNightModle.h"
#import "RBAntiAddictionModle.h"

@interface RBDeviceModel : NSObject<NSCoding>
@property (nonatomic, strong) NSNumber * manager;           //是否是管理员
@property (nonatomic, strong) NSString * mcid;              //设备号
@property (nonatomic, strong) NSString * name;              //设备名称
@property (nonatomic, strong) NSNumber * autodefense;       //是否开启自动布放
@property (nonatomic, strong) NSNumber * briefCode;       //豆豆号
@property (nonatomic, strong) NSArray  * devices;           //设备列表
@property (nonatomic, strong) NSNumber * ipcdetect;         //
@property (nonatomic, strong) NSDictionary * sound;         //
@property (nonatomic, strong) NSArray  * users;             //用户列表
@property (nonatomic, strong) NSNumber * volume;            //声音大小
@property (nonatomic, strong) NSNumber * rvnotify;          //声音提醒
@property (nonatomic, strong) NSArray  * guard_times;       //保护时间
@property (nonatomic, strong) NSString * index_config;      //
@property (nonatomic, strong) NSNumber * mtdetect;          //动态监测
@property (nonatomic, strong) NSNumber * chatlevel;         //
@property (nonatomic, strong) NSNumber * isdefense;         //是否是布放状态
@property (nonatomic, strong) NSNumber * online;            //是否在线
@property (nonatomic, strong) NSString * wifissid;          //wifissid
@property (nonatomic, strong) NSString * bind_user_id;      //绑定的用户 id
@property (nonatomic, strong) NSNumber * voice_wifi_config; //声波配网
@property (nonatomic, strong) NSNumber * voice_note;        //录音
@property (nonatomic, strong) NSNumber * momentID;          //家庭动态最大ID
@property (nonatomic, strong) NSNumber * power;             // 0：未充电 1：充电(暂时未使用)
@property (nonatomic, strong) NSNumber * power_supply;      // 0:未插电 1:插电
@property (nonatomic, strong) NSNumber * battery;           // 电量（0~100）
@property (nonatomic, strong) NSNumber * lock_status;       //布丁是否锁定
@property (nonatomic, strong) PDGrowplan *growplan;
@property (nonatomic, strong) NSNumber *face_track;
@property (nonatomic, strong) NSNumber *user_push;
@property (nonatomic, strong) NSNumber *msgMaxid;// 消息中心最大ID
@property (nonatomic,strong)  PDSourcePlayModle *playinfo;
@property (nonatomic,strong)  PDNightModle *nightmode;
@property (nonatomic, strong) NSString * timbre;// 布丁音效;
@property (nonatomic, strong) NSString * device_type;// 设备类型
@property (nonatomic, strong) RBDeviceModel * detail;
@property (nonatomic, strong) NSString * device_version;// 设备类型
@property (nonatomic, strong) NSArray * fangchenmi;
@property (nonatomic, strong) NSNumber * albumId;// 自定义歌单ID
@property (nonatomic, strong) NSNumber * isChildLockOn;// 布丁X是否开启童锁

- (BOOL)isPuddingPlus;
- (BOOL)isStorybox;

@end
