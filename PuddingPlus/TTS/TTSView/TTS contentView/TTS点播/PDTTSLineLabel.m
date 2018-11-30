//
//  PDTTSLineLabel.m
//  Pudding
//
//  Created by zyqiong on 16/5/20.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDTTSLineLabel.h"

@implementation PDTTSLineLabel
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, self.textColor.CGColor);
    CGContextSetLineWidth(ctx, 2.0f);
    
    CGPoint leftPoint = CGPointMake(self.frame.size.width / 2 - 6, self.frame.size.height);
    CGPoint rightPoint = CGPointMake(self.frame.size.width / 2 + 6,
                             self.frame.size.height);
    CGContextMoveToPoint(ctx, leftPoint.x, leftPoint.y);
    CGContextAddLineToPoint(ctx, rightPoint.x, rightPoint.y);
    CGContextStrokePath(ctx);
}

@end
