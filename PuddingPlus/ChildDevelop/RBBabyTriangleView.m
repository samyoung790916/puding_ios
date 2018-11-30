//
//  MJLayer.m
//  FWRootChartUI
//
//  Created by 张志微 on 16/11/2.
//  Copyright © 2016年 张志微. All rights reserved.
//

#import "RBBabyTriangleView.h"

@implementation RBBabyTriangleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadFromProperty];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadFromProperty];
    }
    return self;
}

- (void)loadFromProperty
{
    //连线
    self.fillColor = [UIColor whiteColor];//[UIColor colorWithRed:0.000 green:0.000 blue:1.000 alpha:0.300];
    self.sideLength = 25;
}



#pragma mark 绘制一个实心三角形
- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
    CGContextMoveToPoint(ctx, _sideLength/2, 0);
    CGContextAddLineToPoint(ctx, 0, 7);
    CGContextAddLineToPoint(ctx, _sideLength, 7);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    
}

- (void)setFillColor:(UIColor *)fillColor
{
    if (_fillColor != fillColor) {
        _fillColor = fillColor;
        [self setNeedsDisplay];
    }
}
-(void)setSideLength:(CGFloat)sideLength{
    _sideLength = sideLength;
      [self setNeedsDisplay];
}

@end
