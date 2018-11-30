//
//  ZYSelectDateView.m
//  Pods-RBAlterView_Example
//
//  Created by kieran on 2018/3/30.
//

#import "ZYSelectDateView.h"
#import "ZYSelectTimerView.h"
#import "RBAPublic.h"
#import "UIView+RBAdd.h"
#import "NSBundle+RBAlter.h"

@interface ZYSelectDateView (){
    ZYPickerView * _pickerViewYear;
    ZYPickerView * _pickerViewMonth;
    ZYPickerView * _pickerViewDay;
    NSMutableArray * yearsArray;
    NSMutableArray * monthsArray;
    
    NSInteger  currentYear;
    NSInteger  currrentMonth;
    NSInteger  currrentDay;
    
    NSInteger  monthDays;
    
}

@end

@implementation ZYSelectDateView

- (id)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        _pickerViewYear = [ZYPickerView new];
        _pickerViewYear.delegate = self;
        _pickerViewYear.dataSource = self;
        _pickerViewYear.showsSelectionIndicator = YES;
        _pickerViewYear.frame =CGRectMake(0, 32, CGRectGetWidth(self.bounds) * 0.4 , CGRectGetMaxY(self.bounds));
        [self addSubview:_pickerViewYear];
        
        _pickerViewMonth = [ZYPickerView new];
        _pickerViewMonth.delegate = self;
        _pickerViewMonth.dataSource = self;
        _pickerViewMonth.showsSelectionIndicator = YES;
        _pickerViewMonth.frame =CGRectMake(CGRectGetWidth(self.bounds) * 0.4, 32, CGRectGetMaxX(self.bounds) * 0.3 , CGRectGetMaxY(self.bounds) );
        [self addSubview:_pickerViewMonth];
        
        _pickerViewDay = [ZYPickerView new];
        _pickerViewDay.delegate = self;
        _pickerViewDay.dataSource = self;
        _pickerViewDay.showsSelectionIndicator = YES;
        _pickerViewDay.frame =CGRectMake(CGRectGetWidth(self.bounds) * 0.7, 32, CGRectGetMaxX(self.bounds) /3 , CGRectGetMaxY(self.bounds) );
        [self addSubview:_pickerViewDay];
        
        UIView *topView = [UIView new];
        topView.backgroundColor = [UIColor colorWithRed:0.843 green:0.855 blue:0.863 alpha:1.000];
        topView.userInteractionEnabled = NO;
        topView.frame = CGRectMake(0, CGRectGetMidY(_pickerViewYear.frame)  - 20 , CGRectGetWidth(self.bounds), 1);
        [self addSubview:topView];
        
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = [UIColor colorWithRed:0.843 green:0.855 blue:0.863 alpha:1.000];
        bottomView.userInteractionEnabled = NO;
        bottomView.frame = CGRectMake(0, CGRectGetMidY(_pickerViewYear.frame) + 20, CGRectGetWidth(self.bounds), 1);
        [self addSubview:bottomView];
        
        UILabel *shi1 = [UILabel new];
        shi1.text = RBLocalizedString(@"年");
        shi1.backgroundColor = [UIColor clearColor];
        shi1.textColor = RBTimerColor;
        [self addSubview:shi1];
        shi1.frame = CGRectMake(CGRectGetWidth(self.bounds) * 0.25, CGRectGetMidY(_pickerViewYear.frame) - 20, CGRectGetWidth(self.bounds) * 0.15, 40);
        shi1.textAlignment = NSTextAlignmentCenter;
        shi1.lineBreakMode = NSLineBreakByTruncatingTail;
        
        UILabel *shi2 = [UILabel new];
        shi2.text = RBLocalizedString(@"月");
        shi2.textColor = RBTimerColor;
        [self addSubview:shi2];
        shi2.frame = CGRectMake(CGRectGetWidth(self.bounds) * 0.55, CGRectGetMidY(_pickerViewYear.frame) - 20, CGRectGetWidth(self.bounds) * 0.15, 40);
        shi2.textAlignment = NSTextAlignmentCenter;
        shi2.lineBreakMode = NSLineBreakByTruncatingTail;
        
        UILabel *fen1 = [UILabel new];
        fen1.textColor = RBTimerColor;
        fen1.text = RBLocalizedString(@"日");
        [self addSubview:fen1];
        fen1.frame = CGRectMake(CGRectGetWidth(self.bounds) * 0.85, CGRectGetMidY(_pickerViewYear.frame) - 20, CGRectGetWidth(self.bounds) * 0.15, 40);
        fen1.textAlignment = NSTextAlignmentCenter;
        fen1.lineBreakMode = NSLineBreakByTruncatingTail;
        
        UIView * menuView = [[UIView alloc] init];
        menuView.backgroundColor = [UIColor colorWithRed:0.937 green:0.945 blue:0.953 alpha:1.000];
        menuView.frame =  CGRectMake(0, 0, CGRectGetWidth(self.bounds), 45);
        [menuView.layer setShadowColor: [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:.1] CGColor]];
        [menuView.layer setShadowOffset: CGSizeMake(0, -4)];
        [menuView.layer setShadowOpacity: 1];
        [menuView.layer setShadowRadius: 4];
        [self addSubview:menuView];
        
        UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.frame = CGRectMake(10, (CGRectGetHeight(menuView.frame) - 30) / 2, 70, 30) ;
        [cancleBtn setBackgroundColor:[UIColor whiteColor]];
        cancleBtn.layer.cornerRadius = 15;
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancleBtn setTitleColor:[UIColor colorWithRed:0.357 green:0.392 blue:0.435 alpha:1.000] forState:0];
        [cancleBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [cancleBtn setTitle:RBLocalizedString(@"取消") forState:0];
        cancleBtn.clipsToBounds = YES;
        [menuView addSubview:cancleBtn];
        
        UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(CGRectGetWidth(menuView.frame) - 70 - 10, (CGRectGetHeight(menuView.frame) - 30) / 2, 70, 30) ;
        [doneBtn setBackgroundColor:RBContentColor];
        [doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        doneBtn.layer.cornerRadius = 15;
        [doneBtn setTitleColor:[UIColor whiteColor] forState:0];
        [doneBtn setTitle:RBLocalizedString(@"确定") forState:0];
        doneBtn.clipsToBounds = YES;
        [menuView addSubview:doneBtn];
        doneBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        cancleBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        yearsArray = [NSMutableArray new];
        monthsArray = [NSMutableArray new];
        
        [self loadYearArra];
        [self loadMonth];
        [self updateMonthDays];
    }
    return self;
}

