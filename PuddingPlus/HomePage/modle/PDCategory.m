//
//  PDCategory.m
//  Pudding
//
//  Created by baxiang on 16/10/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDCategory.h"
#import <NSObject+YYModel.h>

@implementation PDCategory

// 直接添加以下代码即可自动完成
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone {
    return [self modelCopy];
}


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description",@"category_id":@"id",@"newC":@"new"};
}

- (void)setName:(NSString *)name{
    _name = name;
    self.title = name;
}

@end
