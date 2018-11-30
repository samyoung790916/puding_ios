//
//  UIView+RBAdd.h
//  RBCAlterView
//
//  Created by kieran on 2017/1/14.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RBAdd)

@property(nonatomic) CGFloat            left;
@property(nonatomic) CGFloat            top;
@property(nonatomic, readonly) CGFloat  right;
@property(nonatomic, readonly) CGFloat  bottom;
@property(nonatomic) CGFloat            width;
@property(nonatomic) CGFloat            height;
@property (nonatomic,strong) UIView * bgView;

- (UIViewController*)viewController;
- (void)circlebackGround;
- (void)showWarmAnimal;
@end
