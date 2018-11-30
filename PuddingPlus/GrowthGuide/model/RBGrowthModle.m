//
//  RBGrowthModle.m
//  PuddingPlus
//
//  Created by liyang on 2018/6/23.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBGrowthModle.h"

@implementation RBGrowthModle
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"des":@"description"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tags" : [NSString class]};
}
@end

@implementation RBGrowthGroupModle
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"resources" : [RBGrowthModle class]};
}
@end

@implementation RBGrowthContainerModle
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"groups" : [RBGrowthGroupModle class]};
}
@end


