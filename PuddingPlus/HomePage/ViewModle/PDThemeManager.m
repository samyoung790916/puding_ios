//
//  PDThemeManager.m
//  Pudding
//
//  Created by baxiang on 16/6/8.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDThemeManager.h"
#import "PDNightModle.h"
@implementation PDThemeManager

+(BOOL) isNightModle{

    PDNightModle *nightModle  = RBDataHandle.currentDevice.nightmode;
    if (!nightModle ||[nightModle.state boolValue] == NO) {
        return NO;
    }
    NSString * st = [[nightModle.timerang objectAtIndexOrNil:0] objectForKey:@"start"];
    NSString * en = [[nightModle.timerang objectAtIndexOrNil:0] objectForKey:@"end"];
    if ([st isEqualToString:en]) {
        return YES;
    }
    NSArray *sArray =[st componentsSeparatedByString:@":"];
    NSArray *eArray =[en componentsSeparatedByString:@":"];
    NSString *sHour =[sArray objectAtIndexOrNil:0];
    NSString *eHour =[eArray objectAtIndexOrNil:0];
    NSString *sMin =[sArray objectAtIndexOrNil:1];
    NSString *eMin = [eArray objectAtIndexOrNil:1];
    return  [self isBetweenFromHour:[sHour integerValue] FromMinute:[sMin integerValue] toHour:[eHour integerValue] toMinute:[eMin integerValue]];
}

+ (BOOL)isBetweenFromHour:(NSInteger)fromHour FromMinute:(NSInteger)fromMin toHour:(NSInteger)toHour toMinute:(NSInteger)toMin
{
    BOOL isSwap = NO;
    if (fromHour > toHour) {
        NSInteger h;
        NSInteger m;
        h = fromHour;
        fromHour = toHour;
        toHour = h;
        m = fromMin;
        fromMin = toMin;
        toMin = m;
        isSwap = YES;
    }
    if (fromHour == toHour) {
        if (fromMin > toMin) {
            NSInteger m;
            m = fromMin;
            fromMin = toMin;
            toMin = m;
            isSwap = YES;
        }
    }
    NSDate *dateFrom = [self getCustomDateWithHour:fromHour andMinute:fromMin];
    NSDate *dateTo = [self getCustomDateWithHour:toHour andMinute:toMin];
    NSDate *currentDate = [NSDate date];
    if ([currentDate compare:dateFrom]==NSOrderedDescending && [currentDate compare:dateTo]==NSOrderedAscending)
    {
        if (isSwap==YES) {
            return NO;
        }
        return YES;
    }
    if ([currentDate compare:dateFrom]!=NSOrderedDescending || [currentDate compare:dateTo]!=NSOrderedAscending) {
        if (isSwap == YES) {
            return YES;
        }
    }
    return NO;
}
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour andMinute:(NSInteger)minute{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minute];
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}
@end
