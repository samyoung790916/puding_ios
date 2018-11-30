//
//  PDLoadingProgressView.m
//  Pudding
//
//  Created by Zhi Kuiyu on 16/8/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//


#import "PDLoadingProgressView.h"



@interface PDLoadingProgressView ()
@property(nonatomic) CGFloat progress;
@end

@implementation PDLoadingProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupParams];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupParams];
    }
    return self;
}

- (void)setupParams {
    self.backgroundColor = [UIColor clearColor];
    self.frameWidth = 1/[UIScreen mainScreen].scale;
    self.progressColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.progressBackgroundColor = [UIColor clearColor];
    self.circleBackgroundColor = [UIColor clearColor];
}

- (void)updateProgress:(CGFloat)progress {
    
    self.progress = progress;
    [self setNeedsDisplay];
    
}

- (void)stop {
    self.progress = 0;
    [self setNeedsDisplay];
}

#pragma mark draw progress
- (void)drawRect:(CGRect)rect {
    
    [self drawFillPie:rect margin:0 color:self.circleBackgroundColor percentage:1];
    [self drawFramePie:rect];
    [self drawFillPie:rect margin:self.frameWidth color:self.progressBackgroundColor percentage:1];
    [self drawFillPie:rect margin:self.frameWidth color:self.progressColor percentage:self.progress];
}

- (void)drawFillPie:(CGRect)rect margin:(CGFloat)margin color:(UIColor *)color percentage:(CGFloat)percentage {
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) * 0.5 - margin;
    CGFloat centerX = CGRectGetWidth(rect) * 0.5;
    CGFloat centerY = CGRectGetHeight(rect) * 0.5;

    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(cgContext, [color CGColor]);
    CGContextMoveToPoint(cgContext, centerX, centerY);
    CGContextAddArc(cgContext, centerX, centerY, radius, (CGFloat) -M_PI_2, (CGFloat) (-M_PI_2 + M_PI * 2 * percentage), 0);
    CGContextClosePath(cgContext);
    CGContextFillPath(cgContext);
}

- (void)drawFramePie:(CGRect)rect {
    CGFloat radius = MIN(CGRectGetHeight(rect), CGRectGetWidth(rect)) * 0.5;
    CGFloat centerX = CGRectGetWidth(rect) * 0.5;
    CGFloat centerY = CGRectGetHeight(rect) * 0.5;

    [[UIColor whiteColor] set];
    CGFloat fw = self.frameWidth + 0.5;
    CGRect frameRect = CGRectMake(
            centerX - radius + fw,
            centerY - radius + fw,
            (radius - fw) * 2,
            (radius - fw) * 2);
    UIBezierPath *insideFrame = [UIBezierPath bezierPathWithOvalInRect:frameRect];
    insideFrame.lineWidth = 1;
    [insideFrame stroke];
}

@end
