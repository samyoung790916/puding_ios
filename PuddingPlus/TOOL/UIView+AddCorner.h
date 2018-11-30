//
//  UIView+AddCorner.h
//  ClassView
//
//  Created by kieran on 2018/3/29.
//  Copyright © 2018年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSUInteger, RBRadiusPostion) {
    RBRadiusPostionLeftTop              = 1 << 0,
    RBRadiusPostionRightTop             = 1 << 1,
    RBRadiusPostionLeftBottom           = 1 << 2,
    RBRadiusPostionRightBottom          = 1 << 3,
    RBRadiusPostionAllTop               = (RBRadiusPostionLeftTop | RBRadiusPostionRightTop),
    RBRadiusPostionBottom               = (RBRadiusPostionLeftBottom | RBRadiusPostionRightBottom),
    RBRadiusPostionAll                  = (RBRadiusPostionAllTop | RBRadiusPostionBottom),
};


@interface UIView (AddCorner)
- (void)AddCornerRadius:(RBRadiusPostion)postion CornerRadius:(float)cornerRadius;
@end
