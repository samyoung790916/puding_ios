//
//  CircleView.m
//  CircleAnimation
//
//  Created by fujin on 15/10/19.
//  Copyright © 2015年 fujin. All rights reserved.
//

#import "CircleView.h"

#define pi 3.14159265359
#define DEGREES_DefaultStart(degrees)  ((pi * (degrees+270))/ 180) //默认270度为开始的位置
#define DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)         //转化为度

@interface CircleView ()
@property (nonatomic, assign) CGFloat startPercent;
@property (nonatomic, assign) CGFloat endPercent;
@property (nonatomic, strong) CAShapeLayer *animtionLayer;
@property (nonatomic, assign) CGFloat animationTime;
@end

@implementation CircleView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawCircle];
        //默认从零开始
        self.endPercent = 0.0f;
    }
    return self;
}

//初始化
-(void)drawCircle{

    //边缘环
    for (NSInteger i = 0; i < 10; i++) {
        CGFloat startAngle =  DEGREES_DefaultStart(i * 36) ;
        CGFloat endAngle = DEGREES_DefaultStart((i+1) * 36) - DEGREES_TO_RADIANS(1);

        UIBezierPath *ringPath = [UIBezierPath bezierPath];
        [ringPath addArcWithCenter:CGPointMake(self.frame.size.width*0.5, self.frame.size.height * 0.5) radius:self.frame.size.width * 0.5 - (15*0.5 + 2*0.5) startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        CAShapeLayer *ringLayer = [CAShapeLayer layer];
        ringLayer.path = ringPath.CGPath;
        ringLayer.fillColor = self.backgroundColor.CGColor;
        ringLayer.strokeColor = RGBA(189, 189, 189, 1).CGColor;
        ringLayer.lineWidth = 4.8;
        ringLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.layer addSublayer:ringLayer];
    }
    
}

//加入圆弧layer
-(void)makeCircle:(float)percent withAnimationTime:(CGFloat)animationTime{
    self.startPercent = self.endPercent;
    self.endPercent = percent;
    self.animationTime = animationTime;
    [self addCircle];
}
-(void)addCircle{
    
    //animtionLayer默认为整个圆圈路径（为了产生动画）
    UIBezierPath *animationPath = [UIBezierPath bezierPath];
    [animationPath addArcWithCenter:CGPointMake(self.frame.size.width*0.5, self.frame.size.height * 0.5) radius:self.frame.size.width * 0.5 - 9 startAngle:DEGREES_DefaultStart(0) endAngle:DEGREES_DefaultStart(360) clockwise:YES];

    if(!self.animtionLayer){
        self.animtionLayer = [CAShapeLayer layer];
        self.animtionLayer.fillColor = self.backgroundColor.CGColor;
        self.animtionLayer.strokeColor = RGBA(116, 201, 0, 1).CGColor;
        self.animtionLayer.lineWidth = 5;
        self.animtionLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.layer addSublayer:self.animtionLayer];
    }
    
    self.animtionLayer.path = animationPath.CGPath;
    [self addMakeAnimation:self.animtionLayer];
    
}
//过程动画
-(void)addMakeAnimation:(CAShapeLayer *)shapeLayer{
    [shapeLayer removeAllAnimations];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.animationTime;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:self.startPercent];
    pathAnimation.toValue = [NSNumber numberWithFloat:self.endPercent];
    pathAnimation.autoreverses = NO;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;

    pathAnimation.delegate = self;
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    
    
}

//清除layers
-(void)clearCircles{
    if (!self.animtionLayer) {
        return;
    }
    self.endPercent = 0.0f;
    //清除animtionLayer
    [self.animtionLayer removeFromSuperlayer];
    self.animtionLayer = nil;
}
@end
