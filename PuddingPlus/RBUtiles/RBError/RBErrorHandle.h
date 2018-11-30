//
//  RBErrorHandle.h
//  RBErrorDemo
//
//  Created by william on 16/10/18.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSUInteger, RBErrorNumber) {
    RBErrorNumber_1 = 1,
    RBErrorNumber_2 = 2,
    RBErrorNumber_3 = 3,
    RBErrorNumber_4 = 4,
    RBErrorNumber_5 = 5,
    RBErrorNumber_9 = 9,
    RBErrorNumber_10 = 10,
    RBErrorNumber_11 = 11,
    RBErrorNumber_12 = 12,
    RBErrorNumber_13 = 13,
    RBErrorNumber_14 = 14,
    RBErrorNumber_22 = 22,
    RBErrorNumber_30 = 30,
    RBErrorNumber_40 = 40,
    RBErrorNumber_50 = 50,
    RBErrorNumber_51 = 51,
    RBErrorNumber_52 = 52,
    RBErrorNumber_60 = 60,
    RBErrorNumber_80 = 80,
    RBErrorNumber_90 = 90,
    RBErrorNumber_100 = 100,
    RBErrorNumber_101 = 101,
    RBErrorNumber_102 = 102,
    RBErrorNumber_103 = 103,
    RBErrorNumber_110 = 110,
    RBErrorNumber_111 = 111,
    RBErrorNumber_112 = 112,
    RBErrorNumber_113 = 113,
    RBErrorNumber_114 = 114,
    RBErrorNumber_115 = 115,
    RBErrorNumber_116 = 116,
    RBErrorNumber_130 = 130,
    RBErrorNumber_135 = 135,
    RBErrorNumber_200 = 200,
    RBErrorNumber_201 = 201,
    RBErrorNumber_202 = 202,
    RBErrorNumber_203 = 203,
    RBErrorNumber_204 = 204,
    RBErrorNumber_210 = 210,
    RBErrorNumber_211 = 211,
    RBErrorNumber_212 = 212,
    RBErrorNumber_213 = 213,
    RBErrorNumber_214 = 214,
    RBErrorNumber_215 = 215,
    RBErrorNumber_216 = 216,
    RBErrorNumber_220 = 220,
    RBErrorNumber_230 = 230,
    RBErrorNumber_250 = 250,
    RBErrorNumber_300 = 300,
    RBErrorNumber_301 = 301,
    RBErrorNumber_302 = 302,
    RBErrorNumber_310 = 310,
    RBErrorNumber_311 = 311,
    RBErrorNumber_312 = 312,
    RBErrorNumber_306 = 306,
    RBErrorNumber_313 = 313,
    RBErrorNumber_314 = 314,
    RBErrorNumber_315 = 315,
    RBErrorNumber_316 = 316,
    RBErrorNumber_319 = 319,
    RBErrorNumber_320 = 320,
    RBErrorNumber_321 = 321,
    RBErrorNumber_322 = 322,
    RBErrorNumber_323 = 323,
    RBErrorNumber_337 = 337,
    RBErrorNumber_364 = 364,
    RBErrorNumber_370 = 370,
    RBErrorNumber_392 = 392,
    RBErrorNumber_401 = 401,
    RBErrorNumber_402 = 402,
    RBErrorNumber_559 = 559,
    RBErrorNumber_700 = 700,
    RBErrorNumber_701 = 701,
    RBErrorNumber_1001 = 1001,
    RBErrorNumber_1009 = 1009,
    RBErrorNumber_5000 = 5000,
    RBErrorNumber_9999 = 9999,
    RBErrorNumber_80001 = 80001,
    RBErrorNumber_10000 = 10000,
    RBErrorNumber_10001 = 10001,
};


/**
 *  RBError 类的回调代码块
 */
typedef void (^RBErrorBlock)(NSString * errorString);


/**
 *  RBErrorManager 单例初始化
 */
#define RBErrorManager [RBErrorHandle sharedHandle]




#pragma mark ------------------- 自动执行代码块，后返回错误详情 ------------------------

/**
 *  RBErrorConditionString  条件查询语句
 *
 *  @param dict 查询字典
 *  @param con  查询条件
 *
 *  @return 返回错误码详情，如果有代码块将自动执行
 */
#define RBErrorConditionString(dict,con) [RBErrorManager RBErrorWithDict:dict condition:con autohandleBlock:true]



#pragma mark ------------------- 不自动执行代码块，同时返回错误详情与代码块 ------------------------

static const NSString * kRBErrorBlockKey = @"RBErrorBlock";
static const NSString * kRBErrorDetailKey = @"RBErrorDetail";
/**
 *  RBErrorConditionBlock 获取代码块
 *
 *  @param dict 字典
 *  @param con  条件
 *
 *  @return 返回代码块
 */
#define RBErrorConditionBlock(dict,con) [RBErrorBlockConditionString(dict,con) objectForKey:kRBErrorBlockKey]
/**
 *  RBErrorConditionBlockDetail 获取错误详情
 *
 *  @param dict 字典
 *  @param con  条件
 *
 *  @return 返回错误详情
 */
#define RBErrorConditionBlockDetail(dict,con) [RBErrorBlockConditionString(dict,con) objectForKey:kRBErrorDetailKey]
/**
 *  RBErrorBlockConditionString 条件回调语句
 *
 *  @param dict 查询字典
 *  @param con  查询条件
 *
 *  @return 
 *  返回代码块字典，以便自行决定是否调用
 *  RBErrorBlock    中存的是 代码块（类型：RBErrorBlock）
 *  RBErrorDetail   中存的是 错误码所对应的错误详情
 *
 */
#define RBErrorBlockConditionString(dict,con) [RBErrorManager RBErrorWithDict:dict condition:con autohandleBlock:false]



#pragma mark ------------------- 无条件 ------------------------
/**
 *  RBErrorString 默认错误详情（无条件查询）
 *
 *  @param dict 查询数据
 *
 */
#define RBErrorString(dict) RBErrorConditionString(dict,nil)


@interface RBErrorHandle : NSObject
/** 设备名称 */
@property (nonatomic, strong) NSString *deviceName;

/**
 *  单利初始化
 *
 */
+ (id)sharedHandle;




/**
 *  根据字典转换错误描述
 *
 *  说明：如果调用此方法会将默认对应的错误描述替换掉。
 *
 *  @param res  字典
 *  @param condition 条件
 *
 */
- (id)RBErrorWithDict:(NSDictionary *)res condition:(NSString *)condition autohandleBlock:(BOOL)autoHandleBlock;






@end
