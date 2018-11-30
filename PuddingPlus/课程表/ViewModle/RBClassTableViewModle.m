//
//  RBClassTableViewModle.m
//  PuddingPlus
//
//  Created by kieran on 2018/4/3.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "RBClassTableViewModle.h"
#import "RBClassDayModle.h"
#import "RBClassTimeModle.h"
#import "RBClassInfoModle.h"
#import "RBClassTableView.h"

@interface RBClassTableViewModle(){
    NSDateFormatter * _dateFormatter;
    NSDictionary * classInfoDict;
    NSArray * _timesArray;
    NSArray * _daysArray;
}
@end

@implementation RBClassTableViewModle



- (id)init{
    if (self = [super init]){
        [self initFormatter];
        _times = [self getHours:7 EndHours:21];
        _days = [self getDaysInfo:DaysOffset DaysCount:7];
        NSString * jsonStr = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
        NSArray<RBClassInfoModle *>*  tableArray = [NSArray modelArrayWithClass:[RBClassInfoModle class] json:jsonStr];
        classInfoDict = [self getClassInfo:tableArray];

    }
    return self;
}

- (NSDictionary *)getClassInfo:(NSArray<RBClassInfoModle *> *)tableArray{
    NSMutableDictionary * dictionary = [NSMutableDictionary new];
    for (RBClassInfoModle * modle in tableArray){
        if (modle.play_time <= 0 || modle.play_time > 24 || [modle.play_date mStrLength] == 0)
            continue;
        NSInteger section = [_timesArray indexOfObject:@(modle.play_time)];
        NSInteger row = [_daysArray indexOfObject:[self dayString:modle.play_date]];
        dictionary[[NSIndexPath indexPathForRow:row inSection:section]] = modle;
    }
    return dictionary;
}

- (RBClassInfoModle *)getClassInfoModleForIndexPath:(NSIndexPath *)indexPath{
    if (indexPath == nil)
        return nil;
    return classInfoDict[indexPath];
}

- (NSString *)dayString:(NSString *)str{
    NSCharacterSet *setToRemove =
            [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789 "]
                    invertedSet ];
    NSString *newString =
            [[str componentsSeparatedByCharactersInSet:setToRemove]
                    componentsJoinedByString:@"-"];
    return newString;
}

- (void)initFormatter{
    NSDateFormatter * formoat = [[NSDateFormatter alloc] init];
    [formoat setDateFormat:@"YYYY-MM-dd"];
    formoat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];

    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    [formoat setTimeZone:localzone];
    _dateFormatter = formoat;
}

- (NSArray *)getHours:(NSUInteger)startHors EndHours:(NSUInteger)endHours{
    NSMutableArray * timeArray = [NSMutableArray new];
    NSMutableArray * timesArray = [NSMutableArray new];

    for (NSUInteger i = startHors; i <= endHours; ++i) {
        RBClassTimeModle * timeModle = [[RBClassTimeModle alloc] init];
        timeModle.time = i;
        [timeArray addObject:timeModle];
        [timesArray addObject:@(i)];
    }
    _timesArray = [timesArray copy];
    return timeArray;
}

- (NSArray *)getDaysInfo:(int)offset DaysCount:(int)dayCount{
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    NSDate *currentData = [NSDate date];

    NSMutableArray * daysArray = [NSMutableArray new];
    NSMutableArray * dayArray = [NSMutableArray new];

    for (int i = -offset;i < dayCount - offset; i++) {
        RBClassDayModle * model = [self getWeekInfo:[currentData initWithTimeIntervalSinceNow:oneDay * i]];
        if (model){
            model.today = i == 0;
            [daysArray addObject:model];
            [dayArray addObject:[self dayString:[NSString stringWithFormat:@"%d-%@",model.year,model.day]]];
        }
    }
    _daysArray = [dayArray copy];
    return daysArray;
}

- (RBClassDayModle *)getWeekInfo:(NSDate *)date{
    RBClassDayModle * model = [RBClassDayModle new];

    NSString * str = [_dateFormatter stringFromDate:date];
    NSArray * array = [str componentsSeparatedByString:@"-"];
    if ([array count] == 3){
        NSString * weekString = CaculateWeekDay([array[0] intValue], [array[1] intValue], [array[2] intValue]);
        NSString * dayString = [NSString stringWithFormat:@"%d.%d",[array[1] integerValue],[array[2] integerValue]];
        model.week = weekString;
        model.day = dayString;
        model.year = [array[0] integerValue];
        return model;
    }

    return nil;
}

NSString * CaculateWeekDay(int y,int m, int d)
{
    if(m==1||m==2) {
        m+=12;
        y--;
    }
    int iWeek=(d+2*m+3*(m+1)/5+y+y/4-y/100+y/400)%7;
    NSString * weekString = nil;
    switch(iWeek)
    {
        case 0: weekString = NSLocalizedString(@"Monday", @"周一"); break;
        case 1: weekString = NSLocalizedString(@"Tuesday", @"周二"); break;
        case 2: weekString = NSLocalizedString(@"Wednesday", @"周三"); break;
        case 3: weekString = NSLocalizedString(@"Thursday", @"周四"); break;
        case 4: weekString = NSLocalizedString(@"Friday", @"周五"); break;
        case 5: weekString = NSLocalizedString(@"Saturday", @"周六"); break;
        case 6: weekString = NSLocalizedString(@"Sunday", @"周日"); break;
    }
    return weekString;
}
@end