- (void)setSelectDate:(NSDate * )date{
    NSDateFormatter * formoat = [[NSDateFormatter alloc] init];
    [formoat setDateFormat:@"YYYY:MM:dd"];
    NSString * dateString = [formoat stringFromDate:date];
    
    NSArray * dateInfo = [dateString componentsSeparatedByString:@":"];
    
    NSInteger year = [[dateInfo firstObject] integerValue];
    NSInteger month = [[dateInfo objectAtIndex:1] integerValue];
    NSInteger day = [[dateInfo objectAtIndex:2] integerValue];
    
    NSInteger selectYear = [yearsArray indexOfObject:@(year)];
    if (selectYear < 0 || selectYear > 100) {
        NSLog(@"ZYSelectDateView select date year error");
        return;
    }
    
    NSInteger selectMonth = [monthsArray indexOfObject:@(month)];
    if (selectMonth < 0 && selectMonth > 12) {
        NSLog(@"ZYSelectDateView select date month error");
        return;
    }
    
    currentYear = year;
    currrentMonth = month;
    [self updateMonthDays];
    
    if (day < 0 || day - 1 > monthDays) {
        day = 1;
        NSLog(@"ZYSelectDateView select date day error");
    }
    currrentDay = day;
    [_pickerViewYear selectRow:selectYear inComponent:0 animated:NO];
    [_pickerViewMonth selectRow:selectMonth inComponent:0 animated:NO];
    [_pickerViewDay selectRow:day - 1 inComponent:0 animated:NO];
}

