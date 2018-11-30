//
//  MitPickerView.m
//  pickerView
//
//  Created by william on 16/3/31.
//  Copyright © 2016年 Roobo. All rights reserved.
//

#import "MitPickerView.h"
#import "MitPickerView+NSDate.h"


@interface MitPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
/** 滑块 */
@property (nonatomic, strong) UIPickerView *pickerView;

/** 标题视图 */
@property (nonatomic, weak) UIView * titleView;
/** 取消按钮 */
@property (nonatomic, weak) UIButton *cancelBtn;
/** 确定按钮 */
@property (nonatomic, weak) UIButton *makeSureBtn;

/** 年数组 */
@property (nonatomic, strong) NSMutableArray *yearArray;
/** 月数组 */
@property (nonatomic, strong) NSMutableArray *monthArray;
/** 日数组 */
@property (nonatomic, strong) NSMutableArray *dayArray;

/** 年的文本 */
@property (nonatomic, weak) UILabel * yearLab;
/** 月的文本 */
@property (nonatomic, weak) UILabel * monthLab;
/** 日的文本 */
@property (nonatomic, weak) UILabel * dayLab;

/** 选择的年 */
@property (nonatomic, assign) NSInteger selectedYear;
/** 选择的月 */
@property (nonatomic, assign) NSInteger selectedMonth;
/** 选择的日 */
@property (nonatomic, assign) NSInteger selectedDay;
/** 缓存 */
@property (nonatomic, strong) NSCache *cache;


@end

@implementation MitPickerView



#pragma mark ------------------- 初始化 ------------------------
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置 pickerView
        self.pickerView.hidden = NO;
        //设置 标题背景视图
        self.titleView.hidden =NO;
        //取消按钮
        self.cancelBtn.hidden = NO;
        //确认按钮
        self.makeSureBtn.hidden = NO;
        
        //创建年月日的文本
        self.yearLab.hidden = NO;
        self.monthLab.hidden = NO;
        self.dayLab.hidden = NO;
        
    }
    return self;
}


#pragma mark - 创建 -> 创建标题视图
-(UIView *)titleView{
    if (!_titleView) {
        UIView *vi  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetHeight(self.pickerView.frame))];
        vi.backgroundColor = mRGBToColor(0xf7f9fa);
        [self addSubview:vi];
        _titleView = vi;
    }
    return _titleView;
}
#pragma mark - 创建 -> 取消按钮
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 60, CGRectGetHeight(self.titleView.frame));
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitle:NSLocalizedString( @"g_cancel", nil) forState: UIControlStateNormal];
        [btn setTitleColor:mRGBToColor(0x505a66) forState:UIControlStateNormal];
        [self.titleView addSubview:btn];
        [btn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn = btn;
    }
    return _cancelBtn;
}
#pragma mark - action: 取消回调
-(void)cancelClick{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}

#pragma mark - 创建 -> 确认按钮
-(UIButton *)makeSureBtn{
    if (!_makeSureBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(CGRectGetWidth(self.frame) - 60, 0, 60, CGRectGetHeight(self.titleView.frame));
        [btn setTitle:NSLocalizedString( @"g_confirm", nil) forState: UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitleColor:mRGBToColor(0x00aceb) forState:UIControlStateNormal];
        [self.titleView addSubview:btn];
        [btn addTarget:self action:@selector(makeSureClick) forControlEvents:UIControlEventTouchUpInside];
        _makeSureBtn = btn;
    }
    return _makeSureBtn;
}
#pragma mark - action: 确认回调
-(void)makeSureClick{
    if (self.makeSureBlock) {
        NSString * monthMsg = @"";
        //处理月
        if (self.selectedMonth<10) {
            monthMsg = [NSString stringWithFormat:@"0%ld",(long)self.selectedMonth];
        }else{
            monthMsg = [NSString stringWithFormat:@"%ld",(long)self.selectedMonth];
        }
        NSString * dayMsg = @"";
        //处理日
        if (self.selectedDay<10) {
            dayMsg = [NSString stringWithFormat:@"0%ld",(long)self.selectedDay];
        }else{
            dayMsg = [NSString stringWithFormat:@"%ld",(long)self.selectedDay];
        }
        NSString *dateMsg = [NSString stringWithFormat:@"%ld-%@-%@",(long)self.selectedYear,monthMsg,dayMsg];
        self.makeSureBlock(dateMsg);
    }
}




#pragma mark - 创建 ->  创建滑动视图
-(UIPickerView *)pickerView{
    if (!_pickerView) {
        UIPickerView * vi  =[[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, SC_WIDTH, 200)];
        vi.delegate = self;
        vi.dataSource =self;
        [self addSubview:vi];
        vi.center = CGPointMake(CGRectGetWidth(self.frame)*0.5, CGRectGetHeight(self.frame) -0.5* CGRectGetHeight(vi.frame));
        _pickerView = vi;
    }
    return _pickerView;
}



