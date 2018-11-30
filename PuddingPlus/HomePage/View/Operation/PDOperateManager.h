//
//  PDOperateManager.h
//  Pudding
//
//  Created by baxiang on 16/8/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDOprerateModel.h"
@interface PDOperateManager : NSObject
+ (id)shareInstance;
-(void)showOperateView:(UIView*)superView;
-(void)loadOperateDataWithSuperView:(UIView*)superView;
+(void) fetchOperateData:(void(^)(BOOL isShow))block;
+(BOOL) isOperateTimeRange;
@end
