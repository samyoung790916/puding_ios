//
//  PDLaunchAdModel.m
//  Pudding
//
//  Created by baxiang on 16/9/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDLaunchAdModel.h"
@implementation PDPicture
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *height = dic[@"height"];
    NSNumber *width = dic[@"width"];
    if (![height isKindOfClass:[NSNumber class]]&&![width isKindOfClass:[NSNumber class]]) return NO;
    _size = [height integerValue]*[width integerValue];
    return YES;
}
@end
@implementation PDPictures
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *start = dic[@"start"];
    NSNumber *end = dic[@"end"];
    if (![start isKindOfClass:[NSNumber class]]&&![end isKindOfClass:[NSNumber class]]) return NO;
    _start = [NSDate dateWithTimeIntervalSince1970:start.floatValue];
    _end = [NSDate dateWithTimeIntervalSince1970:end.floatValue];
    return YES;
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"pict_id" : @"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"imgs" : [PDPicture class]};
}
@end
@implementation PDLaunchAdModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"pictures" : @"data.pictures"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pictures" : [PDPictures class]};
}
@end
