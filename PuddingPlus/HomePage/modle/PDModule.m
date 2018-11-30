//
//  PDModule.m
//  Pudding
//
//  Created by baxiang on 16/10/12.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDModule.h"

@implementation PDModule
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description",@"module_id":@"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"categories" : [PDCategory class]};
}
@end

