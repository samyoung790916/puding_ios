//
//  RBErrorHandle+AddError.h
//  RBErrorDemo
//
//  Created by william on 16/10/19.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBErrorHandle.h"

@interface RBErrorHandle (AddError)
/** 代码块字典 */
@property (nonatomic, strong) NSMutableDictionary * blockDict;
/** 条件字典 */
@property (nonatomic, strong) NSMutableDictionary * conditionDict;



/**
 *  修改错误码描述
 *
 *  @param num    错误码
 *  @param detail 错误码描述
 */
- (void)setDetailWithErrorNumber:(NSInteger)num detail:(NSString *)detail;

/**
 *  添加错误码描述
 *
 *  @param num       错误码
 *  @param condition 条件
 *  @param detail    错误码描述
 */
- (void)addDetailWithErrorNumber:(NSInteger)num condition:(NSString *)condition detail:(NSString *)detail;

/**
 *  为错误码添加代码块
 *
 *  @param num   错误码
 *  @param block 代码块
 */
- (void)addBlockForErrorNumber:(NSInteger)num Block:(RBErrorBlock)block;

/**
 *  为对应的错误码添加代码块
 *
 *  @param num       错误码
 *  @param condition 条件
 *  @param block     代码块
 */
- (void)addBlockForErrorNumber:(NSInteger)num condition:(NSString *)condition Block:(RBErrorBlock)block;



/**
 *  根据错误码获取代码块
 *
 *  @param num 错误码
 *
 *  @return 代码块
 */
- (id)getBlockWithErrorNumber:(NSInteger)num;

/**
 *  根据错误码和条件获取代码块
 *
 *  @param num       错误码
 *  @param condition 条件
 *
 *  @return 代码块
 */
- (id)getBlockWithErrorNumber:(NSInteger)num condition:(NSString *)condition;


@end
