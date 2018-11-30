//
//  RefreshLoadView.m
//  PullRefreshControl
//
//  Created by zhikuiyu on 14-12-20.
//  Copyright (c) 2014年 YDJ. All rights reserved.
//

#import "RefreshLoadView.h"

#define RefreshHeaderTimeKey @"RefreshHeaderTimeKey"

@implementation RefreshLoadView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self initViews];
    }
    
    return self;
}
#pragma mark - 状态相关
#pragma mark 设置最后的更新时间
- (void)setLastUpdateTime:(NSDate *)lastUpdateTime
{
    _lastUpdateTime = lastUpdateTime;
    
    // 1.归档
    [[NSUserDefaults standardUserDefaults] setObject:lastUpdateTime forKey:RefreshHeaderTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 2.更新时间
    [self updateTimeLabel];
}

#pragma mark 更新时间字符串
- (void)updateTimeLabel
{
    if (!self.lastUpdateTime) return;
    
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:_lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        formatter.dateFormat = NSLocalizedString( @"today__", nil);
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:self.lastUpdateTime];
    
    // 3.显示日期
    _updateLabel.text = [NSString stringWithFormat:NSLocalizedString( @"last_update_", nil), time];
}


- (void)initViews{
    _imageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.image = [UIImage imageNamed:@"img_pulllist_1"];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.translatesAutoresizingMaskIntoConstraints=NO;
    
    NSMutableArray * array = [NSMutableArray array] ;
    for(int i= 1 ; i <= 16 ; i++){
        NSString * imageName = [NSString stringWithFormat:@"img_listloading_%d",i] ;
        [array addObject:[UIImage imageNamed:imageName]];
    
    }
    _imageView.animationImages = array;
    _imageView.animationDuration = 1 ;
    
    [self addSubview:_imageView];
    
    _updateLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _updateLabel.backgroundColor = [UIColor clearColor];
    _updateLabel.translatesAutoresizingMaskIntoConstraints=NO;
    _updateLabel.text = NSLocalizedString( @"last_update_time", nil);
    _updateLabel.font=[UIFont systemFontOfSize:11];
    [self addSubview:_updateLabel];
    
    _promptLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _promptLabel.backgroundColor=[UIColor clearColor];
    _promptLabel.font=[UIFont systemFontOfSize:13];
    _promptLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_promptLabel];
    
    NSDictionary * viewsDictionary=@{@"promptLabel":self.promptLabel,@"imageView":self.imageView,@"updateLabel":self.updateLabel};
   
    ///布局icon 和 下拉刷新的水平位置
    NSArray *p1 =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-95-[imageView(35)]-15-[promptLabel]-|" options:0 metrics:nil views:viewsDictionary];
    NSArray *p2 =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-95-[imageView(35)]-15-[updateLabel]-|" options:0 metrics:nil views:viewsDictionary];
    
    NSArray *pVList=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[promptLabel(==15)]" options:0 metrics:nil views:viewsDictionary];

    NSArray *p3 =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-90-[updateLabel(==15)]" options:0 metrics:nil views:viewsDictionary];
    
    NSArray *ilist2=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[imageView(==35)]" options:0 metrics:nil views:viewsDictionary];

    
//    [self addConstraints:ilist1];
    [self addConstraints:ilist2];
    [self addConstraints:p1];
    [self addConstraints:p2];
    [self addConstraints:p3];
    [self addConstraints:pVList];
    
    [self updateTimeLabel];
}


- (void)resetViews
{
//    _imageView.hidden=NO;
//    [UIView animateWithDuration:0.25 animations:^{
//        _imageView.transform=CGAffineTransformIdentity;
//    }];
    if ([_imageView isAnimating])
    {
        [_imageView stopAnimating];
    }
    _promptLabel.text=NSLocalizedString( @"drop_down_refresh", nil);
    NSString * imageName = [NSString stringWithFormat:@"img_pulllist_16"] ;
    _imageView.image = [UIImage imageNamed:imageName];
}

- (void)canEngageRefresh
{
    _promptLabel.text=NSLocalizedString( @"loosening_and_refreshing", nil);
//    [UIView animateWithDuration:0.25 animations:^{
//        _imageView.transform=CGAffineTransformMakeRotation(M_PI);
//    }];
    NSString * imageName = [NSString stringWithFormat:@"img_pulllist_16"] ;
    _imageView.image = [UIImage imageNamed:imageName];
}

- (void)didDisengageRefresh:(NSNumber *)pro
{

    int index = (int)([pro floatValue] * 16);

    NSString * imageName = [NSString stringWithFormat:@"img_pulllist_%d",index] ;
    _imageView.image = [UIImage imageNamed:imageName];
//    [self resetViews];

}

- (void)startRefreshing
{
    if (![_imageView isAnimating])
        [_imageView startAnimating];
    _promptLabel.text=NSLocalizedString( @"is_loading_", nil);
}

- (void)finishRefreshing
{
    [self resetViews];
    self.lastUpdateTime = [NSDate date];
    
}
- (void)resetLayoutSubViews
{

}


@end
