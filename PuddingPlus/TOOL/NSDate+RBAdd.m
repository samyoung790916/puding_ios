//
//  NSDate+RBAdd.m
//  PuddingPlus
//
//  Created by kieran on 2017/3/9.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "NSDate+RBAdd.h"

@implementation NSDate (RBAdd)
+ (NSString *) ageBeforDate:(NSString *)dataString{
    NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    
    NSDate *nowDate = [NSDate date];
    
    NSString *birth = dataString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    
    //用来得到详细的时差
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0];
    
    if([date year] >0)
    {
        return [NSString stringWithFormat:(NSLocalizedString( @"__age", nil)),(long)[date year]];
    }
    else if([date month] >0)
    {
        return [NSString stringWithFormat:(NSLocalizedString( @"__month", nil)),(long)[date month]];
    }
    else if([date day]>0){
        return [NSString stringWithFormat:(NSLocalizedString( @"__day", nil)),(long)[date day]];
    }else {
        return @"";
    }
}
@end
