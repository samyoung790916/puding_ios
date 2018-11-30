//
//  RBMessageModel.m
//  RBMiddleLevel
//
//  Created by william on 16/10/24.
//  Copyright © 2016年 mengchen. All rights reserved.
//
#import "RBMessageModel.h"
#import "RBMessageHandle.h"
#import "RBMessageDeailModle.h"

@implementation RBMessageModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"mid" : @"id",
             @"alert":@"aps.alert",
             @"type":@"tp",
             @"sound":@"aps.sound",
             @"url":@"aps.url",
             @"babyMaxid":@[@"maxid",@"data.maxid"],
             };
}

@end
