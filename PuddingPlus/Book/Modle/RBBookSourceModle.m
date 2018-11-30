//
// Created by kieran on 2018/2/27.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import "RBBookSourceModle.h"
#import "RBBookModle.h"


@implementation RBBookSourceModle
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"bid" : @"id",
            @"isnew" : @"new",
            @"des" : @"description"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"lists" : [RBBookModle class]};
}

@end