//
//  RBBaseModel.m
//  PuddingPlus
//
//  Created by baxiang on 2017/2/14.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBBaseModel.h"

@implementation RBBaseModel

+ (LKDBHelper *)defaultSQLite
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *dbFolderPath = [documentPath stringByAppendingPathComponent:@"RooboSQLite"];
        NSString* dbpath = [dbFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"pudding.db"]];
        db = [[LKDBHelper alloc] initWithDBPath:dbpath];
        //[db setKey:@"Roobo@2016"];
    });
    return db;
}

@end