- (void)loadYearArra{
    NSDate * date = [NSDate date] ;
    NSDateFormatter * formoat = [[NSDateFormatter alloc] init];
    [formoat setDateFormat:@"YYYY:MM"];
    NSString * dateString = [formoat stringFromDate:date];
    NSInteger year = [[[dateString componentsSeparatedByString:@":"] firstObject] integerValue];
    float minYear = 2000;
    currentYear = minYear;
    for (int i = minYear; i < year + 3; i ++) {
        [yearsArray addObject:@(i)];
    }
}


- (void)loadMonth{
    for (int i = 1; i < 13; i ++) {
        [monthsArray addObject:@(i)];
    }
    currrentMonth = [[monthsArray objectAtIndex:0] integerValue];
    currrentDay = 1;
}

- (void)updateMonthDays{
    NSDateFormatter * formoat = [[NSDateFormatter alloc] init];
    [formoat setDateFormat:@"YYYY:MM:dd:HH"];
    formoat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    [formoat setTimeZone:localzone];
    
    NSDate * date = [formoat dateFromString:[NSString stringWithFormat:@"%ld:%ld:1:8",(long)currentYear,(long)currrentMonth ]];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    monthDays = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    
    currrentDay = MIN(monthDays, currrentDay);
}


- (void)deallocBlockData{
    _SelectDateBlock = nil;
}
- (void)cancelAction:(id)sender{
    if(_SelectDateBlock){
        _SelectDateBlock(nil);
    }
}

- (void)doneAction:(id)sender{
    if(_SelectDateBlock){
        NSDateFormatter * formoat = [[NSDateFormatter alloc] init];
        [formoat setDateFormat:@"YYYY:MM:dd:HH"];
        formoat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        NSTimeZone* localzone = [NSTimeZone localTimeZone];
        [formoat setTimeZone:localzone];
        
        NSDate * date = [formoat dateFromString:[NSString stringWithFormat:@"%ld:%ld:%ld:8",(long)currentYear,(long)currrentMonth ,(long)currrentDay]];
        _SelectDateBlock(date);
    }
}




- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return pickerView.frame.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 40)];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor colorWithRed:0.341 green:0.376 blue:0.424 alpha:1.000] ;
    label.tag = 11;
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    NSString * text = nil;
    
    if (pickerView == _pickerViewYear) {
        text = [NSString stringWithFormat:@"%@",[yearsArray objectAtIndex:row]] ;
        label.frame = CGRectMake(20, 0, 90, 40);
    }else if (pickerView == _pickerViewMonth){
        text = [NSString stringWithFormat:@"%@",[monthsArray objectAtIndex:row]] ;
        label.frame = CGRectMake(15, 0, 40, 40);
    }else if (pickerView == _pickerViewDay){
        text = [NSString stringWithFormat:@"%ld",row + 1] ;
        label.frame = CGRectMake(15, 0, 40, 40);
    }
    
    label.text = text;
    
    [bgView addSubview:label];
    return bgView;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UIView * bgView = [pickerView viewForRow:row forComponent:component];
    UILabel * lab = (UILabel *)[bgView viewWithTag:11];
    
    lab.textColor = [UIColor colorWithRed:0.016 green:0.545 blue:1.000 alpha:1.000] ;
    lab.textColor = RBTimerColor;
    if (pickerView == _pickerViewYear || pickerView == _pickerViewMonth) {
        if (pickerView == _pickerViewYear) {
            currentYear = [[yearsArray objectAtIndex:row] integerValue];
        }else if (pickerView == _pickerViewMonth){
            currrentMonth = [[monthsArray objectAtIndex:row] integerValue];
        }
        
        [self updateMonthDays];
        [_pickerViewDay reloadAllComponents];
        
    }else if(pickerView == _pickerViewDay){
        currrentDay = row + 1;
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == _pickerViewYear) {
        return [yearsArray count];
    }else if (pickerView == _pickerViewMonth){
        return [monthsArray count];
    }else if (pickerView == _pickerViewDay){
        return monthDays;
    }
    return 0;
}

@end
