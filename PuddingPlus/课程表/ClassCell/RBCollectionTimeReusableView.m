//
//  RBCollectionTimeReusableView.m
//  ClassView
//
//  Created by kieran on 2018/3/20.
//  Copyright © 2018年 kieran. All rights reserved.
//

#import "RBCollectionTimeReusableView.h"
@interface RBCollectionTimeReusableView(){
    CAShapeLayer *shapeLayer;
    CAGradientLayer *gradientLayer;
}
@property(nonatomic, strong) UILabel * timeLabel;
@property(nonatomic, strong) UIView  * circleView;
@end

@implementation RBCollectionTimeReusableView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        self.timeLabel.text = @"12点";
        shapeLayer = [CAShapeLayer layer];
        self.circleView.hidden = NO;
    }
    return self;
}

- (void)setTimeString:(NSString *)timeString {
    self.timeLabel.text = timeString;
}

- (void)setTimeType:(RBTimeLocationType)timeType {
    _timeType = timeType;
    [self drawDashTopLine:[UIColor colorWithRed:195.0/255.f green:201.0/255.f blue:206.0/255.f alpha:1]];
}

#pragma mark 懒加载 circleView
- (UIView *)circleView{
    if (!_circleView){
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds) - 4, CGRectGetMidY(self.bounds) - 20, 8, 8)];
        view.backgroundColor = [UIColor clearColor];
        view.layer.borderWidth = 1.5;
        view.layer.cornerRadius = 4;
        view.layer.borderColor = [UIColor colorWithRed:195/255.f green:220.f/255.f blue:143.f/255.f alpha:1].CGColor;
        view.clipsToBounds = YES;
        [self addSubview:view];
        _circleView = view;
    }
    return _circleView;
}


#pragma mark 懒加载 timeLabel
- (UILabel *)timeLabel{
    if (!_timeLabel){
        UILabel * view = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)/2 - 20/2, CGRectGetWidth(self.bounds), 20)];
        view.backgroundColor = [UIColor whiteColor];
        view.font = [UIFont systemFontOfSize:13];
        view.textColor = UIColorHex(0x4a4a4a);
        view.textAlignment = NSTextAlignmentCenter;
        [self addSubview:view];

        _timeLabel = view;
    }
    return _timeLabel;
}



- (void)drawDashTopLine:(UIColor *)color {
    if ([shapeLayer superlayer])
        [shapeLayer removeFromSuperlayer];
    if (gradientLayer){
        [gradientLayer removeFromSuperlayer];
    }

    [self.layer addSublayer:shapeLayer];

    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:color.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:1];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInteger:3], [NSNumber numberWithInteger:3], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(self.bounds), 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - 20);

    CGPathMoveToPoint(path, NULL, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) + 14);
    CGPathAddLineToPoint(path, NULL,CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));

    [shapeLayer setPath:path];
    CGPathRelease(path);

    switch (self.timeType){
        case RBTimeLocationNormail:{
            [self.layer addSublayer:shapeLayer];
            break;
        }
        case RBTimeLocationStart:{
            gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetMaxY(self.bounds));
            gradientLayer.colors = @[(__bridge id)[color colorWithAlphaComponent:0].CGColor,(__bridge id)color.CGColor];

            gradientLayer.locations=@[@0.0,@1];
            gradientLayer.startPoint = CGPointMake(0,0);
            gradientLayer.endPoint = CGPointMake(0,0.5);
            gradientLayer.mask = shapeLayer;
            [self.layer addSublayer:gradientLayer];
            break;
        }
        case RBTimeLocationEnd:{
            gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetMaxY(self.bounds));
            gradientLayer.colors = @[(__bridge id)[color colorWithAlphaComponent:0].CGColor,(__bridge id)color.CGColor];
            gradientLayer.locations=@[@0.0,@1];
            gradientLayer.startPoint = CGPointMake(0,1);
            gradientLayer.endPoint = CGPointMake(0,0.5);
            gradientLayer.mask = shapeLayer;
            [self.layer addSublayer:gradientLayer];
            break;
        }
    }


}


@end
