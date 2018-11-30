//
//  RBAPublic.m
//  RBCAlterView
//
//  Created by kieran on 2017/1/14.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBAPublic.h"

@implementation RBAPublic
+ (UIImage*) rbcreateImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - view 旋转

CGAffineTransform rbtransform(NSInteger orientation){

    CGAffineTransform transform = CGAffineTransformIdentity;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        transform =  CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        transform = CGAffineTransformMakeRotation(M_PI/2);
    }else{
        transform = CGAffineTransformIdentity;
    }
    return transform;
}



@end
