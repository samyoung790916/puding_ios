//
//  QuestionModle.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/12/4.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//

#import "QuestionModle.h"

@implementation QuestionModle



+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"qid" : @"id"
             };
}


- (BOOL)isEqual:(QuestionModle *)object{
    
    if([object isKindOfClass:[QuestionModle class]]){
        if([object.question isEqualToString:self.question] && [object.response isEqualToString:self.response]){
            return YES;
        }
    }
    
    return NO;
}


-(id)copyWithZone:(NSZone *)zone{
    return [self modelCopy];
}
@end
