//
//  PDCategories.m
//  Pudding
//
//  Created by baxiang on 16/10/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDCategories.h"

@implementation PDCategories
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.categories = [NSMutableArray new];
    }
    return self;
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"categories" : @"data.categories",
             @"total" : @"data.total"
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"categories" : [PDCategory class]};
}

@end
