//
//  RBHomePageViewController+PDSideView.m
//  PuddingPlus
//
//  Created by Zhi Kuiyu on 16/11/11.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "RBHomePageViewController+PDSideView.h"
#import <objc/runtime.h>
#import "PDMainSideView.h"

#define sideViewWidth (SC_WIDTH)
float conentScale = 0.15;
@implementation RBHomePageViewController (PDSideView)
@dynamic sildeView ;
@dynamic show;
@dynamic tapGesture;
@dynamic panRecognizer;
@dynamic enableSwipeGesture;
@dynamic leftSwipeGesture;
@dynamic rightSwipeGesture;
#pragma mark - set get
- (PDMainSideView *)sildeView{
    if(objc_getAssociatedObject(self, @"sildeView") == nil){
        PDMainSideView * sldeView = [[PDMainSideView alloc] initWithFrame:CGRectMake(0, 0, sideViewWidth, self.view.height)];
        [self.view insertSubview:sldeView atIndex:0];
        objc_setAssociatedObject(self, @"sildeView", sldeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return objc_getAssociatedObject(self, @"sildeView");
}


- (void)setShow:(BOOL)show{
    if(show){
        [RBStat logEvent:PD_Home_Info message:nil];
    }
    
    objc_setAssociatedObject(self, @"show",@(show) , OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)show{
    return [objc_getAssociatedObject(self, @"show") boolValue];
}

- (UIView*)findInSubview:(UIView*)view className:(NSString*)className
{
    for(UIView* v in view.subviews){
        if([NSStringFromClass(v.class) isEqualToString:className])
            return v;
        UIView* finded = [self findInSubview:v className:className];
        if(finded)
            return finded;
    }
    return nil;
}


- (UITapGestureRecognizer *)tapGesture{
    if (objc_getAssociatedObject(self, @"tapGesture") == nil)
    {
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        objc_setAssociatedObject(self, @"tapGesture",tapRecognizer , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, @"tapGesture");
}


-(UISwipeGestureRecognizer *)leftSwipeGesture{
    if (objc_getAssociatedObject(self, @"leftSwipeGesture") == nil)
    {
        //添加轻扫手势
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeGesture:)];
        //设置轻扫的方向
        swipeGesture.delegate = self;
        [swipeGesture requireGestureRecognizerToFail:self.panRecognizer];
        [swipeGesture requireGestureRecognizerToFail:self.tapGesture];
        
        swipeGesture.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft; //默认向右
        objc_setAssociatedObject(self, @"leftSwipeGesture",swipeGesture , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, @"leftSwipeGesture");
    
}

-(UISwipeGestureRecognizer *)rightSwipeGesture{
    if (objc_getAssociatedObject(self, @"rightSwipeGesture") == nil)
    {
        //添加轻扫手势
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeGesture:)];
        //设置轻扫的方向
        swipeGesture.delegate = self;
        [swipeGesture requireGestureRecognizerToFail:self.panRecognizer];
        [swipeGesture requireGestureRecognizerToFail:self.tapGesture];
        
        swipeGesture.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft; //默认向右
        objc_setAssociatedObject(self, @"rightSwipeGesture",swipeGesture , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, @"rightSwipeGesture");
    
}

-(UIPanGestureRecognizer *)panRecognizer{
    if (objc_getAssociatedObject(self, @"panRecognizer") == nil)
    {
        UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        panRecognizer.delegate = self;
        objc_setAssociatedObject(self, @"panRecognizer",panRecognizer , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, @"panRecognizer");
}

-(void)setEnableSwipeGesture:(BOOL)enableSwipeGesture{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self sildeView];
    
    if(enableSwipeGesture){
        [self.contentView addGestureRecognizer:self.panRecognizer];
        [self.contentView addGestureRecognizer:self.leftSwipeGesture];
        [self.contentView addGestureRecognizer:self.rightSwipeGesture];
    }else{
        [self.contentView removeGestureRecognizer:self.panRecognizer];
        [self.contentView removeGestureRecognizer:self.leftSwipeGesture];
        [self.contentView removeGestureRecognizer:self.rightSwipeGesture];
    }
    
}

- (void)setcontentFrame:(CGRect)frame {
    self.contentView.left = CGRectGetMinX(frame);
}

#pragma mark - Recognizer Method

- (void)leftSwipeGesture:(UISwipeGestureRecognizer *)sender{
    self.show = NO;
    
    [self sideViewUpdate:.3];
    
}

- (void)rightSwipeGesture:(UISwipeGestureRecognizer *)sender{
    self.show = YES;
    
    [self sideViewUpdate:.3];
    
    NSLog(@"swipeGesture %@",sender);
}


- (void)tapDetected:(UITapGestureRecognizer *)sender{
    [self sideMenuAction];
}

- (void)panDetected:(UIPanGestureRecognizer *)aPanRecognizer{
    static NSInteger velocityForFollowingDirection = 900;
    
    CGPoint velocity = [aPanRecognizer velocityInView:aPanRecognizer.view];
    
    if (aPanRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [aPanRecognizer translationInView:aPanRecognizer.view];
        NSInteger movement = translation.x;
        
        [aPanRecognizer setTranslation:CGPointZero inView:aPanRecognizer.view];
        
        CGRect rect = self.contentView.frame;
        rect.origin.x += movement;
        
        if (rect.origin.x >= 0 && rect.origin.x <= sideViewWidth)
            [self setcontentFrame:rect];
        //            self.contentView.frame = rect;
    }else if (aPanRecognizer.state == UIGestureRecognizerStateEnded){
        float currentX = self.contentView.frame.origin.x;
        if(fabs(velocity.x) > velocityForFollowingDirection){
            if(velocity.x < 0){
                self.show = NO;
                [self sideViewUpdate:.1];
            }else{
                self.show = YES;
                [self sideViewUpdate:.1];
            }
        }else{
            if(currentX < (sideViewWidth/2)){
                self.show = NO;
                [self sideViewUpdate:.1];
            }else{
                self.show = YES;
                [self sideViewUpdate:.1];
            }
        }
    }
}

#pragma mark - RecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point  =[gestureRecognizer locationInView:self.contentView];
    if((!self.show && point.x < SC_WIDTH/14.0) || (self.show && point.x < SC_WIDTH)){
        return YES;
    }
    return NO;
}

#pragma mark - method
/**
 *  @author 智奎宇, 16-02-03 15:02:36
 *
 *  弹出侧滑 或关闭侧滑View
 *
 */

- (void)sideMenuAction{
    self.show = !self.show;
    [self sideViewUpdate:.3];
}



/**
 *  @author 智奎宇, 16-02-03 18:02:57
 *
 *  更新菜单位置
 *
 *  @param animailTime 动画时间
 */
- (void)sideViewUpdate:(float)animailTime{
    if (self.show) {
        @weakify(self);
        [RBDataHandle refreshDeviceList:^{
            @strongify(self);
            [self.sildeView reloadPuddingTable];
        }];
    }
    self.mainMenuView.userInteractionEnabled = !self.show;//fix bug  侧边栏点击右边边缘，会点进布丁优先页面，应该回到首页
    [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        CGRect rect = self.contentView.frame;
        if(self.show){
            rect.origin.x = sideViewWidth;
        }else{
            rect.origin.x = 0;
        }
        
        [self setcontentFrame:rect];
    } completion:^(BOOL finished) {
        if(self.show){
            [self.contentView addGestureRecognizer:self.tapGesture];
        }else{
            [self.contentView removeGestureRecognizer:self.tapGesture];
        }
    }];
    
   
    
}
@end
