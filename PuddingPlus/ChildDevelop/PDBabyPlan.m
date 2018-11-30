//
//  PDBabyPlan.m
//  Pudding
//
//  Created by baxiang on 16/11/22.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDBabyPlan.h"
@implementation PDBabyPlanResources
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description"};
}
@end
@implementation PDBabyPlanTags
@end
@implementation PDBabyPlanMod
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"resources" : [PDBabyPlanResources class],
             @"tags":[PDBabyPlanTags class]
             };
}
- (void)setName:(NSString *)name{
    _name = [[name stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

- (void)setFeatures:(NSString *)features{
    _features = [[features stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

@end
@implementation PDBabyPlan
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"des" : @"data.des",
             @"tips": @"data.tips",
             @"mod":@"data.mod"
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"mod" : [PDBabyPlanMod class]
             };
}
@end
