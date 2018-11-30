//
//  PDPuddingXNavtionAnimail.m
//  PuddingPlus
//
//  Created by kieran on 2018/6/20.
//  Copyright © 2018年 Zhi Kuiyu. All rights reserved.
//

#import "PDPuddingXNavtionAnimail.h"

@implementation PDPuddingXNavtionAnimail

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    [transitionContext presentationStyle];
    
    CGRect aa = [transitionContext initialFrameForViewController:toViewController];
    
//    BOOL goingRight = ([transitionContext initialFrameForViewController:toViewController].origin.x < [transitionContext finalFrameForViewController:toViewController].origin.x);
//    CGFloat transDistance = [transitionContext containerView].bounds.size.width + kChildViewPadding;
//    CGAffineTransform transform = CGAffineTransformMakeTranslation(goingRight ? transDistance : -transDistance, 0);
//    // CGAffineTransformInvert 反转
//    toViewController.view.transform = CGAffineTransformInvert(transform);
//    //    toViewController.view.transform = CGAffineTransformTranslate(toViewController.view.transform, (goingRight ? transDistance : -transDistance), 0);
//
//    /**
//     *   ----------弹簧动画.....-------
//     *  使用由弹簧的运动描述的时序曲线` animations` 。当` dampingRatio`为1时，动画将平稳减速到其最终的模型值不会振荡。阻尼比小于1来完全停止前将振荡越来越多。可以使用弹簧的初始速度，以指定的速度在模拟弹簧的端部的物体被移动它附着之前。这是一个单元坐标系，其中1是指行驶总距离的动画在第二。所以，如果你改变一个物体的位置由200PT在这个动画，以及你想要的动画表现得好像物体在动，在100PT /秒的动画开始之前，你会通过0.5 。你通常会想通过0的速度。
//     */
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0 initialSpringVelocity:0 options:0x00 animations:^{
//        fromViewController.view.transform = transform;
//        fromViewController.view.alpha = 0;
//        // CGAffineTransformIdentity  重置,初始化
//        toViewController.view.transform = CGAffineTransformIdentity;
//        toViewController.view.alpha = 1;
//    } completion:^(BOOL finished) {
//        fromViewController.view.transform = CGAffineTransformIdentity;
//        // 声明过渡结束-->记住，一定别忘了在过渡结束时调用 completeTransition: 这个方法。
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//    }];
    
    //    UIView *fromView;
//    UIView *toView;
//    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
//        // iOS8以上用此方法准确获取
//        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//    }
//    else {
//        fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
//        toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
//    }
//
//    UIView *pictureView = self.presenting ? toView : fromView;
//    CGFloat scaleX = CGRectGetWidth(pictureView.frame) ? CGRectGetWidth(self.originFrame) / CGRectGetWidth(pictureView.frame) : 0;
//    CGFloat scaleY = CGRectGetHeight(pictureView.frame) ? CGRectGetHeight(self.originFrame) / CGRectGetHeight(pictureView.frame) : 0;
//    CGAffineTransform transform = CGAffineTransformMakeScale(scaleX, scaleY);
//    CGPoint orginCenter = CGPointMake(CGRectGetMidX(self.originFrame), CGRectGetMidY(self.originFrame));
//    CGPoint pictureCenter = CGPointMake(CGRectGetMidX(pictureView.frame), CGRectGetMidY(pictureView.frame));;
//
//    CGAffineTransform startTransform;
//    CGPoint startCenter;
//    CGAffineTransform endTransform;
//    CGPoint endCenter;
//    if (self.presenting) {
//        startTransform = transform;
//        startCenter = orginCenter;
//        endTransform = CGAffineTransformIdentity;
//        endCenter = pictureCenter;
//    }
//    else {
//        startTransform = CGAffineTransformIdentity;
//        startCenter = pictureCenter;
//        endTransform = transform;
//        endCenter = orginCenter;
//    }
//
//    UIView *container = [transitionContext containerView];
//    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, container.bottom - 30, container.width, 30)];
//    v.backgroundColor = [UIColor redColor];
//    [container addSubview:v];
    
//    [container addSubview:toView];
//    [container bringSubviewToFront:pictureView];
//
//    pictureView.transform = startTransform;
//    pictureView.center = startCenter;
//    [UIView animateWithDuration:self.duration animations:^{
//        pictureView.transform = endTransform;
//        pictureView.center = endCenter;
//    } completion:^(BOOL finished) {
//        BOOL wasCancelled = [transitionContext transitionWasCancelled];
//        [transitionContext completeTransition:!wasCancelled];
//    }];
    
//    /** 目标控制器 */
//    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    /** 原控制器 */
//    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//
//    UIView *toView = nil;
//    UIView *fromView = nil;
//
//    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
//        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//    } else {
//        fromView = fromViewController.view;
//        toView = toViewController.view;
//    }
//    /** containView */
//    UIView *containView = [transitionContext containerView];
//    [containView addSubview:toView];
//    UIImageView *imageView = [toView subviews].firstObject;
//    imageView.frame = CGRectMake(0, 64, 0, 0);
//    UIView *view = [toView subviews].lastObject;
//    view.frame = CGRectMake(0, kScreenHeight  - 64, kScreenWidth, 50);
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    [containView addSubview:imageView];
//    toView.frame = CGRectMake(0, 64, 0, 0);
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        //        view.frame = CGRectMake(0, kScreenHeight - 50 - 64, kScreenWidth, 50);
//        toView.frame = CGRectMake(0, 64, width, height);
//        imageView.frame = CGRectMake(0, 64, kScreenWidth, 220);
//        view.frame = CGRectMake(0, kScreenHeight - 50 - 64, kScreenWidth, 50);
//    } completion:^(BOOL finished) {
//        [transitionContext completeTransition:YES];
//    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end
