//
//  PDInteractModle.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/8/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDInteractModle.h"

@implementation PDInteractModle

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"ID" : @"id"
             };
}

- (NSString *)keyword_str{
    if(self.inter_type.count > 0 ){
        if (_keyword_str == nil) {
            NSMutableString * string = [NSMutableString new];
            for (int i = 0; i < [self.inter_type count]; i++) {
                NSString * str = [self.inter_type objectAtIndex:i];
                if(i == self.inter_type.count -1){
                    [string appendString:str];
                }else{
                    [string appendString:[NSString stringWithFormat:@"%@，",str]];
                }
            }
            _keyword_str = string;
        }
    }
    return _keyword_str;
}


- (NSString *)title{
    if(_title)
        return _title;
    return _name;
}
@end
