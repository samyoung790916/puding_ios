//
// Created by kieran on 2018/3/22.
// Copyright (c) 2018 kieran. All rights reserved.
//

#import "RBClassDayModle.h"


@implementation RBClassDayModle
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder]; }
@end