//
//  TimedataFactory.m
//  365Locator
//
//  Created by Zhi-Kuiyu on 14-11-29.
//  Copyright (c) 2014年 Zhi-Kuiyu. All rights reserved.
//

#import "TimedataFactory.h"

@implementation TimedataFactory
+ (NSDateFormatter *)tcTimeDateFormat
{
    static NSDateFormatter *_shareFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareFormat = [[NSDateFormatter alloc] init];
        [_shareFormat setDateFormat:@"HH:mm"];
        
    });
    
    return _shareFormat;
}

+ (NSDateFormatter *)tcYearDateFormat
{
    static NSDateFormatter *_shareyearFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareyearFormat = [[NSDateFormatter alloc] init];
        [_shareyearFormat setDateFormat:@"YYYY"];
        
    });
    
    return _shareyearFormat;
}

+ (NSDateFormatter *)tcMouthDateFormat
{
    static NSDateFormatter *_shareyearFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareyearFormat = [[NSDateFormatter alloc] init];
        [_shareyearFormat setDateFormat:NSLocalizedString( @"date_format_year_month_day", nil)];
        
    });
    
    return _shareyearFormat;
}

+ (NSDateFormatter *)tcDayDateFormat
{
    static NSDateFormatter *_shareyearFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareyearFormat = [[NSDateFormatter alloc] init];
        [_shareyearFormat setDateFormat:@"YYYYMMdd"];
        
    });
    
    return _shareyearFormat;
}

+ (NSDateFormatter *)tcNormalFormat
{
    static NSDateFormatter *_shareyearFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
     
        
        _shareyearFormat = [[NSDateFormatter alloc] init];
        [_shareyearFormat setDateFormat:@"YYYY-MM-dd"];
        
        NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [_shareyearFormat setTimeZone:GTMzone];
        
    });
    
    return _shareyearFormat;
}
+ (NSDateFormatter *)tcAllInfoFormat
{
    static NSDateFormatter *_shareyearFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareyearFormat = [[NSDateFormatter alloc] init];
        [_shareyearFormat setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
        
    });
    
    return _shareyearFormat;
}

+ (NSDateFormatter *)tcSimpleInfoFormat
{
    static NSDateFormatter *_shareyearFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareyearFormat = [[NSDateFormatter alloc] init];
        [_shareyearFormat setDateFormat:@"MM.dd HH:mm"];
        
    });
    
    return _shareyearFormat;
}

NSString * getAllInfoTime(){

    NSString * str = [[TimedataFactory tcAllInfoFormat] stringFromDate:[NSDate date]];
    return str;
}

NSString * getMapContentTimeWithString(NSString * timestr){
    NSDate * date = [[TimedataFactory tcAllInfoFormat] dateFromString:timestr];
    NSString * str = [[TimedataFactory tcSimpleInfoFormat] stringFromDate:date] ;
    return str;

}

NSString * getMapContentTimeWithNSTimeInterval(NSTimeInterval timestr){
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timestr/1000];
    NSString * str = [[TimedataFactory tcSimpleInfoFormat] stringFromDate:date] ;
    return str;
    
}

NSString * getTimeWithTimeInterval(NSString * timestr){
    NSTimeInterval time = [timestr doubleValue]/1000;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    //显示北京时区的时间
//    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
    return [[TimedataFactory tcTimeDateFormat] stringFromDate:date];
}

NSString * getNormailDataString(NSDate * date){
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSString * st = [[TimedataFactory tcNormalFormat] stringFromDate:localeDate];
    return st;
}


NSString * getNormaillastDay(NSString * string){
    
    NSTimeInterval interval =  [[[TimedataFactory tcNormalFormat] dateFromString:string] timeIntervalSince1970] - 24 * 60 * 60;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [[TimedataFactory tcNormalFormat] stringFromDate:date];
}

NSString * getDayTimeWithString(NSString * timestr){
    NSTimeInterval interval =  [[[TimedataFactory tcNormalFormat] dateFromString:timestr] timeIntervalSince1970];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSString * dataStr =  [[TimedataFactory tcDayDateFormat] stringFromDate:date];
    NSString * currentStr =  [[TimedataFactory tcDayDateFormat] stringFromDate:[NSDate date]];
    long over = [currentStr integerValue] - [dataStr integerValue];
    if(over == 0){
        return NSLocalizedString( @"today", nil);
    }else if(over == 1){
        return NSLocalizedString( @"yesterday", nil);
    }else{
        return timestr;
    }
    
}

NSString * getDayTimeWithTimeInterval(NSString * timestr){
    NSTimeInterval time = [timestr doubleValue]/1000;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSString * dataStr =  [[TimedataFactory tcDayDateFormat] stringFromDate:date];
    NSString * currentStr =  [[TimedataFactory tcDayDateFormat] stringFromDate:[NSDate date]];
    long over = [currentStr integerValue] - [dataStr integerValue];

    if(over == 0){
        return NSLocalizedString( @"today", nil);
    }else if(over == 1){
        return NSLocalizedString( @"yesterday", nil);
    }else{
        return [[TimedataFactory tcMouthDateFormat] stringFromDate:date];

    }
    
}

NSString * getTcTimeWithTimeIntervalStr(NSString * intervalStr){
    NSDate * currentdate = [NSDate date];
    NSTimeInterval resultInterVal = [intervalStr floatValue];
    NSTimeInterval currenInterVal = [currentdate timeIntervalSince1970];
    NSTimeInterval dayInterval = 60 * 60 *24;
    NSDate * resultDate = [NSDate dateWithTimeIntervalSince1970:resultInterVal];
    
    if(resultInterVal >=  currenInterVal){
        return NSLocalizedString( @"just_", nil);
    }else{
        NSTimeInterval over = currenInterVal - resultInterVal;
        if(over < 60){
            return [NSString stringWithFormat:NSLocalizedString( @"before_xx_second", nil),over];
        }else if(over < 60*60){
            return [NSString stringWithFormat:NSLocalizedString( @"before_xx_minute", nil),over/60.f];
        }else if(over < dayInterval){
            return [NSString stringWithFormat:NSLocalizedString( @"before_xx_hour", nil),over/60.f/60.f];
        }else if(over < 7 * dayInterval){
            return [NSString stringWithFormat:NSLocalizedString( @"before_xx_day", nil),over/dayInterval];
        }else if(over < 4 * 7 * dayInterval){
            return [[TimedataFactory tcTimeDateFormat] stringFromDate:resultDate];
        }else if(over < 30 * 12 * dayInterval){
            return [NSString stringWithFormat:NSLocalizedString( @"before_xx_month", nil),over/(30  * dayInterval)];
        }else{
            return [NSString stringWithFormat:NSLocalizedString( @"before_xx_year", nil),over/(30 * 12 * dayInterval)];
        }
        
        //        NSMutableString * resString = [[NSMutableString alloc] init];
        //        NSString * cyears = [[TcPublicUnityFacility tcYearDateFormat] stringFromDate:currentdate];
        //        NSString * oyears = [[TcPublicUnityFacility tcYearDateFormat] stringFromDate:resultDate];
        //        if(![cyears isEqualToString:oyears]){
        //            [resString appendFormat:@"%@年 ",cyears];
        //        }
        //        [resString appendFormat:@"%@",[[TcPublicUnityFacility tcTimeDateFormat] stringFromDate:resultDate] ];
        //        
        //        return resString;
        
    }
    
    return @"";
}
@end
