//
//  CircleAnimationView.m
//  CircleAnimation
//
//  Created by fujin on 15/10/19.
//  Copyright © 2015年 fujin. All rights reserved.
//

#import "CircleAnimationView.h"
#import "CircleView.h"
#import "CountLabel.h"
#import "PointerView.h"

#define AnimationIntertime 1.0
@interface CircleAnimationView ()
{
    NSTimer *timer;
}
@property (nonatomic, strong) CircleView *circleView;
@property (nonatomic, strong) CountLabel *countLabel;
@end
@implementation CircleAnimationView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configViews];
    }
    return self;
}
-(void)configViews{
    [self instanceCircle];
    
    [self instancePercentLabel];
    
}
//初始化圆圈
-(void)instanceCircle{
    self.circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self addSubview:self.circleView];
}
//初始化显示label
-(void)instancePercentLabel{
    self.countLabel = [[CountLabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self addSubview:self.countLabel];
}

- (void)setPercent:(float)percent{
    if(_percent != percent){
        [self.circleView makeCircle:percent withAnimationTime:AnimationIntertime];
        [self.countLabel updateLabel:percent withAnimationTime:AnimationIntertime];
    }
    _percent = percent;

}

// 恢复原位置
-(void)clear{
    [self.circleView clearCircles];
    [self.countLabel clear];
}
@end
