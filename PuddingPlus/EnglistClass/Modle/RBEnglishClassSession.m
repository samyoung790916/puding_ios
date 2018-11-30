//
//  RBEnglishClassSession.m
//  PuddingPlus
//
//  Created by kieran on 2017/3/1.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglishClassSession.h"
#import "RBEnglishChapterModle.h"

@implementation RBEnglishClassSession
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description",@"session_id":@"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [RBEnglishChapterModle class]};
}
@end
