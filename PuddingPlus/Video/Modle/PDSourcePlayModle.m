//
//  PDSourcePlayModle.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/3/19.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDSourcePlayModle.h"

@implementation PDSourcePlayModle


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"sid" : @"extras.content.id",
             @"title":@"extras.content.title",
             @"mid":@"extras.content.mid",
             @"catid":@"extras.content.catid",
             @"fav_able":@"extras.content.fav_able",
             @"cname":@"extras.content.cname",
             @"fid":@"extras.content.fid",
             @"flag":@"extras.content.flag",
             @"img_large":@"extras.content.img_large",
             @"length":@"extras.content.length",
             @"ressrc":@"extras.content.ressrc",
             @"title":@"extras.content.title",
             };
}

- (BOOL)isvalid{
    if([self.sid integerValue] > 0)
        return YES;
    return NO;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder];}
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder];}
-(id)copyWithZone:(NSZone *)zone{return [self modelCopy];}
@end
