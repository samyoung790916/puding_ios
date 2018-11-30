//
//  RBCollectionDayResuableView.m
//  ClassView
//
//  Created by kieran on 2018/3/20.
//  Copyright © 2018年 kieran. All rights reserved.
//

#import "RBCollectionDayResuableView.h"

@interface RBCollectionDayResuableView()
@property(nonatomic, strong) UILabel * dayLable;
@property(nonatomic, strong) UILabel * weekLable;
@property(nonatomic, strong) UIView  * sepBg;
@end

@implementation RBCollectionDayResuableView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        self.dayLable.text = @"19日";
        self.weekLable.text = @"星期二";
    }
    return self;
}

- (void)setIsToday:(Boolean)isToday {
    _isToday = isToday;
    if (isToday){
        self.backgroundColor = [UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1];
    } else{
        self.backgroundColor = [UIColor whiteColor];
    }
    self.weekLable.textColor = [UIColor colorWithRed:84.f/255.f green:84.f/255.f blue:84.f/255.f alpha:1];
    self.dayLable.textColor = [UIColor colorWithRed:167.f/255.f green:167.f/255.f blue:167.f/255.f alpha:1];
    self.sepBg.hidden = YES;
}
- (void)setIsSelectedDay:(Boolean)isSelectedDay{
    _isSelectedDay = isSelectedDay;
    if (isSelectedDay){
        self.backgroundColor = [UIColor colorWithRed:157.f/255.f green:199.f/255.f blue:69.f/255.f alpha:1];
        self.dayLable.textColor = [UIColor whiteColor];
        self.weekLable.textColor = [UIColor whiteColor];
        self.sepBg.hidden = NO;
    }
}
- (void)setWeekString:(NSString *)weekString {
    self.weekLable.text = weekString;
}

- (void)setDayString:(NSString *)dayString {
    self.dayLable.text = dayString;
}

#pragma mark 懒加载 sepBg
- (UIView *)sepBg{
    if (!_sepBg){
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 4)];
        view.backgroundColor = [UIColor colorWithRed:118.f/255.f green:168.f/255.f blue:12.f/255.f alpha:1];
        [self addSubview:view];

        _sepBg = view;
    }
    return _sepBg;
}


#pragma mark 懒加载 dayLable
- (UILabel *)dayLable{
    if (!_dayLable){
        UILabel * view = [[UILabel alloc] initWithFrame:
                CGRectMake(0, CGRectGetMaxY(self.weekLable.frame) + 3, CGRectGetWidth(self.bounds), 11)];
        view.textAlignment = NSTextAlignmentCenter;
        view.backgroundColor = [UIColor clearColor];
        view.font = [UIFont systemFontOfSize:11];
        [self addSubview:view];
        _dayLable = view;
    }
    return _dayLable;
}

#pragma mark 懒加载 weekLable
- (UILabel *)weekLable{
    if (!_weekLable){
        UILabel * view = [[UILabel alloc] initWithFrame:
                CGRectMake(0, 9, CGRectGetWidth(self.bounds), 14)];
        view.textAlignment = NSTextAlignmentCenter;
        view.backgroundColor = [UIColor clearColor];
        view.font = [UIFont systemFontOfSize:13];
        [self addSubview:view];
        _weekLable = view;
    }
    return _weekLable;
}



@end
