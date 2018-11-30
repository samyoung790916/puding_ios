//
//  PDSearchInfoModle.m
//  PuddingPlus
//
//  Created by kieran on 2017/12/7.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "PDSearchInfoModle.h"

@implementation PDSearchInfoModle
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder];}
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder];}
-(id)copyWithZone:(NSZone *)zone{
    return [self modelCopy];
}
@end
