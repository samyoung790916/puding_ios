//
//  RBConfigNetLoadView.m
//  JuanRoobo
//
//  Created by Zhi Kuiyu on 15/12/16.
//  Copyright © 2015年 Zhi Kuiyu. All rights reserved.
//

#import "PDConfigNetLoadView.h"


@interface PDConfigNetLoadView()
/** 线 */
@property (nonatomic, weak)     CAShapeLayer * shapeLayer;

@end

@implementation PDConfigNetLoadView

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.shapeLayer.strokeEnd = 0/100.0;

    }
    return self;
}


#pragma mark - 创建 -> 创建动画图
- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        CAShapeLayer*  layer = [[CAShapeLayer alloc] init];
        [layer setFrame:self.bounds];
        layer.lineWidth = 3.5;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = mRGBToColor(0x32a1ff).CGColor;
        layer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)) radius:self.width/2 - 4 startAngle:-M_PI/2 endAngle:M_PI/2 * 3 clockwise:YES] CGPath];
        [self.layer addSublayer:layer];
        _shapeLayer = layer;
    }
    return _shapeLayer;
}

#pragma mark - action: 重置
- (void)reset{
    self.shapeLayer.strokeEnd = 0/100.0;
}



- (void)startPlayWithTime:(CGFloat)time{
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:time];
    self.shapeLayer.strokeEnd = 1;
    [CATransaction commit];
}

- (void)setDruction:(float)druction{
    _druction = druction;
}
@end
