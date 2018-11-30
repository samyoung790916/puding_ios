//
//  RBDeviceModel.m
//  Domgo
//
//  Created by william on 16/9/28.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "RBDeviceModel.h"


@implementation RBDeviceModel

- (BOOL)isPuddingPlus{
    if([self.device_type isEqualToString:@"pudding-plus"])
        return YES;
    return NO;
}
- (BOOL)isStorybox{
    if([self.device_type isEqualToString:@"storybox"])
        return YES;
    return NO;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"users":[RBDeviceUser class],@"fangchenmi":[RBAntiAddictionModle class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"face_track" : @"face_track.face_track",
             @"user_push":@"face_track.user_push",
             @"momentID":@"moment.maxid",
             @"msgMaxid":@"msginfo.maxid"
             };
}

+(NSString *)getTableName
{
    return @"RBDevice";
}
+(NSString *)getPrimaryKey
{
    return @"mcid";
}

- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder];}
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder];}



- (void)setDevice_type:(NSString *)device_type{
    _device_type = device_type;
}
@end
