//
// Created by kieran on 2018/2/27.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import "RBBookClassModle.h"
#import "RBBookSourceModle.h"


@implementation RBBookClassModle
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"bid" : @"id",
            @"isnew" : @"new",
            @"des" : @"description"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"modules" : [RBBookSourceModle class]};
}

@end
