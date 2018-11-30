//
//  PDOprerateModle.m
//  Pudding
//
//  Created by baxiang on 16/8/10.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDOprerateModel.h"
@implementation PDOprerateNative
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"nativeID" : @"id"};
}
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder];}
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder];}
@end

@implementation PDOprerateImage
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder];}
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder];}
@end

@implementation PDOprerateModel

+ (NSArray *)modelPropertyBlacklist {
    return @[@"index", @"count"];
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"opreateID" : @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"imgs" : [PDOprerateImage class]};
}
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder];}
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder];}

@end
