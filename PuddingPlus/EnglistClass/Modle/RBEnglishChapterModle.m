//
//  RBEnglishChapterModle.m
//  PuddingPlus
//
//  Created by kieran on 2017/3/2.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglishChapterModle.h"

@implementation RBEnglishChapterModle
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description",@"chapter_id":@"id"};
}
@end
