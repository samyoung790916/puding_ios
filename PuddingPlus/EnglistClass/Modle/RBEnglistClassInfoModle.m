//
//  RBEnglistClassInfoModle.m
//  PuddingPlus
//
//  Created by kieran on 2017/3/1.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglistClassInfoModle.h"
#import "RBEnglishClassSession.h"

@implementation RBEnglistClassInfoModle
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [RBEnglishClassSession class]};
}
@end
