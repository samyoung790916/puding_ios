//
//  RBStat.h
//  RBModelTest
//
//  Created by mengchen on 16/10/14.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
    All of the applications for Roobo company can use this To complete stat function.
    说明:
    1、初始化方法
    [RBStat startWithChannelId:AppChannelId UserId:AppUserId DeviceId:AppMcid];
    2、当遇到改变用户 Id 或者设备 Id 的时候只需要重新调用方法1，并传递新的用户 Id 和设备 Id 即可。
 */


//发送类型
typedef NS_OPTIONS(NSUInteger, RBReportPolicy) {
    RBREALTIME = 1 << 0,      //实时发送
    RBBATCH = 1 << 1,         //启动时发送
    RBSEND_INTERVAL = 1 << 2, //最小间隔发送
};


//打点类型
typedef NS_ENUM(NSUInteger, RBStatType) {
    RBStatTypeRecord,      //记录类型
    RBStatTypeDuration,    //时常类型
};


@interface RBStat : NSObject



/**
 *  @author kieran, 06-02
 *
 *  获取公共参数user id
 *
 */
+ (void)getUserId:(NSString *(^)()) block;

/**
 *  @author kieran, 06-02
 *
 *  获取公共参数mcid
 *
 */
+ (void)getMcid:(NSString *(^)()) block;

/**
 *  @author kieran, 06-02
 *
 *  设置打点回调，测试模式专用
 *
 */
+ (void)setLogCallBack:(void(^)(NSString *)) block;


/**
*   初始化 RBStat
*
*  @param cid    渠道号
*  @param userId 用户 Id
*  @param mcid   设备 Id
*/
+ (void)startWithChannelId:(NSString *)cid UserId:(NSString *)userId DeviceId:(NSString *)mcid ;



/**
 *  初始化 RBStat
 *
 *  @param appKey appKey
 *  @param rp     上报策略
 *  @param cid    渠道 Id
 */
//+ (void)startWithAppkey:(NSString *)appKey reportPolicy:(ReportPolicy)rp channelId:(NSString *)cid;

/**
 *  初始化 RBStat
 *
 *  @param appKey appKey
 *  @param cid 渠道 Id
 */
//+ (void)startWithAppKey:(NSString *)appKey channelId:(NSString *)cid;

/**
 *  设置 App 版本
 *
 *  @param appVersion 版本信息
 */
+ (void)setAppVersion:(NSString *)appVersion;

/**
 *  设置最小上报时间间隔
 *
 *  @param duration 时间间隔
 */
+ (void)setUpLoadMinTime:(CGFloat)duration;


/**
 *  设置用户 Id
 *
 *  @param userId 用户 Id
 */
+ (void)setUserId:(NSString *)userId;

/**
 *  设置设备 Id
 *
 *  @param mcId 设备 Id
 */
+ (void)setMcid:(NSString *)mcid;

/**
 *  设置渠道号
 *
 *  @param channelId 渠道号
 */
+ (void)setChannelId:(NSString *)channelId;


/*************************   打点   **********************************/
/**
 *  说明：
 *  一、打点种类
 *  1.记录打点
 *  2.时常打点（如果后面增加时常打点，需要修改 getTypeWithStatId：中的判断）
 *
 *  二、关于 message 字段的解释：
 *  对于不同的点，可能有不能的功能描述（扩展功能），message 字段是用来对这些扩展功能的描述。
 *  暂定扩展字段：
 mcid： 主控 ID（默认写进文件）
 start：时长型事件，传递时间戳（默认写进文件）
 end：  时长型事件，传递事件戳（默认写进文件）
 switch：开关型按钮事件（bool 型事件），开1，关0（需要手动写入，具体举例如下）
 index:0 序列号,用于标记事件的序号
 *  传递格式举例：
 开关打开         - > message：@"switch=1"
 点击的按钮是第1个  - > index:  @"index=1"
 当有两个参数的时候，参数与参数之剑添加 ","
  举例：@"switch=1,index=1"
 *  ！！！请注意：目前除了 switch 需要写进 message 之外，其他参数都会默认写进 message，后期根据产品需求进行扩展。
 *
 */

/**
 *  打点（点击事件，非时长事件）
 *
 *  @param eventId 事件 Id
 *  @param msg     事件详情
 */
+ (void)logEvent:(NSString *)eventId message:(NSString *)msg;

/**
 *  开始打点（时长事件，与结束打点结合使用）
 *
 *  @param eventId 事件 Id
 *  @param msg     事件详情
 */
+ (void)startLogEvent:(NSString *)eventId message:(NSString *)msg;

/**
 *  结束打点（时长事件）
 *
 *  @param eventId 事件 Id
 *  @param msg     事件详情
 */
+ (void)endLogEvent:(NSString *)eventId message:(NSString *)msg;




/**
 *  读取文件（测试）
 */
+ (void)readFile;

/**
 *  文件路径（测试）
 *
 *  @return 文件路径
 */
+ (NSString *)filePath;
/**
 *  文件夹路径(路径)
 *
 *  @return 文件夹路径
 */
+ (NSString *)folderPath;

/**
 *  压缩
 */
+ (void)zipFile;


/**
 *  上传
 */
+ (void)upLoadFileWithSendInterval;
@end
