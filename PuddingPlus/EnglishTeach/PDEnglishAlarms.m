//
//  PDEnglishAlarms.m
//  Pudding
//
//  Created by baxiang on 16/7/26.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDEnglishAlarms.h"
@implementation PDAlarmbell

+ (NSDictionary *)modelCustomPropertyMapper {
        return @{@"desc" : @"description",@"bellID" : @"id"};
}

@end
@implementation PDEnglishAlarms

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *timestamp = dic[@"week"];

    NSMutableArray *weekArray = [NSMutableArray new];
    NSString*dayStr = [self decimalTOBinary:[timestamp integerValue] backLength:7];
    for (NSInteger i= 1; i<=dayStr.length; i++) {
         NSString *s = [dayStr substringWithRange:NSMakeRange(dayStr.length-i, 1)];
        if ([s boolValue]) {
            [weekArray addObject:[NSNumber numberWithInteger:i]];
        }
    }
    _week = [NSArray arrayWithArray:weekArray];
    return YES;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"resources" : [PDEnglishResources class],@"bells":[PDAlarmbell class]};
}
- (NSString *)decimalTOBinary:(NSInteger)tmpid backLength:(NSInteger)length
{
    NSString *a = @"";
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%zd",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= length)
    {
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++)
        {
            [b appendString:@"0"];
        }
        a = [b stringByAppendingString:a];
    }
    return a;
    
}
@end
