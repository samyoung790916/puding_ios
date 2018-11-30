//
//  PDMenu.m
//  Pudding
//
//  Created by baxiang on 16/10/12.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDFilterMenus.h"

@implementation PDFilterAge

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"modules" : [PDModule class]};
}
@end
@implementation PDFilterMenus
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data.list"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [PDFilterAge class]};
}
@end
