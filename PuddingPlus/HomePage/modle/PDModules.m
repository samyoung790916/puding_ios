//
//  PDModules.m
//  Pudding
//
//  Created by baxiang on 16/10/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDModules.h"

@implementation PDModules : NSObject


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"modules" : @[@"data.modules"],@"message":@"data.message"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"modules" : [PDModule class]};
}
@end
