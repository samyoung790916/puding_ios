//
// Created by kieran on 2018/3/22.
// Copyright (c) 2018 kieran. All rights reserved.
//

#import "RBClassTimeModle.h"


@implementation RBClassTimeModle
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder]; }

- (NSString *)timeStr {
    return [NSString stringWithFormat:@"%d%@", self.time, NSLocalizedString(@"point", @"点")];
}
@end