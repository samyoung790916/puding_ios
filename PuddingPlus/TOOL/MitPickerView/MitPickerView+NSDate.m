//
//  MitPickerView+NSDate.m
//  pickerView
//
//  Created by william on 16/3/31.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "MitPickerView+NSDate.h"

@implementation MitPickerView (NSDate)
#pragma mark ------------------- 关于时间 ------------------------
#pragma mark - action: 获取年数
- (NSUInteger)getYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:[NSDate date]];
    return [dayComponents year];
}
#pragma mark - action: 获取月数
- (NSUInteger)getMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:[NSDate date]];
    return [dayComponents month];
}



#pragma mark - action: 根据年月获取天数
- (NSInteger)getYears:(NSInteger)year month:(NSInteger)month{
    NSDate * date = [self createDateWithY:year mon:month day:0 hour:0 minute:0 second:0];
    NSCalendar *c = [NSCalendar currentCalendar];
    //获取一年
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    if ([self isLastMonthWithYear:year Month:month]) {
        return [self getDaysOfCurrentDay];
    }    
    return days.length;
}

//创建时间
#pragma mark - action: 创建时间
- (NSDate*)createDateWithY:(NSInteger)year mon:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
    NSDateComponents*comp = [[NSDateComponents alloc] init];
    [comp setYear:year];
    [comp setMonth:month];
    NSDate*date = [[NSDate alloc]init];
    NSCalendar * cal = [NSCalendar currentCalendar];
    date = [cal dateFromComponents:comp];
    date = [self toStandardDateWithDate:date];
    return date;
}

#pragma mark - action: 转换成标准的时间
- (NSDate*)toStandardDateWithDate:(NSDate*)date{
    NSTimeZone *zone   = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

#pragma mark - action: 是否是今年
-(BOOL)isCurrentYear:(NSInteger)year{
    if([self getYear] ==year){
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - action: 是否是当前月
- (BOOL)isCurrentMonth:(NSInteger)month{
    if ([self getMonth] == month) {
        return YES;
    }else{
        return NO;
    }
}


#pragma mark - action: 获取今天的月份
-(NSInteger)getMonthsOfCurrentDay{
    NSDate*currentDate              = [NSDate date];
    NSCalendar *calendar            = [NSCalendar currentCalendar];
    NSUInteger unitFlags            = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |   NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
    return [dateComponent month];
}

#pragma mark - action: 获取今天的日子
-(NSInteger)getDaysOfCurrentDay{
    NSDate*currentDate              = [NSDate date];
    NSCalendar *calendar            = [NSCalendar currentCalendar];
    NSUInteger unitFlags            = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |   NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
    return [dateComponent day];
}

#pragma mark - action: 根据年月判断是否是最后一月
-(BOOL)isLastMonthWithYear:(NSInteger)year Month:(NSInteger)month{
    if ([self isCurrentYear:year]) {
        if ([self isCurrentMonth:month]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}


@end
