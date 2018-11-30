//
//  RBHeaderIconView.m
//  PuddingPlus
//
//  Created by kieran on 2017/7/26.
//  Copyright © 2017年 Zhi Kuiyu. All rights reserved.
//

#import "RBHeaderIconView.h"

@implementation RBHeaderIconView{
    BOOL    isAnimal;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initze];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initze];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initze];
    }
    return self;
}

- (void)initze{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomAcitive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterbackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];

}

- (void)enterbackGround:(id)sender{
    [self stopAnimail];
}

- (void)becomAcitive:(id)sender{
    if(isAnimal){
        [self beginAnimail];
    }
}

- (void)beginAnimail{
    if(isAnimal){
        [self stopAnimail];
    }
    isAnimal = YES;
    
    
    //变回原来颜色
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation1.duration = 3;
    animation1.fromValue = [NSNumber numberWithFloat:0];
    animation1.toValue =  [NSNumber numberWithFloat: 2* M_PI];
    animation1.autoreverses = NO;
    animation1.removedOnCompletion = NO;
//    animation1.delegate = self;
    animation1.repeatCount = NSIntegerMax;
    [self.layer addAnimation:animation1 forKey:@"a"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self stopAnimail];
}

- (void)stopAnimail{
    isAnimal = NO;
    [self.layer removeAllAnimations];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
