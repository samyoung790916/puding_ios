//
//  RBFeedBackAnimailView.m
//  TestRote
//
//  Created by kieran on 2017/6/6.
//  Copyright © 2017年 kieran. All rights reserved.
//

#import "RBFeedBackAnimailView.h"

@interface RBFeedBackAnimailView ()<CAAnimationDelegate>{
    UIImageView * imageView;
    UIImageView * pinImageView;
    BOOL    isAnimal;
}

@end


@implementation RBFeedBackAnimailView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:imageView];
        
        pinImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:pinImageView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginAnimail) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimail) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [self loadDefaultLocation];
    }
    return self;
}

- (void)beginAnimail{
    if(isAnimal){
        return;
    }
    isAnimal = YES;
    float rotationValue =  M_PI /7;



    //变回原来颜色
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation1.duration = 0.4;
    animation1.fromValue = [NSNumber numberWithFloat:0];
    animation1.toValue =  [NSNumber numberWithFloat: -rotationValue];
    animation1.autoreverses = NO;
    animation1.removedOnCompletion = NO;
    
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation2.duration = 0.8;
    animation2.fromValue = [NSNumber numberWithFloat:-rotationValue];
    animation2.toValue = [NSNumber numberWithFloat:rotationValue];
    animation2.autoreverses = YES;
    animation2.beginTime =  0.4;
    animation2.repeatCount = 2;
    
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation3.duration = 0.5;
    animation3.toValue = [NSNumber numberWithFloat:0];
    animation3.fromValue = [NSNumber numberWithFloat:-rotationValue];
    animation3.autoreverses = NO;
    animation3.beginTime = 3.6;
    
    
    CAAnimationGroup * theGroup = [CAAnimationGroup animation];
    theGroup.animations = @[animation1,animation2,animation3];
    theGroup.repeatCount = INTMAX_MAX;
    theGroup.duration = 10;
    theGroup.delegate = self;
    theGroup.fillMode =kCAFillModeBackwards;
    
    [imageView.layer addAnimation:theGroup forKey:@"a"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self stopAnimail];
}

- (void)stopAnimail{
    isAnimal = NO;
    [imageView.layer removeAllAnimations];

}

- (void)setImage:(UIImage *)image{
    imageView.image = image;
}

- (void)setPinImage:(UIImage *)pinImage{
    pinImageView.image = pinImage;
}


- (void)loadDefaultLocation{

    float offset = 0.11;

    CGPoint oldOrigin = imageView.frame.origin;
    imageView.layer.anchorPoint = CGPointMake(0.5, offset);
    CGPoint newOrigin = imageView.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    imageView.center = CGPointMake (imageView.center.x - transition.x, imageView.center.y - transition.y);
    
    pinImageView.frame = CGRectMake(CGRectGetMidX(imageView.frame) - 4, CGRectGetMinY(imageView.frame) + CGRectGetHeight(imageView.frame) * offset - 13, 9, 13);
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
