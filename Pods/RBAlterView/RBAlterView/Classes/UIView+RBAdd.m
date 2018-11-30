//
//  UIView+RBAdd.m
//  RBCAlterView
//
//  Created by kieran on 2017/1/14.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "UIView+RBAdd.h"
#import <objc/runtime.h>

@implementation UIView (RBAdd)
@dynamic bgView;


- (void)circlebackGround{
    
    UIView * view = [[UIView alloc] initWithFrame:self.bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight ;
    [self insertSubview:view atIndex:0];
    view.userInteractionEnabled = NO;
    view.clipsToBounds = YES;
    view.layer.frame = self.bounds;
    view.layer.borderColor = [UIColor colorWithRed:0.525 green:0.584 blue:0.643 alpha:1.000].CGColor;
    view.layer.cornerRadius = 22;
    view.layer.borderWidth = 1;
    [view.layer setShadowOffset:CGSizeMake(0, 0)];
    [view.layer setShadowColor:[[UIColor clearColor] CGColor]];
    [view.layer setShadowOpacity:1];
    view.layer.shadowRadius = 1.0;//半径
    
    [self setBgView:view];
    
    
}
- (UIViewController*)viewController {
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            if([nextResponder isKindOfClass:[UINavigationController class]]){
                return ((UINavigationController*)nextResponder).visibleViewController;
            }
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
- (void)showWarmAnimal{
    //    [self.bgView.layer setShadowColor:[[UIColor orangeColor] CGColor]];
    self.bgView.layer.borderColor = [UIColor colorWithRed:0.525 green:0.584 blue:0.643 alpha:1.000].CGColor;
    
    [UIView  beginAnimations:@"showWarmAnimal" context:nil];
    [UIView setAnimationDuration:.15];
    [UIView setAnimationRepeatCount:4];
    self.bgView.alpha = .4;
    self.alpha = .7;
    //    self.bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(anmailStop:)];
    [UIView commitAnimations] ;
}
- (void)anmailStop:(id)sender{
    self.bgView.alpha = 1;
    self.alpha = 1;
    [self.bgView.layer setShadowColor:[[UIColor clearColor] CGColor]];
    self.bgView.backgroundColor = [UIColor clearColor];
    
}
- (void)setBgView:(UIView *)bgView{
    
    objc_setAssociatedObject(self, @"bgViewKey", bgView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)bgView{
    return objc_getAssociatedObject(self, @"bgViewKey");
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end
