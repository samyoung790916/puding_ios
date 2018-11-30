//
//  PDGrowplan.m
//  PuddingPlus
//
//  Created by baxiang on 2017/2/14.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDGrowplan.h"

@implementation PDGrowplan

- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder];}
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder];}
@end
