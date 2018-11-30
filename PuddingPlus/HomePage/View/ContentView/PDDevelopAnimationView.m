//
//  PDDevelopAnimationView.m
//  Pudding
//
//  Created by baxiang on 16/10/9.
//  Copyright © 2016年 Zhi Kuiyu. All rights reserved.
//

#import "PDDevelopAnimationView.h"
#import <QuartzCore/QuartzCore.h>

@interface PDDevelopAnimationView()<UIApplicationDelegate>
@property (nonatomic,weak) UIImageView *lefeEye;
@property (nonatomic,weak) UIImageView *rightEye;
@property (nonatomic,weak) UIImageView *lambImageView;
@property (nonatomic,weak) UILabel *titleLabel;
@end
@implementation PDDevelopAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if(RBDataHandle.currentDevice.isPuddingPlus){
            [self loadPuddingPlusAnimail];
        }else if (RBDataHandle.currentDevice.isStorybox){
            [self loadPuddingXAnimail];
        }else{
            [self loadPuddingsAnimail];
        }
    }
    return self;
}

- (void)loadPuddingPlusAnimail{
    UIImageView *rooboImageView = [UIImageView new];
    rooboImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:rooboImageView];
    rooboImageView.image = [UIImage imageNamed:@"home_animation_014"];
    
    NSMutableArray * array = [NSMutableArray new];
    for(int i = 0 ; i < 24 ; i++){
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"home_animation_%03d",i]];
        if(image)
            [array addObject:image];
    }
    
    
    [rooboImageView setAnimationImages:array];
    rooboImageView.animationDuration = .5;
    rooboImageView.animationRepeatCount = 3;
    [rooboImageView startAnimating];
    
    [rooboImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(10);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(rooboImageView.image.size.height*.7);
        make.width.mas_equalTo(rooboImageView.image.size.width*.7);
    }];
    
    
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = mRGBToColor(0xb5b5b5);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.center.x);
        make.top.mas_equalTo(rooboImageView.mas_bottom).offset(10);
    }];
    titleLabel.text = NSLocalizedString( @"selecting_best_content_for_baby", nil);
    self.titleLabel = titleLabel;
    
    
    UIImageView *lambImageView = [UIImageView new];
    [self addSubview:lambImageView];
    lambImageView.image = [UIImage imageNamed:@"light"];
    self.lambImageView = lambImageView;
    self.lambImageView.alpha = 0.;
    [lambImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(rooboImageView.mas_left).offset(15);
        make.bottom.mas_equalTo(rooboImageView.mas_top).offset(15);
        make.width.mas_equalTo(lambImageView.image.size.width);
        make.height.mas_equalTo(lambImageView.image.size.height);
    }];
    
    [self performSelector:@selector(onPuddingImageAnimailStop) withObject:nil afterDelay:1.49];
}


