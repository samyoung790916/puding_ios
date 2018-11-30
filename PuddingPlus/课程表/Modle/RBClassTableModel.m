//
//  RBClassTableModel.m
//  PuddingPlus
//
//  Created by liyang on 2018/4/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBClassTableModel.h"

@implementation RBClassTableModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"menu" : [RBClassTableMenuModel class],
             @"module" :[RBClassTableContentModel class],
             };
}
@end

@implementation RBClassTableMenuModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id":@"id"};
}
@end

@implementation RBClassTableContentModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"content" :[RBClassTableContentDetailModel class]};
}
@end

@implementation RBClassTableContentDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"content" :[RBClassTableContentDetailListModel class]};
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id":@"id"};
}
@end

@implementation  RBClassTableContentDetailListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id":@"id",
             @"desc":@"description"
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" :[RBClassTableContentDetailListInfoModel class]};
}
@end

@implementation  RBClassTableContentDetailListInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id":@"id"};
}


@end

@implementation  RBClassTableContainerModel

@end

