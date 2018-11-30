//
// Created by kieran on 2018/2/27.
// Copyright (c) 2018 Zhi Kuiyu. All rights reserved.
//

#import "RBBookModle.h"


@implementation RBBookModle
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
            @"bid" : @"id",
            @"isnew" : @"new",
            @"des" : @"description"};
}
@end