//
//  RBEnglishKnowledgeTypeModle.m
//  PuddingPlus
//
//  Created by kieran on 2017/3/2.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBEnglishKnowledgeTypeModle.h"

@implementation RBEnglishKnowledgeTypeModle
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [RBEnglishKnowledgeModle class]};
}
@end
