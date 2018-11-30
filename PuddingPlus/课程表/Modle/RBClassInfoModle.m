//
// Created by kieran on 2018/3/22.
// Copyright (c) 2018 kieran. All rights reserved.
//

#import "RBClassInfoModle.h"

@implementation RBClassInfoModle


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cid" : @"id",
            @"des" : @"description"
    };
}
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"categories" : [PDCategory class]};
//}
@end