#pragma mark - 创建 -> 年的文本
-(UILabel *)yearLab{
    if (!_yearLab) {
        UILabel *year = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        year.center = CGPointMake(SC_WIDTH/3 - 20, CGRectGetHeight(self.pickerView.frame)*0.5);
        year.text = NSLocalizedString( @"year", nil);
        year.font = [UIFont systemFontOfSize:15];
        year.textColor = mRGBToColor(0x00aceb);
        [self.pickerView addSubview:year];
        _yearLab = year;
    }
    return _yearLab;
}


#pragma mark - 创建 -> 月的文本
-(UILabel *)monthLab{
    if (!_monthLab) {
        UILabel * month = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        month.center = CGPointMake(SC_WIDTH/3*2 - 20, CGRectGetHeight(self.pickerView.frame)*0.5);
        month.text = NSLocalizedString( @"month", nil);
        month.font = [UIFont systemFontOfSize:15];
        month.textColor = mRGBToColor(0x00aceb);
        [self.pickerView addSubview:month];
        _monthLab = month;
    }
    return _monthLab;
}

#pragma mark - 创建 -> 日的文本
-(UILabel *)dayLab{
    if (!_dayLab) {
        UILabel * day = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        day.center = CGPointMake(SC_WIDTH - 20, CGRectGetHeight(self.pickerView.frame)*0.5);
        day.text = NSLocalizedString( @"day_", nil);
        day.font = [UIFont systemFontOfSize:15];
        day.textColor = mRGBToColor(0x00aceb);
        [self.pickerView addSubview:day];
        _dayLab = day;
    }
    return _dayLab;
}



#pragma mark - 创建 -> 年的数据
-(NSMutableArray *)yearArray{
    //设置年的数据
    if (!_yearArray) {
        _yearArray = [NSMutableArray arrayWithCapacity:0];
        NSUInteger currentYearNumer = [self getYear];
        for (NSInteger i = 0; i<=currentYearNumer - 2000; i++) {
            NSInteger num = 2000+i;
            [_yearArray addObject:@(num)];
        }
    }
    return _yearArray;
}

#pragma mark - action: 月的数据
-(NSMutableArray *)monthArray{
    if (!_monthArray) {
        _monthArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",nil];
    }
    return _monthArray;
}
#pragma mark - action: 日的数据
-(NSMutableArray *)dayArray{
    if (!_dayArray) {
        _dayArray  = [NSMutableArray arrayWithCapacity:0];
        self.selectedYear = 2000 ;
        self.selectedMonth = 1;
        self.selectedDay = 1;
        [self getDaysDataWithYears:self.selectedYear month:self.selectedMonth];
    }
    return _dayArray;
}


#pragma mark - 创建 -> 缓存
-(NSCache *)cache{
    if (!_cache) {
        NSCache *ca = [[NSCache alloc]init];
        _cache = ca;
    }
    return _cache;
}

#pragma mark ------------------- PickerDelegate ------------------------
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0){
        return self.yearArray.count;
    }else if (component == 1){
        if ([self isCurrentYear:self.selectedYear]) {
            return [self getMonthsOfCurrentDay];
        }else{
            return self.monthArray.count;
        }
    }else{
        return self.dayArray.count;
    }
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.yearArray objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    if (!view) {
        view =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    }
    UILabel * lable = (UILabel *)view;
    lable.backgroundColor = [UIColor clearColor];
    lable.font = [UIFont systemFontOfSize:17];
    lable.textColor = self.normalColor;
    lable.textAlignment = NSTextAlignmentRight;
    if (component == 0 ) {
        lable.text = [NSString stringWithFormat:@"%@",self.yearArray[row]];
        UILabel * lab1 = (UILabel *)[pickerView viewForRow:row forComponent:component];
        lab1.textColor = self.selectedColor;
    }else if (component == 1){
        lable.text = self.monthArray[row];
        UILabel * lab1 = (UILabel *)[pickerView viewForRow:row forComponent:component];
        lab1.textColor = self.selectedColor;
    }else{
        if (row>self.dayArray.count - 1) {
            [self.pickerView reloadComponent:2];
            UILabel * lab1 = (UILabel *)[pickerView viewForRow:row forComponent:component];
            lab1.textColor = self.selectedColor;
        }else{
            lable.text = [NSString stringWithFormat:@"%@",self.dayArray[row]];
        }
        UILabel * lab1 = (UILabel *)[pickerView viewForRow:row forComponent:component];
        lab1.textColor = self.selectedColor;
    }
    return lable;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UILabel * lab = (UILabel *)[pickerView viewForRow:row forComponent:component];
    lab.textColor = self.selectedColor;
    NSInteger year = self.selectedYear;
    NSInteger month = self.selectedMonth;
    NSInteger day = self.selectedDay;
    
    if (component == 0) {
        year = [self.yearArray[row] integerValue];
        self.selectedYear = year;
        
    }else if (component ==1){
        month = [self.monthArray[row] integerValue];
        self.selectedMonth = month;
    }else{
        day = [self.dayArray[row] integerValue];
        self.selectedDay = day;
    }
    [self getDaysDataWithYears:self.selectedYear month:self.selectedMonth];
    if (self.selectedDay>self.dayArray.count - 1) {
        self.selectedDay = [[self.dayArray lastObject] integerValue];
    }
    if (self.dateMsg) {
        NSString * monthMsg = @"";
        //处理月
        if (self.selectedMonth<10) {
            monthMsg = [NSString stringWithFormat:@"0%ld",(long)self.selectedMonth];
        }else{
            monthMsg = [NSString stringWithFormat:@"%ld",(long)self.selectedMonth];
        }
        NSString * dayMsg = @"";
        //处理日
        if (self.selectedDay<10) {
            dayMsg = [NSString stringWithFormat:@"0%ld",(long)self.selectedDay];
        }else{
            dayMsg = [NSString stringWithFormat:@"%ld",(long)self.selectedDay];
        }
        NSString *dateMsg = [NSString stringWithFormat:@"%ld-%@-%@",(long)self.selectedYear,monthMsg,dayMsg];
        self.dateMsg(dateMsg);
    }
    
}


