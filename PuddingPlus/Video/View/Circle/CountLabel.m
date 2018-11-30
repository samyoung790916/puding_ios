//
//  CountLabel.m
//  CircleAnimation
//
//  Created by fujin on 15/10/20.
//  Copyright © 2015年 fujin. All rights reserved.
//

#import "CountLabel.h"

@interface CountLabel ()
{
    NSTimer *timer;
}
@end
@implementation CountLabel
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.text = @"0";
        self.font = [UIFont systemFontOfSize:15];
        self.textColor = RGBA(116, 201, 0, 1);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)updateLabel:(float)percent withAnimationTime:(CGFloat)animationTime{
    CGFloat startPercent = [self.text integerValue];
    CGFloat endPercent = percent * 100;
    
    CGFloat intever = animationTime/fabs(endPercent - startPercent);
    
    timer = [NSTimer scheduledTimerWithTimeInterval:intever target:self selector:@selector(IncrementAction:) userInfo:[NSNumber numberWithInteger:endPercent] repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
}

-(void)IncrementAction:(NSTimer *)time{
    NSInteger change = [self.text integerValue];
    
    if(change < [time.userInfo integerValue]){
        change ++;
    }
    else{
        change --;
    }
    
    self.text = [NSString stringWithFormat:@"%ld",(long)change];
    if ([self.text integerValue] == [time.userInfo integerValue]) {
        [time invalidate];
    }
}
-(void)clear{
    self.text = @"0";
}
@end
