//
//  RBInputItemModle.m
//  RBInputView
//
//  Created by kieran on 2017/2/8.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBInputItemModle.h"
#import "NSObject+YYModel.h"


@implementation RBInputItemModle
#pragma mark ------------------- 解析部分 ------------------------
//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}
//解档
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    return  [self modelInitWithCoder:aDecoder];
}

//
-(NSString *)description{
    return [self modelDescription];
}

-(id)copyWithZone:(NSZone *)zone{
    return [self modelCopy];
}
@end
