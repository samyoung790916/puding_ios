//
//  MitPickerView+NSDate.h
//  pickerView
//
//  Created by william on 16/3/31.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "MitPickerView.h"

@interface MitPickerView (NSDate)

/**
 *  获取年数
 *
 *  @return 年的数量
 */
- (NSUInteger)getYear;

#pragma mark - action: 根据年月获取天数
- (NSInteger)getYears:(NSInteger)year month:(NSInteger)month;

#pragma mark - action: 创建时间
- (NSDate*)createDateWithY:(NSInteger)year mon:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

#pragma mark - action: 转换成标准的时间
- (NSDate*)toStandardDateWithDate:(NSDate*)date;

#pragma mark - action: 获取今年天的月
- (NSInteger)getMonthsOfCurrentDay;

#pragma mark - action: 获取今天的日
- (NSInteger)getDaysOfCurrentDay;

#pragma mark - action: 根据日月判断是否是当前日期的月
- (BOOL)isLastMonthWithYear:(NSInteger)year Month:(NSInteger)month;




#pragma mark - action: 是否是今年
- (BOOL)isCurrentYear:(NSInteger)year;

@end
