//
//  PDNationCode.m
//  Pudding
//
//  Created by baxiang on 2017/1/6.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDNationCode.h"

@implementation PDNationcontent

+ (LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* dbpath =[[NSBundle mainBundle] pathForResource:@"PDNationCode" ofType:@"db"];
        db = [[LKDBHelper alloc] initWithDBPath:dbpath];
    });
    return db;
}

+(NSString *)getTableName
{
    return @"PDNationCode";
}
@end
@implementation PDNationCode
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"content" : [PDNationcontent class]};
}
@end
