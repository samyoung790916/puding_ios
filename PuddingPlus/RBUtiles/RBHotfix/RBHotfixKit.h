//
//  ZYHotfixKit.h
//  HotfixSDK
//
//  Created by Zhi Kuiyu on 16/6/21.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBHotfixKit : NSObject
/**
 *  开始加载 HotFix 引擎
 *
 */+ (void)startEngine;



/**
 *  根据模块判断是否有热更新
 *  @param production: 模块名称
 */
+ (void)checkHotfixWithProduction:(NSString *)production;
@end
