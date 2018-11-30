//
//  RBDeviceUser.m
//  PuddingPlus
//
//  Created by baxiang on 2017/2/15.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBDeviceUser.h"

@implementation RBDeviceUser
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder]; }
@end
