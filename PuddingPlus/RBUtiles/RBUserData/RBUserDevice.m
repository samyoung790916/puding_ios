//
//  RBUserDevice.m
//  PuddingPlus
//
//  Created by baxiang on 2017/2/17.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBUserDevice.h"
#import "RBDeviceModel.h"
@implementation RBUserDevice

+(NSString *)getPrimaryKey
{
    return @"mcid";
}

- (NSNumber *)volume{
   RBDeviceModel  *model = [RBDeviceModel searchSingleWithWhere:@{@"mcid":_mcid} orderBy:nil];
   return model.volume;
}
@end
