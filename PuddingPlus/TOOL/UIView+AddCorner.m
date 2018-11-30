//
//  UIView+AddCorner.m
//  ClassView
//
//  Created by kieran on 2018/3/29.
//  Copyright © 2018年 kieran. All rights reserved.
//

#import "UIView+AddCorner.h"

@implementation UIView (AddCorner)

- (void)AddCornerRadius:(RBRadiusPostion)postion CornerRadius:(float)cornerRadius {

    if (cornerRadius <= 0)
        return;

    CGMutablePathRef path = CGPathCreateMutable();
    if (postion & RBRadiusPostionLeftTop){
        CGPathMoveToPoint(path, NULL, 0, cornerRadius);
        CGPathAddArcToPoint(path, NULL, 0, 0, cornerRadius, 0, cornerRadius);
    }else{
        CGPathMoveToPoint(path, NULL, 0, 0);
    }

    if (postion & RBRadiusPostionRightTop){
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(self.bounds) - cornerRadius, 0);
        CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(self.bounds), 0, CGRectGetMaxX(self.bounds), cornerRadius, cornerRadius);
    }else{
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(self.bounds), 0);
    }

    if (postion & RBRadiusPostionRightBottom){
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(self.bounds) , CGRectGetMaxY(self.bounds) - cornerRadius);
        CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds), CGRectGetMaxX(self.bounds)  - cornerRadius, CGRectGetMaxY(self.bounds), cornerRadius);
    }else{
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
    }

    if (postion & RBRadiusPostionLeftBottom){
        CGPathAddLineToPoint(path, NULL, cornerRadius, CGRectGetMaxY(self.bounds) );
        CGPathAddArcToPoint(path, NULL, 0 , CGRectGetMaxY(self.bounds), 0, CGRectGetMaxY(self.bounds) - cornerRadius, cornerRadius);
    }else{
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetMaxY(self.bounds));
    }

    if (postion & RBRadiusPostionLeftTop) {
        CGPathAddLineToPoint(path, NULL, 0 , cornerRadius);
    }else{
        CGPathAddLineToPoint(path, NULL, 0, 0);
    }

    CAShapeLayer *layer = [[CAShapeLayer alloc] init];

    layer.frame = self.bounds;

    [layer setPath:path];
    [self.layer setMask:layer];
}

@end