- (void)onPuddingImageAnimailStop{
    self.titleLabel.text = NSLocalizedString( @"select_complete_show_you_wonderful_content", nil);
    [UIView animateWithDuration:.2 animations:^{
        self.lambImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];

        });
    
    }];

}
- (void)loadPuddingXAnimail{
    UIImageView *rooboImageView = [UIImageView new];
    rooboImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:rooboImageView];
    
    NSMutableArray * array = [NSMutableArray new];
    
    rooboImageView.image = [UIImage imageNamed:@"home_animation_x_0"];
    for(int i = 0 ; i < 36 ; i++){
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"home_animation_x_%d",i]];
        if(image)
            [array addObject:image];
    }
    
    [rooboImageView setAnimationImages:array];
    rooboImageView.animationDuration = .5;
    rooboImageView.animationRepeatCount = 6;
    [rooboImageView startAnimating];
    
    [rooboImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(10);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(rooboImageView.image.size.height*.7);
        make.width.mas_equalTo(rooboImageView.image.size.width*.7);
    }];
    
    
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = mRGBToColor(0xb5b5b5);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.center.x);
        make.top.mas_equalTo(rooboImageView.mas_bottom).offset(10);
    }];
    titleLabel.text = NSLocalizedString( @"selecting_best_content_for_baby", nil);
    self.titleLabel = titleLabel;
    
    
    UIImageView *lambImageView = [UIImageView new];
    [self addSubview:lambImageView];
    lambImageView.image = [UIImage imageNamed:@"light"];
    self.lambImageView = lambImageView;
    self.lambImageView.alpha = 0.;
    [lambImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(rooboImageView.mas_left).offset(15);
        make.bottom.mas_equalTo(rooboImageView.mas_top).offset(15);
        make.width.mas_equalTo(lambImageView.image.size.width);
        make.height.mas_equalTo(lambImageView.image.size.height);
    }];
    
    [self performSelector:@selector(onPuddingImageAnimailStop) withObject:nil afterDelay:1.49];
}
- (void)loadPuddingsAnimail{
    
    UIImageView *lambImageView = [UIImageView new];
    [self addSubview:lambImageView];
    lambImageView.image = [UIImage imageNamed:@"light"];
    self.lambImageView = lambImageView;
    self.lambImageView.alpha = 0.;
    UIImageView *rooboImageView = [UIImageView new];
    [self addSubview:rooboImageView];
    rooboImageView.image = [UIImage imageNamed:@"pudding"];
    
    [rooboImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lambImageView.mas_bottom);
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(rooboImageView.image.size.height);
        make.width.mas_equalTo(rooboImageView.image.size.width);
    }];
    [lambImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(rooboImageView.mas_left);
        make.bottom.mas_equalTo(rooboImageView.mas_top);
        make.width.mas_equalTo(lambImageView.image.size.width);
        make.height.mas_equalTo(lambImageView.image.size.height);
    }];
    
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = mRGBToColor(0xb5b5b5);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.center.x);
        make.top.mas_equalTo(rooboImageView.mas_bottom).offset(15);
    }];
    titleLabel.text = NSLocalizedString( @"selecting_best_content_for_baby", nil);
    self.titleLabel = titleLabel;
    
    
    UIImageView *lefeEye = [UIImageView new];
    [rooboImageView addSubview:lefeEye];
    lefeEye.image = [UIImage imageNamed:@"eye"];
    [lefeEye mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(37);
        make.bottom.mas_equalTo(-44);
        make.width.mas_equalTo(lefeEye.image.size.width);
        make.height.mas_equalTo(lefeEye.image.size.height);
    }];
    self.lefeEye = lefeEye;
    UIImageView *rightEye = [UIImageView new];
    [rooboImageView addSubview:rightEye];
    rightEye.image = [UIImage imageNamed:@"eye"];
    [rightEye mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-41);
        make.bottom.mas_equalTo(-38);
        make.width.mas_equalTo(lefeEye.image.size.width);
        make.height.mas_equalTo(lefeEye.image.size.height);
    }];
    self.rightEye = rightEye;
    CAKeyframeAnimation *lefeEyeAnimation = [ CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    //lefeEyeAnimation.keyTimes = @[@(0),@(0.2),@(0.4),@(0.7),@(1.0)];
    lefeEyeAnimation.values = @[@(0),@(M_PI),@(2 * M_PI),@(3*M_PI),@(4 * M_PI)];
    //        NSNumber *toValue = [NSNumber numberWithDouble:M_PI * 2.0];
    //        lefeEyeAnimation.value = @[toValue];
    lefeEyeAnimation.duration = 1;
    //lefeEyeAnimation.repeatCount = 1;
    lefeEyeAnimation.removedOnCompletion = NO;
    lefeEyeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [lefeEye.layer addAnimation:lefeEyeAnimation forKey:@"lefeEyeAnimation"];
    
    CAKeyframeAnimation *rightEyeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    //rightEyeAnimation.keyTimes = @[@(0),@(0.2),@(0.4),@(0.7),@(1.0)];
    rightEyeAnimation.values = @[@(0),@(M_PI),@(2 * M_PI),@(3*M_PI),@(4 * M_PI)];;
    rightEyeAnimation.duration = 1;
    rightEyeAnimation.removedOnCompletion = NO;
    rightEyeAnimation.delegate = self;
    rightEyeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [rightEye.layer addAnimation:rightEyeAnimation forKey:@"rightEyeAnimation"];
    
    CABasicAnimation *lambOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    lambOpacity.fromValue = [NSNumber numberWithFloat:0.2];
    lambOpacity.toValue   = [NSNumber numberWithFloat:1];
    lambOpacity.beginTime = CACurrentMediaTime() + 2;
    lambOpacity.duration = 0.2;
    lambOpacity.repeatCount = 1;
    lambOpacity.removedOnCompletion= NO;
    lambOpacity.fillMode = kCAFillModeForwards;
    lambOpacity.delegate = self;
    [self.lambImageView.layer addAnimation:lambOpacity forKey:@"lambOpacity"];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([self.rightEye.layer animationForKey:@"rightEyeAnimation"] == anim ) {
        self.rightEye.image = [UIImage imageNamed:@"smile"];
        self.titleLabel.text = NSLocalizedString( @"select_complete_show_you_wonderful_content", nil);
    }else if ([self.lambImageView.layer animationForKey:@"lambOpacity"] == anim){
        [self removeFromSuperview];
    }
    
}

-(void)finishAnimation{
    [self.lefeEye.layer removeAllAnimations];
    [self.rightEye.layer removeAllAnimations];
    
    

}

- (void)dealloc{

}

@end