-(void)setSelectedDateString:(NSString *)selectedDateString{
    _selectedDateString = selectedDateString;
    NSArray * arr = [selectedDateString componentsSeparatedByString:@"-"];
    NSInteger year = 0;
    NSInteger month = 0;
    NSInteger day = 0;
    for (NSInteger i = 0; i<arr.count; i++) {
        if (i == 0) {
            for (NSInteger j = 0; j<self.yearArray.count; j++) {
                if ([self.yearArray[j] integerValue] == [[arr objectAtIndex:i] integerValue]) {
                    year = j;
                }
            }
        }else if (i == 1){
            for (NSInteger j = 0; j<self.monthArray.count; j++) {
                if ([self.monthArray[j] integerValue] == [[arr objectAtIndex:i] integerValue]) {
                    month = j;
                }
            }
        }else{
            for (NSInteger j = 0; j<self.dayArray.count; j++) {
                if ([self.dayArray[j] integerValue] == [[arr objectAtIndex:i] integerValue]) {
                    day = j;
                }
            }
        }
    }
    self.selectedYear = [[self.yearArray objectAtIndex:year] integerValue];
    self.selectedMonth = [[self.monthArray objectAtIndex:month] integerValue];
    self.selectedDay = [[self.dayArray objectAtIndex:day] integerValue];
    
    
//    if ([self isCurrentYear:self.selectedYear]) {
//        NSInteger num = [self getMonthsOfCurrentYear];
//        [self.monthArray removeAllObjects];
//        for (NSInteger i = 0; i<num; i++) {
//            [self.monthArray addObject:[NSNumber numberWithInteger:i]];
//        }
//    }else{
//        self.monthArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",nil];
//    }
    
    
    
    [self getDaysDataWithYears:self.selectedYear month:self.selectedMonth];

    [self.pickerView selectRow:year inComponent:0 animated:YES];
    [self.pickerView selectRow:month inComponent:1 animated:YES];
    [self.pickerView selectRow:day inComponent:2 animated:YES];

    
    
}


#pragma mark ------------------- 日期的操作 ------------------------
#pragma mark - action: 获取天的数据
- (void)getDaysDataWithYears:(NSInteger)year month:(NSInteger)month{
    [self.dayArray removeAllObjects];
    NSString *key = [NSString stringWithFormat:@"%ld%ld",(long)year,(long)month];
    //如果是今年
    if (year == [self getYear]) {
        //判断月份，如果月份大于当前日期的月，那么重新设置月份
        if (month>[self getMonthsOfCurrentDay]) {
            self.selectedMonth = [self getMonthsOfCurrentDay];
            month = [self getMonthsOfCurrentDay];
        }
    }
    
    if ([self.cache objectForKey:key]) {
        self.dayArray = [[self.cache objectForKey:key] mutableCopy];
        [NSObject cancelPreviousPerformRequestsWithTarget:self.pickerView selector:@selector(reloadComponent:) object:@2];
        [self.pickerView performSelector:@selector(reloadAllComponents) withObject:nil afterDelay:.2 inModes:@[NSDefaultRunLoopMode]];
        return;
    }
    NSInteger dayLength = [self getYears:year month:month];
    for (NSInteger i = 1; i<=dayLength; i++) {
        [self.dayArray addObject:@(i)];
        if (i == dayLength) {
            [self.cache setObject:[self.dayArray copy] forKey:key];
            [NSObject cancelPreviousPerformRequestsWithTarget:self.pickerView selector:@selector(reloadComponent:) object:@2];
            [self.pickerView performSelector:@selector(reloadAllComponents) withObject:nil afterDelay:.2 inModes:@[NSDefaultRunLoopMode]];
        }
    }
}






@end
