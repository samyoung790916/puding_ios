//
//  RBHotfixNetHandle.h
//  HotfixSDK
//
//  Created by Zhi Kuiyu on 16/6/21.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBHotfixNetHandle : NSObject


- (void)downloadFixData:(NSString *)urlString  Block:(void (^)(NSData * res)) block;
- (void)getHotFixDataWithProduction:(NSString *)production block:(void (^)(NSData * res)) block;


@end
