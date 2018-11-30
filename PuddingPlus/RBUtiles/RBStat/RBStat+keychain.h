//
//  RBStat+keychain.h
//  Pudding
//
//  Created by william on 16/4/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBStat.h"

@interface RBStat (keychain)
#pragma mark ------------------- KeyChain ------------------------
#pragma mark - action: 根据服务获取
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

#pragma mark - action: 根据服务存储
+ (void)saveWithKey:(NSString *)service data:(id)data;

#pragma mark - action: 根据服务读取
+ (id)loadWithKey:(NSString *)service;

#pragma mark - action: 根据服务删除
+ (void)deleteWithKey:(NSString *)service;

@end
